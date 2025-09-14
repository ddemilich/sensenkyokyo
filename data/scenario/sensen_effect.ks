*start

[iscript]
class Effect {
    static imagePath = "chara/effects/DefaultEffect.png";

    constructor(name, duration, isBuff = true) {
        this.name = name; // 効果の名前（例: 'クールダウン'）
        this.duration = duration; // 効果時間（ターン数）。-1は永続を意味する
        this.isBuff = isBuff; // バフかどうか（trueならバフ、falseならデバフ）
    }

    applyEffect(selfDisp, allEnemies, allHeroines, dispatch) {
        console.log(`[${selfDisp.charaInstance.name}] にエフェクト ${this.name} が発動しました。`);
    }

    tickDownDuration() {
        if (this.duration > 0) {
            this.duration--;
        }
    }
}

class CooldownEffect extends Effect {
    constructor(duration = -1, decreaseRate = 0.05) {
        super('クールダウン', duration, true);
        this.decreaseRate = decreaseRate;
    }

    applyEffect(selfDisp, allEnemies, allHeroines, dispatch) {
        super.applyEffect(selfDisp, allEnemies, allHeroines, dispatch);
        
        if (selfDisp.charaInstance.er == 0) {
            return;
        }
        const erToDecrease = Math.floor(selfDisp.charaInstance.er * this.decreaseRate);
        const actualDecrease = Math.max(1, erToDecrease);
        
        selfDisp.charaInstance.changeEr(-actualDecrease);
        console.log(`[${selfDisp.charaInstance.name}] のERが ${actualDecrease} 減少しました。残り: ${selfDisp.charaInstance.er}`);

        dispatch('HEROINE_ERBAR_REFRESH', {
            source: selfDisp,
            amount: -actualDecrease,
            current: selfDisp.charaInstance.er,
        });
    }
}
window.CooldownEffect = CooldownEffect;

class StepByStepEffect extends Effect {
    constructor(duration = -1) {
        super('ステップバイステップ', duration, true);
    }

    applyEffect(selfDisp, allEnemies, allHeroines, dispatch) {
        super.applyEffect(selfDisp, allEnemies, allHeroines, dispatch);
        
        if (selfDisp.charaInstance.canUseUltimate()) {
            // 最大SPに達しているので何もしない
            return;
        }

        selfDisp.charaInstance.changeSp(50);
        console.log(`[${selfDisp.charaInstance.name}] のSPが 1 上昇しました。残り: ${selfDisp.charaInstance.sp}`);
        dispatch('CHARA_SPBAR_REFRESH', {
            source: selfDisp,
            amount: 1,
        });
    }
}
window.StepByStepEffect = StepByStepEffect;

class BundleEffect extends Effect {
    static #ER_VALUE_LEVEL2 = 10;
    static #ER_VALUE_LEVEL3 = 20;

    constructor(enemy, duration = -1) {
        super('拘束状態', duration, false);
        this.enemy = enemy;
    }

    erApplyAndDispatch(selfDisp, erValue, dispatch) {
        const chara = selfDisp.charaInstance;
        // 先にERを減らす。CRに応じて値が変わるので。
        let actualEr = chara.applyErValue(erValue);
        // そのあと分割する。
        let separatedEr = BattleUtil.calculateSplitDamage(actualEr, 6);
        dispatch('HEROINE_BUNDLE_ER_CHANGE', {
                heroine: selfDisp,
                amount: separatedEr.totalDamage,
                split: separatedEr.splitDamages,
        });
        dispatch('HEROINE_ERBAR_REFRESH', {
            source: selfDisp,
            amount: separatedEr.totalDamage,
            current: chara.er
        });
        // そのあと絶頂チェック。
        if (chara.canEcstasy()) {
            dispatch('HEROINE_BUNDLE_START_ECSTASY', {
                heroine: selfDisp,
            });
            // 連続絶頂処理
            while (chara.canEcstasy()) {
                // ERを減らしCRを上昇させる。
                const amount = chara.processEcstasy();
                dispatch('HEROINE_BUNDLE_ECSTASY', {
                    heroine: selfDisp,
                    amount: amount,
                    current: chara.er
                });
            }
            dispatch('HEROINE_BUNDLE_END_ECSTASY', {
                heroine: selfDisp,
            });
            // 絶頂したらこのエフェクトを削除してもらう
            this.duration = 0;
        }
    }

    applyEffect(selfDisp, allEnemies, allHeroines, dispatch) {
        super.applyEffect(selfDisp, allEnemies, allHeroines, dispatch);
        
        let chara = selfDisp.charaInstance;
        if (!chara.bundled) {
            // 拘束されていない。ので何もしない
            return;
        }

        const damageAmount = Math.floor(this.enemy.currentAp * 1.0);
        if (chara.wearLevel == 1) {
            // いったん1回復する(LastStandを発動させるため)
            chara.heal(1);
            // Lv1: ダメージを４回に分けて与える
            let separatedDamage = BattleUtil.calculateSplitDamage(damageAmount, 4);
            let actualDamage = chara.applyDamageWithEvasion(separatedDamage.splitDamages);
            chara.takeDamage(actualDamage.actualTotalDamage);
            if (chara.wearLevel != 1) {
                dispatch('HEROINE_BUNDLE_LEVELUP', {
                    heroine: selfDisp,
                    amount: actualDamage.actualTotalDamage,
                    split: actualDamage.splitDamages,
                });
                this.erApplyAndDispatch(selfDisp, BundleEffect.#ER_VALUE_LEVEL2, dispatch);
            } else {
                dispatch('HEROINE_BUNDLE_DAMAGE', {
                    heroine: selfDisp,
                    amount: actualDamage.actualTotalDamage,
                    split: actualDamage.splitDamages,
                });
            }
        } else if (chara.wearLevel == 2) {
            // いったん1回復する(LastStandを発動させるため)
            chara.heal(1);
            let separatedDamage = BattleUtil.calculateSplitDamage(damageAmount, 6);
            let actualDamage = chara.applyDamageWithEvasion(separatedDamage.splitDamages);
            let baseErValue = BundleEffect.#ER_VALUE_LEVEL2;
            // Lv2: ダメージを6回に分けて与える
            chara.takeDamage(actualDamage.actualTotalDamage);
            if (chara.wearLevel != 2) {
                dispatch('HEROINE_BUNDLE_LEVELUP', {
                    heroine: selfDisp,
                    amount: actualDamage.actualTotalDamage,
                    split: actualDamage.splitDamages,
                });
                this.erApplyAndDispatch(selfDisp, BundleEffect.#ER_VALUE_LEVEL3, dispatch);
            } else {
                dispatch('HEROINE_BUNDLE_DAMAGE', {
                    heroine: selfDisp,
                    amount: actualDamage.actualTotalDamage,
                    split: actualDamage.splitDamages,
                });
                this.erApplyAndDispatch(selfDisp, BundleEffect.#ER_VALUE_LEVEL2, dispatch);
            }
        } else if (chara.wearLevel == 3) {
            // Lv3: ER20を６回に分けて与える
            this.erApplyAndDispatch(selfDisp, BundleEffect.#ER_VALUE_LEVEL3, dispatch);
        } else {
            console.error(`BundleEffect: 不正な拘束レベル: ${chara.wearLevel}`);
        }

    }
}
window.BundleEffect = BundleEffect;

class BundleAfterEffect extends Effect {
    constructor(enemy, duration = 1) {
        super('事後状態', duration, false);
        this.enemy = enemy;
    }
    applyEffect(selfDisp, allEnemies, allHeroines, dispatch) {
        super.applyEffect(selfDisp, allEnemies, allHeroines, dispatch);

        let chara = selfDisp.charaInstance;
        if (!chara.bundled) {
            // 拘束されていない。ので何もしない
            return;
        }
        // 拘束解除
        dispatch('HEROINE_LEAVE_BUNDLE', {
            heroine: selfDisp,
            enemy: this.enemy,
        });
    }
}
window.BundleAfterEffect = BundleAfterEffect;

class BuddyBonding extends Effect {
    constructor(duration = -1) {
        super('絆', duration, true);
    }

    applyEffect(selfDisp, allEnemies, allHeroines, dispatch) {
        super.applyEffect(selfDisp, allEnemies, allHeroines, dispatch);
        // 自分以外を探して
        const buddy = allHeroines.find(h => h.charaInstance !== selfDisp.charaInstance);
        if (buddy.charaInstance.pose == 'knockout' || buddy.charaInstance.bundled) {
            // AP1.5倍
            selfDisp.charaInstance.applyMultiplicativeApBuff('BuddyBonding', 1.5);
            // アクション＋１
            selfDisp.charaInstance.applyActionCountBuff('BuddyBonding', 1);
        }
    }
}
window.BuddyBonding = BuddyBonding;

[endscript]
[return]
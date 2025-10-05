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
        // 自分が倒れていたら・・・発動しない
        if (selfDisp.charaInstance.pose == 'knockout') {
            return;
        }        
        if (selfDisp.charaInstance.canUseUltimate()) {
            // 最大SPに達しているので何もしない
            return;
        }

        let amount = BattleUtil.getRandomInt(1,3);
        selfDisp.charaInstance.changeSp(amount);
        dispatch('CHARA_SPBAR_REFRESH', {
            source: selfDisp,
            amount: amount,
        });
    }
}
window.StepByStepEffect = StepByStepEffect;

class BundleEffect extends Effect {
    static #ER_VALUE_LEVEL2 = 10;
    static #ER_VALUE_LEVEL3 = 20;
    static #ER_VALUE_RANGE  = 5;

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
                this.erApplyAndDispatch(
                    selfDisp, 
                    BattleUtil.getRandomInt(BundleEffect.#ER_VALUE_LEVEL2 - BundleEffect.#ER_VALUE_RANGE, BundleEffect.#ER_VALUE_LEVEL2 + BundleEffect.#ER_VALUE_RANGE), 
                    dispatch
                );
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
                this.erApplyAndDispatch(
                    selfDisp, 
                    BattleUtil.getRandomInt(BundleEffect.#ER_VALUE_LEVEL3 - BundleEffect.#ER_VALUE_RANGE, BundleEffect.#ER_VALUE_LEVEL3 + BundleEffect.#ER_VALUE_RANGE), 
                    dispatch
                );
            } else {
                dispatch('HEROINE_BUNDLE_DAMAGE', {
                    heroine: selfDisp,
                    amount: actualDamage.actualTotalDamage,
                    split: actualDamage.splitDamages,
                });
                this.erApplyAndDispatch(
                    selfDisp, 
                    BattleUtil.getRandomInt(BundleEffect.#ER_VALUE_LEVEL2 - BundleEffect.#ER_VALUE_RANGE, BundleEffect.#ER_VALUE_LEVEL2 + BundleEffect.#ER_VALUE_RANGE), 
                    dispatch
                );
            }
        } else if (chara.wearLevel == 3) {
        // Lv3: ER20を６回に分けて与える
            this.erApplyAndDispatch(
                selfDisp, 
                BattleUtil.getRandomInt(BundleEffect.#ER_VALUE_LEVEL3 - BundleEffect.#ER_VALUE_RANGE, BundleEffect.#ER_VALUE_LEVEL3 + BundleEffect.#ER_VALUE_RANGE), 
                dispatch
            );
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
        // 自分が倒れていたら・・・発動しない
        if (selfDisp.charaInstance.pose == 'knockout') {
            return;
        }
        // 自分以外を探して
        const buddy = allHeroines.find(h => h.charaInstance !== selfDisp.charaInstance);
        if (buddy.charaInstance.pose == 'knockout' || buddy.charaInstance.bundled) {
            // AP1.5倍
            selfDisp.charaInstance.applyMultiplicativeApBuff('BuddyBonding', 1.5);
            // アクション＋１
            selfDisp.charaInstance.applyActionCountBuff('BuddyBonding', 1);
            dispatch('HEROINE_ENABLE_BUDDY_BONDING', {
                heroine: selfDisp
            });
        }
    }
}
window.BuddyBonding = BuddyBonding;

class InsaneGas extends Effect {
    constructor(duration = -1) {
        super('ガス噴射', duration, true);
    }

    applyEffect(selfDisp, allEnemies, allHeroines, dispatch) {
       
        super.applyEffect(selfDisp, allEnemies, allHeroines, dispatch);
        let mount = selfDisp.charaInstance;

        // bundle中は発動しない
        if (mount.bundled || mount.isDefeated()) {
            return;
        }

        let lplossRate = (1 - mount.lp / mount.maxLp);
        // ヒロインのERを上昇させる

        let targets = allHeroines.filter(hDisp => !hDisp.charaInstance.bundled);
        if (targets.length > 0) {
            // ER上昇値 = 1 + (1 - マウントのLP/マウントの最大LP) * 30
            const erAmount = 1 + Math.floor(lplossRate * 30);
            targets.forEach(hDisp => {
               hDisp.charaInstance.applyErValue(erAmount);
            });
            // イベント発行
            dispatch('MOUNT_INSANE_GAS_ER', {
                source: selfDisp,
                targets: targets,
                amount: erAmount,
                actionType: 'InsaneGas'
            });
        }
        if (lplossRate >= 0.5) {
            let targets = allEnemies.filter(eDisp => !eDisp.charaInstance.isDefeated() && !eDisp.charaInstance.bundled);
            // 敵全体のSPを上昇させる
            if (targets.length > 0) {
                // SP回復値 = 1 + (1 - マウントのLP/マウントの最大LP) * 30
                let spAmount = 1 + Math.floor(lplossRate * 30);
                targets.forEach(eDisp => {
                    eDisp.charaInstance.changeSp(spAmount);
                    dispatch('CHARA_SPBAR_REFRESH', {
                        source: eDisp,
                        amount: spAmount,
                    });
                });
            }
        }

        if (lplossRate >= 0.75) {
            let targets = allEnemies.filter(eDisp => !eDisp.charaInstance.isDefeated() && !eDisp.charaInstance.bundled);
            // 敵全体のLPを回復させる
            if (targets.length > 0) {
                // LP回復値 = 1 + (マウントの最大LP * 0.1)
                let lpAmount = 1 + Math.floor(mount.maxLp * 0.1);
                targets.forEach(eDisp => {
                    eDisp.charaInstance.heal(lpAmount);
                    dispatch('ENEMY_HEAL_DISPLAY', {
                        source: selfDisp,
                        target: eDisp,
                        amount: lpAmount,
                        actionType: 'InsaneGas'
                    });
                });
            }
        }

    }
}
window.InsaneGas = InsaneGas;

class QueensOrder extends Effect {
    constructor(duration = -1) {
        super('女王の秩序', duration, true);
    }

    applyEffect(selfDisp, allEnemies, allHeroines, dispatch) {
        super.applyEffect(selfDisp, allEnemies, allHeroines, dispatch);
        let bind = selfDisp.charaInstance;

        // bundle中は発動しない
        if (bind.bundled || bind.isDefeated()) {
            return;
        }

        let lplossRate = (1 - bind.lp / bind.maxLp);

        let targets = allEnemies.filter(eDisp => !eDisp.charaInstance.isDefeated());
        if (targets.length == 1) {
            // レッサーバインダー２匹を召喚する。  
            for (let i=0; i<2; i++) {
                const enemyInstance = EnemyFactory.createEnemy(
                    "e23", 
                    Math.floor(bind.maxLp / 4), 
                    Math.floor(bind.currentAp), 
                    // ちょっと大きくする
                    Math.floor(bind.width/2 * 1.1), 
                    Math.floor(bind.height * 1.1)
                );
                // 最初からspが高い
                enemyInstance.sp = 50;
                // エロ目
                enemyInstance.firstRate = 1;
                enemyInstance.chargeRate = 3;
                enemyInstance.guardRate = 1;
                const enemyDisplayData = new CharaDisplayData(
                    enemyInstance,
                    (selfDisp.x - 1280),
                    selfDisp.y,
                );
                allEnemies.push(enemyDisplayData);
                dispatch('ENEMY_APPEAR', { enemyDisp: enemyDisplayData});
            }
        } else {
            // LPの昇順（小さい順）にソートする
            targets.sort((a, b) => a.charaInstance.lp - b.charaInstance.lp);
            // ソート後、配列の最初の要素が最もLPの小さいターゲットとなる
            const weakestTarget = targets[0];
            let lpAmount = 1 + Math.floor(bind.maxLp * 0.03);
            weakestTarget.charaInstance.heal(lpAmount);
            dispatch('ENEMY_HEAL_DISPLAY', {
                source: selfDisp,
                target: weakestTarget,
                amount: lpAmount,
                actionType: 'QueensOrder'
            });
        }
        // 生成された子も対象に含める
        let retargets = allEnemies.filter(eDisp => !eDisp.charaInstance.isDefeated() && !eDisp.charaInstance.bundled);
        if (lplossRate >= 0.75) {
            retargets.forEach(eDisp => {
                eDisp.charaInstance.applyActionCountBuff('QueensOrder', 1);
                let spAmount = Math.floor(eDisp.charaInstance.maxSp * 0.1);
                eDisp.charaInstance.changeSp(spAmount);
                dispatch('ENEMY_POWERUP', {
                    source: eDisp,
                    amount: spAmount,
                });
            })
        } else if (lplossRate >= 0.5) {
            const randomIndex = Math.floor(Math.random() * retargets.length);
            const targetEnemyDisp = retargets[randomIndex]
            targetEnemyDisp.charaInstance.applyActionCountBuff('QueensOrder', 1);
            let spAmount = Math.floor(targetEnemyDisp.charaInstance.maxSp * 0.1);
            targetEnemyDisp.charaInstance.changeSp(spAmount);
            dispatch('ENEMY_POWERUP', {
                source: targetEnemyDisp,
                amount: spAmount,
            });
        }
    }
}
window.QueensOrder = QueensOrder;
[endscript]
[return]
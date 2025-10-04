*start

[iscript]

class Action {
    static TYPE_DEFINITIONS = Object.freeze({
        'FirstStrike': '先制',
        'ChargeBurst': '溜め',
        'GuardCounter': '反撃',
        'Ultimate': 'アルティメット',
        'Resist': '抵抗',
        'Break': '強行突破',
        'Concentrate': '集中',
        'Rescue': '救出',
        'Speak': '会話'
    });

    static imagePath = "chara/actions/DefaultAction.png";

    selectedTarget = null; // ターゲットのCharaDisplayData
    needTarget = true; // このアクションがターゲットを必要とするかどうかのフラグ。デフォルトはtrue
    preExecuted = false; // 事前効果発動済のフラグ。デフォルトはfalse;
    canceled = false; // このアクションがキャンセルされたかどうか。デフォルトはfalse;

    constructor(name, type) {
        if (!Action.TYPE_DEFINITIONS.hasOwnProperty(type)) {
            throw new Error(`Invalid action type: ${type}. Must be one of ${Object.keys(Action.TYPE_DEFINITIONS).join(', ')}.`);
        }
        this.name = name; // アクションの名前（例: '攻撃', 'チャージ'）
        this.type = type; // アクションのタイプ（例: 'FirstStrike', 'ChargeBurst', 'GuardCounter'）
    }

    setSelectedTarget(selectedCharaDispData) {
        if (!selectedCharaDispData) {
            // nullもundefinedも許容しない
            console.error(`[Action - ${this.name}] setSelectedTarget: 無効なターゲットが指定されました。CharaDisplayDataインスタンスが必要です。`, selectedCharaDispData);
            return;
        }
        this.selectedTarget = selectedCharaDispData;
        console.log(`[Action - ${this.name}] のターゲットを ${this.selectedTarget.charaInstance.name} に設定しました。`);
    }

    clearSelectedTarget() {
        if (this.selectedTarget !== null) {
            console.log(`[Action - ${this.name}] のターゲットを解除しました。`);
            this.selectedTarget = null;
        }
    }

    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        // デフォルトでは何もしない
        return null;
    }

    preExecute(source, allEnemies, allHeroines, dispatch) {
        this.preExecuted = true;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        console.warn(`[Action - ${this.name}] execute メソッドがオーバーライドされていません。`);
    }
    getImagePath() {
        return this.constructor.imagePath;
    }
}
window.Action = Action;

class DefaultUltimate extends Action {
    static imagePath = "chara/actions/DefaultUltimate.png";
    constructor() {
        super('DefaultUltimate', 'Ultimate'); // 名前とタイプを設定
    }
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        const availableTargets = allHeroines.filter(hDisp => !hDisp.charaInstance.isDefeated() && !hDisp.charaInstance.bundled);
        if (availableTargets.length > 0) {
            this.selectedTarget = availableTargets[Math.floor(Math.random() * availableTargets.length)];
        } else {
            this.selectedTarget = null;
        }
        return this.selectedTarget;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        console.log(`[${source.charaInstance.name}] の必殺技を実行！`);
        // 全SP消費
        source.charaInstance.useSpByUltimate();
        this.decideTargetCharaDisplayData(source, allEnemies, allHeroines);

        if (this.selectedTarget) {
            console.log(`対象決定: [${this.selectedTarget.charaInstance.name}]`);
            
            // 30%回復
            const healAmount = Math.floor(source.charaInstance.maxLp * 0.3);
            source.charaInstance.heal(healAmount);
            dispatch('ENEMY_HEAL_DISPLAY', {
                source: source,
                target: source,
                amount: healAmount,
                actionType: 'Ultimate'
            });
            // Bundleオブジェクトを生成
            this.selectedTarget.enterBundle(source.charaInstance);
            console.log(`[${source.charaInstance.name}] が [${this.selectedTarget.charaInstance.name}] を拘束！`);

            dispatch('ENEMY_ENTER_BUNDLE', {
                source: source,
                target: this.selectedTarget,
                actionType: 'Ultimate'
            });
        } else {
            // 能力値Up(30%~35%)
            source.charaInstance.ap.increaseBaseValue(Math.floor(source.charaInstance.currentAp * (0.10 + (Math.random() * 0.05)))); 
            source.charaInstance.maxLp += Math.floor(source.charaInstance.maxLp * (0.10 + (Math.random() * 0.05))); 
            // 100%回復
            const healAmount = source.charaInstance.maxLp;
            source.charaInstance.heal(healAmount);
            dispatch('ENEMY_HEAL_DISPLAY', {
                source: source,
                target: source,
                amount: healAmount,
                actionType: 'Ultimate'
            });
        }
    }
}
window.DefaultUltimate = DefaultUltimate;

class EnemyFirstStrike extends Action {
    static imagePath = "chara/actions/EnemyFirstStrike.png"; // 画像パスは共通でもOK

    constructor() {
        super('EnemyFirstStrike', 'FirstStrike'); // 名前とタイプを設定
    }

    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        const availableTargets = allHeroines.filter(hDisp => !hDisp.charaInstance.isDefeated() && !hDisp.charaInstance.bundled);
        if (availableTargets.length > 0) {
            this.selectedTarget = availableTargets[Math.floor(Math.random() * availableTargets.length)];
        } else {
            this.selectedTarget = null;
        }
        return this.selectedTarget;
    }

    execute(source, allEnemies, allHeroines, dispatch) {
        console.log(`[${source.charaInstance.name}] の敵先制攻撃を実行！`);

        if (!this.selectedTarget || this.selectedTarget.charaInstance.isDefeated() || this.selectedTarget.charaInstance.bundled) {
            this.decideTargetCharaDisplayData(source, allEnemies, allHeroines);
        }

        if (this.selectedTarget) {
            console.log(`対象決定: [${this.selectedTarget.charaInstance.name}]`);
            const damage = source.charaInstance.currentAp;
            const targetCharaInstance = this.selectedTarget.charaInstance;

            let separatedDamage = BattleUtil.calculateSplitDamage(damage, 3);
            let actualDamage = targetCharaInstance.applyDamageWithEvasion(separatedDamage.splitDamages, source.charaInstance.getHitRate());
            targetCharaInstance.takeDamage(actualDamage.actualTotalDamage);
            console.log(`[${source.charaInstance.name}] が [${targetCharaInstance.name}] に ${damage} ダメージを与えました。残りLP: ${targetCharaInstance.lp}`);

            dispatch('ENEMY_DAMAGE_DISPLAY', {
                source: source,
                target: this.selectedTarget,
                amount: actualDamage.actualTotalDamage,
                split: actualDamage.splitDamages,
                actionType: 'first_strike'
            });
            if (actualDamage.actualTotalDamage > 0) {
                // ダメージを与えたらSPを増やす(最大25くらい)
                const spAmount = Math.floor(Math.random() * actualDamage.actualTotalDamage);
                source.charaInstance.changeSp(spAmount);
                dispatch('CHARA_SPBAR_REFRESH', {
                    source: source,
                    amount: spAmount,
                });
            }
        } else {
            source.charaInstance.changeSp(21);
            dispatch('CHARA_SPBAR_REFRESH', {
                source: source,
                amount: 21,
            });
        }
    }
}
window.EnemyFirstStrike = EnemyFirstStrike;

class EnemyChargeBurst extends Action {
    static imagePath = "chara/actions/EnemyChargeBurst.png";

    constructor() {
        // 親クラスのコンストラクタを呼び出す
        super('EnemyChargeBurst', 'ChargeBurst');
    }
    // ターゲットを決定するロジック
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        const availableTargets = allHeroines.filter(hDisp => !hDisp.charaInstance.isDefeated() && !hDisp.charaInstance.bundled);
        if (availableTargets.length > 0) {
            this.selectedTarget = availableTargets[Math.floor(Math.random() * availableTargets.length)];
        } else {
            this.selectedTarget = null;
        }
        return this.selectedTarget;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        console.log(`[${source.charaInstance.name}] 溜め攻撃を実行！`);

        if (!this.selectedTarget || this.selectedTarget.charaInstance.isDefeated() || this.selectedTarget.charaInstance.bundled) {
            this.decideTargetCharaDisplayData(source, allEnemies, allHeroines);
        }

        if (this.selectedTarget) {
            console.log(`対象決定: [${this.selectedTarget.charaInstance.name}]`);
            const erValue = BattleUtil.getRandomInt(8, 12);
            const targetCharaInstance = this.selectedTarget.charaInstance;

            const actual = targetCharaInstance.applyErValue(erValue);
            console.log(`[${source.charaInstance.name}] が [${targetCharaInstance.name}] に 快楽値 ${actual} を与えました。`);

            dispatch('ENEMY_ER_APPLY_DISPLAY', {
                source: source,
                target: this.selectedTarget,
                amount: actual,
                actionType: 'charge_burst'
            });
        } else {
            source.charaInstance.changeSp(21);
            dispatch('CHARA_SPBAR_REFRESH', {
                source: source,
                amount: 21,
            });
        }
    }
}
window.EnemyChargeBurst = EnemyChargeBurst;

class EnemyGuardCounter extends Action {
    static imagePath = "chara/actions/DefaultGuardCounter.png";

    constructor() {
        // 親クラスのコンストラクタを呼び出す
        super('EnemyGuardCounter', 'GuardCounter');
    }
    // ターゲットを決定するロジック
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        const availableTargets = allHeroines.filter(hDisp => !hDisp.charaInstance.isDefeated() && !hDisp.charaInstance.bundled);
        if (availableTargets.length > 0) {
            this.selectedTarget = availableTargets[Math.floor(Math.random() * availableTargets.length)];
        } else {
            this.selectedTarget = null;
        }
        return this.selectedTarget;
    }
    preExecute(source, allEnemies, allHeroines, dispatch) {
        console.log(`[${source.charaInstance.name}] 反撃攻撃を準備！`);
        super.preExecute(source, allEnemies, allHeroines, dispatch);

        const healAmount = Math.floor(source.charaInstance.maxLp * 0.05);
        source.charaInstance.heal(healAmount);
        dispatch('ENEMY_HEAL_DISPLAY', {
            source: source,
            target: source,
            amount: healAmount,
            actionType: 'preExecuted GuardCounter'
        });
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        console.log(`[${source.charaInstance.name}] 反撃攻撃を実行！`);
        if (!this.selectedTarget || this.selectedTarget.charaInstance.isDefeated() || this.selectedTarget.charaInstance.bundled) {
            this.decideTargetCharaDisplayData(source, allEnemies, allHeroines);
        }
        if (this.selectedTarget) {
            console.log(`対象決定: [${this.selectedTarget.charaInstance.name}]`);
            const damage = Math.floor(source.charaInstance.currentAp * 0.5);
            const targetCharaInstance = this.selectedTarget.charaInstance;

            let separatedDamage = BattleUtil.calculateSplitDamage(damage, 1);
            let actualDamage = targetCharaInstance.applyDamageWithEvasion(separatedDamage.splitDamages, source.charaInstance.getHitRate());
            targetCharaInstance.takeDamage(actualDamage.actualTotalDamage);
            console.log(`[${source.charaInstance.name}] が [${targetCharaInstance.name}] に ${damage} ダメージを与えました。残りLP: ${targetCharaInstance.lp}`);

            dispatch('ENEMY_DAMAGE_DISPLAY', {
                source: source,
                target: this.selectedTarget,
                amount: actualDamage.actualTotalDamage,
                split: actualDamage.splitDamages,
                actionType: 'guard_counter'
            });
            if (actualDamage.actualTotalDamage > 0) {
                // ダメージを与えたらSPを増やす(最大25くらい)
                const spAmount = Math.floor(Math.random() * actualDamage.actualTotalDamage);
                source.charaInstance.changeSp(spAmount);
                dispatch('CHARA_SPBAR_REFRESH', {
                    source: source,
                    amount: spAmount,
                });
            }
        } else {
            console.warn(`[${source.charaInstance.name}] 敵反撃攻撃の対象がいません。`);
        }
    }
}
window.EnemyGuardCounter = EnemyGuardCounter;

[endscript]
[return]
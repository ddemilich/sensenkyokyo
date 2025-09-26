; ヒロイン - ラムダ関連実装
[iscript]

class LambdaFirstStrike extends Action {
    static imagePath = "chara/actions/HeroineFirstStrike.png";

    constructor() {
        super('LambdaFirstStrike', 'FirstStrike');
    }

    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        const availableTargets = allEnemies.filter(eDisp => !eDisp.charaInstance.isDefeated() && !eDisp.charaInstance.bundled);
        if (availableTargets.length > 0) {
            return availableTargets[Math.floor(Math.random() * availableTargets.length)];
        }
        return null;
    }

    execute(source, allEnemies, allHeroines, dispatch) {
        console.log(`[${source.charaInstance.name}] のヒロイン先制攻撃を実行！`);

        let targetCharaDispData = this.selectedTarget; // ユーザー選択済みのターゲットを優先

        if (!targetCharaDispData || targetCharaDispData.charaInstance.isDefeated()) {
            targetCharaDispData = this.decideTargetCharaDisplayData(source, allEnemies, allHeroines);
            if (targetCharaDispData) {
                console.log(`対象変更: -> [${targetCharaDispData.charaInstance.name}]`);
            }
        }

        if (targetCharaDispData) {
            const damage = source.charaInstance.currentAp;
            const targetCharaInstance = targetCharaDispData.charaInstance;

            let separatedDamage = BattleUtil.calculateSplitDamage(damage, 6);
            let actualDamage = targetCharaInstance.applyDamageWithEvasion(separatedDamage.splitDamages, source.charaInstance.getHitRate());
            targetCharaInstance.takeDamage(actualDamage.actualTotalDamage);
            console.log(`[${source.charaInstance.name}] が [${targetCharaInstance.name}] に ${damage} ダメージを与えました。残りLP: ${targetCharaInstance.lp}`);

            dispatch('HEROINE_DAMAGE_LAMBDA_STRIKE', {
                source: source,
                target: targetCharaDispData,
                amount: actualDamage.actualTotalDamage,
                split: actualDamage.splitDamages,
                actionType: 'first_strike'
            });
        } else {
            let spAmount = Math.floor(source.charaInstance.maxSp * 0.2) + 1;
            source.charaInstance.changeSp(spAmount);
            dispatch('HEROINE_SP_GRANTED', {
                source: source,
                amount: spAmount,
            });
        }
    }
}

class LambdaChargeBurst extends Action {
    static imagePath = "chara/actions/Laser.png";

    constructor() {
        // 親クラスのコンストラクタを呼び出す
        super('LambdaChargeBurst', 'ChargeBurst');
        this.needTarget = false;
    }

    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        return null;
    }

    execute(source, allEnemies, allHeroines, dispatch) {
        console.log(`[${source.charaInstance.name}] 溜め攻撃を実行！`);
        const damage = Math.floor(source.charaInstance.currentAp * 0.25);

        const availableTargets = allEnemies.filter(eDisp => !eDisp.charaInstance.isDefeated() && !eDisp.charaInstance.bundled);
        if (availableTargets.length > 0) {
            for (const targetDisp of availableTargets) {
                const targetCharaInstance = targetDisp.charaInstance;

                let separatedDamage = BattleUtil.calculateSplitDamage(damage, 1);
                let actualDamage = targetDisp.charaInstance.applyDamageWithEvasion(separatedDamage.splitDamages, source.charaInstance.getHitRate());
                targetCharaInstance.takeDamage(actualDamage.actualTotalDamage);
                console.log(`[${source.charaInstance.name}] が [${targetCharaInstance.name}] に ${damage} ダメージを与えました。残りLP: ${targetCharaInstance.lp}`);
                dispatch('HEROINE_DAMAGE_LAMBDA_CHARGE', {
                    source: source,
                    target: targetDisp,
                    amount: actualDamage.actualTotalDamage,
                    split: actualDamage.splitDamages,
                    actionType: 'charge_burst'
                });
            }
        } else {
            let spAmount = Math.floor(source.charaInstance.maxSp * 0.2) + 1;
            source.charaInstance.changeSp(spAmount);
            dispatch('HEROINE_SP_GRANTED', {
                source: source,
                amount: spAmount,
            });
        }
    }
}

class LambdaGuardCounter extends Action {
    static imagePath = "chara/actions/DefaultGuardCounter.png";

    constructor() {
        super('LambdaGuardCounter', 'GuardCounter');
        this.needTarget = false;
    }
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        return null;
    }
    preExecute(source, allEnemies, allHeroines, dispatch) {
        console.log(`[${source.charaInstance.name}] 反撃攻撃を準備！`);
        super.preExecute(source, allEnemies, allHeroines, dispatch);

        const healAmount = Math.floor(source.charaInstance.maxLp * 0.07);
        source.charaInstance.heal(healAmount);
        dispatch('HEROINE_HEAL_DISPLAY', {
            source: source,
            target: source,
            amount: healAmount,
            actionType: 'preExecuted GuardCounter'
        });
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        console.log(`[${source.charaInstance.name}] 反撃攻撃を実行！`);
        let targetCharaDispData = this.selectedTarget;
        console.log(`対象決定: [${targetCharaDispData.charaInstance.name}]`);

        if (targetCharaDispData) {
            const damage = Math.floor(source.charaInstance.currentAp * 0.5);
            const targetCharaInstance = targetCharaDispData.charaInstance;

            let separatedDamage = BattleUtil.calculateSplitDamage(damage, 1);
            let actualDamage = targetCharaInstance.applyDamageWithEvasion(separatedDamage.splitDamages, source.charaInstance.getHitRate());
            targetCharaInstance.takeDamage(actualDamage.actualTotalDamage);
            console.log(`[${source.charaInstance.name}] が [${targetCharaInstance.name}] に ${damage} ダメージを与えました。残りLP: ${targetCharaInstance.lp}`);

            dispatch('HEROINE_DAMAGE_GUARD_COUNTER', {
                source: source,
                target: targetCharaDispData,
                amount: actualDamage.actualTotalDamage,
                split: actualDamage.splitDamages,
                actionType: 'guard_counter'
            });
        } else {
            console.warn(`[${source.charaInstance.name}] 敵反撃攻撃の対象がいません。`);
        }
    }
}

class LightningSunday extends Action {
    static imagePath = "chara/actions/LightningSunday.png";

    constructor() {
        super('LightningSunday', 'Ultimate');
        this.needTarget = false;
    }
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        return null;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        // 全SP消費
        source.charaInstance.useSpByUltimate();
        let healAmount = source.charaInstance.maxLp;
        if (source.charaInstance.ultimateUsed) {
            healAmount = Math.floor(source.charaInstance.maxLp * 0.3);
        } else {
            source.charaInstance.ultimateUsed = true;
        }
        source.charaInstance.heal(healAmount);
        source.charaInstance.wearLevel = 1;
        source.charaInstance.er = 0;
        // 拘束状態を解除
        if (source.charaInstance.bundled) {
            const heroine = source;
            const enemy = allEnemies.find(enemy => enemy.charaInstance.bundled && enemy.charaInstance === source.bundleInstance.captor);
            dispatch('HEROINE_LEAVE_BUNDLE', {
                heroine: heroine,
                enemy: enemy.charaInstance,
            })
        }
        console.log(`[${source.charaInstance.name}] 必殺技を実行！`);
        const availableTargets = allEnemies.filter(eDisp => !eDisp.charaInstance.isDefeated() && !eDisp.charaInstance.bundled);
        // 敵のスキルを１つずつキャンセル
        availableTargets.forEach(enemyDisp => {
            let activeAction = enemyDisp.charaInstance.actions.find(action => !action.canceled);
            if (activeAction) {
                activeAction.canceled = true;
            }
        });

        // イベント発行
        dispatch('LAMBDA_LIGHTNING_SUNDAY', {
            source: source,
            amount: healAmount,
            enemies: availableTargets,
            actionType: 'ultimate'
        });
        dispatch('CHARA_ACTION_REFRESH', {
            enemies: allEnemies, heroines: allHeroines
        });
    }
}

class LambdaResist extends Action {
    static imagePath = "chara/actions/Resist.png";
    constructor() {
        super('LambdaResis', 'Resist');
        this.needTarget = false;
    }
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        return null;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        if (!source.charaInstance.bundled) {
            // もう拘束されていない！ので何もしない
            return;
        }
        // LPを減らす
        source.bundleInstance.takeDamage(1);
        // 表示更新
        dispatch('HEROINE_RESIST_BUNDLE', {
            heroine: source,
            amount: 1,
        });
        if (source.bundleInstance.isBroken()) {
            // 拘束している敵を探す
            const enemy = allEnemies.find(enemy => enemy.charaInstance.bundled && enemy.charaInstance === source.bundleInstance.captor);
            dispatch('HEROINE_LEAVE_BUNDLE', {
                heroine: source,
                enemy: enemy.charaInstance,
            });
        }
    }
}

class LambdaBreak extends Action {
    static imagePath = "chara/actions/Break.png";
    constructor() {
        super('LambdaBreak', 'Break');
        this.needTarget = false;
    }
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        return null;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        if (!source.charaInstance.bundled) {
            // もう拘束されていない！ので何もしない
            return;
        }

        let hitRate = 0.95 - ((source.charaInstance.er * 0.5) / 100);
        if (hitRate < 0.45) {
            hitRate = 0.45;
        }
        let result = true;
        let count = 0;
        for (let i = 0; i < source.bundleInstance.lp; i++) {
            const randomNumber = Math.random(); 
            if (randomNumber < hitRate) {
                // 命中
                count++;
                continue;
            } else {
                result = false;
                break;
            }
        }
        if (!result) {
            // 失敗したらLPを増やす
            source.bundleInstance.lp++;
        }
        // 表示更新
        dispatch('HEROINE_BREAK_BUNDLE', {
            heroine: source,
            result: result,
        });
        if (result) {
            // 拘束している敵を探す
            const enemy = allEnemies.find(enemy => enemy.charaInstance.bundled && enemy.charaInstance === source.bundleInstance.captor);
            dispatch('HEROINE_LEAVE_BUNDLE', {
                heroine: source,
                enemy: enemy.charaInstance,
            });
        }
    }
}

class LambdaConcentrate extends Action {
    static imagePath = "chara/actions/Concentrate.png";
    constructor() {
        super('LambdaConcentrate', 'Concentrate');
        this.needTarget = false;
    }
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        return null;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        if (!source.charaInstance.bundled) {
            // もう拘束されていない！ので何もしない
            return;
        }
        let erAmount = Math.floor(source.charaInstance.er * 0.1) + 1;
        source.charaInstance.changeEr(-erAmount);
        dispatch('HEROINE_ERBAR_REFRESH', {
            source: source,
            amount: -erAmount,
            current: source.charaInstance.er,
        });
        let spAmount = Math.floor(source.charaInstance.sp * 0.1) + 1;
        source.charaInstance.changeSp(spAmount);
        dispatch('CHARA_SPBAR_REFRESH', {
            source: source,
            amount: spAmount,
        });
    }
}

class LambdaRescue extends Action {
    static imagePath = "chara/actions/Rescue.png"
    constructor() {
        super('LambdaRescue', 'Rescue');
        this.needTarget = false;
    }
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        return null;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        let spAmount = Math.floor(source.charaInstance.maxSp * Heroine.HEROINE_RESCUE_RATE);
        source.charaInstance.changeSp(-spAmount);
        // ミューを探す
        const buddy = allHeroines.find(h => h.charaInstance !== source.charaInstance);
        // 表示更新
        dispatch('HEROINE_RESCUE_BUNDLE', {
            heroine: source,
            buddy: buddy,
        });
        // 拘束している敵を探す
        const enemy = allEnemies.find(enemy => enemy.charaInstance.bundled && enemy.charaInstance === buddy.bundleInstance.captor);
        dispatch('HEROINE_LEAVE_BUNDLE', {
            heroine: buddy,
            enemy: enemy.charaInstance,
        });
    }    
}

class LambdaSpeak extends Action {
    static imagePath = "chara/actions/DefaultSpeak.png"
    constructor() {
        super('LambdaSpeak', 'Speak');
        this.needTarget = false;
    }
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        return null;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        // TODO: なんか状態に応じてセリフを言う
    }
}

class HeroineLambda extends Heroine {
    constructor(lp, ap, width=500, height=702) {
        super("lambda", lp, ap, width, height);
        this.displayName = "ラムダ";
        this.zindex = 10;
        console.log(`${this.displayName}はヒロインです。`);
    }

    registerDefaultActions() {
        this.actionClasses.set('FirstStrike', LambdaFirstStrike);
        this.actionClasses.set('ChargeBurst', LambdaChargeBurst);
        this.actionClasses.set('GuardCounter', LambdaGuardCounter);
        this.actionClasses.set('Ultimate', LightningSunday);
        this.actionClasses.set('Resist', LambdaResist);
        this.actionClasses.set('Break', LambdaBreak);
        this.actionClasses.set('Concentrate', LambdaConcentrate);
        this.actionClasses.set('Rescue', LambdaRescue);
        this.actionClasses.set('Speak', LambdaSpeak);

        const definedActionKeys = new Set(Object.keys(Action.TYPE_DEFINITIONS));
        const registeredActionKeys = new Set(this.actionClasses.keys());

        definedActionKeys.forEach(key => {
            if (!registeredActionKeys.has(key)) {
                console.error(`[Character - ${this.name}] アクション登録エラー: Action.TYPE_DEFINITIONSに定義されている '${key}' が _registerDefaultActions に登録されていません。`);
            }
        });
        registeredActionKeys.forEach(key => {
            if (!definedActionKeys.has(key)) {
                console.warn(`[Character - ${this.name}] アクション登録警告: '${key}' は Action.TYPE_DEFINITIONS に定義されていない不正なアクションキーです。`);
            }
        });
    }
}
window.HeroineLambda = HeroineLambda;
[endscript]

[macro name="lightning_sunday"]
    ;mp.lambda_disp
    ;mp.amount
    ;mp.enemies
    [anim name="&mp.lambda_disp.charaInstance.name" left="-=25" time="100" effect="easeInCirc"][wa]
    [playse storage="UltimateHeal.mp3"]
    [heal_to chara="&mp.lambda_disp.charaInstance" healValue="&mp.amount" x="&mp.lambda_disp.x" y="&mp.lambda_disp.y"]
    [heroine_mod heroine="&mp.lambda_disp.charaInstance" time="100"]
    [image name="lightning_sunday_01" layer="8" folder="fgimage" storage="chara/effects/LightningSunday_01_loop.webp" left="0" top="0" width="640" wait="false"]
    [playse storage="LightningSunday.mp3"]
    [iscript]
        tf.enemy_lightning_sunday_loop_index = 0;
    [endscript]
    [wait time="300"]
    [free layer="8" name="lightning_sunday_01"]
*enemy_lightning_sunday_loop_start
    [jump target="*enemy_lightning_sunday_loop_end" cond="!(tf.enemy_lightning_sunday_loop_index < mp.enemies.length)"]
    [image layer="8" folder="fgimage" storage="chara/effects/LightningSunday_02_loop.webp" left="&mp.enemies[tf.enemy_lightning_sunday_loop_index].x" top="&mp.enemies[tf.enemy_lightning_sunday_loop_index].y" width="&mp.enemies[tf.enemy_lightning_sunday_loop_index].charaInstance.width" time="100" wait="false"]
    [iscript]
        tf.enemy_lightning_sunday_loop_index++;
    [endscript]
    [jump target="*enemy_lightning_sunday_loop_start"]
*enemy_lightning_sunday_loop_end
    [wait time="1000"]
    [anim name="&mp.lambda_disp.charaInstance.name" left="+=25" time="100" effect="easeInCirc"][wa]
    [freeimage layer="8" wait="true"]
[endmacro]

; ゲーム開始時にキャラクタ定義する
[chara_new name="lambda" storage="chara/lambda/lambda_base.png" width="500" height="702"]
    [chara_face name="lambda" face="base" storage="chara/lambda/lambda_base.png"]
        [chara_layer name="lambda" part="wear" id="base1" storage="chara/lambda/lambda_base_wear_1.png" zindex="1"]
        [chara_layer name="lambda" part="wear" id="base2" storage="chara/lambda/lambda_base_wear_2.png" zindex="1"]
        [chara_layer name="lambda" part="wear" id="base3" storage="chara/lambda/lambda_base_wear_3.png" zindex="1"]
        [chara_layer name="lambda" part="head" id="base1" storage="chara/lambda/lambda_base_head_1.webp" zindex="10"]
        [chara_layer name="lambda" part="head" id="base2" storage="chara/lambda/lambda_base_head_2.webp" zindex="10"]
        [chara_layer name="lambda" part="head" id="base3" storage="chara/lambda/lambda_base_head_3.webp" zindex="10"]
    [chara_face name="lambda" face="attack" storage="chara/lambda/lambda_attack.png"]
        [chara_layer name="lambda" part="wear" id="attack1" storage="chara/lambda/lambda_attack_wear_1.png" zindex="1"]
        [chara_layer name="lambda" part="wear" id="attack2" storage="chara/lambda/lambda_attack_wear_2.png" zindex="1"]
        [chara_layer name="lambda" part="wear" id="attack3" storage="chara/lambda/lambda_attack_wear_3.png" zindex="1"]
        [chara_layer name="lambda" part="head" id="attack1" storage="chara/lambda/lambda_attack_head_1.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="attack2" storage="chara/lambda/lambda_attack_head_2.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="attack3" storage="chara/lambda/lambda_attack_head_3.png" zindex="10"]
        [chara_layer name="lambda" part="attacking_l" id="default" storage="none" zindex="11"]
        [chara_layer name="lambda" part="attacking_l" id="wait1" storage="chara/lambda/lambda_attack_diff1_wear_1.png" zindex="11"]
        [chara_layer name="lambda" part="attacking_l" id="wait2" storage="chara/lambda/lambda_attack_diff1_wear_2.png" zindex="11"]
        [chara_layer name="lambda" part="attacking_l" id="wait3" storage="chara/lambda/lambda_attack_diff1_wear_3.png" zindex="11"]
        [chara_layer name="lambda" part="attacking_l" id="attacking1" storage="chara/lambda/lambda_attack_01_animation_loop.webp" zindex="11"]
        [chara_layer name="lambda" part="attacking_l" id="attacking2" storage="chara/lambda/lambda_attack_02_animation_loop.webp" zindex="11"]
        [chara_layer name="lambda" part="attacking_l" id="attacking3" storage="chara/lambda/lambda_attack_03_animation_loop.webp" zindex="11"]
        [chara_layer name="lambda" part="attacking_r" id="default" storage="none" zindex="11"]
        [chara_layer name="lambda" part="attacking_r" id="wait1" storage="none" zindex="-1"]
        [chara_layer name="lambda" part="attacking_r" id="wait2" storage="none" zindex="-1"]
        [chara_layer name="lambda" part="attacking_r" id="wait3" storage="none" zindex="-1"]
        [chara_layer name="lambda" part="attacking_r" id="attacking1" storage="none" zindex="-1"]
        [chara_layer name="lambda" part="attacking_r" id="attacking2" storage="none" zindex="-1"]
        [chara_layer name="lambda" part="attacking_r" id="attacking3" storage="none" zindex="-1"]
    [chara_face name="lambda" face="guard" storage="chara/lambda/lambda_guard.png"]
        [chara_layer name="lambda" part="wear" id="guard1" storage="chara/lambda/lambda_guard_wear_1.png" zindex="1"]
        [chara_layer name="lambda" part="wear" id="guard2" storage="chara/lambda/lambda_guard_wear_2.png" zindex="1"]
        [chara_layer name="lambda" part="wear" id="guard3" storage="chara/lambda/lambda_guard_wear_3.png" zindex="1"]
        [chara_layer name="lambda" part="head" id="guard1" storage="chara/lambda/lambda_guard_head_1.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="guard2" storage="chara/lambda/lambda_guard_head_2.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="guard3" storage="chara/lambda/lambda_guard_head_3.png" zindex="10"]
    [chara_face name="lambda" face="damaged" storage="chara/lambda/lambda_damaged.png"]
        [chara_layer name="lambda" part="wear" id="damaged1" storage="chara/lambda/lambda_damaged_wear_1.png" zindex="1"]
        [chara_layer name="lambda" part="wear" id="damaged2" storage="chara/lambda/lambda_damaged_wear_2.png" zindex="1"]
        [chara_layer name="lambda" part="wear" id="damaged3" storage="chara/lambda/lambda_damaged_wear_3.png" zindex="1"]
        [chara_layer name="lambda" part="head" id="damaged1" storage="chara/lambda/lambda_damaged_head_1.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="damaged2" storage="chara/lambda/lambda_damaged_head_2.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="damaged3" storage="chara/lambda/lambda_damaged_head_3.png" zindex="10"]
    [chara_face name="lambda" face="down" storage="chara/lambda/lambda_down.png"]
        [chara_layer name="lambda" part="wear" id="down1" storage="chara/lambda/lambda_down_wear_1.png" zindex="10"]
        [chara_layer name="lambda" part="wear" id="down2" storage="chara/lambda/lambda_down_wear_2.png" zindex="10"]
        [chara_layer name="lambda" part="wear" id="down3" storage="chara/lambda/lambda_down_wear_3.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="down1" storage="chara/lambda/lambda_down_head_1.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="down2" storage="chara/lambda/lambda_down_head_2.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="down3" storage="chara/lambda/lambda_down_head_3.png" zindex="10"]
    [chara_face name="lambda" face="knockout" storage="chara/lambda/lambda_knockout.png"]
        [chara_layer name="lambda" part="wear" id="knockout1" storage="chara/lambda/lambda_knockout_wear_1.png" zindex="10"]
        [chara_layer name="lambda" part="wear" id="knockout2" storage="chara/lambda/lambda_knockout_wear_2.png" zindex="10"]
        [chara_layer name="lambda" part="wear" id="knockout3" storage="chara/lambda/lambda_knockout_wear_3.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="knockout1" storage="chara/lambda/lambda_knockout_head_1.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="knockout2" storage="chara/lambda/lambda_knockout_head_2.png" zindex="10"]
        [chara_layer name="lambda" part="head" id="knockout3" storage="chara/lambda/lambda_knockout_head_3.png" zindex="10"]
[chara_new name="lambda_normal_bundle" storage="chara/lambda_normal_bundle/default.png" width="500" height="702"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv1_1" storage="chara/lambda_normal_bundle/e11_Lv1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv1_2" storage="chara/lambda_normal_bundle/e11_Lv1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv1_3" storage="chara/lambda_normal_bundle/e11_Lv1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv2_1_1" storage="chara/lambda_normal_bundle/e11_Lv2_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv2_1_2" storage="chara/lambda_normal_bundle/e11_Lv2_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv2_1_3" storage="chara/lambda_normal_bundle/e11_Lv2_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv2_2_1" storage="chara/lambda_normal_bundle/e11_Lv2_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv2_2_2" storage="chara/lambda_normal_bundle/e11_Lv2_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv2_2_3" storage="chara/lambda_normal_bundle/e11_Lv2_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv2_3_1" storage="chara/lambda_normal_bundle/e11_Lv2_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv2_3_2" storage="chara/lambda_normal_bundle/e11_Lv2_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv2_3_3" storage="chara/lambda_normal_bundle/e11_Lv2_3_3.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv3_1_1" storage="chara/lambda_normal_bundle/e11_Lv3_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv3_1_2" storage="chara/lambda_normal_bundle/e11_Lv3_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv3_1_3" storage="chara/lambda_normal_bundle/e11_Lv3_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv3_2_1" storage="chara/lambda_normal_bundle/e11_Lv3_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv3_2_2" storage="chara/lambda_normal_bundle/e11_Lv3_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv3_2_3" storage="chara/lambda_normal_bundle/e11_Lv3_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv3_3_1" storage="chara/lambda_normal_bundle/e11_Lv3_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv3_3_2" storage="chara/lambda_normal_bundle/e11_Lv3_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e11_Lv3_3_3" storage="chara/lambda_normal_bundle/e11_Lv3_3_3.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv1_1" storage="chara/lambda_normal_bundle/e12_Lv1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv1_2" storage="chara/lambda_normal_bundle/e12_Lv1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv1_3" storage="chara/lambda_normal_bundle/e12_Lv1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv2_1_1" storage="chara/lambda_normal_bundle/e12_Lv2_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv2_1_2" storage="chara/lambda_normal_bundle/e12_Lv2_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv2_1_3" storage="chara/lambda_normal_bundle/e12_Lv2_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv2_2_1" storage="chara/lambda_normal_bundle/e12_Lv2_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv2_2_2" storage="chara/lambda_normal_bundle/e12_Lv2_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv2_2_3" storage="chara/lambda_normal_bundle/e12_Lv2_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv2_3_1" storage="chara/lambda_normal_bundle/e12_Lv2_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv2_3_2" storage="chara/lambda_normal_bundle/e12_Lv2_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv2_3_3" storage="chara/lambda_normal_bundle/e12_Lv2_3_3.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv3_1_1" storage="chara/lambda_normal_bundle/e12_Lv3_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv3_1_2" storage="chara/lambda_normal_bundle/e12_Lv3_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv3_1_3" storage="chara/lambda_normal_bundle/e12_Lv3_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv3_2_1" storage="chara/lambda_normal_bundle/e12_Lv3_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv3_2_2" storage="chara/lambda_normal_bundle/e12_Lv3_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv3_2_3" storage="chara/lambda_normal_bundle/e12_Lv3_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv3_3_1" storage="chara/lambda_normal_bundle/e12_Lv3_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv3_3_2" storage="chara/lambda_normal_bundle/e12_Lv3_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e12_Lv3_3_3" storage="chara/lambda_normal_bundle/e12_Lv3_3_3.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv1_1" storage="chara/lambda_normal_bundle/e13_Lv1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv1_2" storage="chara/lambda_normal_bundle/e13_Lv1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv1_3" storage="chara/lambda_normal_bundle/e13_Lv1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv2_1_1" storage="chara/lambda_normal_bundle/e13_Lv2_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv2_1_2" storage="chara/lambda_normal_bundle/e13_Lv2_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv2_1_3" storage="chara/lambda_normal_bundle/e13_Lv2_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv2_2_1" storage="chara/lambda_normal_bundle/e13_Lv2_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv2_2_2" storage="chara/lambda_normal_bundle/e13_Lv2_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv2_2_3" storage="chara/lambda_normal_bundle/e13_Lv2_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv2_3_1" storage="chara/lambda_normal_bundle/e13_Lv2_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv2_3_2" storage="chara/lambda_normal_bundle/e13_Lv2_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv2_3_3" storage="chara/lambda_normal_bundle/e13_Lv2_3_3.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv3_1_1" storage="chara/lambda_normal_bundle/e13_Lv3_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv3_1_2" storage="chara/lambda_normal_bundle/e13_Lv3_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv3_1_3" storage="chara/lambda_normal_bundle/e13_Lv3_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv3_2_1" storage="chara/lambda_normal_bundle/e13_Lv3_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv3_2_2" storage="chara/lambda_normal_bundle/e13_Lv3_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv3_2_3" storage="chara/lambda_normal_bundle/e13_Lv3_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv3_3_1" storage="chara/lambda_normal_bundle/e13_Lv3_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv3_3_2" storage="chara/lambda_normal_bundle/e13_Lv3_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e13_Lv3_3_3" storage="chara/lambda_normal_bundle/e13_Lv3_3_3.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv1_1" storage="chara/lambda_normal_bundle/e21_Lv1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv1_2" storage="chara/lambda_normal_bundle/e21_Lv1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv1_3" storage="chara/lambda_normal_bundle/e21_Lv1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv2_1_1" storage="chara/lambda_normal_bundle/e21_Lv2_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv2_1_2" storage="chara/lambda_normal_bundle/e21_Lv2_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv2_1_3" storage="chara/lambda_normal_bundle/e21_Lv2_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv2_2_1" storage="chara/lambda_normal_bundle/e21_Lv2_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv2_2_2" storage="chara/lambda_normal_bundle/e21_Lv2_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv2_2_3" storage="chara/lambda_normal_bundle/e21_Lv2_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv2_3_1" storage="chara/lambda_normal_bundle/e21_Lv2_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv2_3_2" storage="chara/lambda_normal_bundle/e21_Lv2_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv2_3_3" storage="chara/lambda_normal_bundle/e21_Lv2_3_3.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv3_1_1" storage="chara/lambda_normal_bundle/e21_Lv3_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv3_1_2" storage="chara/lambda_normal_bundle/e21_Lv3_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv3_1_3" storage="chara/lambda_normal_bundle/e21_Lv3_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv3_2_1" storage="chara/lambda_normal_bundle/e21_Lv3_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv3_2_2" storage="chara/lambda_normal_bundle/e21_Lv3_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv3_2_3" storage="chara/lambda_normal_bundle/e21_Lv3_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv3_3_1" storage="chara/lambda_normal_bundle/e21_Lv3_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv3_3_2" storage="chara/lambda_normal_bundle/e21_Lv3_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e21_Lv3_3_3" storage="chara/lambda_normal_bundle/e21_Lv3_3_3.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv1_1" storage="chara/lambda_normal_bundle/e22_Lv1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv1_2" storage="chara/lambda_normal_bundle/e22_Lv1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv1_3" storage="chara/lambda_normal_bundle/e22_Lv1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv2_1_1" storage="chara/lambda_normal_bundle/e22_Lv2_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv2_1_2" storage="chara/lambda_normal_bundle/e22_Lv2_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv2_1_3" storage="chara/lambda_normal_bundle/e22_Lv2_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv2_2_1" storage="chara/lambda_normal_bundle/e22_Lv2_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv2_2_2" storage="chara/lambda_normal_bundle/e22_Lv2_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv2_2_3" storage="chara/lambda_normal_bundle/e22_Lv2_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv2_3_1" storage="chara/lambda_normal_bundle/e22_Lv2_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv2_3_2" storage="chara/lambda_normal_bundle/e22_Lv2_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv2_3_3" storage="chara/lambda_normal_bundle/e22_Lv2_3_3.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv3_1_1" storage="chara/lambda_normal_bundle/e22_Lv3_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv3_1_2" storage="chara/lambda_normal_bundle/e22_Lv3_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv3_1_3" storage="chara/lambda_normal_bundle/e22_Lv3_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv3_2_1" storage="chara/lambda_normal_bundle/e22_Lv3_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv3_2_2" storage="chara/lambda_normal_bundle/e22_Lv3_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv3_2_3" storage="chara/lambda_normal_bundle/e22_Lv3_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv3_3_1" storage="chara/lambda_normal_bundle/e22_Lv3_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv3_3_2" storage="chara/lambda_normal_bundle/e22_Lv3_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e22_Lv3_3_3" storage="chara/lambda_normal_bundle/e22_Lv3_3_3.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv1_1" storage="chara/lambda_normal_bundle/e23_Lv1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv1_2" storage="chara/lambda_normal_bundle/e23_Lv1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv1_3" storage="chara/lambda_normal_bundle/e23_Lv1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv2_1_1" storage="chara/lambda_normal_bundle/e23_Lv2_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv2_1_2" storage="chara/lambda_normal_bundle/e23_Lv2_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv2_1_3" storage="chara/lambda_normal_bundle/e23_Lv2_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv2_2_1" storage="chara/lambda_normal_bundle/e23_Lv2_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv2_2_2" storage="chara/lambda_normal_bundle/e23_Lv2_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv2_2_3" storage="chara/lambda_normal_bundle/e23_Lv2_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv2_3_1" storage="chara/lambda_normal_bundle/e23_Lv2_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv2_3_2" storage="chara/lambda_normal_bundle/e23_Lv2_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv2_3_3" storage="chara/lambda_normal_bundle/e23_Lv2_3_3.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv3_1_1" storage="chara/lambda_normal_bundle/e23_Lv3_1_1.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv3_1_2" storage="chara/lambda_normal_bundle/e23_Lv3_1_2.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv3_1_3" storage="chara/lambda_normal_bundle/e23_Lv3_1_3.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv3_2_1" storage="chara/lambda_normal_bundle/e23_Lv3_2_1.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv3_2_2" storage="chara/lambda_normal_bundle/e23_Lv3_2_2.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv3_2_3" storage="chara/lambda_normal_bundle/e23_Lv3_2_3.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv3_3_1" storage="chara/lambda_normal_bundle/e23_Lv3_3_1.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv3_3_2" storage="chara/lambda_normal_bundle/e23_Lv3_3_2.png"]
    [chara_face name="lambda_normal_bundle" face="e23_Lv3_3_3" storage="chara/lambda_normal_bundle/e23_Lv3_3_3.png"]

[chara_new name="lambda_boss_bundle" storage="chara/lambda_boss_bundle/default.png" width="1000" height="702"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv1_1" storage="chara/lambda_boss_bundle/e14_Lv1_1.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv1_2" storage="chara/lambda_boss_bundle/e14_Lv1_2.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv1_3" storage="chara/lambda_boss_bundle/e14_Lv1_3.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv2_1_1" storage="chara/lambda_boss_bundle/e14_Lv2_1_1.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv2_1_2" storage="chara/lambda_boss_bundle/e14_Lv2_1_2.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv2_1_3" storage="chara/lambda_boss_bundle/e14_Lv2_1_3.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv2_2_1" storage="chara/lambda_boss_bundle/e14_Lv2_2_1.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv2_2_2" storage="chara/lambda_boss_bundle/e14_Lv2_2_2.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv2_2_3" storage="chara/lambda_boss_bundle/e14_Lv2_2_3.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv2_3_1" storage="chara/lambda_boss_bundle/e14_Lv2_3_1.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv2_3_2" storage="chara/lambda_boss_bundle/e14_Lv2_3_2.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv2_3_3" storage="chara/lambda_boss_bundle/e14_Lv2_3_3.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv3_1_1" storage="chara/lambda_boss_bundle/e14_Lv3_1_1.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv3_1_2" storage="chara/lambda_boss_bundle/e14_Lv3_1_2.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv3_1_3" storage="chara/lambda_boss_bundle/e14_Lv3_1_3.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv3_2_1" storage="chara/lambda_boss_bundle/e14_Lv3_2_1.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv3_2_2" storage="chara/lambda_boss_bundle/e14_Lv3_2_2.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv3_2_3" storage="chara/lambda_boss_bundle/e14_Lv3_2_3.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv3_3_1" storage="chara/lambda_boss_bundle/e14_Lv3_3_1.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv3_3_2" storage="chara/lambda_boss_bundle/e14_Lv3_3_2.png"]
    [chara_face name="lambda_boss_bundle" face="e14_Lv3_3_3" storage="chara/lambda_boss_bundle/e14_Lv3_3_3.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv1_1" storage="chara/lambda_boss_bundle/e24_Lv1_1.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv1_2" storage="chara/lambda_boss_bundle/e24_Lv1_2.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv1_3" storage="chara/lambda_boss_bundle/e24_Lv1_3.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv2_1_1" storage="chara/lambda_boss_bundle/e24_Lv2_1_1.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv2_1_2" storage="chara/lambda_boss_bundle/e24_Lv2_1_2.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv2_1_3" storage="chara/lambda_boss_bundle/e24_Lv2_1_3.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv2_2_1" storage="chara/lambda_boss_bundle/e24_Lv2_2_1.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv2_2_2" storage="chara/lambda_boss_bundle/e24_Lv2_2_2.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv2_2_3" storage="chara/lambda_boss_bundle/e24_Lv2_2_3.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv2_3_1" storage="chara/lambda_boss_bundle/e24_Lv2_3_1.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv2_3_2" storage="chara/lambda_boss_bundle/e24_Lv2_3_2.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv2_3_3" storage="chara/lambda_boss_bundle/e24_Lv2_3_3.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv3_1_1" storage="chara/lambda_boss_bundle/e24_Lv3_1_1.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv3_1_2" storage="chara/lambda_boss_bundle/e24_Lv3_1_2.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv3_1_3" storage="chara/lambda_boss_bundle/e24_Lv3_1_3.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv3_2_1" storage="chara/lambda_boss_bundle/e24_Lv3_2_1.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv3_2_2" storage="chara/lambda_boss_bundle/e24_Lv3_2_2.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv3_2_3" storage="chara/lambda_boss_bundle/e24_Lv3_2_3.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv3_3_1" storage="chara/lambda_boss_bundle/e24_Lv3_3_1.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv3_3_2" storage="chara/lambda_boss_bundle/e24_Lv3_3_2.png"]
    [chara_face name="lambda_boss_bundle" face="e24_Lv3_3_3" storage="chara/lambda_boss_bundle/e24_Lv3_3_3.png"]

[chara_new name="story_lambda" jname="ラムダ" storage="chara/story/lambda_stand.png" width="600" height="848"]

[return]


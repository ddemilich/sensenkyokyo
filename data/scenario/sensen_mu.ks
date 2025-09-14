; ヒロイン - ミュー関連実装
[iscript]
class MuFirstStrike extends Action {
    static imagePath = "chara/actions/HeroineFirstStrike.png"; // 画像パスは共通でもOK

    constructor() {
        super('MuFirstStrike', 'FirstStrike'); // 名前とタイプを設定
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

            let separatedDamage = BattleUtil.calculateSplitDamage(damage, 4);
            let actualDamage = targetCharaInstance.applyDamageWithEvasion(separatedDamage.splitDamages, source.charaInstance.getHitRate());
            targetCharaInstance.takeDamage(actualDamage.actualTotalDamage);

            console.log(`[${source.charaInstance.name}] が [${targetCharaInstance.name}] に ${damage} ダメージを与えました。残りLP: ${targetCharaInstance.lp}`);

            dispatch('HEROINE_DAMAGE_MU_STRIKE', {
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
class MuChargeBurst extends Action {
    static imagePath = "chara/actions/BodyAttack.png";

    constructor() {
        super('MuChargeBurst', 'ChargeBurst');
        this.needTarget = false;
    }
    // ターゲットを決定するロジック
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        const availableTargets = allEnemies.filter(eDisp => !eDisp.charaInstance.isDefeated() && !eDisp.charaInstance.bundled);
        if (availableTargets.length > 0) {
            return availableTargets[Math.floor(Math.random() * availableTargets.length)];
        }
        return null;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        console.log(`[${source.charaInstance.name}] 溜め攻撃を実行！`);
        const damage = Math.floor(source.charaInstance.currentAp * 2.0);

        // ランダムに対象を選択
        let targetCharaDispData = this.decideTargetCharaDisplayData(source, allEnemies, allHeroines);
        if (targetCharaDispData) {
            const targetCharaInstance = targetCharaDispData.charaInstance;

            let separatedDamage = BattleUtil.calculateSplitDamage(damage, 1);
            let actualDamage = targetCharaInstance.applyDamageWithEvasion(separatedDamage.splitDamages, source.charaInstance.getHitRate());
            targetCharaInstance.takeDamage(actualDamage.actualTotalDamage);

            console.log(`[${source.charaInstance.name}] が [${targetCharaInstance.name}] に ${damage} ダメージを与えました。残りLP: ${targetCharaInstance.lp}`);

            dispatch('HEROINE_DAMAGE_MU_CHARGE', {
                source: source,
                target: targetCharaDispData,
                amount: actualDamage.actualTotalDamage,
                split: actualDamage.splitDamages,
                actionType: 'charge_burst'
            });
        } else {
            let spAmount = Math.floor(source.charaInstance.sp * 0.1) + 1;
            source.charaInstance.changeSp(spAmount);
            dispatch('HEROINE_SP_GRANTED', {
                source: source,
                amount: spAmount,
            });
        }
    }
}
class MuGuardCounter extends Action {
    static imagePath = "chara/actions/DefaultGuardCounter.png";

    constructor() {
        super('MuGuardCounter', 'GuardCounter');
        this.needTarget = false;
    }
    // ターゲットを決定するロジック
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
class AdrenalineRush extends Action {
    static imagePath = "chara/actions/AdrenalineRush.png";

    constructor() {
        super('AdrenalineRush', 'Ultimate');
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
            const enemy = allEnemies.find(enemy => enemy.charaInstance === source.bundleInstance.captor);
            dispatch('HEROINE_LEAVE_BUNDLE', {
                heroine: heroine,
                enemy: enemy.charaInstance,
            })
        }
        console.log(`[${source.charaInstance.name}] 必殺技を実行！`);
        // アクション数を一時的に2増加
        source.charaInstance.applyActionCountBuff('AdrenalineRush', 2);
        // イベント発行
        dispatch('MU_ADRENALINE_RUSH', {
            source: source,
            amount: healAmount,
            actionType: 'ultimate'
        });
    }
}
class MuResist extends Action {
    static imagePath = "chara/actions/Resist.png";
    constructor() {
        super('MuResis', 'Resist');
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

class MuBreak extends Action {
    static imagePath = "chara/actions/Break.png";
    constructor() {
        super('MuBreak', 'Break');
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

class MuConcentrate extends Action {
    static imagePath = "chara/actions/Concentrate.png";
    constructor() {
        super('MuConcentrate', 'Concentrate');
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

class MuRescue extends Action {
    static imagePath = "chara/actions/Rescue.png"
    constructor() {
        super('MuRescue', 'Rescue');
        this.needTarget = false;
    }
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        return null;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        let spAmount = Math.floor(source.charaInstance.maxSp * Heroine.HEROINE_RESCUE_RATE);
        source.charaInstance.changeSp(-spAmount);
        // ラムダを探す
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

class MuSpeak extends Action {
    static imagePath = "chara/actions/DefaultSpeak.png"
    constructor() {
        super('MuSpeak', 'Speak');
        this.needTarget = false;
    }
    decideTargetCharaDisplayData(source, allEnemies, allHeroines) {
        return null;
    }
    execute(source, allEnemies, allHeroines, dispatch) {
        // TODO: なんか状態に応じてセリフを言う
    }
}

class HeroineMu extends Heroine {
    constructor(lp, ap, width=500, height=702) {
        super("mu", lp, ap, width, height);
        this.displayName = "ミュー";
        this.zindex = 5;
        console.log(`${this.displayName}はヒロインです。`);
    }
    registerDefaultActions() {
        this.actionClasses.set('FirstStrike', MuFirstStrike);
        this.actionClasses.set('ChargeBurst', MuChargeBurst);
        this.actionClasses.set('GuardCounter', MuGuardCounter);
        this.actionClasses.set('Ultimate', AdrenalineRush);
        this.actionClasses.set('Resist', MuResist);
        this.actionClasses.set('Break', MuBreak);
        this.actionClasses.set('Concentrate', MuConcentrate);
        this.actionClasses.set('Rescue', MuRescue);
        this.actionClasses.set('Speak', MuSpeak);

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
window.HeroineMu = HeroineMu;
[endscript]
; ゲーム開始時にキャラクタ定義する
[macro name="adrenaline_rush"]
    ;mp.mu_disp
    ;mp.amount
    [anim name="&mp.mu_disp.charaInstance.name" left="-=50" time="100" effect="easeInCirc"][wa]
    [heal_to chara="&mp.mu_disp.charaInstance" healValue="&mp.amount" x="&mp.mu_disp.x" y="&mp.mu_disp.y"]
    [heroine_mod heroine="&mp.mu_disp.charaInstance" time="100"]
    [anim name="&mp.mu_disp.charaInstance.name" left="+=50" time="100" effect="easeInCirc"][wa]
    [image layer="8" folder="fgimage" storage="chara/effects/AdrenalineRush.webp" left="&mp.mu_disp.x" top="&mp.mu_disp.y" width="&mp.mu_disp.charaInstance.width" wait="false"]
    [wait time="1000"]
    [freeimage layer="8" wait="true"]
[endmacro]
[chara_new name="mu" storage="chara/mu/mu_base.png" width="500" height="702"]
    [chara_face name="mu" face="base" storage="chara/mu/mu_base.png"]
        [chara_layer name="mu" part="wear" id="base1" storage="chara/mu/mu_base_wear_1.png" zindex="1"]
        [chara_layer name="mu" part="wear" id="base2" storage="chara/mu/mu_base_wear_2.png" zindex="1"]
        [chara_layer name="mu" part="wear" id="base3" storage="chara/mu/mu_base_wear_3.png" zindex="1"]
        [chara_layer name="mu" part="head" id="base1" storage="chara/mu/mu_base_head_1.webp" zindex="10"]
        [chara_layer name="mu" part="head" id="base2" storage="chara/mu/mu_base_head_2.webp" zindex="10"]
        [chara_layer name="mu" part="head" id="base3" storage="chara/mu/mu_base_head_3.webp" zindex="10"]
    [chara_face name="mu" face="attack" storage="chara/mu/mu_attack.png"]
        [chara_layer name="mu" part="wear" id="attack1" storage="chara/mu/mu_attack_wear_1.png" zindex="1"]
        [chara_layer name="mu" part="wear" id="attack2" storage="chara/mu/mu_attack_wear_2.png" zindex="1"]
        [chara_layer name="mu" part="wear" id="attack3" storage="chara/mu/mu_attack_wear_3.png" zindex="1"]
        [chara_layer name="mu" part="head" id="attack1" storage="chara/mu/mu_attack_head_1.png" zindex="10"]
        [chara_layer name="mu" part="head" id="attack2" storage="chara/mu/mu_attack_head_2.png" zindex="10"]
        [chara_layer name="mu" part="head" id="attack3" storage="chara/mu/mu_attack_head_3.png" zindex="10"]
        [chara_layer name="mu" part="attacking_l" id="default" storage="none" zindex="11"]
        [chara_layer name="mu" part="attacking_l" id="wait1" storage="chara/mu/mu_attack_left_wear_1.png" zindex="11"]
        [chara_layer name="mu" part="attacking_l" id="wait2" storage="chara/mu/mu_attack_left_wear_1.png" zindex="11"]
        [chara_layer name="mu" part="attacking_l" id="wait3" storage="chara/mu/mu_attack_left_wear_2.png" zindex="11"]
        [chara_layer name="mu" part="attacking_l" id="attacking1" storage="chara/mu/mu_attack_l_01_animation_loop.webp" zindex="11"]
        [chara_layer name="mu" part="attacking_l" id="attacking2" storage="chara/mu/mu_attack_l_01_animation_loop.webp" zindex="11"]
        [chara_layer name="mu" part="attacking_l" id="attacking3" storage="chara/mu/mu_attack_l_01_animation_loop.webp" zindex="11"]
        [chara_layer name="mu" part="attacking_r" id="default" storage="none" zindex="-1"]
        [chara_layer name="mu" part="attacking_r" id="wait1" storage="chara/mu/mu_attack_right_wear_1.png" zindex="-1"]
        [chara_layer name="mu" part="attacking_r" id="wait2" storage="chara/mu/mu_attack_right_wear_1.png" zindex="-1"]
        [chara_layer name="mu" part="attacking_r" id="wait3" storage="chara/mu/mu_attack_right_wear_2.png" zindex="-1"]
        [chara_layer name="mu" part="attacking_r" id="attacking1" storage="chara/mu/mu_attack_r_01_animation_loop.webp" zindex="-1"]
        [chara_layer name="mu" part="attacking_r" id="attacking2" storage="chara/mu/mu_attack_r_01_animation_loop.webp" zindex="-1"]
        [chara_layer name="mu" part="attacking_r" id="attacking3" storage="chara/mu/mu_attack_r_01_animation_loop.webp" zindex="-1"]
    [chara_face name="mu" face="guard" storage="chara/mu/mu_guard.png"]
        [chara_layer name="mu" part="wear" id="guard1" storage="chara/mu/mu_guard_wear_1.png" zindex="1"]
        [chara_layer name="mu" part="wear" id="guard2" storage="chara/mu/mu_guard_wear_2.png" zindex="1"]
        [chara_layer name="mu" part="wear" id="guard3" storage="chara/mu/mu_guard_wear_3.png" zindex="1"]
        [chara_layer name="mu" part="head" id="guard1" storage="chara/mu/mu_guard_head_1.png" zindex="10"]
        [chara_layer name="mu" part="head" id="guard2" storage="chara/mu/mu_guard_head_2.png" zindex="10"]
        [chara_layer name="mu" part="head" id="guard3" storage="chara/mu/mu_guard_head_3.png" zindex="10"]
    [chara_face name="mu" face="damaged" storage="chara/mu/mu_damaged.png"]
        [chara_layer name="mu" part="wear" id="damaged1" storage="chara/mu/mu_damaged_wear_1.png" zindex="1"]
        [chara_layer name="mu" part="wear" id="damaged2" storage="chara/mu/mu_damaged_wear_2.png" zindex="1"]
        [chara_layer name="mu" part="wear" id="damaged3" storage="chara/mu/mu_damaged_wear_3.png" zindex="1"]
        [chara_layer name="mu" part="head" id="damaged1" storage="chara/mu/mu_damaged_head_1.png" zindex="10"]
        [chara_layer name="mu" part="head" id="damaged2" storage="chara/mu/mu_damaged_head_2.png" zindex="10"]
        [chara_layer name="mu" part="head" id="damaged3" storage="chara/mu/mu_damaged_head_3.png" zindex="10"]
    [chara_face name="mu" face="down" storage="chara/mu/mu_down.png"]
        [chara_layer name="mu" part="wear" id="down1" storage="chara/mu/mu_down_wear_1.png" zindex="10"]
        [chara_layer name="mu" part="wear" id="down2" storage="chara/mu/mu_down_wear_2.png" zindex="10"]
        [chara_layer name="mu" part="wear" id="down3" storage="chara/mu/mu_down_wear_3.png" zindex="10"]
        [chara_layer name="mu" part="head" id="down1" storage="chara/mu/mu_down_head_1.png" zindex="10"]
        [chara_layer name="mu" part="head" id="down2" storage="chara/mu/mu_down_head_2.png" zindex="10"]
        [chara_layer name="mu" part="head" id="down3" storage="chara/mu/mu_down_head_3.png" zindex="10"]
    [chara_face name="mu" face="knockout" storage="chara/mu/mu_knockout.png"]
        [chara_layer name="mu" part="wear" id="knockout1" storage="chara/mu/mu_knockout_wear_1.png" zindex="10"]
        [chara_layer name="mu" part="wear" id="knockout2" storage="chara/mu/mu_knockout_wear_2.png" zindex="10"]
        [chara_layer name="mu" part="wear" id="knockout3" storage="chara/mu/mu_knockout_wear_3.png" zindex="10"]
        [chara_layer name="mu" part="head" id="knockout1" storage="chara/mu/mu_knockout_head_1.png" zindex="10"]
        [chara_layer name="mu" part="head" id="knockout2" storage="chara/mu/mu_knockout_head_2.png" zindex="10"]
        [chara_layer name="mu" part="head" id="knockout3" storage="chara/mu/mu_knockout_head_3.png" zindex="10"]
[chara_new name="mu_normal_bundle" storage="chara/mu_normal_bundle/default.png" width="500" height="702"]
    [chara_face name="mu_normal_bundle" face="e11_Lv1_1" storage="chara/mu_normal_bundle/e11_Lv1_1.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv1_2" storage="chara/mu_normal_bundle/e11_Lv1_2.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv1_3" storage="chara/mu_normal_bundle/e11_Lv1_3.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv2_1_1" storage="chara/mu_normal_bundle/e11_Lv2_1_1.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv2_1_2" storage="chara/mu_normal_bundle/e11_Lv2_1_2.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv2_1_3" storage="chara/mu_normal_bundle/e11_Lv2_1_3.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv2_2_1" storage="chara/mu_normal_bundle/e11_Lv2_2_1.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv2_2_2" storage="chara/mu_normal_bundle/e11_Lv2_2_2.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv2_2_3" storage="chara/mu_normal_bundle/e11_Lv2_2_3.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv2_3_1" storage="chara/mu_normal_bundle/e11_Lv2_3_1.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv2_3_2" storage="chara/mu_normal_bundle/e11_Lv2_3_2.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv2_3_3" storage="chara/mu_normal_bundle/e11_Lv2_3_3.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv3_1_1" storage="chara/mu_normal_bundle/e11_Lv3_1_1.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv3_1_2" storage="chara/mu_normal_bundle/e11_Lv3_1_2.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv3_1_3" storage="chara/mu_normal_bundle/e11_Lv3_1_3.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv3_2_1" storage="chara/mu_normal_bundle/e11_Lv3_2_1.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv3_2_2" storage="chara/mu_normal_bundle/e11_Lv3_2_2.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv3_2_3" storage="chara/mu_normal_bundle/e11_Lv3_2_3.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv3_3_1" storage="chara/mu_normal_bundle/e11_Lv3_3_1.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv3_3_2" storage="chara/mu_normal_bundle/e11_Lv3_3_2.png"]
    [chara_face name="mu_normal_bundle" face="e11_Lv3_3_3" storage="chara/mu_normal_bundle/e11_Lv3_3_3.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv1_1" storage="chara/mu_normal_bundle/e12_Lv1_1.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv1_2" storage="chara/mu_normal_bundle/e12_Lv1_2.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv1_3" storage="chara/mu_normal_bundle/e12_Lv1_3.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv2_1_1" storage="chara/mu_normal_bundle/e12_Lv2_1_1.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv2_1_2" storage="chara/mu_normal_bundle/e12_Lv2_1_2.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv2_1_3" storage="chara/mu_normal_bundle/e12_Lv2_1_3.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv2_2_1" storage="chara/mu_normal_bundle/e12_Lv2_2_1.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv2_2_2" storage="chara/mu_normal_bundle/e12_Lv2_2_2.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv2_2_3" storage="chara/mu_normal_bundle/e12_Lv2_2_3.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv2_3_1" storage="chara/mu_normal_bundle/e12_Lv2_3_1.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv2_3_2" storage="chara/mu_normal_bundle/e12_Lv2_3_2.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv2_3_3" storage="chara/mu_normal_bundle/e12_Lv2_3_3.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv3_1_1" storage="chara/mu_normal_bundle/e12_Lv3_1_1.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv3_1_2" storage="chara/mu_normal_bundle/e12_Lv3_1_2.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv3_1_3" storage="chara/mu_normal_bundle/e12_Lv3_1_3.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv3_2_1" storage="chara/mu_normal_bundle/e12_Lv3_2_1.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv3_2_2" storage="chara/mu_normal_bundle/e12_Lv3_2_2.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv3_2_3" storage="chara/mu_normal_bundle/e12_Lv3_2_3.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv3_3_1" storage="chara/mu_normal_bundle/e12_Lv3_3_1.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv3_3_2" storage="chara/mu_normal_bundle/e12_Lv3_3_2.png"]
    [chara_face name="mu_normal_bundle" face="e12_Lv3_3_3" storage="chara/mu_normal_bundle/e12_Lv3_3_3.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv1_1" storage="chara/mu_normal_bundle/e13_Lv1_1.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv1_2" storage="chara/mu_normal_bundle/e13_Lv1_2.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv1_3" storage="chara/mu_normal_bundle/e13_Lv1_3.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv2_1_1" storage="chara/mu_normal_bundle/e13_Lv2_1_1.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv2_1_2" storage="chara/mu_normal_bundle/e13_Lv2_1_2.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv2_1_3" storage="chara/mu_normal_bundle/e13_Lv2_1_3.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv2_2_1" storage="chara/mu_normal_bundle/e13_Lv2_2_1.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv2_2_2" storage="chara/mu_normal_bundle/e13_Lv2_2_2.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv2_2_3" storage="chara/mu_normal_bundle/e13_Lv2_2_3.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv2_3_1" storage="chara/mu_normal_bundle/e13_Lv2_3_1.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv2_3_2" storage="chara/mu_normal_bundle/e13_Lv2_3_2.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv2_3_3" storage="chara/mu_normal_bundle/e13_Lv2_3_3.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv3_1_1" storage="chara/mu_normal_bundle/e13_Lv3_1_1.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv3_1_2" storage="chara/mu_normal_bundle/e13_Lv3_1_2.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv3_1_3" storage="chara/mu_normal_bundle/e13_Lv3_1_3.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv3_2_1" storage="chara/mu_normal_bundle/e13_Lv3_2_1.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv3_2_2" storage="chara/mu_normal_bundle/e13_Lv3_2_2.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv3_2_3" storage="chara/mu_normal_bundle/e13_Lv3_2_3.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv3_3_1" storage="chara/mu_normal_bundle/e13_Lv3_3_1.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv3_3_2" storage="chara/mu_normal_bundle/e13_Lv3_3_2.png"]
    [chara_face name="mu_normal_bundle" face="e13_Lv3_3_3" storage="chara/mu_normal_bundle/e13_Lv3_3_3.png"]
[chara_new name="mu_boss_bundle" storage="chara/mu_boss_bundle/default.png" width="1000" height="702"]
    [chara_face name="mu_boss_bundle" face="e14_Lv1_1" storage="chara/mu_boss_bundle/e14_Lv1_1.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv1_2" storage="chara/mu_boss_bundle/e14_Lv1_2.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv1_3" storage="chara/mu_boss_bundle/e14_Lv1_3.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv2_1_1" storage="chara/mu_boss_bundle/e14_Lv2_1_1.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv2_1_2" storage="chara/mu_boss_bundle/e14_Lv2_1_2.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv2_1_3" storage="chara/mu_boss_bundle/e14_Lv2_1_3.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv2_2_1" storage="chara/mu_boss_bundle/e14_Lv2_2_1.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv2_2_2" storage="chara/mu_boss_bundle/e14_Lv2_2_2.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv2_2_3" storage="chara/mu_boss_bundle/e14_Lv2_2_3.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv2_3_1" storage="chara/mu_boss_bundle/e14_Lv2_3_1.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv2_3_2" storage="chara/mu_boss_bundle/e14_Lv2_3_2.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv2_3_3" storage="chara/mu_boss_bundle/e14_Lv2_3_3.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv3_1_1" storage="chara/mu_boss_bundle/e14_Lv3_1_1.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv3_1_2" storage="chara/mu_boss_bundle/e14_Lv3_1_2.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv3_1_3" storage="chara/mu_boss_bundle/e14_Lv3_1_3.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv3_2_1" storage="chara/mu_boss_bundle/e14_Lv3_2_1.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv3_2_2" storage="chara/mu_boss_bundle/e14_Lv3_2_2.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv3_2_3" storage="chara/mu_boss_bundle/e14_Lv3_2_3.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv3_3_1" storage="chara/mu_boss_bundle/e14_Lv3_3_1.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv3_3_2" storage="chara/mu_boss_bundle/e14_Lv3_3_2.png"]
    [chara_face name="mu_boss_bundle" face="e14_Lv3_3_3" storage="chara/mu_boss_bundle/e14_Lv3_3_3.png"]
[macro name="mu_ultimate"]
    ;mp.mu
    ;mp.x
    ;mp.y
    [iscript]
        mp.mu.sp = 0;
        mp.mu.heal(mp.mu.maxLp);
        mp.mu.wearLevel = 1;
        mp.mu.ep = 0;
    [endscript]
    [heal_to chara="&mp.mu" healValue="&mp.mu.maxLp" x="&mp.x" y="&mp.y"]
    [heroine_mod heroine="&mp.mu"]
[endmacro]
[return]
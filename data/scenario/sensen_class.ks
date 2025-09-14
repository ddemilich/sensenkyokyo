*start
;クラス定義
[call storage="sensen_effect.ks"]
[call storage="sensen_action.ks"]
[iscript]

class ModifiableStatus {
    constructor(baseValue) {
        this.baseValue = baseValue;
        this.addModifiers = new Map();
        this.multiplyModifiers = new Map();
    }

    increaseBaseValue(amount) {
        this.baseValue += amount;
    }

    addModifier(key, value, isMultiplicative = false) {
        if (isMultiplicative) {
            this.multiplyModifiers.set(key, value);
        } else {
            this.addModifiers.set(key, value);
        }
    }

    removeModifier(key) {
        this.addModifiers.delete(key);
        this.multiplyModifiers.delete(key);
    }
    
    getCurrentValue() {
        // 1. まず、ベース値に加算・減算の修正を適用
        let currentValue = this.baseValue;
        for (const value of this.addModifiers.values()) {
            currentValue += value;
        }

        // 2. その結果に、乗算・除算の修正を適用
        for (const value of this.multiplyModifiers.values()) {
            currentValue *= value;
        }

        // 3. 最終的な値を返す（整数にするならここでMath.floor）
        return Math.floor(currentValue);
    }

    clearModifiers() {
        this.addModifiers.clear();
        this.multiplyModifiers.clear();
    }
}

class BattleUtil {
    static calculateSplitDamage(baseDamage, splitCount) {
        if (splitCount <= 0) {
            console.error(`calculateSplitDamage: 分割数は1以上である必要があります。splitCount: ${splitCount}`);
            return { totalDamage: 0, splitDamages: [] };
        }

        let splitDamage = Math.floor(baseDamage / splitCount);
        if (splitDamage <= 0) {
            splitDamage = 1;
        }

        let lastHitDamage = baseDamage - (splitDamage * (splitCount - 1));
        if (lastHitDamage <= 0) {
            lastHitDamage = 1;
        }

        const splitDamages = [];
        for (let i = 0; i < splitCount - 1; i++) {
            splitDamages.push(splitDamage);
        }
        splitDamages.push(lastHitDamage);

        const totalDamage = splitDamages.reduce((sum, current) => sum + current, 0);

        return {
            totalDamage: totalDamage,
            splitDamages: splitDamages
        };
    }
}
window.BattleUtil = BattleUtil;

class Character {
    constructor(name, lp, ap, width, height) {
        this.name = name; // これがchara_Xタグで指定する名前になる。unique
        this.displayName = "???";
        this.ap = new ModifiableStatus(ap);
        this.lp = lp;
        this.maxLp = lp;
        this.sp = 0;
        this.maxSp = 100;
        this.dodgeRate = 0.0;
        this.hitRate = 1.0;

        // 表示用の設定
        this.width = width;
        this.height = height;
        this.zindex = 1;

        // バー関係
        this.ptextName = this.name + '_ptext';
        this.lpbarWidth = this.width;
        this.lpbarHeight = 10;
        this.lpbarLeftToRight = true;
        this.spbarHeight = 5;

        // アクション
        this.actionClasses = new Map();
        this.registerDefaultActions(); 
        this.actions = [];
        this.maxActionCount = new ModifiableStatus(1);
        // エフェクト
        this.activeEffects = [];
        this.activeEffects.push(new StepByStepEffect());

        // 拘束
        this.bundled = false;
        console.log(`${this.name}が生成されました。`);
    }

    // AP関係
    get currentAp() {
        return this.ap.getCurrentValue();
    }
    applyApBuff(key, value) {
        this.ap.addModifier(key, Math.floor(value));
    }
    applyMultiplicativeApBuff(key, rate) {
        this.ap.addModifier(key, rate, true);
    }

    // アクション数
    get currentActionCount() {
        return this.maxActionCount.getCurrentValue();
    }
    applyActionCountBuff(key, value) {
        this.maxActionCount.addModifier(key, Math.floor(value));
    }
    clearAllTemporaryStatuses() {
        this.ap.clearModifiers();
        this.maxActionCount.clearModifiers();
    }

    lpbarX(x) {
        return String(parseInt(x));
    }
    lpbarY(y) {
        return String(parseInt(y) + this.height - this.lpbarHeight);
    }
    lpbarName() {
        return this.name + '_lpbar'
    }
    lpbarActiveX(x) {
        if (this.lpbarLeftToRight) {
            return String(parseInt(x));
        } else {
            return String(parseInt(x) + (this.lpbarWidth - this.lpbarActiveWidth()));
        }
    }
    lpbarActiveWidth() {
        if (this.isDefeated()) {
            return 1;
        } else {
            let liferate = this.lp / this.maxLp;
            return parseInt(this.width * liferate);
        }
    }
    getLpbarImagePath() {
        return `chara/bar/lpbar_max.png`;
    }
    lpbarActiveName() {
        return `${this.name}_lpbar_active`;
    }
    getLpbarActiveImagePath() {
        return `chara/bar/lpbar.png`;
    }
    lpbarText() {
        return `${this.name}_lpbar_text`;
    }
    spbarName() {
        return `${this.name}_spbar`;
    }
    spbarWidth() {
        if (this.sp==0) {
            return 1;
        } else {
            let liferate = this.sp / this.maxSp;
            return parseInt(this.width * liferate);
        }
    }
    spbarX(x) {
        if (this.lpbarLeftToRight) {
            return String(parseInt(x));
        } else {
            return String(parseInt(x) + (this.width - this.spbarWidth()));
        }
    }
    spbarY(y) {
        return String(parseInt(y) + this.height);
    }
    getSpbarImagePath() {
        return `chara/bar/spbar.png`;
    }
    guardedX(x) {
        if (this.lpbarLeftToRight) {
            return String((parseInt(x) + this.width) - Math.floor(this.width * 0.3));
        } else {
            return String((parseInt(x) - this.width) + Math.floor(this.width * 0.3));
        }
    }
    guardedY(y) {
        return String(y);
    }

    isDefeated() {
        return (this.lp <= 0);
    }

    // デフォルトアクションを登録するヘルパーメソッド
    registerDefaultActions() {
        console.warn(`[Character - ${this.name}] registerDefaultActions メソッドがオーバーライドされていません。`);
    }
    createActionInstance(actionKey) {
        // actionKeyがAction.TYPE_DEFINITIONSに存在するかをチェック
        if (!Action.TYPE_DEFINITIONS.hasOwnProperty(actionKey)) {
            console.error(`[Character - ${this.name}] 無効なアクションキーが指定されました。Action.TYPE_DEFINITIONSに定義されていません: ${actionKey}`);
            return null;
        }

        // マップからアクションクラス（コンストラクタ）を取得
        const ActionClass = this.actionClasses.get(actionKey);
        if (!ActionClass) {
            console.error(`[Character - ${this.name}] アクションクラスが見つかりません。actionClassesに登録されていません: ${actionKey}`);
            return null;
        }
        
        const actionInstance = new ActionClass(); 

        // 生成されたインスタンスがActionクラスの派生であることをチェック
        if (!(actionInstance instanceof Action)) {
            console.error(`[Character - ${this.name}] ファクトリが不正な型を生成しました。期待される型: Action, 実際の型: ${actionInstance.constructor.name || typeof actionInstance}`, actionInstance);
            return null;
        }

        return actionInstance;
    }
    decideOneAction(source, allEnemies, allHeroines) {
        const actionKeyToSelect = this.selectActionByWeight(4,2,1);
        const selectedAction = this.createActionInstance(actionKeyToSelect); 
        if (selectedAction) {
            selectedAction.decideTargetCharaDisplayData(source, allEnemies, allHeroines);
            this.actions.push(selectedAction);
            console.log(`[Character - ${this.name}] がアクション "${selectedAction.name}" を自動決定し、リストに追加しました。`);
        } else {
            console.warn(`[Character - ${this.name}] 自動決定できるアクションが見つからなかったため、リストに追加されませんでした。`);
        }
    }
    decideActions(source, allEnemies, allHeroines) {
        for (let i = 0; i < this.currentActionCount; i++){
            this.decideOneAction(source, allEnemies, allHeroines);
        }
    }
    selectActionByWeight(firstStrikeWeight, chargeBurstWeight, guardCounterWeight) {
        let weights = {
            'FirstStrike': firstStrikeWeight,
            'ChargeBurst': chargeBurstWeight,
            'GuardCounter': guardCounterWeight,
        };

        const hasValidWeights = (w1, w2, w3) => {
            if (!Number.isInteger(w1) || w1 < 0 ||
                !Number.isInteger(w2) || w2 < 0 ||
                !Number.isInteger(w3) || w3 < 0) {
                return false;
            }
            return (w1 + w2 + w3) > 0;
        };

        if (!hasValidWeights(firstStrikeWeight, chargeBurstWeight, guardCounterWeight)) {
            console.warn(`[Character - ${this.name}] 無効なアクション重みが指定されました。FirstStrikeをデフォルトで選択します。`);
            weights = {
                'FirstStrike': 1,
                'ChargeBurst': 0,
                'GuardCounter': 0,
            };
        }

        const totalWeight = Object.values(weights).reduce((sum, weight) => sum + weight, 0);
        let randomNumber = Math.random() * totalWeight;
        for (const key in weights) {
            const weight = weights[key];
            if (weight <= 0) continue;
            
            randomNumber -= weight;
            if (randomNumber < 0) {
                return key;
            }
        }
        return 'FirstStrike';
    }
    setActionByKey(actionKey) {
        const action = this.createActionInstance(actionKey);
        if (action) {
            this.actions.push(action);
            console.log(`[Character - ${this.name}] にアクション "${action.name}" を設定し、リストに追加しました。`);
            return action; // 設定されたActionインスタンスを返すことで、続けてターゲットを設定できる
        }
        return null;
    }
    removeActions() {
        this.actions.length = 0;
    }
    removeAction(actionToRemove) {
        const index = this.actions.indexOf(actionToRemove);
        if (index > -1) {
            this.actions.splice(index, 1);
        }
    }
    actionIconX(x, index) {
        const asize = this.actionIconSize();
        const asize_with_margin = asize + 1;
        const result = (x + this.width - asize - (asize_with_margin * index));
        return String(result);
    }
    actionIconY(y, index) {
        const result = y - this.actionIconSize();
        return String(result);
    }
    actionIconSize() {
        // キャラクタの縦幅に比例させる？
        return Math.floor(this.width/6);
    }
    IsActionDecisionCompleted() {
        const comp = (this.actions.length >= this.currentActionCount);
        return comp;
    }

    // --- エフェクト関連メソッド ---
    addEffect(effect) {
        this.activeEffects.push(effect);
    }
    removeEffect(effectClass) {
        // filter()メソッドを使って、指定されたクラスのインスタンス以外で構成される新しい配列を作成する
        const effectsToKeep = this.activeEffects.filter(effect => {
            // effectインスタンスが指定されたeffectClassの派生ではない場合にtrueを返す
            return !(effect instanceof effectClass);
        });

        // activeEffectsリストを新しい配列で置き換える
        if (effectsToKeep.length < this.activeEffects.length) {
            console.log(`[${this.name}] から ${effectClass.name} のエフェクトが削除されました。`);
            this.activeEffects = effectsToKeep;
            return true;
        }
        console.warn(`[${this.name}] に ${effectClass.name} のエフェクトは見つかりませんでした。`);
        return false;
    }

    changeSp(amount) {
        this.sp += amount;
        
        if (this.sp > this.maxSp) {
            this.sp = this.maxSp;
        }
        if (this.sp < 0) {
            this.sp = 0;
        }
    }
    increaseSpByDamage(damage) {
        const threshold = this.maxLp * 0.6;
        const spIncreaseAmount = Math.ceil(this.maxSp * damage / threshold);
        this.changeSp(spIncreaseAmount);
    }
    canUseUltimate() {
        return (this.sp == this.maxSp);
    }
    useSpByUltimate() {
        this.sp -= this.maxSp;
        if (this.sp < 0) {
            this.sp = 0;
        }
    }
    applyDamageWithEvasion(incomingDamages, incomingHitRate = 1.0) {
        const actualDamages = [];
        let actualTotalDamage = 0;

        const finalHitChance = Math.max(0, Math.min(1, incomingHitRate * (1 - this.getDodgeRate())));

        console.log(`[${this.name}] hit:${incomingHitRate} vs dodge:${this.getDodgeRate()} 最終的な命中確率: ${(finalHitChance * 100).toFixed(2)}%`);

        incomingDamages.forEach((damage, index) => {
            const randomNumber = Math.random(); // 0.0 から 1.0 未満の乱数を生成
            
            // 命中判定
            if (finalHitChance > randomNumber) {
                // 命中！
                actualDamages.push(damage);
                actualTotalDamage += damage;
                console.log(`[${this.name}] ヒット${index + 1} (${damage}D) -> 命中！ (乱数: ${randomNumber.toFixed(4)})`);
            } else {
                // 回避！
                actualDamages.push(0); // ダメージは0として記録
                console.log(`[${this.name}] ヒット${index + 1} (${damage}D) -> 回避成功！ (乱数: ${randomNumber.toFixed(4)})`);
            }
        });

        console.log(`[${this.name}] 全体の合計ダメージ: ${actualTotalDamage}`);

        return {
            actualTotalDamage: actualTotalDamage,
            splitDamages: actualDamages
        };
    }
    takeDamage(damage) {
        this.increaseSpByDamage(damage);
        this.lp -= damage;
        if (this.lp < 0) {
            this.lp = 0;
        }
    }
    heal(amount) {
        this.lp += amount;
        if (this.lp > this.maxLp) {
            this.lp = this.maxLp;
        }
    }
    lpDiffX(x, fix=false) {
        if (fix) {
            return String(parseInt(x));
        }
        const result = parseInt(x) + Math.floor((Math.random() - 0.5) * this.width);
        return String(result);
    }
    lpDiffY(y, fix=false) {
        const diffy = Math.floor(parseInt(y) + this.height * 0.8);

        if (fix) {
            return String(diffy);
        }
        const result = diffy - Math.floor((Math.random()) * this.height * 0.8);
        return String(result);
    }

    lpDiffName(label="") {
        return `${this.name}_lp_diff${label}`;
    }
    getDodgeRate() {
        return this.dodgeRate;
    }
    getHitRate() {
        return this.hitRate;
    }
}

class Heroine extends Character {
    // ヒロイン共通
    static HEROINE_DODGE_RATE = 0.85;
    static HEROINE_RESCUE_RATE = 0.2;

    constructor(name, lp, ap, width, height) {
        super(name, lp, ap, width, height);
        this.dodgeRate = Heroine.HEROINE_DODGE_RATE;

        this.wearLevel = 1;
        this.er = 0;
        this.cr = 0;
        this.pose = "base";

        this.lpbarLeftToRight = false;
        this.erbarHeight = this.spbarHeight;
        this.activeEffects.push(new CooldownEffect());
        this.activeEffects.push(new BuddyBonding());

        // アルティメット使用
        this.decideUltimate = false;
        // 救出使用
        this.decideRescue = false;
    }

    // 服破レベル 無傷:1 中破:2 大破:3
    setWearLevel(level) {
        if (level < 1 || level > 3) {
            this.wearLevel = 1;
        } else {
            this.wearLevel = level;
        }
    }
    setPose(pose) {
        this.pose = pose;
    }
    getPoseHeadLabel() {
        return `${this.pose}${this.getEcstaticLevel()}`;
    }
    getPoseWearLabel() {
        return `${this.pose}${this.wearLevel}`;
    }
    getAttackingLabel() {
        if (this.pose == "attack") {
            return `attacking${this.wearLevel}`;
        } else {
            return "default";
        }
    }
    // 快楽値 小:1 中:2 大:3
    setEcstaticLevel(level) {
        if (level == 3) {
            this.er = 80;
        } else if (level == 2) {
            this.er = 30;
        } else {
            this.er = 0;
        }
    }
    getEcstaticLevel() {
        if (this.er >= 80) {
            return 3;
        } else if (this.er >= 30) {
            return 2;
        } else {
            return 1;
        }
    }
    getEcstaticLevelLabel() {
        return `head${this.getEcstaticLevel()}`;
    }

    // 堕落度 小:1 中:2 大:3
    setCorruptedLevel(level) {
        if (level == 3) {
            this.cr = 80;
        } else if (level == 2) {
            this.cr = 30;
        } else {
            this.cr = 0;
        }
    }
    getCorruptedLevel() {
        if (this.cr >= 80) {
            return 3;
        } else if (this.cr >= 30) {
            return 2;
        } else {
            return 1;
        }
    }
    getCorruptedLevelLabel() {
        return `head${this.getCorruptedLevel()}`;
    }
    lpbarActiveWidth() {
        let liferate = this.lp / this.maxLp;
        let resultInt = parseInt(this.width * liferate);
        if (resultInt == 0) {
            return 1;
        } else {
            return resultInt;
        }
    }
    isDefeated() {
        return false;
    }

    // ヒロインのアクションアイコン配置は左から右
    actionIconX(x, index) {
        const asize = this.actionIconSize();
        const asize_with_margin = asize + 1;
        return String(x + (asize_with_margin * index));
    }
    actionIconY(y, index) {
        return String(y - this.actionIconSize());
    }
    actionIconSize() {
        // キャラクタの縦幅に比例させる？
        return Math.floor(this.width/8);
    }

    actionSelectX(x, index) {
        return String(x - (this.actionSelectWidth() + 1) * (2 - index));
    }
    actionSelectY(y, index) {
        return String(y + (this.actionSelectWidth() + 1) * index);
    }
    actionSelectWidth() {
        // キャラクタの縦幅に比例させる？
        return Math.floor(this.width/6);
    }
    prepareUltimate() {
        this.decideUltimate = true;
    }
    prepareRescue() {
        this.decideRescue = true;
    }

    tryWearLevelUp(damage) {
        // LPが0以下の場合は、既に戦闘不能やそれに近い状態なので、イベント発生は考慮しない（必要であれば調整）
        if (this.lp <= 0) {
            return;
        }
        // 服が破れ切ってたら終わり
        if (this.wearLevel >= 3) {
            return;
        }
        // 1. 基本となる上昇確率を計算
        // 例: damageReceived=10, currentLp=100 -> probability = 0.1 (10%)
        // 例: damageReceived=10, currentLp=20  -> probability = 0.5 (50%)
        let probability = damage / this.lp * 1.5;

        // 確率が100%を超える場合があるため、最大値を1.0 (100%) に制限
        // 例: damageReceived=50, currentLp=20 -> probability = 2.5 -> 1.0 (100%) になる
        if (probability > 1.0) {
            probability = 1.0;
        }

        console.log(`ダメージ: ${damage}, 現在LP: ${this.lp}`);
        console.log(`計算された確率: ${(probability * 100).toFixed(2)}%`);

        // 2. 乱数を生成して確率判定
        const randomNumber = Math.random(); 
        console.log(`生成された乱数: ${randomNumber.toFixed(4)}`);

        // 乱数が計算された確率よりも小さければ、イベント発生
        // 例: 確率0.5 (50%) なら、乱数0.0000～0.4999...で true
        if (randomNumber < probability) {
            console.log("-> イベント発生: TRUE");
            this.wearLevel++;
        } else {
            console.log("-> イベント発生: FALSE");
            return;
        }
    }

    takeDamage(damage) {
        this.increaseSpByDamage(damage);
        // 服敗れチャレンジ
        this.tryWearLevelUp(damage);
        // 既存のLPを保存しておく
        const previousLp = this.lp;

        // まずダメージを適用
        this.lp -= damage;

        // ラストスタンドの判定と適用
        if (previousLp > 1 && this.lp <= 0) {
            this.lp = 1; // LPを1で踏みとどまる
            console.log(`${this.name} は踏みとどまった！ 残りLP: 1`);
        } else if (this.lp < 0) {
            this.lp = 0;
        }
        this.updatePoseByLp();
    }
    heal(amount) {
        const previousLp = this.lp;
        this.lp += amount;

        if (this.maxLp && this.lp > this.maxLp) {
            this.lp = this.maxLp;
        }        
        this.updatePoseByLp();
    }
    updatePoseByLp() {
        if (this.lp === 1) {
            this.setPose("down");
        } else if (this.lp === 0) {
            this.setPose("knockout");
        } else {
            this.setPose("base");
        }
    }

    // ER関連
    erbarName() {
        return `${this.name}_erbar`;
    }
    erbarWidth(current=-1) {
        let baseEr = this.er;
        if (current != -1) {
            baseEr = current;
        }
        if (baseEr==0) {
            return 1;
        } else {
            let errate = baseEr / 100;
            if (errate > 1.0) {
                errate = 1.0;
            }
            return Math.floor(this.width * errate);
        }
    }
    erbarX(x, current=-1) {
        return String(parseInt(x) + (this.width - this.erbarWidth(current)));
    }
    erbarY(y) {
        // spbarの下にerbarを配置する
        return String(parseInt(y) + this.height + this.spbarHeight);
    }
    canEcstasy() {
        return this.er >= 100;
    }
    processEcstasy() {
        const fixedErConsume = -100;
        this.changeEr(fixedErConsume);
        const optionErConsume = -Math.floor(this.er * 0.5);
        this.changeEr(optionErConsume);
        this.changeCr(1);
        return fixedErConsume + optionErConsume;
    }
    getErbarImagePath() {
        return `chara/bar/erbar.png`;
    }
    changeEr(amount) {
        this.er += amount;
        if (this.er < 0) {
            this.er = 0;
        }
    }
    applyErValue(value) {
        // ER上昇値 = スキル固有のER上昇値 * (3/1000 * CR^2 + 3/100 * CR + 1)
        // 
        const erAmount = Math.floor(value * (1 + (this.cr * 3 / 100) + (this.cr * this.cr * 3 / 1000)));
        this.changeEr(erAmount);
        return erAmount;
    }
    getDodgeRate() {
        if (this.bundled) {
            // 拘束中は回避しない
            return 0.0;
        }
        // ヒロイン回避率 = 0.85 - (ER * 0.8 / 100)
        let drAmount = this.dodgeRate - (this.er * 0.8 / 100);

        if (drAmount < 0.05) {
            drAmount = 0.05;
        }
        if (drAmount > 1.0) {
            drAmount = 1.0;
        }
        return drAmount;
    }
    getHitRate() {
        // ヒロイン命中率 = 1.0 - (ER * 0.5 / 100)
        let hrAmount = this.hitRate - (this.er * 0.5 / 100);

        if (hrAmount < 0.5) {
            hrAmount = 0.5;
        }
        if (hrAmount > 1.0) {
            hrAmount = 1.0;
        }
        return hrAmount;
    }

    changeCr(amount) {
        this.cr += amount;
        
        if (this.cr < 0) {
            this.cr = 0;
        }
    }

    canUseRescue(buddy) {
        // 自分が拘束されている
        if (this.bundled) {
            return false;
        }
        // SPが20%未満
        if (this.sp < Math.floor(this.maxSp * Heroine.HEROINE_RESCUE_RATE)) {
            return false;
        }
        // 味方が拘束されていない
        if (!buddy.bundled) {
            return false;
        }
        return true;
    }
}
window.Heroine = Heroine;

class Enemy extends Character {
    constructor(name, lp, ap, label, width, height) {
        super(name, lp, ap, width, height);
        this.label = label;
    }
    getEnemyId() {
        return this.constructor.ENEMY_ID;
    }
    getImagePath() {
        return `chara/enemy/${this.getEnemyId()}.png`;
    }
    registerDefaultActions() {
        this.actionClasses.set('FirstStrike', EnemyFirstStrike); // Enemy 用の先制攻撃
        this.actionClasses.set('ChargeBurst', EnemyChargeBurst); 
        this.actionClasses.set('GuardCounter', EnemyGuardCounter);
        this.actionClasses.set('Ultimate', DefaultUltimate);
    
        const definedActionKeys = new Set(Object.keys(Action.TYPE_DEFINITIONS));
        const registeredActionKeys = new Set(this.actionClasses.keys());

        registeredActionKeys.forEach(key => {
            if (!definedActionKeys.has(key)) {
                console.warn(`[Character - ${this.name}] アクション登録警告: '${key}' は Action.TYPE_DEFINITIONS に定義されていない不正なアクションキーです。`);
            }
        });

    }
}

class Luigi extends Enemy {
    static ENEMY_ID = "e11";

    constructor(lp, ap, label, width=500, height=702) {
        super(`${Luigi.ENEMY_ID}_${label}`, lp, ap, label, width, height);
        this.displayName = `配管工のおじさん${label}`;
        console.log(`${this.displayName}はエネミーです。`);
    }
}

class CleaningWoman extends Enemy {
    static ENEMY_ID = "e12";

    constructor(lp, ap, label, width=500, height=702) {
        super(`${CleaningWoman.ENEMY_ID}_${label}`, lp, ap, label, width, height);
        this.displayName = `掃除のお姉さん${label}`;
        console.log(`${this.displayName}はエネミーです。`);
    }
}

class Jelly extends Enemy {
    static ENEMY_ID = "e13";

    constructor(lp, ap, label, width=500, height=702) {
        super(`${Jelly.ENEMY_ID}_${label}`, lp, ap, label, width, height);
        this.displayName = `ゼリー${label}`;
        console.log(`${this.displayName}はエネミーです。`);
    }
}

class Mount extends Enemy {
    static ENEMY_ID = "e14";

    constructor(lp, ap, label, width=1000, height=702) {
        if (width < height) {
            width = parseInt(width * 2);
        }
        super(`${Mount.ENEMY_ID}_${label}`, lp, ap, label, width, height);

        this.displayName = "マウント";
        this.isBoss = true;
        console.log(`${this.displayName}はエネミーです。`);
    }
}

class CharacterBundle {
    constructor(captive, captor, centerX, centerY) {
        this.lp = 3;
        this.captive = captive;
        this.captor = captor;
        if (this.captor.isBoss) {
            this.name = `${this.captive.name}_boss_bundle`;
        } else {
            this.name = `${this.captive.name}_normal_bundle`;
        }
        this.step = 1;
        if (this.captor.isBoss) {
            this.width = this.captive.width * 2;
        } else {
            this.width = this.captive.width;
        }
        this.height = this.captive.height;
        this.x = Math.floor(centerX - (this.width / 2));
        this.y = Math.floor(centerY - (this.height / 2));
        this.textSize = 32;
    }
    getFace() {
        if (this.getLevel() == 1) {
            return `${this.captor.getEnemyId()}_Lv${this.getLevel()}_${this.captive.getEcstaticLevel()}`;
        }
        return  `${this.captor.getEnemyId()}_Lv${this.getLevel()}_${this.captive.getCorruptedLevel()}_${this.step}`
    }
    getLevel() {
        return this.captive.wearLevel;
    }
    takeDamage(value) {
        this.lp -= value;
        if (this.lp < 0) {
            this.lp = 0;
        }
    }
    isBroken() {
        return (this.lp <= 0);
    }

    lpValue() {
        let lpValue = "";
        for (let i = 0; i < this.lp; i++) {
            lpValue += "■";
        }
        return lpValue;
    }
    lpName() {
        return `${this.name}_lp_text`;
    }
    lpX(x) {
        return x;
    }
    lpY(y) {
        return y;
    }
    lpSize() {
        return this.textSize;
    }

    resultName() {
        return `${this.name}_result`;
    }
    resultX() {
        return this.x;
    }
    resultY() {
        return Math.floor(this.y + this.height * 0.8);
    }
}
window.CharacterBundle = CharacterBundle;

class CharaDisplayData {
    constructor(charaInstance, initialX, initialY) {
        if (!charaInstance) {
            throw new Error("CharaDisplayData: charaInstanceは必須です。");
        }
        this.charaInstance = charaInstance;
        this.bundleInstance = null;
        this.x = initialX;
        this.y = initialY;
    }

    // 利便性のために、charaInstanceのdisplayNameを直接取得できるようにしておく
    get displayName() {
        return this.charaInstance.displayName;
    }
    // アクション選択が必要かどうかを判定する(拘束状態も必要なのでこのクラスで実装)
    canSelectAction() {
        // knockoutされていたら選べない
        if (this.charaInstance.pose == 'knockout') {
            return false;
        }
        // 拘束されていなければ選べる
        if (!this.bundleInstance) {
            return true;
        }
        // 拘束されていても、stepが1なら選べる
        if (this.bundleInstance.step == 1) {
            return true;
        }
        // それ以外(主に事後状態を想定したケース)は選べない
        return false;
    }
    updatePositionFromCenter(newCenterX, newCenterY) {
        let width = this.charaInstance.width;
        let height = this.charaInstance.height;

        this.centerX = newCenterX;
        this.centerY = newCenterY;
        this.x = Math.floor(newCenterX - (width / 2));
        this.y = Math.floor(newCenterY - (height / 2));
    }

    // 拘束関連(ヒロイン専用)
    enterBundle(enemy) {
        this.bundleInstance = new CharacterBundle(this.charaInstance, enemy, this.centerX, this.centerY);
        this.bundleInstance.captive.bundled = true;
        this.bundleInstance.captor.bundled = true;
        // add effect
        this.bundleInstance.captive.addEffect(new BundleEffect(enemy));
    }
    setAfterBundle() {
        // add effect
        this.bundleInstance.captive.addEffect(new BundleAfterEffect(this.bundleInstance.captor));
    }
    leaveBundle() {
        // remove effect
        this.bundleInstance.captive.removeEffect(BundleEffect);
        this.bundleInstance.captive.bundled = false;
        this.bundleInstance.captor.bundled = false;
        this.bundleInstance = null;
    }
    cameraX() {
        return (this.centerX - 640);
    }
    cameraY() {
        return (360 - this.centerY);
    }
    fromCameraX() {
        return (this.centerX - 640) + ((Math.random() - 0.5) * this.charaInstance.width * 3);
    }
    fromCameraY() {
        return (360 - this.centerY) + ((Math.random() - 0.5) * this.charaInstance.height * 3);
    }
}
window.CharaDisplayData = CharaDisplayData;

class LabelManager {
    static #ASCII_CODE_OF_A = 65; // 'A' のASCIIコード
    static #MAX_ALPHABET_INDEX = 25; // 'Z' は0オリジンで25番目

    static usedLabels = {};
    static freedLabels = {};

    static getUniqueLabel(enemyId) {
        if (LabelManager.usedLabels[enemyId] === undefined) {
            // init
            LabelManager.usedLabels[enemyId] = -1;
            LabelManager.freedLabels[enemyId] = [];
        }

        let nextIndex = LabelManager.usedLabels[enemyId] + 1;
        if (nextIndex <= LabelManager.#MAX_ALPHABET_INDEX) {
            LabelManager.usedLabels[enemyId] = nextIndex;
            return String.fromCharCode(LabelManager.#ASCII_CODE_OF_A + nextIndex);
        } else {
            if (LabelManager.freedLabels[enemyId].length > 0) {
                const freedIndex = LabelManager.freedLabels[enemyId].shift();
                return String.fromCharCode(LabelManager.#ASCII_CODE_OF_A + freedIndex);
            } else {
                throw new Error(`敵ID "${enemyId}" のラベル上限に達しました。新しいラベルも解放されたラベルもありません。`);
            }
        }
    }

    static releaseLabel(enemyId, label) {
        const index = label.charCodeAt(0) - LabelManager.#ASCII_CODE_OF_A;
        if (index >= 0 && index <= LabelManager.#MAX_ALPHABET_INDEX) {
            LabelManager.freedLabels[enemyId].push(index);
            LabelManager.freedLabels[enemyId].sort((a, b) => a - b);
        }
    }

    static releaseAll() {
        LabelManager.usedLabels = {};
        LabelManager.freedLabels = {};
        console.log("LabelManager: すべてのラベル管理状態が初期化されました。");
    }
}

class EnemyFactory {
    // enemyId と 敵クラスのコンストラクタを対応付けるマップ
    static #enemyRegistry = new Map();

    static registerEnemy(enemyId, enemyClass) {
        if (EnemyFactory.#enemyRegistry.has(enemyId)) {
            console.warn(`警告: 敵ID "${enemyId}" は既に登録されています。上書きします。`);
        }
        EnemyFactory.#enemyRegistry.set(enemyId, enemyClass);
        console.log(`敵ID "${enemyId}" にクラス ${enemyClass.name} が登録されました。`);
    }

    static createEnemy(enemyId, lp, ap, width, height) {
        const enemyClass = EnemyFactory.#enemyRegistry.get(enemyId);
        if (!enemyClass) {
            throw new Error(`不明な敵ID: "${enemyId}"。登録されていません。`);
        }

        const label = LabelManager.getUniqueLabel(enemyId); // LabelManagerは引き続き使用
        return new enemyClass(lp, ap, label, width, height);
    }

    static releaseEnemy(enemyInstance) {
        if (!(enemyInstance instanceof Enemy)) {
            console.warn("警告: releaseEnemy に Enemy クラスのインスタンスではないものが渡されました。");
            return;
        }

        // インスタンスから enemyId と label を取得して LabelManager に渡す
        // enemyId は getEnemyId() メソッドで取得
        // label はインスタンスのメンバ変数として保持されている
        const enemyIdToRelease = enemyInstance.getEnemyId();
        const labelToRelease = enemyInstance.label;

        if (!enemyIdToRelease || !labelToRelease) {
            console.warn(`警告: 敵インスタンスに必要な情報 (enemyId: ${enemyIdToRelease}, label: ${labelToRelease}) がありません。解放できませんでした。`);
            return;
        }

        LabelManager.releaseLabel(enemyIdToRelease, labelToRelease);
        console.log(`敵ID "${enemyIdToRelease}" のラベル "${labelToRelease}" が解放されました。`);
    }
}
window.EnemyFactory = EnemyFactory;

class GameEvent {
    constructor(eventDefinition, params = {}) {
        if (!eventDefinition || typeof eventDefinition.eventName !== 'string' || typeof eventDefinition.jumpLabel !== 'string') {
            throw new Error("GameEvent: 'eventDefinition' は有効なイベント定義オブジェクトである必要があります。");
        }
        this.eventName = eventDefinition.eventName;
        this.jumpLabel = eventDefinition.jumpLabel;
        this.params = params;
    }

    toString() {
        return `[GameEvent] Name: '${this.eventName}', Label: '${this.jumpLabel}', Params: ${JSON.stringify(this.params)}`;
    }
}
window.GameEvent = GameEvent;

EnemyFactory.registerEnemy(Luigi.ENEMY_ID, Luigi);
EnemyFactory.registerEnemy(CleaningWoman.ENEMY_ID, CleaningWoman);
EnemyFactory.registerEnemy(Jelly.ENEMY_ID, Jelly);
EnemyFactory.registerEnemy(Mount.ENEMY_ID, Mount);

[endscript]

[return]
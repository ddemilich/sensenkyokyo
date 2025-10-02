*start
; ステージクラスと表示ブロック
[iscript]

class SensenStage {
    static REWARD_CARD_CLASSES = [
        HeroineApUpCard,
        HeroineCooldownCard,
        HeroineGoodForBoth,
        HeroineLpUpCard,
        HeroineRebalanceCard,
        HeroineLoversCard,
        HeroineLpUpMiddleCard,
        HeroineBerserkCard,
        HeroineApUpMiddleCard,
        HeroineCooldownMiddleCard,
        HeroineDopingCard,
        HeroineWonderingSweetCard,
        HeroineApUpBigCard,
        HeroineCooldownBigCard,
        HeroineLpUpBigCard,
        HeroineForbiddenFruitCard,
        HeroineApUpExtreamCard,
        HeroineLpUpExtreamCard,
    ];
    static RANK_RATES = [
        { 1: 75, 2: 25, 3: 0, 4: 0 }, // 合計 100
        { 1: 55, 2: 30, 3: 15, 4: 0 },  // 合計 100
        { 1: 45, 2: 33, 3: 20, 4: 2 },  // 合計 100
        { 1: 30, 2: 40, 3: 25, 4: 5 },  // 合計 100
        { 1: 19, 2: 35, 3: 35, 4: 10 },  // 合計 100
        { 1: 18, 2: 25, 3: 36, 4: 18 },  // 合計 100
        { 1: 18, 2: 25, 3: 36, 4: 18 },  // 合計 100
        { 1: 10, 2: 20, 3: 25, 4: 35 },
    ];

    static selectRandomCardClass(list) {
        const maxIndex = list.length - 1;
        // 0 から リストの最大インデックス までのランダムな整数を取得
        const randomIndex = BattleUtil.getRandomInt(0, maxIndex);
        return list[randomIndex];
    }

    static drawRandomRank(stageIndex, isBoss) {
        // 配列のインデックスで排出率テーブルを取得
        const rates = SensenStage.RANK_RATES[stageIndex];
        
        if (!rates) return 1; 
        
        const total = 100;
        let randomValue = BattleUtil.getRandomInt(1, total);

        let currentSum = 0;
        for (let rank = 1; rank <= 4; rank++) {
            currentSum += rates[rank] || 0;

            if (randomValue <= currentSum) {
                if (isBoss && rank < 4) {
                    return rank + 1;
                } else {
                    return rank;
                }
            }
        }
        return 1;
    }
    static isBossEvent(event) {
        return(event instanceof SensenStageBossEvent || event instanceof SensenStageBossEventTwo);
    }
    
    constructor() {
        this.stageIndex = 0;

        this.progress = 0;
        this.progressBarX = 50;
        this.progressBarY = 650;
        this.progressBarHeight = 20;
        this.progressBarWidth = 600;
        this.progressFontSize = 32;

        this.progressFontX = this.progressBarX + this.progressBarWidth - this.progressFontSize;
        this.progressFontY = this.progressBarY - this.progressFontSize;
        this.stringName = "stage_p_bar_string";
        this.barBgName = "stage_p_bar_bg";
        this.barName = "stage_p_bar";
        
        this.fixedEventItems = [];
        this.ListedEventItems = [];
        this.selectedEventIndex = -1;

        this.eventDetailX = 50;
        this.eventDetailY = 50;
        this.eventDetailWidth = 250;
        this.eventDetailHeight = 550;
        this.eventDetailBottomY = this.eventDetailHeight - 50;

        this.eventListX = 410;
        this.eventListY = 50;
        this.eventListWidth = 240;
        this.eventListHeight = 550;

        this.eventButtonWidth = this.eventListWidth;
        this.eventButtonHeight = 80;
        this.eventButtonMargin = 5;

        this.eventMarkWidth = this.eventListX - (this.eventDetailX + this.eventDetailWidth);
    }
    progressString() {
        return `${this.progress}%`;
    }
    getBarBgPath() {
        return `chara/bar/lpbar_max.png`;
    }
    getBarPath() {
        return `chara/bar/lpbar.png`;
    }
    getBarWidth() {
        let liferate = this.progress / 100;
        let v = Math.floor(this.progressBarWidth * liferate);
        if (v == 0) {
            return 1;
        }
        return v;
    }
    getBarX() {
        return String(this.progressBarX + (this.progressBarWidth - this.getBarWidth()));
    }

    eventY(index) {
        return this.eventButtonHeight + parseInt(index) * (this.eventButtonHeight + this.eventButtonMargin);
    }
    eventX(index) {
        return this.eventListX;
    }
    eventMarkX() {
        return (this.eventDetailX + this.eventDetailWidth);
    }
    eventMarkY() {
        return this.eventY(this.selectedEventIndex);
    }
    applyProgress(value) {
        this.progress += value;
        if (this.progress > 100) {
            this.progress = 100;
        }
    }

    generateNewEventItems() {
        this.selectedEventIndex = -1;
        let eventItems = [];
        const desiredEventCount = BattleUtil.getRandomInt(2, 4);

        // 固定イベントが全て完了した場合はイベントを発行しない
        const unCompleteFixedEvents = this.fixedEventItems.filter(item => !item.isCompleted);
        if (unCompleteFixedEvents.length==0) {
            console.warn("no item remained!");
            this.ListedEventItems = eventItems;
            return;
        }
        // 1. 次に条件を満たす固定イベント項目を見つける
        const nextFixedEventItem = this.fixedEventItems.find(item =>
            !item.isCompleted && this.progress >= item.progressReq
        );

        // 2. もし見つかれば、固定イベント項目への参照をリストに追加する
        if (nextFixedEventItem) {
            eventItems.push(nextFixedEventItem);
        }

        // 3. 残りの枠を汎用イベント項目で埋める
        const currentEventCount = eventItems.length;
        const genericEventCount = desiredEventCount - currentEventCount;

        for (let i = 0; i < genericEventCount; i++) {
            // 汎用イベント用に、完了フラグを持つ新しい項目を作成する
            eventItems.push({
                event: new SensenStageEvent(this.progress),
                isCompleted: false, // 汎用イベントは固定イベントと同じ方法では完了しない
                progressReq: -1 // 固定イベントではないため、ダミー値を設定
            });
        }

        // 4. リストをシャッフルする
        eventItems.sort(() => Math.random() - 0.5);

        // 新しいリストをメンバ変数に代入する
        this.ListedEventItems = eventItems;
    }

    handleEventSelection(lambda, mu) {
        const selectedEventItem = this.ListedEventItems[this.selectedEventIndex];
        const selectedEvent = selectedEventItem.event;

        selectedEvent.apply(lambda, mu);
    }
    hasBattleEvent() {
        return this.ListedEventItems[this.selectedEventIndex].event.hasBattle;
    }
    getEventDetail() {
        return this.ListedEventItems[this.selectedEventIndex].event.detail();
    }
    getEventMessage() {
        return this.ListedEventItems[this.selectedEventIndex].event.eventMsg;
    }
    onEventCompleted() {
        const selectedEventItem = this.ListedEventItems[this.selectedEventIndex];

        const progressValue = selectedEventItem.event.getProgressPoint();
        this.applyProgress(progressValue);
        selectedEventItem.isCompleted = true;
        this.generateNewEventItems()
    }

    getSettingBg() {
        return "default.png";
    }
    getBgm() {
        // 通常イベントとボスイベントで変更する。
        const selectedEventItem = this.ListedEventItems[this.selectedEventIndex];
        const selectedEvent = selectedEventItem.event;
        if (SensenStage.isBossEvent(selectedEvent)) {
            return "FuneralRites.wav";
        } else {
            return "LoseMe.wav";
        }
    }
    battleSetup(lambda, mu, scenario, target) {
        // イベントから敵の数とか吸い出してthis.Battleを作り上げる
    }

    generateSingleReward(targetHeroine, buddyHeroine) {
        const selectedEventItem = this.ListedEventItems[this.selectedEventIndex];
        const selectedEvent = selectedEventItem.event;
        const targetRank = SensenStage.drawRandomRank(this.stageIndex, SensenStage.isBossEvent(selectedEvent)); 
        
        const candidates = SensenStage.REWARD_CARD_CLASSES.filter(CardClass => 
            CardClass.rank === targetRank
        );
        
        // c. カードクラスの抽選 (候補がない場合はエラーログを出してフォールバック)
        if (candidates.length === 0) {
            console.error(`リワード生成: ランク ${targetRank} の候補が見つかりません。`);
            // ここで代替処理（例: ランク1のカードで代替）を行うとより安全だが、
            // 今は単純にランク1候補から選ぶことにする
            const fallbackCandidates = SensenStage.REWARD_CARD_CLASSES.filter(CardClass => CardClass.rank === 1);
            const CardClass = SensenStage.selectRandomCardClass(fallbackCandidates);
            return new CardClass(targetHeroine, buddyHeroine);
        }
        
        const CardClass = SensenStage.selectRandomCardClass(candidates);
        
        // d. インスタンス生成
        return new CardClass(targetHeroine, buddyHeroine);
    }
    prepareRewards(lambda, mu) {
        this.lambdaReward = this.generateSingleReward(lambda, mu);
        this.muReward = this.generateSingleReward(mu, lambda);
    }
}

class SensenStageOne extends SensenStage {
    constructor() {
        super();
        this.stageIndex = 0;
        this.fixedEventItems = [
            {
                event: new SensenStageBossEvent(100),
                isCompleted: false,
                progressReq: 100,
            },
            {
                event: new SensenStageFixedEventE11(25),
                isCompleted: false,
                progressReq: 25,
            },
            {
                event: new SensenStageFixedEventE12(50),
                isCompleted: false,
                progressReq: 50,
            },
            {
                event: new SensenStageFixedEventE13(75),
                isCompleted: false,
                progressReq: 75,
            },
        ].sort((a, b) => a.progressReq - b.progressReq);
    }
    getSettingBg() {
        return "stage1.png";
    }
    battleSetup(lambda, mu, scenario, target) {
        // イベントを確認して
        const selectedEventItem = this.ListedEventItems[this.selectedEventIndex];
        const selectedEvent = selectedEventItem.event;

        let enemyIds = ["e11", "e12"];
        if (this.progress >= 50) {
            enemyIds.push("e13");
        }        
        // 敵一覧を生成
        const enemyList = selectedEvent.generateEnemyIdList(enemyIds);

        // 敵の強さ(Lv1~Lv5)
        let enemyLevel = 1 + Math.floor((this.progress * 4)/100);
        // 初期SP
        const defaultSp = selectedEvent.getDefaultSp();
        // 偏り
        const weight = selectedEvent.getActionWeight();
        // バトルセクション生成
        this.Battle = new BattleSection(lambda, mu, enemyList, enemyLevel, scenario, target, defaultSp, weight);
    }
}
window.SensenStageOne = SensenStageOne;

class SensenStageTwo extends SensenStage {
    constructor() {
        super();
        this.stageIndex = 1;
        this.fixedEventItems = [
            {
                event: new SensenStageBossEventTwo(100),
                isCompleted: false,
                progressReq: 100,
            },
            {
                event: new SensenStageFixedEventE21(25),
                isCompleted: false,
                progressReq: 25,
            },
            {
                event: new SensenStageFixedEventE22(50),
                isCompleted: false,
                progressReq: 50,
            },
            {
                event: new SensenStageFixedEventE23(75),
                isCompleted: false,
                progressReq: 75,
            },
        ].sort((a, b) => a.progressReq - b.progressReq);
    }
    getSettingBg() {
        return "stage2.png";
    }
    battleSetup(lambda, mu, scenario, target) {
        // イベントを確認して
        const selectedEventItem = this.ListedEventItems[this.selectedEventIndex];
        const selectedEvent = selectedEventItem.event;

        let enemyIds = ["e21", "e22"];
        if (this.progress >= 50) {
            enemyIds.push("e23");
        }        
        // 敵一覧を生成
        const enemyList = selectedEvent.generateEnemyIdList(enemyIds);
        // 初期SP
        const defaultSp = selectedEvent.getDefaultSp();
        // 偏り
        const weight = selectedEvent.getActionWeight();

        // 敵の強さ(Lv6~Lv10)
        let enemyLevel = 6 + Math.floor((this.progress * 4)/100);
        
        // バトルセクション生成
        this.Battle = new BattleSection(lambda, mu, enemyList, enemyLevel, scenario, target, defaultSp, weight);
    }
}
window.SensenStageTwo = SensenStageTwo;
[endscript]

[macro name="stage_progress_bar_show"]
    ;mp.stage
    [ptext layer="5" name="&mp.stage.stringName" color="0x42f5f5" size="32" text="&mp.stage.progressString()" x="&mp.stage.progressBarX" y="&mp.stage.progressBarY" width="&mp.stage.progressBarWidth" align="right" edge="4px 0x000000" overwrite="true"]
    ; 下地
    [image layer="4" name="&mp.stage.barBgName" storage="&mp.stage.getBarBgPath()" x="&mp.stage.progressBarX" y="&mp.stage.progressBarY" width="&mp.stage.progressBarWidth" height="&mp.stage.progressBarHeight"]
    [image layer="4" name="&mp.stage.barName" storage="&mp.stage.getBarPath()" x="&mp.stage.getBarX()" y="&mp.stage.progressBarY" width="&mp.stage.getBarWidth()" height="&mp.stage.progressBarHeight"]
[endmacro]
; イベント完了処理とバーの更新
[macro name="stage_progress_bar_refresh"]
    ;mp.stage
    [iscript]
        mp.stage.onEventCompleted();
    [endscript]
    [if exp="mp.stage.getBarWidth()!=0"]
        [anim layer="4" name="&mp.stage.barName" left="&mp.stage.getBarX()" top="&mp.stage.progressBarY" width="&mp.stage.getBarWidth()" height="&mp.stage.progressBarHeight"]
    [endif]
    [ptext layer="5" name="&mp.stage.stringName" color="0x42f5f5" size="32" text="&mp.stage.progressString()" x="&mp.stage.progressBarX" y="&mp.stage.progressBarY" width="&mp.stage.progressBarWidth" align="right" edge="4px 0x000000" overwrite="true"]
[endmacro]
[macro name="stage_progress_bar_hide"]
    [free layer="5" name="&mp.stage.stringName"]
    [free layer="4" name="&mp.stage.barBgName"]
    [free layer="4" name="&mp.stage.barName"]
[endmacro]
[macro name="stage_msg"]
    ;mp.text
    [ptext name="stage_msg" layer="5" x="0" y="250" text="&mp.text" width="1280" size="80" align="center" edge="8px 0x000000" overwrite="true" ]
    [wait time="500"]
[endmacro]
[macro name="stage_event_msg"]
    ;mp.stage
    ;mp.target_event_continue
    [ptext name="stage_event_msg" layer="5" x="&mp.stage.eventDetailX" y="150" text="&mp.stage.getEventMessage()" width="1080" size="24" edge="4px 0x000000" overwrite="true" ]
    [glink color="btn_29_green" text="次へ" size="24" target="&mp.target_event_continue" x="&mp.stage.eventDetailX" y="&mp.stage.eventDetailBottomY" width="&mp.stage.eventDetailWidth" enterse="open.mp3" leavese="close.mp3"]
[endmacro]
[macro name="stage_msg_fadeout"]
    [free name="stage_msg" layer="5" time="150"]
[endmacro]
[macro name="stage_event_msg_fadeout"]
    [free name="stage_event_msg" layer="5" time="150"]
[endmacro]

[macro name="stage_event_detail_bg"]
    ;mp.stage
    [image layer="4" name="stage_event_detail_bg" storage="chara/bar/lpbar_max.png" x="&mp.stage.eventDetailX" y="&mp.stage.eventDetailY" width="&mp.stage.eventDetailWidth" height="&mp.stage.eventDetailHeight"]
[endmacro]
[macro name="stage_event_select"]
    ;mp.stage
    ;mp.target
    ;mp.target_event_start
    [if exp="mp.stage.selectedEventIndex == -1"]
        [ptext layer="5" text="イベントを選んでステージを進んでいこう→" name="event_detail" x="&mp.stage.eventDetailX" y="&mp.stage.eventDetailY" width="&mp.stage.eventDetailWidth" size="24" align="center" overwrite="true" ]
        [ptext layer="5" text=" " name="event_selected" x="&mp.stage.eventMarkX()" y="&mp.stage.eventMarkY()" width="&mp.stage.eventMarkWidth" size="48" align="right" overwrite="true"]
    [else]
        [ptext layer="5" text="&mp.stage.getEventDetail()" name="event_detail" x="&mp.stage.eventDetailX" y="&mp.stage.eventDetailY" width="&mp.stage.eventDetailWidth" size="18" align="left" overwrite="true" ]
        [ptext layer="5" text="→" name="event_selected" x="&mp.stage.eventMarkX()" y="&mp.stage.eventMarkY()" width="&mp.stage.eventMarkWidth" size="48" align="right" overwrite="true"]
        [glink color="btn_29_green" text="進む" size="24" target="&mp.target_event_start" exp="tf.sensenStage.handleEventSelection(tf.sensenData.lambda, tf.sensenData.mu)" x="&mp.stage.eventDetailX" y="&mp.stage.eventDetailBottomY" width="&mp.stage.eventDetailWidth" enterse="open.mp3" leavese="close.mp3"]    
    [endif]
    [button target="&mp.target" exp="tf.sensenStage.selectedEventIndex=0" graphic="&mp.stage.ListedEventItems[0].event.getImagePath()" x="&mp.stage.eventX(0)" y="&mp.stage.eventY(0)" width="&mp.stage.eventButtonWidth" height="&mp.stage.eventButtonHeight" cond="mp.stage.ListedEventItems.length > 0"]
    [button target="&mp.target" exp="tf.sensenStage.selectedEventIndex=1" graphic="&mp.stage.ListedEventItems[1].event.getImagePath()" x="&mp.stage.eventX(1)" y="&mp.stage.eventY(1)" width="&mp.stage.eventButtonWidth" height="&mp.stage.eventButtonHeight" cond="mp.stage.ListedEventItems.length > 1"]
    [button target="&mp.target" exp="tf.sensenStage.selectedEventIndex=2" graphic="&mp.stage.ListedEventItems[2].event.getImagePath()" x="&mp.stage.eventX(2)" y="&mp.stage.eventY(2)" width="&mp.stage.eventButtonWidth" height="&mp.stage.eventButtonHeight" cond="mp.stage.ListedEventItems.length > 2"]
    [button target="&mp.target" exp="tf.sensenStage.selectedEventIndex=3" graphic="&mp.stage.ListedEventItems[3].event.getImagePath()" x="&mp.stage.eventX(3)" y="&mp.stage.eventY(3)" width="&mp.stage.eventButtonWidth" height="&mp.stage.eventButtonHeight" cond="mp.stage.ListedEventItems.length > 3"]
[endmacro]
[macro name="stage_event_hide"]
    [cm]
    [free layer="4" name="stage_event_detail_bg"]
    [free layer="5" name="event_selected"]
    [free layer="5" name="event_detail"]
[endmacro]
[macro name="stage_battle_setup"]
    ;mp.scenario
    ;mp.target
    [iscript]
        tf.sensenStage.battleSetup(tf.sensenData.lambda, tf.sensenData.mu, mp.scenario, mp.target);
    [endscript]
    [chara_config pos_mode="false"]
    [bg storage="&tf.sensenStage.getSettingBg()" time="100"]
    [playbgm storage="&tf.sensenStage.getBgm()" loop="true" restart="false" volume="10"]
    [layopt layer="0" visible="true"]
    [layopt layer="1" visible="true"]
    [layopt layer="2" visible="true"]
    [layopt layer="3" visible="true"]
    [layopt layer="4" visible="true"]
    [layopt layer="5" visible="true"]
    [layopt layer="6" visible="true"]
    [layopt layer="7" visible="true"]
    [layopt layer="8" visible="true"]
    [layopt layer="9" visible="true"]
    [battle_init battle="&tf.sensenStage.Battle"]
[endmacro]
[macro name="stage_battle_mainloop"]
    [battle_loop]
[endmacro]
[macro name="stage_reward"]
    [iscript]
        // 抽選
        mp.stage.prepareRewards(tf.sensenData.lambda, tf.sensenData.mu);
        tf.lambda_lp_text = `${tf.sensenData.lambda.lp}/${tf.sensenData.lambda.maxLp}`;
        tf.mu_lp_text = `${tf.sensenData.mu.lp}/${tf.sensenData.mu.maxLp}`;
    [endscript]
    ;mp.stage
    ;mp.target
    [layopt layer="3" visible="true"]
    [ptext layer="3" name="lambda_stat"    x="375" y="200" size="20" text="ラムダ" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_stat"       x="635" y="200" size="20" text="ミュー" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_lp_name" x="375" y="230" size="16" text="体力(LP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_lp_name"    x="635" y="230" size="16" text="体力(LP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_ap_name" x="375" y="250" size="16" text="攻撃力(AP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_ap_name"    x="635" y="250" size="16" text="攻撃力(AP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_er_name" x="375" y="270" size="16" color="0xfc03db" text="快楽値(ER)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_er_name"    x="635" y="270" size="16" color="0xfc03db" text="快楽値(ER)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_cr_name" x="375" y="290" size="16" color="0x3e8238" text="堕落値(CR)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_cr_name"    x="635" y="290" size="16" color="0x3e8238" text="堕落値(CR)" overwrite="true" edge="2px 0x000000" overwrite="true"]

    [ptext layer="3" name="lambda_lp"  x="375" y="230" size="22" text="&tf.lambda_lp_text" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_lp"     x="635" y="230" size="22" text="&tf.mu_lp_text" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_ap"  x="375" y="250" size="22" text="&tf.sensenData.lambda.currentAp" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_ap"     x="635" y="250" size="22" text="&tf.sensenData.mu.currentAp" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_er"  x="375" y="270" size="22" color="0xfc03db" text="&tf.sensenData.lambda.er" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_er"     x="635" y="270" size="22" color="0xfc03db" text="&tf.sensenData.mu.er" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_cr"  x="375" y="290" size="22" color="0x3e8238" text="&tf.sensenData.lambda.cr" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_cr"     x="635" y="290" size="22" color="0x3e8238" text="&tf.sensenData.mu.cr" width="180" align="right" edge="3px 0x000000" overwrite="true"]

    [ptext layer="3" name="what_to_do" x="275" y="320" size="30" overwrite="true" text="報酬を選んでください" edge="3px 0x000000" width="730" align="center"]

    [glink color="&mp.stage.lambdaReward.getButtonColor()" target="*end_stage_reward" size="20" text="&mp.stage.lambdaReward.getCardText()" x="275" y="370" width="240" height="280" exp="mp.stage.lambdaReward.apply()" enterse="open.mp3" leavese="close.mp3"]
    [glink color="&mp.stage.muReward.getButtonColor()" target="*end_stage_reward" size="20" text="&mp.stage.muReward.getCardText()" x="765" y="370" width="240" height="280" exp="mp.stage.muReward.apply()" enterse="open.mp3" leavese="close.mp3"]
    [s]
*end_stage_reward
    [free layer="3" name="what_to_do"]
    [iscript]
        tf.lambda_lp_text = `${tf.sensenData.lambda.lp}/${tf.sensenData.lambda.maxLp}`;
        tf.mu_lp_text = `${tf.sensenData.mu.lp}/${tf.sensenData.mu.maxLp}`;
    [endscript]
    [ptext layer="3" name="lambda_stat"    x="375" y="200" size="20" text="ラムダ" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_stat"       x="635" y="200" size="20" text="ミュー" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_lp_name" x="375" y="230" size="16" text="体力(LP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_lp_name"    x="635" y="230" size="16" text="体力(LP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_ap_name" x="375" y="250" size="16" text="攻撃力(AP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_ap_name"    x="635" y="250" size="16" text="攻撃力(AP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_er_name" x="375" y="270" size="16" color="0xfc03db" text="快楽値(ER)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_er_name"    x="635" y="270" size="16" color="0xfc03db" text="快楽値(ER)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_cr_name" x="375" y="290" size="16" color="0x3e8238" text="堕落値(CR)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_cr_name"    x="635" y="290" size="16" color="0x3e8238" text="堕落値(CR)" overwrite="true" edge="2px 0x000000" overwrite="true"]

    [ptext layer="3" name="lambda_lp"  x="375" y="230" size="22" text="&tf.lambda_lp_text" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_lp"     x="635" y="230" size="22" text="&tf.mu_lp_text" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_ap"  x="375" y="250" size="22" text="&tf.sensenData.lambda.currentAp" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_ap"     x="635" y="250" size="22" text="&tf.sensenData.mu.currentAp" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_er"  x="375" y="270" size="22" color="0xfc03db" text="&tf.sensenData.lambda.er" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_er"     x="635" y="270" size="22" color="0xfc03db" text="&tf.sensenData.mu.er" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_cr"  x="375" y="290" size="22" color="0x3e8238" text="&tf.sensenData.lambda.cr" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_cr"     x="635" y="290" size="22" color="0x3e8238" text="&tf.sensenData.mu.cr" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [glink color="btn_29_green" target="*end_stage_reward_confirm" size="20" text="OK" x="520" y="370" width="240" enterse="open.mp3" leavese="close.mp3"]
    [s]
*end_stage_reward_confirm
[endmacro]
[macro name="stage_battle_end"]
    [layopt layer="0" visible="false"]
    [layopt layer="1" visible="false"]
    [layopt layer="2" visible="false"]
    [layopt layer="3" visible="false"]
    [layopt layer="4" visible="false"]
    [layopt layer="5" visible="false"]
    [layopt layer="6" visible="false"]
    [layopt layer="7" visible="false"]
    [layopt layer="8" visible="false"]
    [layopt layer="9" visible="false"]
    [fadeoutbgm time="100"]
    [freeimage layer="0"]
    [freeimage layer="1"]
    [freeimage layer="2"]
    [freeimage layer="3"]
    [freeimage layer="4"]
    [freeimage layer="5"]
    [freeimage layer="6"]
    [freeimage layer="7"]
    [freeimage layer="8"]
    [freeimage layer="9"]
[endmacro]
[return]

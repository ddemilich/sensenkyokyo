*start
; ステージクラスと表示ブロック
[iscript]

class SensenStage {
    constructor() {
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

    handleEventSelection() {
        // リストから完全な項目を取得する
        console.warn(`handleEventSelection: ${this.selectedEventIndex}`);
        const selectedEventItem = this.ListedEventItems[this.selectedEventIndex];
        const selectedEvent = selectedEventItem.event;

        // TODO:イベント本体を実行する

        this.onEventCompleted(selectedEventItem)
    }
    getEventDetail() {
        return this.ListedEventItems[this.selectedEventIndex].event.detail();
    }
    onEventCompleted(eventItem) {
        const progressValue = eventItem.event.getProgressPoint();
        this.applyProgress(progressValue);
        eventItem.isCompleted = true;
        this.generateNewEventItems()
    }
}

class SensenStageOne extends SensenStage {
    constructor() {
        super();
        this.fixedEventItems = [
            {
                event: new SensenStageBossEvent(100),
                isCompleted: false,
                progressReq: 100,
            },
            {
                event: new SensenStageFixedEvent(50),
                isCompleted: false,
                progressReq: 50,
            },
        ].sort((a, b) => a.progressReq - b.progressReq);
    }
}
window.SensenStageOne = SensenStageOne;

[endscript]

[macro name="stage_progress_bar_show"]
    ;mp.stage
    [ptext layer="5" name="&mp.stage.stringName" color="0x42f5f5" size="32" text="&mp.stage.progressString()" x="&mp.stage.progressBarX" y="&mp.stage.progressBarY" width="&mp.stage.progressBarWidth" align="right" edge="4px 0x000000" overwrite="true"]
    ; 下地
    [image layer="4" name="&mp.stage.barBgName" storage="&mp.stage.getBarBgPath()" x="&mp.stage.progressBarX" y="&mp.stage.progressBarY" width="&mp.stage.progressBarWidth" height="&mp.stage.progressBarHeight"]
    [image layer="4" name="&mp.stage.barName" storage="&mp.stage.getBarPath()" x="&mp.stage.getBarX()" y="&mp.stage.progressBarY" width="&mp.stage.getBarWidth()" height="&mp.stage.progressBarHeight"]
[endmacro]
[macro name="stage_progress_bar_refresh"]
    ;mp.stage
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
[macro name="stage_msg_fadeout"]
    [free name="stage_msg" layer="5" time="150"]
[endmacro]

[macro name="stage_event_detail_bg"]
    ;mp.stage
    [image layer="4" name="stage_event_detail_bg" storage="chara/bar/lpbar_max.png" x="&mp.stage.eventDetailX" y="&mp.stage.eventDetailY" width="&mp.stage.eventDetailWidth" height="&mp.stage.eventDetailHeight"]
[endmacro]
[macro name="stage_event_select"]
    ;mp.stage
    ;mp.target
    [if exp="mp.stage.selectedEventIndex == -1"]
        [ptext layer="5" text="イベントを選んでステージを進んでいこう→" name="event_detail" x="&mp.stage.eventDetailX" y="&mp.stage.eventDetailY" width="&mp.stage.eventDetailWidth" size="24" align="center" overwrite="true" ]
        [ptext layer="5" text=" " name="event_selected" x="&mp.stage.eventMarkX()" y="&mp.stage.eventMarkY()" width="&mp.stage.eventMarkWidth" size="48" align="right" overwrite="true"]
    [else]
        [ptext layer="5" text="&mp.stage.getEventDetail()" name="event_detail" x="&mp.stage.eventDetailX" y="&mp.stage.eventDetailY" width="&mp.stage.eventDetailWidth" size="18" align="left" overwrite="true" ]
        [ptext layer="5" text="→" name="event_selected" x="&mp.stage.eventMarkX()" y="&mp.stage.eventMarkY()" width="&mp.stage.eventMarkWidth" size="48" align="right" overwrite="true"]
        [glink color="btn_29_green" text="進む" size="24" target="&mp.target" exp="tf.sensenStage.handleEventSelection()" x="&mp.stage.eventDetailX" y="&mp.stage.eventDetailBottomY" width="&mp.stage.eventDetailWidth" enterse="open.mp3" leavese="close.mp3"]    
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
[return]
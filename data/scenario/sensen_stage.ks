*start
; ステージクラスと表示ブロック
[iscript]
    // ステージクラス。進捗率を持ってる。
    // 敵のIDリスト、ボスのID、等をコンストラクタで持ってる。
    // tf.sensenStageに格納される？
    class SensenStage {
        constructor() {
            this.progress = 0;
            this.progressBarX = 50;
            this.progressBarY = 650;
            this.progressBarHeight = 20;
            this.progressBarWidth = 500;
            this.progressFontSize = 32;

            this.progressFontX = this.progressBarX + this.progressBarWidth - this.progressFontSize;
            this.progressFontY = this.progressBarY - this.progressFontSize;
            this.stringName = "stage_p_bar_string";
            this.barBgName = "stage_p_bar_bg";
            this.barName = "stage_p_bar";
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

        applyProgress(value) {
            this.progress += value;
            if (this.progress > 100) {
                this.progress = 100;
            }
        }
    }
    window.SensenStage = SensenStage;

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
[return]
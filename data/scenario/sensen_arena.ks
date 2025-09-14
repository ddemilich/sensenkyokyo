*start
;アリーナのコントローラ
[iscript]
class ArenaController {
    static MAX_ENEMY = 6;

    constructor() {
        this.x = 20;
        this.y = 80;
        this.gridWidth = 64;
        this.gridHeight = 32;
        this.marginX = 2;
        this.marginY = 4;
        this.bgStage = 1;
        this.enemyList = [];
        this.enemyLevel = 0;
        this.settingWidth = parseInt(1280 / 2);
        this.settingHeight = parseInt(720  / 2);
        this.settingX = this.getBgSelectX(8); 
        this.settingY = this.getBgSelectY(1);
        this.LP = 500;
        this.AP = 50;
        this.ER = 0;
        this.CR = 0;
        this.startButtonX = 50;
        this.startButtonY = 650;
    }

    getBgSelectX(row) {
        return this.x + ((this.gridWidth+this.marginX) * (row-1));
    }
    getBgSelectY(col) {
        return this.y + ((this.gridHeight+this.marginY) * (col-1));
    }
    setBgStage(stage) {
        this.bgStage = stage;
    }
    addEnemy(enemyId) {
        if (this.enemyList.length < ArenaController.MAX_ENEMY) {
            if (enemyId == "e14" && this.enemyList.includes("e14")) {
                // ボスは１体だけ
                return;
            } 
            this.enemyList.push(enemyId);
        }
    }
    setLevel(level) {
        this.enemyLevel += parseInt(level);
        if (this.enemyLevel < 0) {
            this.enemyLevel = 0;
        }
    }
    getSettingBg() {
        return `stage${this.bgStage}.png`;
    }
    getEnemyImage(index) {
        if (index < this.enemyList.length) {
            return `../fgimage/chara/enemy/${this.enemyList[index]}.png`;
        } else {
            return undefined;
        }
    }
    removeEnemy(index) {
        if (index < this.enemyList.length) {
            this.enemyList.splice(index, 1);
        }
    }
    setLP(value) {
        this.LP += parseInt(value);
        if (this.LP < 1) {
            this.LP = 1;
        }
    }
    setAP(value) {
        this.AP += parseInt(value);
        if (this.AP < 1) {
            this.AP = 1;
        }
    }
    setER(value) {
        this.ER += parseInt(value);
        if (this.ER > 100) {
            this.ER = 100;
        }
        if (this.ER < 0) {
            this.ER = 0;
        }
    }
    setCR(value) {
        this.CR += parseInt(value);
        if (this.CR > 100) {
            this.CR = 100;
        }
        if (this.CR < 0) {
            this.CR = 0;
        }
    }

    battleSetup() {
        let lambda = new HeroineLambda(this.LP, this.AP, 250, 351);
        let mu = new HeroineMu(this.LP, this.AP, 250, 351);
        lambda.er = this.ER;
        mu.er = this.ER;
        lambda.cr = this.CR;
        mu.cr = this.CR;
        this.Battle = new BattleSection(lambda, mu, this.enemyList, this.enemyLevel);
    }
}
window.ArenaController = ArenaController;

[endscript]

[macro name="arena_menu_init"]
    [iscript]
        tf.ArenaController = new ArenaController();
    [endscript]
    [layopt layer="1" visible="true"]
    [glink_config vertical="center" width="default" height="default" padding_x="default" padding_y="default"]
[endmacro]
; UI要素
[macro name="arena_menu_bg_select"]
    [ptext name="backgrounds" overwrite="true"  layer="1" color="black" text="背景" x="&tf.ArenaController.getBgSelectX(1)" y="&tf.ArenaController.getBgSelectY(1)"]
    [button graphic="../bgimage/stage1.png" x="&tf.ArenaController.getBgSelectX(2)" y="&tf.ArenaController.getBgSelectY(1)" exp="tf.ArenaController.setBgStage(1)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="../bgimage/stage2.png" x="&tf.ArenaController.getBgSelectX(3)" y="&tf.ArenaController.getBgSelectY(1)" exp="tf.ArenaController.setBgStage(2)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="../bgimage/stage3.png" x="&tf.ArenaController.getBgSelectX(4)" y="&tf.ArenaController.getBgSelectY(1)" exp="tf.ArenaController.setBgStage(3)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="../bgimage/stage4.png" x="&tf.ArenaController.getBgSelectX(2)" y="&tf.ArenaController.getBgSelectY(2)" exp="tf.ArenaController.setBgStage(4)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="../bgimage/stage5.png" x="&tf.ArenaController.getBgSelectX(3)" y="&tf.ArenaController.getBgSelectY(2)" exp="tf.ArenaController.setBgStage(5)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="../bgimage/stage6.png" x="&tf.ArenaController.getBgSelectX(4)" y="&tf.ArenaController.getBgSelectY(2)" exp="tf.ArenaController.setBgStage(6)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
[endmacro]

[macro name="arena_menu_enemy_buttons"]
    [ptext name="enemies" overwrite="true" layer="1" color="black" text="敵キャラ" x="&tf.ArenaController.getBgSelectX(1)" y="&tf.ArenaController.getBgSelectY(4)"  width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="button/vs_e11.png" x="&tf.ArenaController.getBgSelectX(2)" y="&tf.ArenaController.getBgSelectY(4)" exp="tf.ArenaController.addEnemy('e11')" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="button/vs_e12.png" x="&tf.ArenaController.getBgSelectX(3)" y="&tf.ArenaController.getBgSelectY(4)" exp="tf.ArenaController.addEnemy('e12')" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="button/vs_e13.png" x="&tf.ArenaController.getBgSelectX(4)" y="&tf.ArenaController.getBgSelectY(4)" exp="tf.ArenaController.addEnemy('e13')" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="button/vs_e14.png" x="&tf.ArenaController.getBgSelectX(5)" y="&tf.ArenaController.getBgSelectY(4)" exp="tf.ArenaController.addEnemy('e14')" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
[endmacro]

[macro name="arena_menu_enemy_levels"]
    [button graphic="button/decdec.png" x="&tf.ArenaController.getBgSelectX(1)" y="&tf.ArenaController.getBgSelectY(6)" exp="tf.ArenaController.setLevel(-10)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [button graphic="button/dec.png" x="&tf.ArenaController.getBgSelectX(2)" y="&tf.ArenaController.getBgSelectY(6)" exp="tf.ArenaController.setLevel(-1)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [ptext name="enemyLevelTitle" overwrite="true" layer="1" color="black" text="敵レベル" x="&tf.ArenaController.getBgSelectX(3)" y="&tf.ArenaController.getBgSelectY(6)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="button/inc.png" x="&tf.ArenaController.getBgSelectX(4)" y="&tf.ArenaController.getBgSelectY(6)" exp="tf.ArenaController.setLevel(1)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [button graphic="button/incinc.png" x="&tf.ArenaController.getBgSelectX(5)" y="&tf.ArenaController.getBgSelectY(6)" exp="tf.ArenaController.setLevel(10)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
[endmacro]
[macro name="arena_menu_lp"]
    [button graphic="button/decdec.png" x="&tf.ArenaController.getBgSelectX(1)" y="&tf.ArenaController.getBgSelectY(8)" exp="tf.ArenaController.setLP(-10)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [button graphic="button/dec.png" x="&tf.ArenaController.getBgSelectX(2)" y="&tf.ArenaController.getBgSelectY(8)" exp="tf.ArenaController.setLP(-1)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [ptext name="heroineLpTitle" overwrite="true" layer="1" color="black" text="LP" x="&tf.ArenaController.getBgSelectX(3)" y="&tf.ArenaController.getBgSelectY(8)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="button/inc.png" x="&tf.ArenaController.getBgSelectX(4)" y="&tf.ArenaController.getBgSelectY(8)" exp="tf.ArenaController.setLP(1)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [button graphic="button/incinc.png" x="&tf.ArenaController.getBgSelectX(5)" y="&tf.ArenaController.getBgSelectY(8)" exp="tf.ArenaController.setLP(10)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
[endmacro]

[macro name="arena_menu_ap"]
    [button graphic="button/decdec.png" x="&tf.ArenaController.getBgSelectX(1)" y="&tf.ArenaController.getBgSelectY(10)" exp="tf.ArenaController.setAP(-10)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [button graphic="button/dec.png" x="&tf.ArenaController.getBgSelectX(2)" y="&tf.ArenaController.getBgSelectY(10)" exp="tf.ArenaController.setAP(-1)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [ptext name="heroineApTitle" overwrite="true" layer="1" color="black" text="AP" x="&tf.ArenaController.getBgSelectX(3)" y="&tf.ArenaController.getBgSelectY(10)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="button/inc.png" x="&tf.ArenaController.getBgSelectX(4)" y="&tf.ArenaController.getBgSelectY(10)" exp="tf.ArenaController.setAP(1)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [button graphic="button/incinc.png" x="&tf.ArenaController.getBgSelectX(5)" y="&tf.ArenaController.getBgSelectY(10)" exp="tf.ArenaController.setAP(10)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
[endmacro]

[macro name="arena_menu_er"]
    [button graphic="button/decdec.png" x="&tf.ArenaController.getBgSelectX(1)" y="&tf.ArenaController.getBgSelectY(12)" exp="tf.ArenaController.setER(-10)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [button graphic="button/dec.png" x="&tf.ArenaController.getBgSelectX(2)" y="&tf.ArenaController.getBgSelectY(12)" exp="tf.ArenaController.setER(-1)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [ptext name="heroineErTitle" overwrite="true" layer="1" color="black" text="ER" x="&tf.ArenaController.getBgSelectX(3)" y="&tf.ArenaController.getBgSelectY(12)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="button/inc.png" x="&tf.ArenaController.getBgSelectX(4)" y="&tf.ArenaController.getBgSelectY(12)" exp="tf.ArenaController.setER(1)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [button graphic="button/incinc.png" x="&tf.ArenaController.getBgSelectX(5)" y="&tf.ArenaController.getBgSelectY(12)" exp="tf.ArenaController.setER(10)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
[endmacro]

[macro name="arena_menu_cr"]
    [button graphic="button/decdec.png" x="&tf.ArenaController.getBgSelectX(1)" y="&tf.ArenaController.getBgSelectY(14)" exp="tf.ArenaController.setCR(-10)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [button graphic="button/dec.png" x="&tf.ArenaController.getBgSelectX(2)" y="&tf.ArenaController.getBgSelectY(14)" exp="tf.ArenaController.setCR(-1)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [ptext name="heroineCrTitle" overwrite="true" layer="1" color="black" text="CR" x="&tf.ArenaController.getBgSelectX(3)" y="&tf.ArenaController.getBgSelectY(14)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [button graphic="button/inc.png" x="&tf.ArenaController.getBgSelectX(4)" y="&tf.ArenaController.getBgSelectY(14)" exp="tf.ArenaController.setCR(1)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
    [button graphic="button/incinc.png" x="&tf.ArenaController.getBgSelectX(5)" y="&tf.ArenaController.getBgSelectY(14)" exp="tf.ArenaController.setCR(10)" width="&tf.ArenaController.gridWidth" target="&mp.target"]
[endmacro]

[macro name="arena_menu_show"]
    [image layer="1" storage="&tf.ArenaController.getSettingBg()" folder="bgimage" left="&tf.ArenaController.settingX" top="&tf.ArenaController.settingY" width="&tf.ArenaController.settingWidth" height="&tf.ArenaController.settingHeight"]
    [button graphic="&tf.ArenaController.getEnemyImage(0)" x="&tf.ArenaController.getBgSelectX(9)" y="&tf.ArenaController.getBgSelectY(2)" width="&tf.ArenaController.gridWidth" exp="tf.ArenaController.removeEnemy(0)" cond="tf.ArenaController.enemyList.length > 0" target="&mp.target"]
    [button graphic="&tf.ArenaController.getEnemyImage(1)" x="&tf.ArenaController.getBgSelectX(10)" y="&tf.ArenaController.getBgSelectY(2)" width="&tf.ArenaController.gridWidth" exp="tf.ArenaController.removeEnemy(1)" cond="tf.ArenaController.enemyList.length > 1" target="&mp.target"]
    [button graphic="&tf.ArenaController.getEnemyImage(2)" x="&tf.ArenaController.getBgSelectX(11)" y="&tf.ArenaController.getBgSelectY(2)" width="&tf.ArenaController.gridWidth" exp="tf.ArenaController.removeEnemy(2)" cond="tf.ArenaController.enemyList.length > 2" target="&mp.target"]
    [button graphic="&tf.ArenaController.getEnemyImage(3)" x="&tf.ArenaController.getBgSelectX(12)" y="&tf.ArenaController.getBgSelectY(2)" width="&tf.ArenaController.gridWidth" exp="tf.ArenaController.removeEnemy(3)" cond="tf.ArenaController.enemyList.length > 3" target="&mp.target"]
    [button graphic="&tf.ArenaController.getEnemyImage(4)" x="&tf.ArenaController.getBgSelectX(13)" y="&tf.ArenaController.getBgSelectY(2)" width="&tf.ArenaController.gridWidth" exp="tf.ArenaController.removeEnemy(4)" cond="tf.ArenaController.enemyList.length > 4" target="&mp.target"]
    [button graphic="&tf.ArenaController.getEnemyImage(5)" x="&tf.ArenaController.getBgSelectX(14)" y="&tf.ArenaController.getBgSelectY(2)" width="&tf.ArenaController.gridWidth" exp="tf.ArenaController.removeEnemy(5)" cond="tf.ArenaController.enemyList.length > 5" target="&mp.target"]
    [ptext name="showEnemyLevelTitle" overwrite="true" edge="4px 0x000000" layer="1" color="white" text="敵レベル" x="&tf.ArenaController.getBgSelectX(9)" y="&tf.ArenaController.getBgSelectY(6)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [ptext name="showEnemyLevelValue" overwrite="true" edge="4px 0x000000" layer="1" color="white" size="20" text="&tf.ArenaController.enemyLevel" x="&tf.ArenaController.getBgSelectX(10)" y="&tf.ArenaController.getBgSelectY(6)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [ptext name="showHeroineLPTitle" overwrite="true" edge="4px 0x000000" layer="1" color="white" text="LP" x="&tf.ArenaController.getBgSelectX(11)" y="&tf.ArenaController.getBgSelectY(6)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [ptext name="showHeroineLPlValue" overwrite="true" edge="4px 0x000000" layer="1" color="white" size="20" text="&tf.ArenaController.LP" x="&tf.ArenaController.getBgSelectX(12)" y="&tf.ArenaController.getBgSelectY(6)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [ptext name="showHeroineAPTitle" overwrite="true" edge="4px 0x000000" layer="1" color="white" text="AP" x="&tf.ArenaController.getBgSelectX(11)" y="&tf.ArenaController.getBgSelectY(7)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [ptext name="showHeroineAPlValue" overwrite="true" edge="4px 0x000000" layer="1" color="white" size="20" text="&tf.ArenaController.AP" x="&tf.ArenaController.getBgSelectX(12)" y="&tf.ArenaController.getBgSelectY(7)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [ptext name="showHeroineERTitle" overwrite="true" edge="4px 0x000000" layer="1" color="white" text="ER" x="&tf.ArenaController.getBgSelectX(11)" y="&tf.ArenaController.getBgSelectY(8)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [ptext name="showHeroineERlValue" overwrite="true" edge="4px 0x000000" layer="1" color="white" size="20" text="&tf.ArenaController.ER" x="&tf.ArenaController.getBgSelectX(12)" y="&tf.ArenaController.getBgSelectY(8)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [ptext name="showHeroineCRTitle" overwrite="true" edge="4px 0x000000" layer="1" color="white" text="CR" x="&tf.ArenaController.getBgSelectX(11)" y="&tf.ArenaController.getBgSelectY(9)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
    [ptext name="showHeroineCRValue" overwrite="true" edge="4px 0x000000" layer="1" color="white" size="20" text="&tf.ArenaController.CR" x="&tf.ArenaController.getBgSelectX(12)" y="&tf.ArenaController.getBgSelectY(9)" width="&tf.ArenaController.gridWidth" height="&tf.ArenaController.gridHeight" target="&mp.target"]
[endmacro]
[macro name="arena_start_button"]
    [glink text="戦闘開始" x="&tf.ArenaController.startButtonX" y="&tf.ArenaController.startButtonY" exp="tf.ArenaController.startBattle()" cond="tf.ArenaController.enemyList.length > 0" target="&mp.target"]
[endmacro]
[macro name="arena_end_button"]
    [glink text="戦闘中止" x="&tf.ArenaController.startButtonX" y="&tf.ArenaController.startButtonY" target="&mp.target" storage="arena_battle.ks"]
[endmacro]

[macro name="arena_battle_setup"]
    [iscript]
        tf.ArenaController.battleSetup();
    [endscript]
    [chara_config pos_mode="false"]
    [bg storage="&tf.ArenaController.getSettingBg()" time="100"]
    [playbgm storage="LoseMe.wav" loop="true" restart="false" volume="10"]
    [layopt layer="0" visible="true"]
    [layopt layer="1" visible="true"]
    [layopt layer="2" visible="true"]
    [layopt layer="3" visible="true"]
    [layopt layer="4" visible="true"]
    [layopt layer="5" visible="true"]
    [layopt layer="6" visible="true"]
    [layopt layer="8" visible="true"]
    [layopt layer="9" visible="true"]
    [battle_init battle="&tf.ArenaController.Battle"]
[endmacro]

[macro name="arena_battle_mainloop"]
    [battle_loop battle="&tf.ArenaController.Battle"]
[endmacro]

[macro name="arena_battle_end"]
    [layopt layer="0" visible="false"]
    [layopt layer="1" visible="false"]
    [layopt layer="2" visible="false"]
    [layopt layer="3" visible="false"]
    [layopt layer="4" visible="false"]
    [layopt layer="5" visible="false"]
    [layopt layer="6" visible="false"]
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
    [freeimage layer="8"]
    [freeimage layer="9"]
[endmacro]

[return]
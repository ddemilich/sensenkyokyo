*start
;CGモードのコントローラ
; CGモードの初期化
[iscript]
class CGMode {
    static EVENTS = Object.freeze({
        // キャラ変更
        SWITCH_CHAR: {
            eventName: 'SWITCH_CHAR',
            jumpLabel: '*cgmode_switch_char'
        },
        // キャラ同じ
        UPDATE_CHAR: {
            eventName: 'UPDATE_CHAR',
            jumpLabel: '*cgmode_update_char'
        },
        ENTER_BUNDLE: {
            eventName: 'ENTER_BUNDLE',
            jumpLabel: '*cgmode_enter_bundle'
        },
        UPDATE_BUNDLE: {
            eventName: 'UPDATE_BUNDLE',
            jumpLabel: '*cgmode_update_bundle'
        },
        LEAVE_BUNDLE: {
            eventName: 'LEAVE_BUNDLE',
            jumpLabel: '*cgmode_leave_bundle'
        },
        ENEMY_SHOW: {
            eventName: 'ENEMY_SHOW',
            jumpLabel: '*cgmode_enemy_show'
        },
    });

    constructor(name="lambda") {
        this.lambda = new HeroineLambda(10,10);
        this.mu = new HeroineMu(10,10);

        this.x = 20;
        this.y = 130;
        this.grid_width = 64;
        this.grid_height = 32;
        this.margin_x = 0;
        this.margin_y = 4;

        this.selected = this.lambda;
        this.vs_char = "none";
        this.bundle_pose = "bundle_base";
        
        this.eventQueue = [];
    }

    button_x(row) {
        return this.x + ((this.grid_width+this.margin_x) * (row-1));
    }
    button_y(col) {
        return this.y + ((this.grid_height+this.margin_y) * (col-1));
    }
    button_width(count) {
        return (this.grid_width * count);
    }
    button_height(count) {
        return (this.grid_height * count);
    }

    name_button_img(button_name) {
        if (this.selected.name == button_name) {
            return `button/button_cgmode_${button_name}.png`;
        } else {
            return `button/button_cgmode_${button_name}_disable.png`;
        }
    }
    name_button_enterimg(button_name) {
        if (this.selected.name == button_name) {
            return "";
        }
        return `button/button_cgmode_${button_name}_mo.png`;
    }
    name_button_action(button_name) {
        if (this.selected.name == button_name) {
            return;
        }
        if (button_name == "lambda") {
            this.selected = this.lambda;
            this.selected_bundle = this.lambda_bundle;
        } else {
            this.selected = this.mu;
            this.selected_bundle = this.mu_bundle;
        }
        if (this.vs_char == "none") {
            this.eventQueue.push(new GameEvent(CGMode.EVENTS.SWITCH_CHAR, { name: button_name }));
        } else {
            if (this.bundle_pose == "bundle_base") {
                this.eventQueue.push(new GameEvent(CGMode.EVENTS.ENEMY_SHOW, { isBoss: this.enemy.isBoss}));
            } else {
                this.eventQueue.push(new GameEvent(CGMode.EVENTS.ENTER_BUNDLE, { isBoss: this.selected_bundle.captor.isBoss}));
           }
        }
    }
    head_button_img(head_level) {
        if (this.vs_char == "none" || this.selected_bundle.getLevel() == 1) {
            if (head_level == this.selected.getEcstaticLevel()) {
                return `button/button_head_${head_level}.png`;
            } else {
                return `button/button_head_${head_level}_disable.png`;
            }
        } else {
            if (head_level == this.selected_bundle.captive.getCorruptedLevel()) {
                return `button/button_head_${head_level}.png`;
            } else {
                return `button/button_head_${head_level}_disable.png`;
            }
        }
    }
    head_button_enterimg(head_level) {
        if (this.vs_char == "none" || this.selected_bundle.getLevel() == 1) {
            if (head_level == this.selected.getEcstaticLevel()) {
                return "";
            } else {
                return `button/button_head_${head_level}_mo.png`;
            }
        } else {
            if (head_level == this.selected_bundle.captive.getCorruptedLevel()) {
                return "";
            } else {
                return `button/button_head_${head_level}_mo.png`;
            }
        }
    }
    head_button_action(head_level) {
        if (this.vs_char == "none" || this.selected_bundle.getLevel() == 1) {
            if (head_level == this.selected.getEcstaticLevel()) {
                return;
            }
        } else {
            if (head_level == this.selected.getCorruptedLevel()) {
                return;
            }
        }
        this.lambda.setEcstaticLevel(head_level);
        this.mu.setEcstaticLevel(head_level);
        this.lambda.setCorruptedLevel(head_level);
        this.mu.setCorruptedLevel(head_level);

        if (this.vs_char == "none") {
            this.eventQueue.push(new GameEvent(CGMode.EVENTS.UPDATE_CHAR, { param: "param" }));
        } else if (this.bundle_pose != "bundle_base") {
            this.eventQueue.push(new GameEvent(CGMode.EVENTS.UPDATE_BUNDLE, { param: "param" }));
        }
    }
    wear_button_img(wear_level) {
        if (this.vs_char == "none") {
            if (this.selected.pose == "down" || this.selected.pose == "knockout") {
                // ダウンとノックアウトは服差分固定
                if (wear_level == 3) {
                    return `button/button_wear_${wear_level}.png`;
                }
                return `button/button_wear_${wear_level}_ignore.png`;
            }
            if (this.selected.wearLevel == wear_level) {
                return `button/button_wear_${wear_level}.png`;
            } else {
                return `button/button_wear_${wear_level}_disable.png`;
            }
        } else {
            if (this.selected_bundle.getLevel() == wear_level) {
                return `button/button_wear_${wear_level}.png`;
            } else {
                return `button/button_wear_${wear_level}_disable.png`;
            }
        }
    }
    wear_button_enterimg(wear_level) {
        if (this.vs_char == "none") {
            if (this.pose == "down" || this.pose == "knockout") {
                // ダウンとノックアウトは服差分固定
                return "";
            }
            if (this.selected.wearLevel == wear_level) {
                return "";
            } else {
                return `button/button_wear_${wear_level}_mo.png`;
            }
        } else {
            if (this.selected_bundle.getLevel() == wear_level) {
                return "";
            } else {
                return `button/button_wear_${wear_level}_mo.png`;
            }
        }
    }
    wear_button_action(wear_level) {
        if (this.vs_char == "none") {
            if (this.pose == "down" || this.pose == "knockout") {
                // ダウンとノックアウトは服差分固定
                return "";
            }
            if (this.selected.wearLevel == wear_level) {
                return;
            }
            this.lambda.wearLevel = wear_level;
            this.mu.wearLevel = wear_level;
            this.eventQueue.push(new GameEvent(CGMode.EVENTS.UPDATE_CHAR, { param: "param" }));
        } else {
            this.lambda.wearLevel = wear_level;
            this.mu.wearLevel = wear_level;
            this.eventQueue.push(new GameEvent(CGMode.EVENTS.UPDATE_BUNDLE, { param: "param" }));
        }
    }
    pose_button_img(pose) {
        if (this.vs_char == "none") {
            if (this.selected.pose == pose) {
                return `button/button_pose_${pose}.png`;
            } else {
                return `button/button_pose_${pose}_disable.png`;
            }
        } else {
            if (this.selected_bundle.getLevel() == 1) {
                if (pose != "bundle_base" && pose != "bundle_before") {
                    return `button/button_pose_${pose}_ignore.png`;
                }
            }
            if (this.bundle_pose == pose) {
                return `button/button_pose_${pose}.png`;
            } else {
                return `button/button_pose_${pose}_disable.png`;
            }
        }
    }
    pose_button_enterimg(pose) {
        if (this.vs_char == "none") {
            if (this.selected.pose == pose) {
                return "";
            } else {
                return `button/button_pose_${pose}_mo.png`;
            }
        } else {
            if (this.selected_bundle.getLevel() == 1) {
                if (pose != "bundle_base" && pose != "bundle_before") {
                    return "";
                }
            }
            if (this.bundle_pose == pose) {
                return "";
            } else {
                return `button/button_pose_${pose}_mo.png`;
            }            
        }
    }
    pose_button_action(pose) {
        if (this.vs_char == "none") {
            if (this.selected.pose == pose) {
                return;
            }
            this.lambda.pose = pose;
            this.mu.pose = pose;
            this.eventQueue.push(new GameEvent(CGMode.EVENTS.UPDATE_CHAR, { param: "param" }));
        } else {
            if (this.bundle_pose == pose) {
                return;
            }
            if (this.selected_bundle.getLevel() == 1) {
                if (pose != "bundle_base" && pose != "bundle_before") {
                    return;
                }
            }
            const old_pose = this.bundle_pose;
            this.bundle_pose = pose;
            if (this.bundle_pose == "bundle_base") {
                // 敵表示
                this.eventQueue.push(new GameEvent(CGMode.EVENTS.ENEMY_SHOW, { isBoss: this.enemy.isBoss}));
            }
            // 拘束更新
            if (this.bundle_pose == "bundle_before") {
                this.lambda_bundle.step = 1;
                this.mu_bundle.step = 1;
            } else if (this.bundle_pose == "bundle_peak") {
                this.lambda_bundle.step = 2;
                this.mu_bundle.step = 2;
            } else {
                this.lambda_bundle.step = 3;
                this.mu_bundle.step = 3;
            }
            if (old_pose == "bundle_base") {
                // 新規拘束
                this.eventQueue.push(new GameEvent(CGMode.EVENTS.ENTER_BUNDLE, { isBoss: this.selected_bundle.captor.isBoss }));
            } else {
                this.eventQueue.push(new GameEvent(CGMode.EVENTS.UPDATE_BUNDLE, { param: "param" }));
            }
        }
    }

    vs_char_button_img(char) {
        if (this.vs_char == char) {
            return `button/vs_${char}.png`;
        } else {
            return `button/vs_${char}_disable.png`;
        }
    }
    vs_char_button_enterimg(char) {
        if (this.vs_char == char) {
            return "";
        } else {
            return `button/vs_${char}_mo.png`;
        }
    }
    vs_char_button_action(char) {
        if (this.vs_char == char) {
            return;
        }
        this.vs_char = char;
        if (this.enemy) {
            EnemyFactory.releaseEnemy(this.enemy);
        }
        if (this.vs_char == 'none') {
            // 拘束オブジェクトを削除、通常表示
            this.eventQueue.push(new GameEvent(CGMode.EVENTS.SWITCH_CHAR, { param: "param" }));
        } else {
            // 敵キャラを生成
            this.enemy = EnemyFactory.createEnemy(this.vs_char, 100, 10);
            // 二人分生成して、選ばれているほうを設定しておく。
            this.lambda_bundle = new CharacterBundle(this.lambda, EnemyFactory.createEnemy(this.vs_char, 100, 10));
            this.mu_bundle = new CharacterBundle(this.mu, EnemyFactory.createEnemy(this.vs_char, 100, 10));
            if (this.selected.name == "lambda") {
                this.selected_bundle = this.lambda_bundle;
            } else {
                this.selected_bundle = this.mu_bundle;
            }

            if (this.bundle_pose == "bundle_base") {
                this.eventQueue.push(new GameEvent(CGMode.EVENTS.ENEMY_SHOW, { isBoss: this.enemy.isBoss}));
            } else {
                this.eventQueue.push(new GameEvent(CGMode.EVENTS.ENTER_BUNDLE, { isBoss: this.selected_bundle.captor.isBoss}));
            }
        }
    }
}
// クラスをグローバルに公開
window.CGMode = CGMode;
[endscript]

; CGモード初期化処理
[macro name="cgmode_init"]
    [iscript]
        tf.cgmode = new CGMode();
    [endscript]
    [chara_config pos_mode="false"]
    [heroine_show heroine="&tf.cgmode.selected" left="650" top="10" time="100"]
[endmacro]

; CGモードの評価
[macro name="cgmode_load"]
*cgmode_loop_start
    [jump target="*cgmode_loop_end" cond="!(tf.currentEvent = tf.cgmode.eventQueue.shift())"]
    [jump target="&tf.currentEvent.jumpLabel"]

*cgmode_switch_char
    [chara_hide_all time="0"]
    [heroine_show heroine="&tf.cgmode.selected" left="650" top="10" time="100"]
    [jump target="*cgmode_loop_start"]
*cgmode_update_char
    [heroine_mod heroine="&tf.cgmode.selected" time="100"]
    [jump target="*cgmode_loop_start"]
*cgmode_enemy_show
    [chara_hide_all time="0"]
    [enemy_new enemy="&tf.cgmode.enemy"]
    [if exp="tf.currentEvent.params.isBoss"]
        [enemy_show enemy="&tf.cgmode.enemy" left="280" top="10" time="100"]
    [else]
        [enemy_show enemy="&tf.cgmode.enemy" left="650" top="10" time="100"]
    [endif]
    [jump target="*cgmode_loop_start"]
*cgmode_enter_bundle
    [chara_hide_all time="0"]
    [if exp="tf.currentEvent.params.isBoss"]
        [bundle_show bundle="&tf.cgmode.selected_bundle" left="280" top="10" time="100"]
    [else]
        [bundle_show bundle="&tf.cgmode.selected_bundle" left="650" top="10" time="100"]
    [endif]
    [jump target="*cgmode_loop_start"]
*cgmode_update_bundle
    [bundle_mod bundle="&tf.cgmode.selected_bundle" time="100"]
    [jump target="*cgmode_loop_start"]

*cgmode_loop_end
[endmacro]

; CGモードのボタン生成
[macro name="cgmode_generate_buttons"]
    [button graphic="&tf.cgmode.name_button_img('lambda')" enterimg="&tf.cgmode.name_button_enterimg('lambda')" x="&tf.cgmode.button_x(1)"  y="&tf.cgmode.button_y(1)" width="128" height="32" target="&mp.target" exp="tf.cgmode.name_button_action('lambda')"]
    [button graphic="&tf.cgmode.name_button_img('mu')"     enterimg="&tf.cgmode.name_button_enterimg('mu')"     x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(1)" width="128" height="32" target="&mp.target" exp="tf.cgmode.name_button_action('mu')"]
    [image layer="1" storage="button/h_title.png" folder="image"                                                x="&tf.cgmode.button_x(1)"  y="&tf.cgmode.button_y(2)" width="64" height="32"]
    [button graphic="&tf.cgmode.head_button_img(1)" enterimg="&tf.cgmode.head_button_enterimg(1)"               x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(2)" width="64" height="32" target="&mp.target" exp="tf.cgmode.head_button_action(1)"]
    [button graphic="&tf.cgmode.head_button_img(2)" enterimg="&tf.cgmode.head_button_enterimg(2)"               x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(2)" width="64" height="32" target="&mp.target" exp="tf.cgmode.head_button_action(2)"]
    [button graphic="&tf.cgmode.head_button_img(3)" enterimg="&tf.cgmode.head_button_enterimg(3)"               x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(2)" width="64" height="32" target="&mp.target" exp="tf.cgmode.head_button_action(3)"]
    [image layer="1" storage="button/wear_title.png"  folder="image"                                            x="&tf.cgmode.button_x(1)" y="&tf.cgmode.button_y(3)" width="64" height="32"]
    [button graphic="&tf.cgmode.wear_button_img(1)" enterimg="&tf.cgmode.wear_button_enterimg(1)"               x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(3)" width="64" height="32" target="&mp.target" exp="tf.cgmode.wear_button_action(1)"]
    [button graphic="&tf.cgmode.wear_button_img(2)" enterimg="&tf.cgmode.wear_button_enterimg(2)"               x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(3)" width="64" height="32" target="&mp.target" exp="tf.cgmode.wear_button_action(2)"]
    [button graphic="&tf.cgmode.wear_button_img(3)" enterimg="&tf.cgmode.wear_button_enterimg(3)"               x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(3)" width="64" height="32" target="&mp.target" exp="tf.cgmode.wear_button_action(3)"]
    ; 4行目 組み合わせ選び タイトル+なし+ラムダ＋ミュー？(自分を選んだら自慰、なしはポーズ、味方を選んだらそういうシーン)
    [image layer="1" storage="button/vs_title.png" folder="image"                                               x="&tf.cgmode.button_x(1)" y="&tf.cgmode.button_y(4)" width="64" height="32"]
    [button graphic="&tf.cgmode.vs_char_button_img('none')" enterimg="&tf.cgmode.vs_char_button_enterimg('none')"  x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(4)" width="64" height="32" target="&mp.target" exp="tf.cgmode.vs_char_button_action('none')"]
    [image layer="1" storage="button/vs_lambda_disable.png" folder="image"                                               x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(4)" width="64" height="32"]
    [image layer="1" storage="button/vs_mu_disable.png" folder="image"                                               x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(4)" width="64" height="32"]
    ; 5行目 ステージ1
    [button graphic="&tf.cgmode.vs_char_button_img('e11')" enterimg="&tf.cgmode.vs_char_button_enterimg('e11')"  x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(5)" width="64" height="32" target="&mp.target" exp="tf.cgmode.vs_char_button_action('e11')"]
    [button graphic="&tf.cgmode.vs_char_button_img('e12')" enterimg="&tf.cgmode.vs_char_button_enterimg('e12')"  x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(5)" width="64" height="32" target="&mp.target" exp="tf.cgmode.vs_char_button_action('e12')"]
    [button graphic="&tf.cgmode.vs_char_button_img('e13')" enterimg="&tf.cgmode.vs_char_button_enterimg('e13')"  x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(5)" width="64" height="32" target="&mp.target" exp="tf.cgmode.vs_char_button_action('e13')"]
    [button graphic="&tf.cgmode.vs_char_button_img('e14')" enterimg="&tf.cgmode.vs_char_button_enterimg('e14')"  x="&tf.cgmode.button_x(5)" y="&tf.cgmode.button_y(5)" width="64" height="32" target="&mp.target" exp="tf.cgmode.vs_char_button_action('e14')"]
    ; 6行目 ステージ2
    [image layer="1" storage="button/vs_e21_disable.png" folder="image"                                               x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(6)" width="64" height="32"]
    [image layer="1" storage="button/vs_e22_disable.png" folder="image"                                               x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(6)" width="64" height="32"]
    [image layer="1" storage="button/vs_e23_disable.png" folder="image"                                               x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(6)" width="64" height="32"]
    [image layer="1" storage="button/vs_e24_disable.png" folder="image"                                               x="&tf.cgmode.button_x(5)" y="&tf.cgmode.button_y(6)" width="64" height="32"]
    ; 7行目 ステージ3
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(7)" width="64" height="32"]
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(7)" width="64" height="32"]
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(7)" width="64" height="32"]
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(5)" y="&tf.cgmode.button_y(7)" width="64" height="32"]
    ; 8行目 ステージ4
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(8)" width="64" height="32"]
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(8)" width="64" height="32"]
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(8)" width="64" height="32"]
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(5)" y="&tf.cgmode.button_y(8)" width="64" height="32"]
    ; 9行目 ステージ5-1
    [image layer="1" storage="button/vs_e51_disable.png" folder="image"                                               x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(9)" width="64" height="32"]
    [image layer="1" storage="button/vs_e52_disable.png" folder="image"                                               x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(9)" width="64" height="32"]
    [image layer="1" storage="button/vs_e53_disable.png" folder="image"                                               x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(9)" width="64" height="32"]
    ;10行目 ステージ5-2
    [image layer="1" storage="button/vs_e54_disable.png" folder="image"                                               x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(10)" width="64" height="32"]
    [image layer="1" storage="button/vs_e55_disable.png" folder="image"                                               x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(10)" width="64" height="32"]
    [image layer="1" storage="button/vs_e56_disable.png" folder="image"                                               x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(10)" width="64" height="32"]
    ;11行目 ステージ6
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(11)" width="64" height="32"]
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(11)" width="64" height="32"]
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(11)" width="64" height="32"]
    [image layer="1" storage="button/vs_undefined_disable.png" folder="image"                                         x="&tf.cgmode.button_x(5)" y="&tf.cgmode.button_y(11)" width="64" height="32"]
    
    [image layer="1" storage="button/pose_title.png" folder="image"                                             x="&tf.cgmode.button_x(1)" y="&tf.cgmode.button_y(12)" width="64" height="32"]
    [button graphic="&tf.cgmode.pose_button_img('base')"     enterimg="&tf.cgmode.pose_button_enterimg('base')"     x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(12)" width="64" height="32" target="&mp.target" exp="tf.cgmode.pose_button_action('base')"   cond="tf.cgmode.vs_char=='none'"]
    [button graphic="&tf.cgmode.pose_button_img('attack')"   enterimg="&tf.cgmode.pose_button_enterimg('attack')"   x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(12)" width="64" height="32" target="&mp.target" exp="tf.cgmode.pose_button_action('attack')" cond="tf.cgmode.vs_char=='none'"]
    [button graphic="&tf.cgmode.pose_button_img('guard')"    enterimg="&tf.cgmode.pose_button_enterimg('guard')"    x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(12)" width="64" height="32" target="&mp.target" exp="tf.cgmode.pose_button_action('guard')"  cond="tf.cgmode.vs_char=='none'"]
    [button graphic="&tf.cgmode.pose_button_img('damaged')"  enterimg="&tf.cgmode.pose_button_enterimg('damaged')"  x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(13)" width="64" height="32" target="&mp.target" exp="tf.cgmode.pose_button_action('damaged')" cond="tf.cgmode.vs_char=='none'"]
    [button graphic="&tf.cgmode.pose_button_img('down')"     enterimg="&tf.cgmode.pose_button_enterimg('down')"     x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(13)" width="64" height="32" target="&mp.target" exp="tf.cgmode.pose_button_action('down')"  cond="tf.cgmode.vs_char=='none'"]
    [button graphic="&tf.cgmode.pose_button_img('knockout')" enterimg="&tf.cgmode.pose_button_enterimg('knockout')" x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(13)" width="64" height="32" target="&mp.target" exp="tf.cgmode.pose_button_action('knockout')" cond="tf.cgmode.vs_char=='none'"]

    [button graphic="&tf.cgmode.pose_button_img('bundle_base')"   enterimg="&tf.cgmode.pose_button_enterimg('bundle_base')"   x="&tf.cgmode.button_x(2)" y="&tf.cgmode.button_y(12)" width="64" height="32" target="&mp.target" exp="tf.cgmode.pose_button_action('bundle_base')"   cond="tf.cgmode.vs_char!='none'"]
    [button graphic="&tf.cgmode.pose_button_img('bundle_before')" enterimg="&tf.cgmode.pose_button_enterimg('bundle_before')" x="&tf.cgmode.button_x(3)" y="&tf.cgmode.button_y(12)" width="64" height="32" target="&mp.target" exp="tf.cgmode.pose_button_action('bundle_before')"   cond="tf.cgmode.vs_char!='none'"]
    [button graphic="&tf.cgmode.pose_button_img('bundle_peak')"   enterimg="&tf.cgmode.pose_button_enterimg('bundle_peak')"   x="&tf.cgmode.button_x(4)" y="&tf.cgmode.button_y(12)" width="64" height="32" target="&mp.target" exp="tf.cgmode.pose_button_action('bundle_peak')" cond="tf.cgmode.vs_char!='none'"]
    [button graphic="&tf.cgmode.pose_button_img('bundle_after')"  enterimg="&tf.cgmode.pose_button_enterimg('bundle_after')"  x="&tf.cgmode.button_x(5)" y="&tf.cgmode.button_y(12)" width="64" height="32" target="&mp.target" exp="tf.cgmode.pose_button_action('bundle_after')"  cond="tf.cgmode.vs_char!='none'"]
[endmacro]

[return]
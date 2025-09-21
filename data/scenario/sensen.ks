*start

[call storage="sensen_class.ks"]
[call storage="sensen_char.ks"]
[call storage="sensen_lambda.ks"]
[call storage="sensen_mu.ks"]
[call storage="sensen_battle.ks"]
[call storage="sensen_cgmode.ks"]
[call storage="sensen_arena.ks"]
[call storage="sensen_event.ks"]
[call storage="sensen_saveload.ks"]

[macro name="sensen_header"]
    ;mp.bgm
    ;mp.bg
    [bg storage="&mp.bg" time="100"]
    [playbgm storage="&mp.bgm" loop="true" restart="false" volume="10"]
    [layopt layer="1" visible="true"]
    [layopt layer="2" visible="true"]
    [layopt layer="3" visible="true"]
    [start_keyconfig]
[endmacro]
[macro name="sensen_footer"]
    [stop_keyconfig]
    [cm]
    [fadeoutbgm time="100"]
    [layopt layer="1" visible="false"]
    [layopt layer="2" visible="false"]
    [layopt layer="3" visible="false"]
    [freeimage layer="1"]
    [freeimage layer="2"]
    [freeimage layer="3"]
[endmacro]

[macro name="novel_header"]
    ;メッセージウィンドウの設定
    [position layer="message0" left="60" top="500" width="1200" height="200" page="fore" visible="false"]
    ;文字が表示される領域を調整
    [position layer="message0" page="fore" margint="45" marginl="50" marginr="70" marginb="60"]
    [ptext name="chara_name_area" layer="message0" color="white" size="28" bold="true" x="120" y="510"]
    ;上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
    [chara_config ptext="chara_name_area" talk_anim="up" talk_anim_time="150" ]
    ;メッセージウィンドウの表示
    [layopt layer="message0" visible="true"]
[endmacro]

[macro name="novel_footer"]
    [layopt layer="message0" visible="false"]
[endmacro]

[return]
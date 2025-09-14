;=========================================
; アリーナメニュー　画面作成
;=========================================
[layopt layer="message0" visible="false"]

[clearfix]
[hidemenubutton]
[cm]

[arena_menu_init]

*arena_menu
[bg storage="../../tyrano/images/system/bg_base.png" time="100"]
[playbgm storage="hello_world.mp3" loop="true" restart="false" volume="10"]
[layopt layer="1" visible="true"]
[ptext layer="1" x="0" y="0" text="アリーナメニュー画面" size="32" color="black"]
[cm]
[button graphic="config/menu_button_close.png" enterimg="config/menu_button_close2.png"  target="*backtitle" x="1150" y="40" ]

;背景選ぶ
[arena_menu_bg_select target="*arena_menu"]

;敵選ぶ
;ボタンを押すと敵領域に反映される。最大６体。ボスは１体。
[arena_menu_enemy_buttons target="*arena_menu"]

;敵のレベル選ぶ
;0~200, 10刻み
[arena_menu_enemy_levels target="*arena_menu"]

;ヒロインの設定
[arena_menu_lp target="*arena_menu"]
[arena_menu_ap target="*arena_menu"]
[arena_menu_er target="*arena_menu"]
[arena_menu_cr target="*arena_menu"]

;選んだ設定が表示される
[arena_menu_show target="*arena_menu"]

[arena_start_button target="*arena_start"]
[s]

*arena_start
[cm]
[freeimage layer=1]
[fadeoutbgm time="100"]
[jump storage="arena_battle.ks"]
[s]

*backtitle
[cm]
[freeimage layer=1]
[chara_hide_all time="0"]
[fadeoutbgm time="100"]
[jump storage="title.ks"]
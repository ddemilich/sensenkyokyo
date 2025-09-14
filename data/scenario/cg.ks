;=========================================
; CG モード　画面作成
;=========================================
[layopt layer=message0 visible=false]

[clearfix]
[hidemenubutton]
[cm]

[bg storage="../../tyrano/images/system/bg_base.png" time=100]
[playbgm storage="music.m4a" loop="true" restart="false" volume="10"]
[layopt layer="1" visible="true"]
[image layer="1" left="0" top="0" storage="config/label_cg.png" folder="image" ]
[cgmode_init]

*cgpage
[button graphic="config/menu_button_close.png" enterimg="config/menu_button_close2.png"  target="*backtitle" x="1150" y="40" ]

[cgmode_generate_buttons target="*reload"]
[cgmode_load]
*stay
[s]

*reload
[jump target="*cgpage"]

*backtitle
[cm]
[freeimage layer=1]
[chara_hide_all time="0"]
[jump storage="title.ks"]

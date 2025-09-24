;=========================================
; アリーナバトル　画面作成
;=========================================
[layopt layer="message0" visible="false"]

[clearfix]
[hidemenubutton]
[cm]

;[arena_end_button target="*back_to_menu"]
[arena_battle_setup backtarget="*back_to_menu" ]
[arena_battle_mainloop backtarget="*back_to_menu"]
[s]

*back_to_menu
[cm]
[arena_battle_end]
[jump storage="arena_menu.ks" target="*arena_menu"]
[s]


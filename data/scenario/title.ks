
[cm]

@clearstack
@bg storage ="title.png" time=100
[playbgm storage="hello_world.mp3" loop="true" restart="false" volume="10"]
@wait time = 200

*start 

;[glink color="btn_06_black" x=135 y=320 text="はじめから" width="240" size="32" target="*gamestart" keyfocus="1"]
[glink color="btn_06_black" x=400 y=320 text="CGモード"  width="240" size="32" target="*cgmode" keyfocus="3"]
[glink color="btn_06_black" x=135 y=410 text="アリーナ"  width="240" size="32" target="*arenamode" keyfocus="3"]
;[button x=135 y=500 graphic="title/button_load.png" enterimg="title/button_load2.png" role="load" keyfocus="2"]
[button x=135 y=590 graphic="title/button_config.png" enterimg="title/button_config2.png" role="sleepgame" storage="config.ks" keyfocus="4"]

[s]
*cgmode
[fadeoutbgm time="100"]
[jump storage="cg.ks"]
*arenamode
[fadeoutbgm time="100"]
[jump storage="arena_menu.ks"]
*gamestart
;一番最初のシナリオファイルへジャンプする
[fadeoutbgm time="100"]
@jump storage="scene1.ks"




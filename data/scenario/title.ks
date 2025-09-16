
[cm]

@clearstack
@bg storage ="title.png" time=100
[playbgm storage="hello_world.mp3" loop="true" restart="false" volume="10"]
@wait time = 200

*start 

[glink color="btn_29_green" x=115 y=400 text="はじめから" width="240" size="24" target="*gamestart" keyfocus="1" enterse="open.mp3" leavese="close.mp3"]
[glink color="btn_29_green" x=115 y=490 text="つづきから" width="240" size="24" target="*gamecontinue" keyfocus="2" enterse="open.mp3" leavese="close.mp3"]
[glink color="btn_29_purple" x=400 y=400 text="CGモード"  width="240" size="24" target="*cgmode" keyfocus="3" enterse="open.mp3" leavese="close.mp3"]
[glink color="btn_29_purple" x=400 y=490 text="アリーナ"  width="240" size="24" target="*arenamode" keyfocus="4" enterse="open.mp3" leavese="close.mp3"]
[glink color="btn_29_black" x=115 y=580 text="コンフィグ" width="240" size="24" target="*sleepthenconfig" keyfocus="5" enterse="open.mp3" leavese="close.mp3"]

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
[jump storage="scene1.ks"]
*gamecontinue
[fadeoutbgm time="100"]
[jump target="*start"]
*sleepthenconfig
[fadeoutbgm time="100"]
[sleepgame storage="config.ks"]
[jump target="*start"]

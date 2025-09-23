*start
[sensen_header bg="lobby01.jpg" bgm="kaiju.mp3"]

[image layer="1" storage="&tf.sensenData.getStageResultImage(1)" x="240" y="500" width="85" height="85" cond="tf.sensenData.stage > 1"]
[image layer="1" storage="&tf.sensenData.getStageResultImage(2)" x="330" y="410" width="85" height="85" cond="tf.sensenData.stage > 2"]
[image layer="1" storage="&tf.sensenData.getStageResultImage(3)" x="420" y="320" width="85" height="85" cond="tf.sensenData.stage > 3"]
[image layer="1" storage="&tf.sensenData.getStageResultImage(4)" x="510" y="230" width="85" height="85" cond="tf.sensenData.stage > 4"]
[image layer="1" storage="&tf.sensenData.getStageResultImage(5)" x="600" y="140" width="85" height="85" cond="tf.sensenData.stage > 5"]

*refresh_heroine_stat
[button graphic="../bgimage/stage1.png" x="50" y="500" width="180" height="85" target="*advance_to_stage1" cond="tf.sensenData.stage >= 1"]
[button graphic="../bgimage/stage2.png" x="140" y="410" width="180" height="85" target="*advance_to_stage2" cond="tf.sensenData.stage >= 2"]
[button graphic="../bgimage/stage3.png" x="230" y="320" width="180" height="85" target="*advance_to_stage3" cond="tf.sensenData.stage >= 3"]
[button graphic="../bgimage/stage4.png" x="320" y="230" width="180" height="85" target="*advance_to_stage4" cond="tf.sensenData.stage >= 4"]
[button graphic="../bgimage/stage5.png" x="410" y="140" width="180" height="85" target="*advance_to_stage5" cond="tf.sensenData.stage >= 5"]

[heroine_stand target="*change_heroine_stat"]
[glink color="btn_29_green" target="*back" text="タイトルに戻る" width="240" size="24" x="10" y="650" enterse="open.mp3" leavese="close.mp3"]
[s]

*change_heroine_stat
[cm]
[freeimage layer="2"]
[freeimage layer="3"]
[jump target="*refresh_heroine_stat"]

*advance_to_stage1
[sensen_footer]
[jump storage="stage1.ks"]

*advance_to_stage2
[sensen_footer]
[jump storage="stage2.ks"]

*advance_to_stage3
[sensen_footer]
[jump storage="stage3.ks"]

*advance_to_stage4
[sensen_footer]
[jump storage="stage4.ks"]

*advance_to_stage5
[sensen_footer]
[jump storage="stage5.ks"]


*back
[sensen_save]
[cm]
[layopt layer="1" visible="false"]
[layopt layer="2" visible="false"]
[layopt layer="3" visible="false"]
[freeimage layer="1"]
[freeimage layer="2"]
[freeimage layer="3"]
[stop_keyconfig]
[jump storage="title.ks"]
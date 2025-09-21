*start
[sensen_header bg="stage1.png" bgm="music.ogg"]

[glink color="btn_29_green" text="ステージ攻略成功" size="24" target="*end" exp="tf.sensenData.processStage(1, true)" enterse="open.mp3" leavese="close.mp3"]
[glink color="btn_29_green" text="ステージ攻略失敗" size="24" target="*end" exp="tf.sensenData.processStage(1, false)" enterse="open.mp3" leavese="close.mp3"]
[s]
*end
[sensen_footer]
[jump storage="stage1_end.ks"]
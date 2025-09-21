*start
[sensen_header bg="stage2.png" bgm="music.ogg"]

[glink color="btn_29_green" text="ステージ攻略成功" size="24" target="*back" exp="tf.sensenData.processStage(2, true)" enterse="open.mp3" leavese="close.mp3"]
[glink color="btn_29_green" text="ステージ攻略失敗" size="24" target="*back" exp="tf.sensenData.processStage(2, false)" enterse="open.mp3" leavese="close.mp3"]
[s]

*back
[sensen_save]
[sensen_footer]
[jump storage="lobby.ks"]
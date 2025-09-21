*start
[sensen_header bg="stage2.png" bgm="music.ogg"]

[glink color="btn_29_green" text="ステージ攻略成功" size="24" target="*back" exp="tf.sensenData.processStage(2, true)"]
[glink color="btn_29_green" text="ステージ攻略失敗" size="24" target="*back" exp="tf.sensenData.processStage(2, false)"]
[s]

*back
[sensen_save]
[sensen_footer]
[jump storage="scene1.ks" target="*scene1_start"]
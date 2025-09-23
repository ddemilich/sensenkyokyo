*start
[sensen_header bg="stage1.png" bgm="music.ogg"]
[iscript]
    tf.sensenStage = new SensenStage();
[endscript]
[stage_progress_bar_show stage="&tf.sensenStage"]

*stand_start
[heroine_stand target="*stand_end"]
[glink color="btn_29_green" text="ステージ攻略成功" size="24" target="*end" exp="tf.sensenData.processStage(1, true)" enterse="open.mp3" leavese="close.mp3"]
[glink color="btn_29_green" text="ステージ攻略失敗" size="24" target="*end" exp="tf.sensenData.processStage(1, false)" enterse="open.mp3" leavese="close.mp3"]
[s]

*stand_end
[stage_progress_bar_refresh stage="&tf.sensenStage"]
[freeimage layer="2"]
[freeimage layer="3"]
[jump target="*stand_start"]

*end
[stage_progress_bar_hide stage="&tf.sensenStage"]
[sensen_footer]
[jump storage="stage1_end.ks"]
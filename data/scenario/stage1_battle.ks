*start
[sensen_header bg="stage1.png" bgm="stage_event.mp3"]
[stage_msg text="STAGE ONE"]
[stage_msg text="??READY??"]
[stage_msg text="!!!START!!!"]
[stage_msg_fadeout]
[iscript]
    tf.sensenStage = new SensenStageOne();
    // 最初のイベントをロード
    tf.sensenStage.generateNewEventItems();
[endscript]
[stage_event_detail_bg stage="&tf.sensenStage"]
[stage_progress_bar_show stage="&tf.sensenStage"]

*stand_start
[jump target="*end" cond="tf.sensenStage.ListedEventItems.length==0"]
[heroine_stand target="*stand_end"]
[stage_event_select stage="&tf.sensenStage" target="*stand_end" target_event_start="*event_start" ]
[s]

*stand_end
[cm]
[stage_progress_bar_refresh stage="&tf.sensenStage"]
[freeimage layer="2"]
[freeimage layer="3"]
[jump target="*stand_start"]

*end
[iscript]
    tf.sensenData.processStage(1, true);
[endscript]
[stage_event_hide]
[stage_msg text="STAGE ONE"]
[stage_msg text="!!! CLEAR !!!"]
[stage_msg_fadeout]
[stage_progress_bar_hide stage="&tf.sensenStage"]
[sensen_footer]
[jump storage="stage1_end.ks"]

*event_start
[cm]
[stage_event_hide]
[freeimage layer="2"]
[freeimage layer="3"]
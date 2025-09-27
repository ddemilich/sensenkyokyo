*start
[sensen_header bg="stage2.png" bgm="stage_event.mp3"]
[stage_msg text="STAGE TWO"]
[stage_msg text="??READY??"]
[stage_msg text="!!!START!!!"]
[stage_msg_fadeout]
[iscript]
    tf.sensenStage = new SensenStageTwo();
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
[freeimage layer="2"]
[freeimage layer="3"]
[jump target="*stand_start"]

*end
[iscript]
    tf.sensenData.processStage(2, true);
[endscript]
[stage_event_hide]
[stage_msg text="STAGE TWO"]
[stage_msg text="!!! CLEAR !!!"]
[stage_msg_fadeout]
[stage_progress_bar_hide stage="&tf.sensenStage"]
[sensen_footer]
[jump storage="stage2_end.ks"]

*end_failed
[iscript]
    tf.sensenData.processStage(2, false);
[endscript]
[stage_event_hide]
[stage_msg text="STAGE ONE"]
[stage_msg text="!!! FAILED !!!"]
[stage_msg_fadeout]
[stage_progress_bar_hide stage="&tf.sensenStage"]
[sensen_footer]
[jump storage="stage2_end.ks"]

*event_start
[cm]
[stage_event_hide]
[freeimage layer="2"]
[freeimage layer="3"]

[jump target="*event_continue" cond="!tf.sensenStage.getEventMessage()"]
[stage_event_msg stage="&tf.sensenStage" target_event_continue="*event_continue"]
[s]

*event_continue
[stage_event_msg_fadeout]

; battleがなければ終了
[jump target="*event_completed" cond="!tf.sensenStage.hasBattleEvent()"]
[stage_progress_bar_hide stage="&tf.sensenStage"]
[stage_battle_setup scenario="stage2_battle.ks" target="*back_to_stage1_battle_end"]
[stage_battle_mainloop]
[s]

*event_completed
[cm]
[stage_event_detail_bg stage="&tf.sensenStage"]
[stage_progress_bar_refresh stage="&tf.sensenStage"]
[jump target="*stand_end"]

*back_to_stage1_battle_end
[cm]
[stage_battle_end]
[sensen_header bg="stage2.png" bgm="stage_event.mp3"]
[stage_progress_bar_show stage="&tf.sensenStage"]
[jump target="*end_failed" cond="tf.sensenData.lambda.isLosed && tf.sensenData.mu.isLosed"]
[jump target="*event_completed"]
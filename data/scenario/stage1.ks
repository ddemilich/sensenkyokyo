*start
[sensen_header bg="stage1.png" bgm="music.ogg"]
[novel_header]
#
薄暗い地下水路にモーターの音が響き渡っている。[p]

[chara_show name="story_lambda" left="780" top="100" wait="false" zindex="10"]
[chara_show name="story_mu" left="780" top="100" wait="true" zindex="1"]

# story_lambda
地図が正確ならばそろそろ敵が現れる。[p]
#
ラムダは手に持っていた紙に火をつける。[p]
# story_mu
まってましたぁ。[p]
# 
ミューは腕をぐるぐると回して準備体操に余念がない。[p]
# story_lambda
久しぶりの戦闘だ。[l][r]
焦らずいつも通りやろう。[p]
# story_mu
おっけー。まかせて！[p]
#
二人はゆっくりと奥へと進んだ。[p]

[chara_hide_all]

[novel_footer]
[sensen_footer]
[jump storage="stage1_battle.ks"]

[glink color="btn_29_green" text="ステージ攻略成功" size="24" target="*back" exp="tf.sensenData.processStage(1, true)" enterse="open.mp3" leavese="close.mp3"]
[glink color="btn_29_green" text="ステージ攻略失敗" size="24" target="*back" exp="tf.sensenData.processStage(1, false)" enterse="open.mp3" leavese="close.mp3"]
[s]

*back
[sensen_save]
[sensen_footer]
[jump storage="lobby.ks"]
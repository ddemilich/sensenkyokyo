*start
[sensen_header bg="stage2.png" bgm="stage_end.mp3"]
[novel_header]
[if exp="tf.sensenData.stage_result[1]"]
[chara_show name="story_lambda" left="780" top="100" wait="false" zindex="10"]
[chara_show name="story_mu" left="780" top="100" wait="true" zindex="1"]
#
駐屯地の中のコンピュータを素早くラムダが操作している。[p]
# story_mu
日本にはこんなに大きな蜘蛛がいるんだね。[p]
# story_lambda
いや。そいつらはデーモンの一部だ。[p]
# story_mu
えぇ！？そうなの？[p]
#
ミューはちぎれたバインドの脚を摘まんでまじまじと見ている[p]
# story_lambda
（半人半獣のデーモン・・・。ベイ国らしい子供じみたやり口だ。）[p]
# story_lambda
バインドは人間だったのかもしれない。[p]
# story_mu
ボクは？ボクはデーモンだけど、その前はどうだったんだろう？[p]
# story_lambda
ミューは生まれた時からデーモンだ。[l][r]
私の意識とつながった日を覚えているか？[p]
# story_mu
うん。ラムダはまだ小さかったね。[p]
# story_lambda
・・・そうだね。[p]

#
カチカチと鳴っていた機械式の打鍵の音が止んだ。[l][r]
ラムダは差し込んだデバイスを取り出すと、その場を去った。[p]

[chara_hide_all]

#
ベイ国による切札暗殺計画。[l][r]
その完全な情報をソ国は手に入れたのだった。[p]
[heroine_restart]
[else]

#
※エロシーン[p]

[heroine_restart_from_defeat]
[endif]

*back
[sensen_save]
[novel_footer]
[sensen_footer]
[jump storage="lobby.ks"]
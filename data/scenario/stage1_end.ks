*start
[sensen_header bg="stage1.png" bgm="stage_end.mp3"]
[novel_header]
[if exp="tf.sensenData.stage_result[0]"]
[chara_show name="story_lambda" left="780" top="100" wait="false" zindex="10"]
[chara_show name="story_mu" left="780" top="100" wait="true" zindex="1"]
#
マウントの残骸と思われるゼリー状の欠片が散らばっている。[p]
# story_mu
こいつもデーモン？だったんだよね。[p]
# story_lambda
そう。[p]
# story_mu
ボクとはずいぶん違うね。[l][r]
[l]でかいし、[l]キモいし、[l]頭悪いし！[p]
#
ミューは欠片の上で地団駄を踏んでいる。[p]
# story_lambda
（原始的な形質を持つデーモンだった・・・。）[l][r]
（言語を理解せず、プログラムされた通りに動くだけのステートマシン。）[p]
# story_lambda
ミューはソ国の技術の結晶だ。[l][r]
他のどの国にも作れないよ。[p]
# story_mu
んー。[l]よくわかんない。[l][r]
けど、ボクはボクでよかったなって。[p]
# story_lambda
うん。[l][r]
それにはちゃんと理由がある。[l][r]
今回の仕事が終わったら話そう。[p]
#

[chara_hide_all]

#
ラムダは薬物プラントの詳細な様子をディスクに収めた。[l][r]
そのデータは翌日の新聞各紙を大いに賑わせることになった。[p]
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
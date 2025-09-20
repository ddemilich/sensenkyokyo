;ティラノスクリプトサンプルゲーム

*start

[cm]
[clearfix]
[start_keyconfig]
[bg storage="robby00.jpg" time="100"]


[sensen_init]
[sensen_load]
;メッセージウィンドウの設定
[position layer="message0" left="60" top="500" width="1200" height="200" page="fore" visible="false"]
;文字が表示される領域を調整
[position layer="message0" page="fore" margint="45" marginl="50" marginr="70" marginb="60"]
[ptext name="chara_name_area" layer="message0" color="white" size="28" bold="true" x="180" y="510"]
;上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
[chara_config ptext="chara_name_area"]


;メッセージウィンドウの表示
[layopt layer="message0" visible="true"]

#
この度は戦々嬌々をダウンロードしていただきありがとうございます。[l][r]
このバージョンではステージ１とステージ２をプレイすることができます。[p]
[layopt layer="message0" visible="false"]

*scene1_start
[bg storage="robby01.jpg" time="100"]

[layopt layer="1" visible="true"]
[image layer="1" name="lambda_stand" storage="chara/story/lambda_stand.png" left="780" top="150" width="600" time="300" zindex="20" wait="false"]
[image layer="1" name="mu_stand" storage="chara/story/mu_stand.png" left="780" top="150" width="600" time="300" zindex="10"]

*loop

[ptext layer="1" name="systemdata" text="&f.sensenSystemData.getFirstLaunchDateString()" x="100" y="300" width="600"]
[glink name="back" target="*back" text="back to title" x="100" y="100"]
[glink name="lambda_stat" target="*loop" exp="tf.lambda_stat_open=true" text="&tf.sensenData.lambda.currentAp" x="780" y="600" width="100" exp="tf.sensenData.lambda.ap.increaseBaseValue(10)"]
[s]

*back
[sensen_save]
[layopt layer="1" visible="false"]
[freeimage layer="1"]
[jump storage="title.ks"]
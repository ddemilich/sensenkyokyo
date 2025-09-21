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
[sensen_header bg="robby01.jpg" bgm="kaiju.mp3"]

[image layer="1" name="lambda_stand" storage="chara/story/lambda_stand.png" left="780" top="150" width="600" time="300" zindex="20" wait="false"]
[image layer="1" name="mu_stand" storage="chara/story/mu_stand.png" left="780" top="150" width="600" time="300" zindex="10"]
[image layer="1" storage="&tf.sensenData.getStageResultImage(1)" x="240" y="500" width="85" height="85" cond="tf.sensenData.stage > 1"]
[image layer="1" storage="&tf.sensenData.getStageResultImage(2)" x="330" y="410" width="85" height="85" cond="tf.sensenData.stage > 2"]
[image layer="1" storage="&tf.sensenData.getStageResultImage(3)" x="420" y="320" width="85" height="85" cond="tf.sensenData.stage > 3"]
[image layer="1" storage="&tf.sensenData.getStageResultImage(4)" x="510" y="230" width="85" height="85" cond="tf.sensenData.stage > 4"]
[image layer="1" storage="&tf.sensenData.getStageResultImage(5)" x="600" y="140" width="85" height="85" cond="tf.sensenData.stage > 5"]

*refresh_heroine_stat
[button graphic="../bgimage/stage1.png" x="50" y="500" width="180" height="85" target="*advance_to_stage1" cond="tf.sensenData.stage >= 1"]
[button graphic="../bgimage/stage2.png" x="140" y="410" width="180" height="85" target="*advance_to_stage2" cond="tf.sensenData.stage >= 2"]
[button graphic="../bgimage/stage3.png" x="230" y="320" width="180" height="85" target="*advance_to_stage3" cond="tf.sensenData.stage >= 3"]
[button graphic="../bgimage/stage4.png" x="320" y="230" width="180" height="85" target="*advance_to_stage4" cond="tf.sensenData.stage >= 4"]
[button graphic="../bgimage/stage5.png" x="410" y="140" width="180" height="85" target="*advance_to_stage5" cond="tf.sensenData.stage >= 5"]

[iscript]
    tf.lambda_lp_text = `${tf.sensenData.lambda.lp}/${tf.sensenData.lambda.maxLp}`;
    tf.mu_lp_text = `${tf.sensenData.mu.lp}/${tf.sensenData.mu.maxLp}`;
[endscript]
[if exp="tf.heroineStatDetail"]
    [ptext layer="2" name="lambda_stat"    x="880" y="385" size="20" text="ラムダ" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="2" name="mu_stat"       x="1080" y="385" size="20" text="ミュー" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="2" name="lambda_lp_name" x="880" y="420" size="16" text="体力(LP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="2" name="mu_lp_name"    x="1080" y="420" size="16" text="体力(LP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="2" name="lambda_ap_name" x="880" y="450" size="16" text="攻撃力(AP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="2" name="mu_ap_name"    x="1080" y="450" size="16" text="攻撃力(AP)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="2" name="lambda_er_name" x="880" y="480" size="16" color="0xfc03db" text="快楽値(ER)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="2" name="mu_er_name"    x="1080" y="480" size="16" color="0xfc03db" text="快楽値(ER)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="2" name="lambda_cr_name" x="880" y="510" size="16" color="0x3e8238" text="堕落値(CR)" overwrite="true" edge="2px 0x000000" overwrite="true"]
    [ptext layer="2" name="mu_cr_name"    x="1080" y="510" size="16" color="0x3e8238" text="堕落値(CR)" overwrite="true" edge="2px 0x000000" overwrite="true"]

    [ptext layer="3" name="lambda_lp"  x="880" y="420" size="22" text="&tf.lambda_lp_text" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_lp"     x="1080" y="420" size="22" text="&tf.mu_lp_text" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_ap"  x="880" y="450" size="22" text="&tf.sensenData.lambda.currentAp" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_ap"     x="1080" y="450" size="22" text="&tf.sensenData.mu.currentAp" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_er"  x="880" y="480" size="22" color="0xfc03db" text="&tf.sensenData.lambda.er" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_er"     x="1080" y="480" size="22" color="0xfc03db" text="&tf.sensenData.mu.er" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="lambda_cr"  x="880" y="510" size="22" color="0x3e8238" text="&tf.sensenData.lambda.cr" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [ptext layer="3" name="mu_cr"     x="1080" y="510" size="22" color="0x3e8238" text="&tf.sensenData.mu.cr" width="180" align="right" edge="3px 0x000000" overwrite="true"]
    [glink color="btn_29_purple" target="*change_heroine_stat" size="24" text="CLOSE" x="980" y="650" width="240" exp="tf.heroineStatDetail = false"]
[else]
    [glink color="btn_29_purple" target="*change_heroine_stat" size="24" text="ステータス" x="980" y="650" width="240" exp="tf.heroineStatDetail = true"]
[endif]
[glink color="btn_29_green" target="*back" text="タイトルに戻る" width="240" size="24" x="10" y="650"]
[s]

*change_heroine_stat
[cm]
[freeimage layer="2"]
[freeimage layer="3"]
[jump target="*refresh_heroine_stat"]

*advance_to_stage1
[sensen_footer]
[jump storage="stage1.ks"]

*advance_to_stage2
[sensen_footer]
[jump storage="stage2.ks"]

*advance_to_stage3
[sensen_footer]
[jump storage="stage3.ks"]

*advance_to_stage4
[sensen_footer]
[jump storage="stage4.ks"]

*advance_to_stage5
[sensen_footer]
[jump storage="stage5.ks"]


*back
[sensen_save]
[cm]
[layopt layer="1" visible="false"]
[layopt layer="2" visible="false"]
[layopt layer="3" visible="false"]
[freeimage layer="1"]
[freeimage layer="2"]
[freeimage layer="3"]
[stop_keyconfig]
[jump storage="title.ks"]
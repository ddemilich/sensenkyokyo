;ティラノスクリプトサンプルゲーム

*start

[cm]
[clearfix]
[start_keyconfig]


[bg storage="stage1.png" time="100"]

;メニューボタンの表示
@showmenubutton

;メッセージウィンドウの設定
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true]

;文字が表示される領域を調整
[position layer=message0 page=fore margint="45" marginl="50" marginr="70" marginb="60"]


;メッセージウィンドウの表示
@layopt layer=message0 visible=true

;キャラクターの名前が表示される文字領域
[ptext name="chara_name_area" layer="message0" color="white" size=28 bold=true x=180 y=510]

;上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
[chara_config ptext="chara_name_area"]

# aaa
test[p]

[layopt layer="1" visible="true" ]
[ptext layer="1" name="hoge" text="aaa" x="0" y="300" size="32" edge="4px 0x000000"]

[chara_show name="mu" time="100"]
# ラムダ
登場[p]

[chara_part name="mu" wear="attack1" head="attack1" attacking_l="attacking1" time="100" wait="false"]
[chara_part name="mu" wear="attack1" head="attack1" attacking_r="attacking1" time="100" wait="false"]
[chara_mod name="mu" face="attack" time="100" wait="true"]
攻撃[p]

[chara_hide name="mu" time="100"]
# ラムダ
退場[p]

[layopt layer="message0" visible="false"]
[cm]
[jump storage="title.ks"]
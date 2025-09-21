*start
[sensen_header bg="lobby00.jpg" bgm="kaiju.mp3"]

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

[if exp="sf.sensenSaveData"]
#
セーブ済のデータがあります。[r]
新規データで上書きすると、過去のデータは完全に削除されます。[r]
上書きしても良いでしょうか？[r]

    [glink color="btn_29_green" text="新規データで上書きする！" size="24" width="400" target="*overwrite_latestgame" enterse="open.mp3" leavese="close.mp3"]
    [glink color="btn_29_green" text="過去データで遊ぶ！" size="24"  width="400" target="*continue_latestgame" enterse="open.mp3" leavese="close.mp3"]
    [s]
[endif]


*startnewgame
[sensen_init]
[sensen_load]

*advance_to_lobby
[layopt layer="message0" visible="false"]

[sensen_footer]
[jump storage="lobby.ks"]

*overwrite_latestgame
#
[r]
新規データを作成し、過去データを上書きします。[p]
[jump target="*startnewgame"]

*continue_latestgame
#
[r]
過去データの続きから再開します。[p]
[jump target="*advance_to_lobby"]
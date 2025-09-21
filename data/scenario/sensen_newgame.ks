*start
[sensen_header bg="lobby00.jpg" bgm="kaiju.mp3"]
[novel_header]

# ddemilich
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
[novel_footer]
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
[sensen_load]
[jump target="*advance_to_lobby"]
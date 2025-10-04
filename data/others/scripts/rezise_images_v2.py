import os
import sys
import argparse
from PIL import Image
from shutil import move

def resize_images_in_folder(target_dir):
    """
    指定されたフォルダ内のPNGとWebP画像を40%に縮小し、
    オリジナルをバックアップ、縮小版を成果物フォルダに保存する。
    WebPアニメーションは全フレームを処理する。
    """
    
    # フォルダの存在チェック
    if not os.path.isdir(target_dir):
        print(f"エラー: フォルダ '{target_dir}' が見つかりません。")
        return

    # 成果物フォルダとバックアップフォルダのパスを定義
    output_dir = os.path.join(target_dir, "resized_output")
    backup_dir = os.path.join(target_dir, "original_backup")
    
    # 成果物フォルダとバックアップフォルダを作成
    for d in [output_dir, backup_dir]:
        if not os.path.exists(d):
            os.makedirs(d)
            print(f"フォルダを作成しました: {d}")

    # 処理対象の拡張子
    target_extensions = ('.webp')
    
    print("-" * 30)
    print(f"フォルダ '{target_dir}' の画像処理を開始します。")
    print(f"縮小画像は '{output_dir}' に、オリジナルは '{backup_dir}' に移動されます。")
    print("-" * 30)
    
    processed_count = 0
    
    # 処理対象のファイルリストを事前に作成（処理中に作られたファイルの影響を防ぐ）
    files_to_process = [f for f in os.listdir(target_dir) 
                        if os.path.isfile(os.path.join(target_dir, f)) and f.lower().endswith(target_extensions)]

    if not files_to_process:
        print("処理対象の画像ファイルが見つかりませんでした。")
        return

    for filename in files_to_process:
        original_file_path = os.path.join(target_dir, filename)
        output_path = os.path.join(output_dir, filename)
        
        # 処理が成功したかどうかを記録するフラグ
        success_flag = False

        try:
            # --- 1. 画像処理の実行（withブロック内で完結） ---
            with Image.open(original_file_path) as img:
                original_width, original_height = img.size
                
                new_width = round(original_width * 0.40)
                new_height = round(original_height * 0.40)
                new_size = (new_width, new_height)

                # --- アニメーション WebP 専用処理 ---
                if filename.lower().endswith('.webp') and img.is_animated:
                    
                    frames = []
                    durations = [] # 各フレームの表示時間リストを格納
                    loop = img.info.get('loop', 0)
                    
                    try:
                        while True:
                            # 1. 各フレームの情報を取得
                            frame = img.copy()
                            
                            # 2. 表示時間（duration）をフレームリストに追加
                            # Pillowはフレームごとにduration情報を持っている
                            durations.append(img.info.get('duration', 100)) 
                            
                            # 3. リサイズ
                            resized_frame = frame.resize(new_size, Image.LANCZOS)
                            frames.append(resized_frame)
                            
                            img.seek(img.tell() + 1)
                    except EOFError:
                        pass # 全フレーム処理完了

                    # アニメーションとして保存
                    # 【重要】quality=90（高品質）と duration=durations（リスト）を指定
                    frames[0].save(
                        output_path, 
                        save_all=True, 
                        append_images=frames[1:], 
                        duration=durations, # リストとして渡すことで、フレームごとの時間を反映
                        loop=loop,
                        quality=90,          # 品質を明示的に指定（ぼやけ対策）
                        minimize_size=False  # qualityを指定した場合は minimize_size は不要
                    )
                
                # --- 静止画 PNG/WebP 処理 ---
                else:
                    resized_img = img.resize(new_size, Image.LANCZOS)
                    
                    if filename.lower().endswith('.png'):
                        # PNGは透過を考慮して保存
                        resized_img.save(output_path, "PNG") 
                    elif filename.lower().endswith('.webp'):
                        # WebPはロスレスで保存
                        resized_img.save(output_path, "WEBP", lossless=True)
                
            # --- 2. ファイルハンドルが解放された後に、オリジナルファイルを移動 ---
            # withブロックを抜けたため、ファイルは確実に閉じられている (WinError 32対策)
            backup_path = os.path.join(backup_dir, filename)
            move(original_file_path, backup_path)
            
            # 処理成功
            success_flag = True
            
        except Exception as e:
            # エラー発生時のログ
            print(f"❌ {filename}: 処理中にエラーが発生しました - {e}")
            
        # 成功した場合のみログを出力
        if success_flag:
            type_str = "アニメーションWebP" if filename.lower().endswith('.webp') and Image.open(backup_path).is_animated else "静止画"
            print(f"✅ {filename} ({type_str}): {original_width}x{original_height} → {new_width}x{new_height} (保存先: {output_dir})")
            processed_count += 1
            
    print("-" * 30)
    print(f"🎉 処理が完了しました。合計 {processed_count} 個のファイルを処理しました。")
    print(f"縮小画像は '{output_dir}' にあります。確認後、手動でオリジナルフォルダに戻してください。")


if __name__ == "__main__":
    # argparseの設定
    parser = argparse.ArgumentParser(
        description="指定されたフォルダ内のPNG/WebP画像を40%に縮小し、オリジナルと成果物を別フォルダに整理します。"
    )
    # 必須の位置引数としてフォルダパスを設定
    parser.add_argument(
        "folder_path", 
        type=str, 
        help="処理対象の画像ファイルが含まれるフォルダのパス"
    )

    args = parser.parse_args()
    
    # OSのパス区切り文字の問題を防ぐため、パスを正規化
    folder_path_normalized = os.path.abspath(args.folder_path)
    
    resize_images_in_folder(folder_path_normalized)
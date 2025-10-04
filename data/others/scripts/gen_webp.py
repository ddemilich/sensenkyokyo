import os
import glob
import argparse
import re
from PIL import Image
import imageio

def create_webp_animation(input_dir, output_prefix, fps, loop_count):
    """
    指定されたディレクトリ内の連番画像ファイルからWebPアニメーションを生成する。
    ループありとループなしの2つのファイルを生成する。

    :param input_dir: 画像ファイルが格納されているディレクトリのパス
    :param output_prefix: 出力ファイル名のプレフィックス
    :param fps: アニメーションのフレームレート (frames per second)
    :param loop_count: ループ回数 (0で無限ループ)
    """
    # ディレクトリが存在するかチェック
    if not os.path.isdir(input_dir):
        print(f"エラー: ディレクトリ '{input_dir}' が見つからない。")
        return

    # 対応する画像フォーマット
    supported_formats = ('*.png', '*.jpg', '*.jpeg')
    image_files = []
    for fmt in supported_formats:
        image_files.extend(glob.glob(os.path.join(input_dir, fmt)))

    if not image_files:
        print(f"エラー: ディレクトリ '{input_dir}' の中に画像ファイルが見つからない。")
        return

    # ファイル名を自然順（人間が直感的に理解する順）でソートする
    def natural_sort_key(s):
        return [int(text) if text.isdigit() else text.lower() for text in re.split('([0-9]+)', s)]
    
    image_files.sort(key=natural_sort_key)

    print(f"{len(image_files)}個のファイルを検出した。")
    print("WebPに変換中...")

    # 画像を開き、リストに追加
    try:
        images = [Image.open(image_file) for image_file in image_files]
    except Exception as e:
        print(f"エラー: 画像ファイルの読み込み中に問題が発生した: {e}")
        return
        
    # durationをFPSから計算 (ミリ秒単位)
    duration_ms = 1000 / fps

    # ループあり、ループなしの2つのファイルを生成
    output_files = {
        "loop": f"{output_prefix}_animation_loop.webp",
        "noloop": f"{output_prefix}_animation_noloop.webp"
    }

    for anim_type, filename in output_files.items():
        current_loop = loop_count if anim_type == "loop" else 1 # noloopの場合は1回だけ再生
        print(f"'{anim_type}' バージョンを保存中: '{filename}'")
        try:
            imageio.mimwrite(filename, images, format="webp", duration=duration_ms, loop=current_loop)
            print(f"完了。'{filename}' として保存した。")
        except Exception as e:
            print(f"エラー: WebPファイルの保存中に問題が発生した: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="連番の画像ファイルからWebPアニメーションを生成するスクリプト。")
    
    # 必須の引数（フォルダ名）
    parser.add_argument("input_dir", help="画像ファイルが格納されているディレクトリ。")
    
    # オプションの引数
    parser.add_argument("--fps", type=float, default=60.0, 
                        help="アニメーションのフレームレート(fps)。 (デフォルト: 60.0)")
    parser.add_argument("--loop", type=int, default=0, 
                        help="ループ回数。0で無限ループ。 (デフォルト: 0)")
    
    args = parser.parse_args()
    
    # 出力ファイル名のプレフィックスを生成
    # ソート済みの最初のファイル名から数字部分と拡張子を除去
    if os.path.isdir(args.input_dir):
        supported_formats = ('*.png', '*.jpg', '*.jpeg')
        image_files_for_prefix = []
        for fmt in supported_formats:
            image_files_for_prefix.extend(glob.glob(os.path.join(args.input_dir, fmt)))
        
        if image_files_for_prefix:
            # natural_sort_keyを使ってソート
            def natural_sort_key(s):
                return [int(text) if text.isdigit() else text.lower() for text in re.split('([0-9]+)', s)]
            image_files_for_prefix.sort(key=natural_sort_key)
            
            first_file_name = os.path.basename(image_files_for_prefix[0])
            # 拡張子を除去
            name_without_ext = os.path.splitext(first_file_name)[0]
            # 数字部分を除去
            output_prefix = re.sub(r'[0-9]+$', '', name_without_ext)
            if not output_prefix: # 数字のみのファイル名だった場合などのFallback
                output_prefix = "output"
        else:
            output_prefix = "output" # 画像ファイルがない場合のFallback
    else:
        output_prefix = "output" # ディレクトリがない場合のFallback


    # 関数を実行
    create_webp_animation(args.input_dir, output_prefix, args.fps, args.loop)
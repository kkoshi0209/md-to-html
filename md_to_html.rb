require 'kramdown'
require 'kramdown-parser-gfm'
require 'rouge'

USAGE = <<~TEXT
  使い方:
    ruby md_to_html.rb <input.md> <output.html>   1 つのファイルを変換する
    ruby md_to_html.rb <フォルダ>                  フォルダ内の .md をすべて変換する
TEXT

# ページ全体に当てる CSS
STYLE = <<~CSS
  body {
    max-width: 800px;
    margin: 40px auto;
    padding: 0 20px;
    font-family: -apple-system, "Hiragino Sans", "Noto Sans JP", sans-serif;
    line-height: 1.8;
    color: #333;
  }
  h1 { color: #1a5276; border-bottom: 2px solid #1a5276; padding-bottom: 4px; }
  h2 { color: #2874a6; border-left: 6px solid #2874a6; padding-left: 8px; }
  table { border-collapse: collapse; }
  th, td { border: 1px solid #ccc; padding: 6px 12px; }
  th { background: #f2f2f2; }
  pre { padding: 12px; border-radius: 6px; overflow-x: auto; }
  code { font-family: Menlo, Consolas, monospace; }
CSS

# === Markdown を HTML に変換する（テーブル・コードブロック対応）===
def markdown_to_html(markdown)
  Kramdown::Document.new(
    markdown,
    input: 'GFM',                 # GitHub と同じ書き方で読む
    hard_wrap: false,             # 段落内の改行を <br> にしない
    auto_ids: false,              # 見出しに id を付けない
    syntax_highlighter: 'rouge'   # コードブロックに色を付ける
  ).to_html
end

# === HTML 全体の構造で包む ===
def build_page(title, body)
  # コードハイライト用の色の CSS を rouge に作ってもらう
  highlight_css = Rouge::Themes::Github.render(scope: '.highlight')

  <<~HTML
    <!DOCTYPE html>
    <html lang="ja">
    <head>
      <meta charset="UTF-8">
      <title>#{title}</title>
      <style>
    #{STYLE}
    #{highlight_css}
      </style>
    </head>
    <body>
    #{body}
    </body>
    </html>
  HTML
end

# === 1 つのファイルを変換する ===
def convert_file(input_path, output_path)
  markdown = File.read(input_path)
  title = File.basename(input_path, '.md')
  html = build_page(title, markdown_to_html(markdown))
  File.write(output_path, html)
  puts "#{input_path} → #{output_path}"
end

# === フォルダ内の .md をすべて変換する ===
def convert_folder(folder)
  md_files = Dir.glob(File.join(folder, '*.md')).sort

  if md_files.empty?
    puts "#{folder} に .md ファイルがありません"
    return
  end

  md_files.each do |input_path|
    # sample.md → sample.html のように、拡張子だけ変える
    output_path = input_path.delete_suffix('.md') + '.html'
    convert_file(input_path, output_path)
  end
end

# === メイン処理 ===
def main
  if ARGV.length == 2
    convert_file(ARGV[0], ARGV[1])
  elsif ARGV.length == 1 && File.directory?(ARGV[0])
    convert_folder(ARGV[0])
  elsif ARGV.length == 1
    puts "フォルダが見つかりません: #{ARGV[0]}"
    puts USAGE
    exit 1
  else
    puts USAGE
    exit 1
  end
rescue Errno::ENOENT => e
  # ファイルが見つからなかったとき（Python の FileNotFoundError）
  puts "ファイルが見つかりません: #{e.message}"
  exit 1
end

main if __FILE__ == $PROGRAM_NAME

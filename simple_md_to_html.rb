require 'kramdown'

input_path = ARGV[0]
output_path = ARGV[1]

# 1. Markdown ファイルを読み込む
markdown = File.read(input_path)

# 2. HTML に変換する
html = Kramdown::Document.new(markdown, auto_ids: false).to_html

# 3. HTML ファイルに書き出す
File.write(output_path, html)

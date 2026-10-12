# Markdown to HTML Converter

Markdown ファイルを HTML ファイルに変換する、Ruby 製のコマンドラインツールです。
変換には [kramdown](https://kramdown.gettalong.org/) を使い、CSS 付きの完全な Web ページとして出力します。

## 特徴

- 見出し・段落・太字などの基本的な Markdown に加え、**テーブル**と**コードブロック**（GitHub と同じ書き方）に対応
- コードブロックは言語ごとに色分け表示（シンタックスハイライト）
- `<html>` から `</html>` までの完全な HTML として出力し、CSS で見やすく整形
- フォルダを指定すると、中の `.md` ファイルをまとめて変換

## 動作環境

- Ruby 3.0 以上
- Bundler

## セットアップ

```bash
bundle config set --local path 'vendor/bundle'
bundle install
```

gem はプロジェクト内の `vendor/bundle` にインストールされ、ほかのプロジェクトや Ruby 全体には影響しません。使用する gem は次のとおりです。

| gem | 用途 |
| --- | ---- |
| `kramdown` | Markdown を HTML に変換する |
| `kramdown-parser-gfm` | GitHub 形式の Markdown（テーブル・コードブロック）を読み込む |
| `rouge` | コードブロックに色を付ける |

## 使い方

### 1 つのファイルを変換する

```bash
bundle exec ruby md_to_html.rb <input.md> <output.html>
```

```
$ bundle exec ruby md_to_html.rb sample.md sample.html
sample.md → sample.html
```

### フォルダ内の .md をまとめて変換する

```bash
bundle exec ruby md_to_html.rb <フォルダ>
```

フォルダ内のすべての `.md` ファイルが、同じ場所に同じ名前の `.html` として出力されます。

```
$ bundle exec ruby md_to_html.rb docs
docs/intro.md → docs/intro.html
docs/usage.md → docs/usage.html
```

生成された HTML ファイルは、ブラウザで開くとそのまま Web ページとして表示できます。

## エラー処理

引数の数が正しくない場合は使い方を、ファイルやフォルダが存在しない場合はエラーメッセージを表示し、終了ステータス `1` で終了します。

## 簡易版（simple_md_to_html.rb）

ライブラリとの比較用に、外部の gem を使わず**見出しと太字だけ**に対応した簡易版も同梱しています。`bundle exec` は不要です。

```bash
ruby simple_md_to_html.rb <input.md> <output.html>
```

簡易版には次の制限があります。

- 見出しと段落の間には空行が必要
- リスト・リンク・画像・テーブル・コードブロックには非対応
- `<` や `&` などの記号をエスケープしない

## ファイル構成

```
.
├── Gemfile                 # 使用する gem の一覧
├── Gemfile.lock            # gem のバージョンを固定する（自動生成）
├── md_to_html.rb           # 変換ツール本体
├── simple_md_to_html.rb    # 比較用の簡易版
└── sample.md               # 動作確認用のサンプル
```

`vendor/bundle` はインストールした gem の置き場所なので、Git で管理する場合は `.gitignore` に追加してください。

## トラブルシューティング

### `cannot load such file -- rouge (LoadError)` と表示される

`bundle exec` を付けずに実行すると、`vendor/bundle` にインストールした gem が見つかりません。`bundle exec ruby md_to_html.rb ...` のように実行してください。

それでも解決しない場合は、`bundle install` を実行して gem がインストールされているか確認してください。

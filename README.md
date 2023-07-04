# Team Enu PRサイト

本リポジトリはTeam Enuを紹介するWebサイトのソースコードです。

本Webサイトは、[Hugo](https://gohugo.io/)で作成しています。
Hugoの入力は、[`/content/`](/content/)以下で管理しています。
Hugoの出力は、[`/docs/`](/docs/)以下に保存しています。
本番環境では、GitHub Pagesを用いて、[`/docs/`](/docs/)以下を公開することを想定しています。


## このレポジトリのクローン

```bash
git clone https://github.com:Team-Enu/pr-site-dev.git
cd pr-site-dev
git submodule init && git submodule update
```

Hugoを入れた環境が欲しい人は、[`/Dockerfile`](/Dockerfile)を使ってみてください。


## Webサイトの確認方法

1. 次のようなコマンドで、Webサーバーを起動します

    ```bash
    cd docs
    python3 -m http.server 8080
    ```

2. Webブラウザで、[http://localhost:8080](http://localhost:8080)にアクセスします


## Webサイトの更新方法

[`/content/`](./content/)以下のMarkdownファイルを更新したら、次のコマンドでHTMLを出力します。

```bash
hugo
```

そしたら、Webサーバーを立ち上げてアクセスしたり、ブラウザでページをリフレッシュすれば、反映されていることが確認できます。


# 現状について

Webサイト右上のリンクを用いると、サイト内のページに遷移します。  
以下の2種類のページがあります。
- Webサイトのトップページ: <http://localhost:8080/>
- writeupページ: <http://localhost:8080/writeups/>
  - サンプルのWriteUp: <http://localhost:8080/writeups/writeup1/>


## Link Previewへの対応について

```html
<meta name="description" content="Team EnuのWriteupや活動の紹介を掲載しています。">
```

この`meta`タグにより、全ページで共通のLink Previewが表示されます。
OpenGraphやTwitter Cardの仕様に従うものではないようですので、詳細は検討中です。
設定上は1箇所のみdescriptionを記入できるようになっているため、文章は画面上の右側の紹介と共通になります。


# ページの編集方法について

ページの追加方法および編集方法を説明します。


## Newsの追加方法

次のテンプレートを参考に、[`/content/news/_index.md`](/content/news/_index.md)を修正してください。

```markdown
# 表題 (yyyy-mm-dd)

Team Enuが予選にどのように取り組んでいるか記事にしました。ぜひご覧ください。  
[DEF CON CTF 2022 予選参加レポート(サンプル)](/posts/2022060801)
```

専用のページで詳しく公開したい場合は、次の「News記事の追加方法」を参考にしてください。


## News記事の追加方法

<span style="color: red">注意：ページを作ってGitHubにpushした段階で公開されます。自動で`/posts/`にリンクが作成されます。意図しない公開に気をつけてください。</span>  

1. Markdownファイルを作成するために、次のようなコマンドを実行してください

    ```bash
    hugo new posts/2022123101/_index.md
    ```

2. `posts/2022123101/_index.md`として、次のような内容のファイルが作成されるので、これを元に編集してください

    ```
    ---
    title: "記事のタイトル"
    date: 2022-11-10T03:13:53Z
    author: "記事の概要と記事のページに印字される著者名"
    draft: false
    summary: "記事の一覧に表示される概要です。"
    ---
    <!--ここから記事のMarkdownを書く。最初にtitleが自動で出力される。-->
    ```

    - 画像等を挿入したい場合は、`posts/2022123101/`以下に入れて、見通しを良くしましょう

3. リンクを[`/content/news/_index.md`](/content/news/_index.md)に貼る
    - このファイルからの相対パスで記述してください: `../posts/2022111101/`


## News記事の削除方法

リンク `/posts/2022123101`の個別記事を削除したい場合は、次のコマンドを実行します

```bash
git rm -rf content/posts/2022123101
```


## Writeupの作成方法

1. Markdownを作成するために、次のようなコマンドを実行します

    ```bash
    hugo new writeup/2022123101/_index.md
    ```

2. `writeup/2022123101/_index.md`として、次のような内容のファイルが作成されるので、これを元に編集してください

    ```
    ---
    title: "記事のタイトルです。"
    date: 2022-11-10T14:58:39+09:00
    draft: false
    summary: "記事一覧に表示される概要です"
    author: "著者名"
    ---
    <!--ここから記事のMarkdownを書く。最初にtitleが自動で出力される。-->
    ```

    - 画像等を挿入したい場合は、`writeup/2022123101/`以下に入れて、見通しを良くしましょう

3. リンクを[`/content/writeups/_index.md`](/content/writeups/_index.md)に貼ります
    - このファイルからの相対パスで記述してください: `../writeup/2022123101/`


## writeupの削除方法

リンク `/writeup/2022123101`のwriteupを削除したい場合は、次のコマンドを実行します

```bash
git rm -rf content/writeup/2022123101
```

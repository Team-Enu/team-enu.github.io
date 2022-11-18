# Team Enu PRサイト

本リポジトリはTeam Enuを紹介するWebサイトのソースコードです。

本WebサイトはHugoで作成し、Hugoの出力をdocsに保存しています。
本番環境ではGitHub Pagesでdocs以下を公開することを想定しています。

## Webサイトの確認方法

### 1. Webサーバを起動する

```bash
git clone --recursive git@github.com:Team-Enu/pr-site-dev.git
cd pr-site-dev/docs
python3 -m http.server 8080
```

### 2. Webサイトにアクセスする

Webブラウザで[http://localhost:8080](http://localhost:8080)にアクセスする。

# 現状について

Webサイト右上のリンクを用いると、サイト内のページに遷移します。  
以下の2種類のページがあります。
- Webサイトのトップページ[http://localhost:8080/](http://localhost:8080/)
- writeupページ[http://localhost:8080/writeups/](http://localhost:8080/writeups/)
  - サンプルのWriteUp [http://localhost:8080/writeups/writeup1/](http://localhost:8080/writeups/writeup1/)

# Link Previewへの対応について

以下の行がすべてのページについているため、全ページ共通のLink Previewがなされる場合があると思います。OpenGraphやTwitter Cardではないので、どうなるかわかりません。設定上は1箇所のみdescriptionを記入できるようになっているため、文章は画面上の右側の紹介と共通になります。
```html
<meta name="description" content="Team EnuのWriteupや活動の紹介を掲載しています。">
```

# ページの編集方法について

ページの追加方法および編集方法を説明します。

## Newsの追加方法

`/content/news/_index.md`を修正してください。

以下のような感じです。個別記事の書き方は下の「個別記事の追加方法」を参照してください。

```md
# 表題 (yyyy-mm-dd)

Team Enuが予選にどのように取り組んでいるか記事にしました。ぜひご覧ください。  
[DEF CON CTF 2022 予選参加レポート(サンプル)](/posts/2022060801)
```

## 個別記事の追加方法（Postsの追加方法）

<span style="color: red">注意：ページを作ってGitHubにpushした段階で公開されます。自動で`/posts/`にリンクが作成されます。意図しない公開に気をつけてください。</span>  

1. 個別記事を作る

markdownを作る。説明では`2022123101.md`を作成するものとする。

Hugoがインストールされている場合以下のコマンドを実行する。
```bash
hugo new posts/2022123101.md
```

Hugoがインストールされていない場合、以下のコマンドを実行する。

```bash
cp archetypes/posts.md content/posts/2022123101.md
```

以下の内容のファイルが作成される。これを編集する。
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

2. （画像を貼る場合）、外部ファイルを置くためのディレクトリを作成する

作成したmarkdownのファイル名から`.md`を除いたディレクトリ名でディレクトリを作成する。

```bash
mkdir `content/posts/2022123101`
```

この中に画像を配置することで、`content/posts/2022123101.md`では`[aaa](<content/posts/2022123101からの相対パス>)`で参照できる

3. リンクをNewsに貼る


絶対パスで`/posts/2022123101/`をリンク先にすると、正しく表示される。


## 個別記事の削除方法

絶対パスで`/posts/2022123101`を削除する場合、以下を実行する。

```bash
git rm content/posts/2022123101.md
git rm -rf content/posts/2022123101
```

上記の場合、`content/posts/2022123101`ディレクトリが存在しない場合は実行しなく良い。


## Writeupの作成方法

1. writeup用のmarkdownを作る

markdownを作る。説明では`2022123101.md`を作成するものとする。

Hugoがインストールされている場合以下のコマンドを実行する。
```bash
hugo new writeups/2022123101.md
```

Hugoがインストールされていない場合、以下のコマンドを実行する。

```bash
cp archetypes/writeups.md content/writeups/2022123101.md
```

以下の内容のファイルが作成される。これを編集する。
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

2. （画像を貼る場合）、外部ファイルを置くためのディレクトリを作成する

作成したmarkdownのファイル名から`.md`を除いたディレクトリ名でディレクトリを作成する。

```bash
mkdir `content/writeups/2022123101`
```

この中に画像を配置することで、`content/writeups/2022123101.md`では`[aaa](<content/writeups/2022123101からの相対パス>)`で参照できる


## writeupの削除方法

絶対パスで`/writeups/2022123101`を削除する場合、以下を実行する。

```bash
git rm content/writeups/2022123101.md
git rm -rf content/writeups/2022123101
```

上記の場合、`content/writeups/2022123101`ディレクトリが存在しない場合は実行しなく良い。

## memberの追加方法

1. member用のmarkdownを作る

markdownを作る。説明では`s.ichioka.md`を作成するものとする。

Hugoがインストールされている場合以下のコマンドを実行する。
```bash
hugo new members/s.ichioka.md
```

Hugoがインストールされていない場合、以下のコマンドを実行する。

```bash
cp archetypes/members.md content/members/s.ichioka.md
```

以下の内容のファイルが作成される。これを編集する。
```
---
title: "表示する氏名"
draft: false
---

## 普段のCTF活動
Team-Enuでは毎週金曜日にpwn部屋で活動したり、たまに有志で野良CTFに参加しています。

## CTF以外の趣味
ポケモン

## CTF活動での経歴

- SECCON CTF ○○を作問 (2022)
- SECCON for Beginners 作問 (2018)
```

2. （画像を貼る場合）、外部ファイルを置くためのディレクトリを作成する

作成したmarkdownのファイル名から`.md`を除いたディレクトリ名でディレクトリを作成する。

```bash
mkdir `content/members/s.ichioka`
```

この中に画像を配置することで、`content/members/s.ichioka.md`では`[aaa](<content/members/s.ichiokaからの相対パス>)`で参照できる


## writeupの削除方法

絶対パスで`/members/s.ichioka`を削除する場合、以下を実行する。

```bash
git rm content/members/s.ichioka.md
git rm -rf content/members/s.ichioka
```

上記の場合、`content/members/s.ichioka`ディレクトリが存在しない場合は実行しなく良い。
# Team Enu PRサイト

本リポジトリはTeam Enuを紹介するWebサイトのソースコードです。

本WebサイトはHugoで作成し、Hugoの出力をdocsに保存しています。
本番環境ではGitHub Pagesでdocs以下を公開することを想定しています。

## Webサイトの確認方法

### 1. Webサーバを起動する

```bash
git clone git@github.com:Team-Enu/pr-site-dev.git
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


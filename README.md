# ZomekiAutoTest
zomeki3上のボタンの動作が正常であるか確認する自動テストのプラグイン

## 使い方

##### 1. このプラグインを導入したいzomekiの[ツール]-[プラグイン]-[新規作成]で、プラグイン名 shimizu000/zoemki\_auto\_test を選択したものを新規作成してください。

##### 2. <https://github.com/shimizu000/zomeki_auto_test_files> にあるファイルのうち 'README.md' 以外をダウンロードし、zomekiファイル下に入れてください。

フォルダに入っているファイルはフォルダごと入れてください。

##### 3. zomekiの .rspec ファイルに -r turnip/rspec を追記してください。

例：<https://github.com/zomeki/zomeki3>の ZOMEKI インストールマニュアル に沿ってインストールしたzomekiである場合

```
 $ cd /var/www/zomeki

 $ vi .rspec
```

```
 -r turnip/rspec # 追加
```

##### 4. ダウンロードした config.yml ファイルでテストしたいzomekiを指定してください。

デフォルトではzomekiのデモサイトになっています。

```
 $ vi config.yml
```

```
  app_host: http://demo-cms.zomekiv3.zomeki.jp/ # 'app_host: ' より後のURLを変更する
```

##### 5. bundle install を行ってください。

```
 $ bunlde install
```

エラーになる場合は、以下のようにファイルを変更することでエラーが解消される可能性があります。

```
 $ vi config/plugins/Gemfile
```

変更前

```
 gem 'zomeki_auto_test', git: 'http://github.com/shimizu000/zomeki_auto_test.git', branch: 'master'
```

変更後

```
 gem 'zomeki_auto_test', git: 'git@github.com:shimizu000/zomeki_auto_test.git', branch: 'master'
```

##### 6. zomekiの[ツール]-[プラグイン]で、1.で新規作成したプラグインを選択し、テスト実行 のボタンをクリックしてください。

テストの実行には時間がかかります。

ページを更新すると、終了したテストの結果が表示されます。



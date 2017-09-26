# ZomekiAutoTest
zomeki3上のボタンの動作が正常であるか確認する自動テストのプラグイン

## 使い方

##### 1. このプラグインを導入したいzomekiの[ツール]-[プラグイン]-[新規作成]で、プラグイン名 shimizu000/zoemki\_auto\_test を選択したものを新規作成してください。

##### 2. <https://github.com/shimizu000/zomeki_auto_test_files> にあるファイルのうち 'README.md' 以外をダウンロードし、/var/www/zomeki_auto_test_files下に入れてください。

フォルダに入っているファイルはフォルダごと入れてください。

##### 3. ダウンロードした config.yml ファイルでテストしたいzomekiを指定してください。

デフォルトではzomekiのデモサイトになっています。

```
 $ vi /var/www/zomeki_auto_test_files/config.yml
```

```
  app_host: http://demo-cms.zomekiv3.zomeki.jp/ # 'app_host: ' より後のURLを変更する
```

##### 4. zomeki の 以下のファイルを変更してください。

・.rspec ファイル

```
 $ cd /var/www/zomeki

 $ vi .rspec
```

```
 -r turnip/rspec # 追加する
```

・spec/spec_helper.rb ファイル

```
 $ cd /var/www/zomeki/spec

 $ vi spec_helper.rb
```

```
 require "/var/www/zomeki_auto_test_files/spec/turnip_helper.rb" # 追加する
```

これによりテストに関するファイルを読み込むようになります。


##### 5. zomeki で bundle install を行ってください。

```
 $ cd /var/www/zomeki

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



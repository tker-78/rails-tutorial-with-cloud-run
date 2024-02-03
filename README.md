# README

## Docker Composeによる開発環境構築

```bash
$ docker compose build
```

```
$ docker compose run web bin/rails db:create
$ docker compose run web bin/rails db:migrate
```

```bash
$ docker compose up
```


## Deployment instructions
How to deploy this application to Google Cloud Platform(Google Cloud Run)

APIの有効化
```bash
$ gcloud services enable run.googleapis.com sql-component.googleapis.com \
  cloudbuild.googleapis.com secretmanager.googleapis.com compute.googleapis.com \
  sqladmin.googleapis.com
```

sqlインスタンスの作成
```bash
$ gcloud sql instances create rails-instance \
  --database-version POSTGRES_12 \
  --tier db-f1-micro \
  --region asia-northeast1
```

データベースの作成
```bash
$ gcloud sql databases create rails-database \
  --instance rails-instance
```

データベースのユーザーパスワードを作成
```bash
$ cat /dev/urandom | LC_ALL=C tr -dc '[:alpha:]'| fold -w 50 | head -n1 > dbpassword
```

パスワードを指定してデータベースユーザーを作成
```bash
$ gcloud sql users create rails-user \
  --instance rails-instance \
  --password=$(cat dbpassword)
```

Cloud Storageのバケットの作成
```bash
$ gsutil mb -l asia-northeast1 gs://hello-app-413020-media
```

```bash
$ gsutil iam ch allUsers:objectViewer gs://hello-app-413020-media
```


Secret Managerでデータベースパスワードをcredentialsに追記
すでに`config/master.key`と`config/credentials.yml.enc`が存在する場合は削除する。
```bash
$ EDITOR=vim bin/rails credentials/edit
```

```vim
# 以下を追記
gcp:
  db_password: <dbpasswordの文字列>
```


```bash
$ gcloud secrets create rails-secret --data-file config/master.key
$ gcloud secrets describe rails-secret # 登録されているか確認
```



```bash
# secret managerロールをcompute engineとcloud buildに付与する
$ gcloud secrets add-iam-policy-binding rails-secret \
  --member serviceAccount:156503406577-compute@developer.gserviceaccount.com \
  --role roles/secretmanager.secretAccessor

$ gcloud secrets add-iam-policy-binding rails-secret \
  --member serviceAccount:156503406577@cloudbuild.gserviceaccount.com \
  --role roles/secretmanager.secretAccessor

$ gcloud projects add-iam-policy-binding cloudrun-rails \
    --member serviceAccount:156503406577@cloudbuild.gserviceaccount.com \
    --role roles/cloudsql.client
```




config/application.rb
```ruby
# 以下を追記
key_file = File.join "config", "master.key"
if File.exist? key_file
  ENV["RAILS_MASTER_KEY"] = File.read key_file
end
```

config/environment/production.rb
```ruby
# 以下を追記
 config.active_storage.service = :google
```

Gemfile
```ruby
# 以下を追記
gem 'dotenv-rails', '~>2.8'
gem 'google-cloud-storage', '~>1.44'
```


イメージのビルド
```bash
$ gcloud builds submit --config cloudbuild.yaml
```

**.envが有効にならない場合**
`database.yaml`に直接databaseの設定値を記述する。
```
production:
  <<: *default
  database: rails-tutorial
  username: postgres
  password: <%= Rails.application.credentials.gcp[:db_password] %>
  host: /cloudsql/cloudrun-rails:asia-northeast1:rails-instance/
```

デプロイ
```bash
$ gcloud run deploy hello-app \
  --platform managed \
  --region asia-northeast1 \
  --image gcr.io/cloudrun-rails/hello-app \
  --add-cloudsql-instances cloudrun-rails:asia-northeast1:rails-instance \
  --allow-unauthenticated
```
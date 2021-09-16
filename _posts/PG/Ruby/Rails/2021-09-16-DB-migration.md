---
categories:
  - Programming
  - Ruby
tags:
  - Ruby
  - Rails
---

# DB migration

Railsのマイグレーションは、`db/migrations`ディレクトリ内のマイグレーションファイルからデータを更新し、`db/scheme.rb`ファイルに最新のDBテーブルの情報を更新します

## migrationファイルの生成

```
$ bundle exec rails g migration [migration file name] [field[:type][:index]]
```

- model作成コマンドでも同時に作成可能(`--no-migration`オプションで除外可能)

```
$ bundle exec rails g model [model name] [field[:type][:index]]
```

### create_table

テーブルを作成する

```ruby
create_table :products do |t|
  t.string :name

  t.timestamps
end
```

### change_table

テーブルの構造を変更する

```ruby
change_table :products do |t|
  t.remove :description, :name # description fieldを削除する
  t.string :part_number # part_number fieldを新たに追加する
  t.index :part_number # part_number fieldにindexを貼る
  t.rename :upccode, :upc_code # upccode -> upc_codeにリネームする
end
```

### change_column

カラムを変更する

```ruby
change_column :products, :part_number, :text
```

### add_index

indexを追加する

```ruby add_index :products, :code, uniq: true # code fieldにuniq制約を追加
```

### add_foreign_key

外部キーを追加する

```ruby
add_foreign_key :articles, :authors
```

### SQLを直接実行する

```ruby
Product.connection.execute("UPDATE products SET price = 'free' WHERE 1=1")
```

### upメソッド

migration時に実行したい内容を記述する

### downメソッド

rollback時に実行したい内容を記述する

### changeメソッド

`change`メソッドを使用すると`up`と`down`、つまり実行とrollback両方対応してくれる。

#### changeメソッドでサポートされ散るマイグレーション定義

- add_column
- add_foreign_key
- add_index
- add_reference
- add_timestamps
- change_column_default (:fromと:toの指定は省略できない)
- change_column_null
- create_join_table
- create_table
- disable_extension
- drop_join_table
- drop_table （ブロックを渡さなければならない）
- enable_extension
- remove_column（型を指定しなければならない）
- remove_foreign_key（2番目のテーブルを指定しなければならない）
- remove_index
- remove_reference
- remove_timestamps
- rename_column
- rename_index
- rename_tabl

### reversibleメソッド

`change`メソッド内で`reversible`メソッドを使用することで、`up`の場合の処理と、`down`の場合の処理を制御出来る

```ruby
class ExampleMigration < ActiveRecord::Migration[5.0]
  def change
    create_table :distributors do |t|
      t.string :zipcode
    end

    reversible do |dir|
      # migration実行時のみ実行され、rollback時には実行されない
      dir.up do
        # CHECK制約を追加
        execute <<-SQL
          ALTER TABLE distributors
            ADD CONSTRAINT zipchk
              CHECK (char_length(zipcode) = 5) NO INHERIT;
        SQL
      end

      # rollback時のみ実行される
      dir.down do
        execute <<-SQL
          ALTER TABLE distributors
            DROP CONSTRAINT zipchk
        SQL
      end
    end

    add_column :users, :home_page_url, :string
    rename_column :users, :email, :email_address
  end
end
```

### revertメソッド

以前のマイグレーションロールバック機能を利用できる


```ruby
# ここの時点のmigrationの内容をrevertする
require_relative '20121212123456_example_migration'

class FixupExampleMigration < ActiveRecord::Migration[5.0]
  def change
    revert ExampleMigration

    create_table(:apples) do |t|
      t.string :variety
    end
  end
end
```

- ブロックも渡すことが可能。以前のマイグレーションの一部のみをrevertしたい場合に用いる

```ruby
class DontUseConstraintForZipcodeValidationMigration < ActiveRecord::Migration[5.0]
  def change
    revert do
      # ExampleMigrationのコードをコピー＆ペースト
      reversible do |dir|
        dir.up do
          # CHECK制約を追加
          execute <<-SQL
            ALTER TABLE distributors
              ADD CONSTRAINT zipchk
                CHECK (char_length(zipcode) = 5);
          SQL
        end
        dir.down do
          execute <<-SQL
            ALTER TABLE distributors
              DROP CONSTRAINT zipchk
          SQL
        end
      end

      # 以後のマイグレーションはOK
    end
  end
end
```

## オペレーションコマンド

### データベースを作成する

```
$ bundle exed rails db:create
```

### migrationの実行

- VERSIONを指定するとそのバージョンのみmigrationを実行する

```
$ bundle exec rails db:migrate [VERSION=$VERSION]
```

### ロールバック

- 直前に行ったマイグレーションをロールバックする

```
$ bundle exec rails db:rollback
```

- 複数バージョンをロールバックする

```
$ bundle exec rails db:rollback STEP=(n)
```

### データベースを設定する

データベースの作成、スキーマの読み込み、シードデータの投入まで行う

```
$ bundle exec rails db:setup
```

### データベースをリセットする

```
$ bundle exec rails db:reset
```

### seedデータの投入

`db/seeds.rb`の内容をもとに、初期データの投入を行う

```
$ bundle exec rails db:seed
```

## スキーマダンプの種類

- ruby : `db/scheme.rb`を生成しスキーマの情報を保存する
- sql : `db/structure.sql`を生成しSQLでスキーマの情報を保存する

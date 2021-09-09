---
categories:
  - Programming
  - Ruby
tags:
  - Ruby
  - Rails
---

# ActiveRecord Association

[Railsガイド](https://railsguides.jp/association_basics.html)

## 関連付けの種類

### belongs_to

`belongs_to`関連付けを行うと、他方のモデル間に`1:1`の関係が設定される。この宣言を行うと他方のモデルインスタンスに「従属(belogns to)」することができる。 一般的には外部キーを持つテーブルのモデルに指定される。

```ruby
class Book < ApplicationRecord
  belongs_to :author
end
```

<!-- TODO PlantUMLで生成 -->

> belongs_toで指定するモデル名は必ず単数形にする必要がある

#### Options

##### :class_name

belongs_toで指定したモデル名が推測できない場合に、クラス名を直接指定することが可能

##### :foreign_key

関連付けに使用される外部キーを指定する。デフォルトではモデル名 + `_id`が外部キーとして推測されている

##### :primary_key

関連付けに使用される主キーを指定する。デフォルトでは`id`

##### :dependent

`:destroy` を指定すると削除時にこのモデルに関連するモデルも同時に削除する。`:destroy_async`を指定するとバックグラウンドジョブで削除されるようにスケジュールされる。

##### :polymorphic

この関連付けがポリモーフィック(多態性)関連であることを示す。

### has_one

`has_one`関連付けも、`1:1`の関連付けが設定される。`has_one`の場合は、その宣言が行われているモデルのインスタンスが、他方のモデルインスタンスを「まるごと含んでいる」または「所有している」ことを示す。一般的には外部キーの関連元のテーブルのモデルに指定される。

```ruby
class Supplier < ApplicationRecord
  has_one :account
end
```

#### Scopes

scopeを定義することで、アソシエーション関連付ける際に条件を追加することができる

```ruby
has_one :author, -> { where(deleted_at: nil) }
```

#### Options


##### :through

`has_one :through`関連付けは、他方のモデルに対して「1対1」の関連付けを設定する。2つのモデルの間に「第３のモデル」が介在する

```ruby
class Supplier < ApplicationRecord
  has_one :account
  has_one :account_history, through: :account
end

class Account < ApplicationRecord
  belongs_to :supplier
  has_one :account_history
end

class AccountHistory < ApplicationRecord
  belongs_to :account
end
```

##### :inverse_of

双方向の関連付けを明示的に宣言できる

### has_many

`has_many`関連付けは、他のモデルとの間に「1:多」のつながりであることを示す。

```ruby
class Author < ApplicationRecord
  has_many :books
end
```

### has_many :through

`has_many :through`関連付けは、他方のモデルと「多対多」のつながりを設定する場合に使われる

```ruby
class Physician < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments
end

class Appointment < ApplicationRecord
  belongs_to :physician
  belongs_to :patient
end

class Patient < ApplicationRecord
  has_many :appointments
  has_many :physicians, through: :appointments
end
```

### ポリモーフィック関連付け

ポリモーフィック関連付けを使うと、ある1つのモデルが他の複数のモデルに属していることを、1つの関連付けだけで表現できる

```ruby
class CreatePictures < ActiveRecord::Migration[5.2]
  def change
    create_table :pictures do |t|
      t.string  :name
      t.references :imageable, polymorphic: true
      t.timestamps
    end
  end
end
```

```ruby
class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
end

class Employee < ApplicationRecord
  has_many :pictures, as: :imageable
end

class Product < ApplicationRecord
  has_many :pictures, as: :imageable
end

@employee.pictures # Employeeに属しているpicturesを取得できる
```

### 自己結合

`class_name`を自身のモデル、`foregen_key`を自身の関連キーを指定するようにすると自己結合が可能になる

```ruby
class Employee < ApplicationRecord
  has_many :subordinates, class_name: "Employee",
                          foreign_key: "manager_id"

  belongs_to :manager, class_name: "Employee", optional: true
end
```

```ruby
class CreateEmployees < ActiveRecord::Migration[5.0]
  def change
    create_table :employees do |t|
      t.references :manager
      t.timestamps
    end
  end
end
```

---
categories:
  - Programming
  - Ruby
tags:
  - Ruby
  - Rails
---

# ActiveRecord Association

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

### has_many

`has_many`関連付けは、他のモデルとの間に「1:多」のつながりであることを示す。

```ruby
class Author < ApplicationRecord
  has_many :books
end
```

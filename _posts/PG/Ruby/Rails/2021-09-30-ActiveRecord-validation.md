---
categories:
  - Programming
  - Ruby
tags:
  - Ruby
  - Rails
---

# ActiveRecord Validation

## Validationの概要

バリデーションは、正しいデータだけをデータベースに保存するために行われる。

`validates`構文をModelのattributeに適用したり、独自の関数をvalidation時に呼び出し、妥当性検査を行うことが出来る

```ruby
class Person < ApplicationRecord
  validates :name, presence: true
end

Person.create(name: "John Doe").valid? # => true
Person.create(name: nil).valid? # => false
```

### Validationが行われるタイミング

- `create`
- `create!`
- `save`
- `save!`
- `update`
- `update!`

### バリデーションのスキップ

以下のメソッドはバリデーションを行わずにスキップする

- `decrement!`
- `decrement_counter`
- `increment!`
- `increment_counter`
- `toggle!`
- `touch`
- `update_all`
- `update_attribute`
- `update_column`
- `update_columns`
- `update_counters`

## バリデーションヘルパー

`:on`オプションはバリデーションを実行するタイミングを指定し、`:messages`オプションはバリデーション失敗時に`errors`コレクションに追加するメッセージを指定します

### acceptance

チェックボックスがONになっているかどうかを検証する

```ruby
class Person < ApplicationRecord
  validates :terms_of_service, acceptance: true
end
```

### validates_associated

モデルが他のモデルに関連付けられていて、両方のモデルに対してバリデーションを実行する必要がある場合に使うべきです。オブジェクトを保存しようとすると関連付けられていているオブジェクトごとに`valid?`が呼び出されます

```ruby
class Library < ApplicationRecord
  has_many :books
  validates_associated :books
end
```

> `validates_associated`を関連付けの両方のオブジェクトで実行してはいけない。両方で設定すると無限ループになってしまうため。

### confirmation

2つのテキストフィールドで受け取る内容が完全に一致する必要がある場合に使用する。このバリデーションヘルパーは`_confirmation`を末尾に追加した仮想の属性を作成する。

```ruby
class Person < ApplicationRecord
  validates :email, confirmation: true
end
```

- ビューテンプレート側

```erb
<%= text_field :person, :email %>
<%= text_field :person, :email_confirmation %>
```

### exclusion

与えられた集合に属性の値が「含まれていない」ことを検証する

```ruby
class Account < ApplicationRecord
  validates :subdomain, exclusion: { in: %w(www us ca jp),
    message: "%{value}は予約済みです" }
end
```

### format

`with`オプションで与えられた正規表現と属性の値がマッチするかどうかのテストによる検証を行う

```ruby
class Product < ApplicationRecord
  validates :legacy_code, format: { with: /\A[a-zA-Z]+\z/,
    message: "英文字のみが使えます" }
end
```

### inclusion

与えられた集合に属性の値が含まれているかどうかを検証する

```ruby
class Coffee < ApplicationRecord
  validates :size, inclusion: { in: %w(small medium large),
message: "%{value} のサイズは無効です" }
end
```

### length

属性の値の長さを検証する

```ruby
class Person < ApplicationRecord
  validates :name, length: { minimum: 2 }
  validates :bio, length: { maximum: 500 }
  validates :password, length: { in: 6..20 }
  validates :registration_number, length: { is: 6 }
end
```

- minimux: この値より小さい長さだとエラー
- maximum: この値より大きい長さだとエラー
- inまたはwithin: 属性の長さは、与えられた区間以内でなければならない
- is: 属性の長さは与えられた値と等しくなければならない

### numericality

数値のみが使われているかを検証する

```ruby
class Player < ApplicationRecord
  validates :points, numericality: true
  validates :games_played, numericality: { only_integer: true }
end
```

- only_integer: 整数のみ
- greater_than: 指定された値より大きくなければならない
- greater_than_or_equal_to: 指定された値委譲でなければならない
- equal_to: 指定された値と等しくなければならない
- less_than: 指定された値より小さくなければならない
- less_than_or_equal_to: 指定された値以下でなければならない
- other_than: 渡した値意外でなければならない
- add: `true`の場合は奇数でなければならない
- even: `true`の場合は偶数でなければならない

### presence

指定された属性が空でないことを検証する(内部で`blank?`メソッドで検証している)

```ruby
class Person < ApplicationRecord
  validates :name, :login, :email, presence: true
end
```

### absence

指定された属性が空であることを検証する(内部で`present?`メソッドで検証している)

```ruby
class Person < ApplicationRecord
  validates :name, :login, :email, absence: true
end
```

### uniqueness

俗世の値が一意であり重複していないことを検証する。検証時にSELECT文を実行している

```ruby
class Account < ApplicationRecord
  validates :email, uniqueness: true
end
```

- case_sensitiveはデフォルトでtrue

### validates_with

バリデーション専用の別クラスにレコードを渡す

```ruby
class GoodnessValidator < ActiveModel::Validator
  def validate(record)
    if record.first_name == "Evil"
      record.errors[:base] << "これは悪人だ"
    end
  end
end

class Person < ApplicationRecord
  validates_with GoodnessValidator
end
```

### validates_each

1つのブロックに対して属性を検証する。

```ruby
class Person < ApplicationRecord
  validates_each :name, :surname do |record, attr, value|
    record.errors.add(attr, 'must start with upper case') if value =~ /\A[a-z]/
  end
end
```

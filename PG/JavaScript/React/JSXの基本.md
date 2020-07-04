---
tags:
  - JavaScript
  - React
---

# JSXの基本

- JSXはテンプレート言語ではない
> JavaScriptにHTMLライクな構文を拡張したもので、あくまでJavaScriptがベース。

- createElementをシンタックスシュガー

```jsx
<h1>Hello, world</h1>
```

上記のJSXは以下のビルド後、createElementとなる

```javascript
React.createElement("h1", "Hello, World")
```

Reactでは、マークアップとロジックを別々のファイルに変えて人為的に技術を分離するのではなく、マークアップとロジックを両方含む疎結合の「コンポーネント」という単位を用いて関心を分離します。

## 唯一のルート要素を持つ

- NG

ルート要素が2つあるためエラーとなる

```javascript
ReactDOM.render(
  <p>Reactを始めよう</p>
  <p>JSXの基本</p>
)
```

- OK

```javascript
ReactDOM.render(
  <div>
    <p>Reactを始めよう</p>
    <p>JSXの基本</p>
  </div>
)
```

## 空要素

JSXでは、XHTML/XMLと同じく、空要素は必ず`</>`で終える必要がある

- NG

```javascript
const tag = <img src={logo}>;
```

- OK

```javascript
const tag = <img src={logo} />;
```

## HTML属性の命名規則

- キャメルケースである必要がある
- 予約後と被る名前は代替のプロパティが存在する

- NG

```javascript
const tag = (
  <label for="name" class="form-input">
    <input id="name" type="text" tabindex="0" />
  </label>
);
```

- OK

```javascript
const tag = (
  <label htmlFor="name" className="form-input">
    <input id="name" type="text" tabIndex="0" />
  </label>
);
```

- [サポートされているHTML属性](https://ja.reactjs.org/docs/dom-elements.html#all-supported-html-attributes)

## コメント

あくまでJavaScript構文なので、HTMLコメント(`<!-- -->`)は使用不可能

- NG

```javascript
<!-- comment -->
```

```javascript
// comment
/* comment */
{/* comment */}
```

## JSXに式を埋め込む

```javascript
const name = "Bob";

ReactDOM.render(
  <div>
    <h1>Hello, {name}</h1>
  </div>
)
```

> JSXに埋め込まれた値をレンダリングする前にエスケープするため、インジェクション攻撃の対策にもなる。

## 属性値を動的に設定する

{}式は、属性値に対しても利用可能だが、注意点があります。

### 属性前後のクォートは付けない

- NG

```javascript
const url = "https://example.com";

ReactDOM.render(
  <div>
    <a href="{url}">
  </div>
)
```

- OK

```javascript
const url = "https://example.com";

ReactDOM.render(
  <div>
    <a href={url}>
  </div>
)
```

### sytle属性の指定にはオブジェクトを利用する

- NG

```javascript
const style = "color: Red; background-color: Yellow;";

ReactDOM.render(
  <p style={style}>Color</p>
)
```

- OK

```javascript
const style = { color: "Red", backgroundColor: "Yellow" };

ReactDOM.render(
  <p style={style}>Color</p>
)
```

cssプロパティ名はキャメルケースで記述する必要がある

### 属性をまとめて設定する

オブジェクトリテラルと「`...`」演算子を利用することで、複数の属性をまとめて設定することが可能

```javascript
const attrs = {
  src: "http://www.cdn.hogehoge/image.png",
  title: "画像"
};

ReactDOM.render(
  <img {...attrs} />
)
```

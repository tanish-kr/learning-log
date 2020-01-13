# Hooks

React16.8で追加された新機能。stateなどのReactの機能をクラスを書かずに使えるようになる。
関数コンポーネントにstateやライフサイクルといったReactの機能を接続する(`hook into`)ための関数

- 後方互換性がある
- クラス型コンポーネントを削除する予定はない
- Reactのコンセプトを置き換えるものではない

## メリット

- コードが読みやすくシンプルになる
- stateやライフサイクルを使うといったコンポーネントに付与したい機能を切り出すことが簡単になる
- 再利用しやすくテストしやすい

## State Hook

クラスコンポーネントんのLocal Stateに相当するものを関数コンポーネントでも使えるようにする機能

```javascript
import React, { useState } from "react";

function Counter() {
  // [hook] useStateは現在のstateの値とそれを更新するための関数をペアで返す
  // クラスコンポーネントのsetStateとは新しいstateが古いものとマージされないという違いがある
  // stateの初期値を引数にわたす, 最初のレンダー時のみに使用される
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}>
        count up
      </button>
    </div>
  )
}
```

- クラスコンポーネントで書いた場合

```javascript
class Counter extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      count: 0
    };
  }

  render() {
    return (
      <div>
        <p>{this.state.count}</p>
        <button onClick={() => this.setState({ count: this.state.count + 1})}>
          count up
        </button>
      </div>
    )
  }
}
```

- Hookをいつ使うべきか
> 関数コンポーネントを書いていてstateが必要だと気づいた時

## Effect Hook(副作用フック)

クラスコンポーネントのライフサイクルメソッド、`componentDidMount`, `componentDidUpdate`, `componentWillUnmount`に相当する機能を実現する機能

```javascript
import React, { useState, useEffect } from "react";

function Counter() {
  const [count, setCount] = useState(0);

  // DOMへの更新を反映したあとで実行される
  // 副作用はコンポーネント内で宣言されるので、propsやstateにアクセスすることが可能
  // デフォルトでは初回のレンダーも含め、毎回レンダー時にこの副作用関数が呼び出される
  useEffect(() => {
    document.title = `You clicked ${count} times`;
  });

  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}>
        count up
      </button>
    </div>
  );
}
```

## Hookのルール

- Hookは関数のトップレベルのみで呼び出すこと。ループや条件分岐やネストした関数の中でHookを呼び出さない
- HookはReactの関数コンポーネントの内部のみで呼び出すこと。通常のJavaScript関数内では呼び出してはいけない

## Custom Hook

自分独自のHookを作成することで、コンポーネントからロジックを抽出して再利用可能な関数を作ることが可能

- 関数名は`use`で始める
- Custom Hookはstateを使うロジックを共有するためのものだが、Custom Hookを使う場所ごとで、内部のstateや副作用は完全に分離している
- Hook間で情報の受け渡しが可能

## 参考文献

- [Hooks API Reference](https://ja.reactjs.org/docs/hooks-reference.html)




---
tags:
  - JavaScript
  - React
---

# stateとライフサイクル

コンポーネント自体が内部に持つ状態のこと

`props`がコンポーネントへ渡されるのに対し、`state`はコンポーネントの内部で制御される。


- :examle カウンター

```javascript
class Counter extends React.Component {
  constructor(props) {
    // classのコンポーネントは常にprppsを引数として親クラスのコンストラクタを呼び出す必要がある
    super(props);
    // stateの初期状態をコンストラクタで設定
    this.state = { count: 0 };
  }

  increment() {
    // setStateでstateの状態を変更する
    this.setState(prevState => ({
      count: prevState.count + 1
    }));
  }

  decrement = () => {
    this.setState(prevState => ({
      count: prevState.count - 1
    }));
  }

  render() {
    const { count } = this.state;
    return (
      <div className="counter">
        <header>
          <h1>カウンター</h1>
        </header>
        <p>count: {count}</p>
        {/* アロー関数にすることで、`this`から呼び出せる */}
        <button onClick={this.decrement()}>-</button>
        {/* 関数定義の場合は`this`は実行時のオブジェクトになる */}
        <button onClick={() => this.increment()}>+</button>
      </div>
    );
  }
}

ReactDOM.render(
  <Counter />,
  document.getElementById("root")
);
```

## 子コンポーネントから親コンポーネントの情報伝達

親コンポーネント -> 子コンポーネントの情報伝達は**props**を利用するのに対し、子コンポーネントから親コンポーネントへの情報伝達には**state**を利用する

```javascript

class Parent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      data: null
    };
  }

  update(state) {
    this.setState(state);
  }

  render() {
    return (
      <div>
        <p>MyParent: {this.state.data}</p>
        {/* updateメソッドを子コンポーネントに引き渡す */}
        <Child onUpdate={this.update.bind(this)} />
      </div>
    );
  }
}

class Child extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      data: "child data"
    };
    // 親コンポーネントのupdateメソッドを呼び出す
    this.props.onUpdate(this.state);
  }

  render() {
    return (
      <p>MyChild: {this.state.data}</p>
    );
  }
}

ReactDOM.render(
  <Parent />,
  document.getElementById("root")
);
```

## stateを正しく使用する

- stateを直接変更しないこと
- stateの更新は非同期に行われる可能性がある
- stateの更新はマージされる

## コンポーネントのライフサイクル

コンポーネントクラスで特別なメソッドを宣言することで、コンポーネントがマウントしたりアンマウントしたりした際にコードを実行することができる。

大きく分けて以下の4つのフェーズがある。

- Mounthing : コンポーネントが生成されDOMノードに挿入されるフェーズ
- Updating : 変更を検知してコンポーネントが再レンダリングされるフェーズ
- Unmouthing : コンポーネントがDOMノードから削除されるフェーズ
- Error Handling : そのコンポーネント自身および子コンポーネントのエラーを補足する

> コンポーネントが再レンダリングされるのは、基本的にそのコンポーネントに渡されているPropsか、または自身のLocal Stateの値に変更があったとき

- [ライフサイクル図](http://projects.wojtekmaj.pl/react-lifecycle-methods-diagram/)


### Mounthingフェーズ

|   メソッド   |  戻り値  |                説明                |
|-------------|---------|-----------------------------------|
|constructor(props)|void|コンストラクタ(引数にpropsは最低限必須) |
|static getDerivedStateFromProps(props, state)|State \| null |レンダリングの直前に呼ばれ、戻り値でLocal Stateを変更することが出来る|
|render() |React.ReactNode|レンダリングを行う|
|**componentDidMount()**|void|コンポーネントがマウントされた直後に呼ばれる|

### Updathingフェーズ

|   メソッド   |  戻り値  |                説明                |
|-------------|---------|-----------------------------------|
|static getDerivedStateFromProps(props, state)|State \| null |レンダリングの直前に呼ばれ、戻り値でLocal Stateを変更することが出来る|
|**shouldComponentUpdate(nextProps, nextState)**|boolean|再レンダリングの直前で呼ばれ、faalseを返せば再レンダリングを中止できる|
|render() |React.ReactNode|レンダリングを行う|
|getSnapshotBeforeUpdate(prevProps, prefState)|Snapshot \| null |コンポーネントが変更される直前に呼ばれ、戻り値でスナップショットを取っておける|
|**componentDidUpdate(prevProps, prevState, snapshot)**|void|コンポーネントが変更された直後に呼ばれる|

### Unmounthingフェーズ

|   メソッド   |  戻り値  |                説明                |
|-------------|---------|-----------------------------------|
|**componentWillUnmount()**| void | コンポーネントがアンマウントされる直前に呼ばれる|

### Error Handlingフェーズ

|   メソッド   |  戻り値  |                説明                |
|-------------|---------|-----------------------------------|
|static getDerivedStateFromError(error)|State|子孫コンポーネントで例外が起きたときに呼ばれる。Stateを更新する|
|componentDidCatch(error, info)|void|子孫コンポーネントで例外が起きたときに呼ばれる|


- [Reactの最上位API|React.Component](https://ja.reactjs.org/docs/react-component.html)


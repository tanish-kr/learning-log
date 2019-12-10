# Reactの流儀

## コンポジションを使う

コンポーネント感のコードの再利用には継承よりもコンポジションが推奨されている。

### 子要素の出力

コンポーネントの中には事前に子要素を知らないものもある。
このような場合、`children`というpropsを使い、受け取った子要素を出力することが出来る

```javascript
function FancyBorder(props) {
  return (
    <div className={'FancyBorder Fancy' + props.color}>
      {props.children}
    </div>
  )
}
```

### 特化したコンポーネント

コンポーネントを他のコンポーネントの特別なケースとして扱う場合、Reactではコンポジションで実現できる

```javascript
function Dialog(props) {
  return (
    <FancyBorder color="blue">
      <h1 className="Dialog-title">
        {props.title}
      </h1>
      <p className="Dialog-message">
        {props.message}
      </p>
    </FancyBorder>
  );
}

function WelcomeDialog() {
  return (
    <Dialog
      title="Welcome"
      message="Thank you for visiting our spacecraft!" />
  );
}
```

## モックから始めよう

1. UIをコンポーネントの改装構造に落とし込む
2. Reactで静的なバージョンを作成する
3. UI状態を表現する必要かつ十分なstateを決定する
4. stateをどこに配置するべきなのかを明確にする
5. 逆方向のデータフローを追加する



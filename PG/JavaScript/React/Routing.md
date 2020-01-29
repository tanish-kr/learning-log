# Routing

Reactのルーティングには幾つかライブラリは存在するが、`React Router`を基本的に使用するほうが良さそう

## React Router

- [React Router Document](https://reacttraining.com/react-router/web/guides/quick-start)

## Install

```sh
$ npm install react-router-dom
```

## Useage

### 基本的な使い方

ex: `create-react-app --typescript`で生成された index.tsxにReact Routerを適用してみる

- index.tsx

AppコンポーネントをBrowserRouterでラップする事により、以下の階層のコンポーネントでHistory APIを利用した各種機能が使えるようになる

```typescript
import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter } from "react-router-dom";
import "./index.css";
import App from "./App";
import * as serviceWorker from "./serviceWorker";

ReactDOM.render(
  <BrowserRouter>
    <App />
  </BrowserRouter>,
  document.getElementById("root")
);

serviceWorker.unregister();
```

- App.tsx

`Switch`内部に`Route`でルーティングを定義していく。基本的にはルーティングの`path`と`component`を指定する。
`Redirect`でマッチしなかったURLの場合にリダイレクトを設定できる


```typescript
import React from "react";
import { Switch, Route } from "react-router-dom";
import Home from "./components/Home";
import Details from "./components/Details";

import "./App.sass";

const App: React.FC = () => {
  return (
    <div className="container">
      <Switch>
        <Route path="/" component={Home} />
        <Route path="/details" component={Details} />
        <Redirect to="/" />
      </Switch>
    </div>
  );
};

export default App;
```

- components/Home.tsx

`Link`で遷移先のパスを指定することで、React-routerで設定したルーティング先に遷移できるようになる。Historyも変わる。

```typescript
import React from "react";
import { Link } from "react-router-dom";

const Home: React.FC = () => {
  return (
    <div className="container">
      <h1>Welcom Home</h1>
      <ul>
        <li>
          <Link to="/">Home</Link>
        </li>
        <li>
          <Link to="/details">Detail</Link>
        </li>
      </ul>
    </div>
  );
};

export default Home;
```

- components/Details.tsx

```typescript
import React from "react";
import { Link } from "react-router-dom";

const Details: React.FC = () => {
  return (
    <div className="container">
      <h1>Welcom Detail</h1>
      <ul>
        <li>
          <Link to="/">Home</Link>
        </li>
        <li>
          <Link to="/details">Detail</Link>
        </li>
      </ul>
    </div>
  );
};

export default Details;
```

### URLパラメーター

pathに`:id`等、pathパラメータを設定した場合、コンポーネント内では`useParams()`を使用することでパラメータを取得できる

```typescript
import React from "react";
import { Link, useParams } from "react-router-dom";

const Details: React.FC = () => {
  const { id } = useParams();
  return (
    <div className="container">
      <h1>Welcom Detail { id }</h1>
      <ul>
        <li>
          <Link to="/">Home</Link>
        </li>
        <li>
          <Link to="/details">Detail</Link>
        </li>
      </ul>
    </div>
  );
};
```

### Nested

v3とv4では変更があり、書き方が子要素のコンポーネント側にルーティングを記述する方法に変わった

- v3

```typescript
const MyApp = () => (
  <Router history={history}>
    <Route path="/main" component={Layout}>
      <Route path="/foo" component={Foo} />
      <Route path="/bar" component={Bar} />
    </Route>
  </Router>
);

const Layout = ({ children }) => (
  <div className="body">
    <h1 className="title">MyApp</h1>
    <div className="content">
      {children}
    </div>
  </div>
);
```

- v4

```typescript
const MyApp = () => (
  <Router history={history}>
    <Route path="/main" component={Layout} />
  </Router>
);

const Layout = () => (
  <div className="body">
    <h1 className="title">MyApp</h1>
    <div className="content">
      <Switch>
        <Route path="/main/foo" component={Foo} />
        <Route path="/main/bar" component={Bar} />
      </Switch>
    </div>
  </div>
);
```

### No Match

マッチしないルーティングに対してコンポーネントを当てられる

```typescript
export default function NoMatchExample() {
  return (
    <Router>
      <div>
        <ul>
          <li>
            <Link to="/">Home</Link>
          </li>
          <li>
            <Link to="/old-match">Old Match, to be redirected</Link>
          </li>
          <li>
            <Link to="/will-match">Will Match</Link>
          </li>
          <li>
            <Link to="/will-not-match">Will Not Match</Link>
          </li>
          <li>
            <Link to="/also/will/not/match">Also Will Not Match</Link>
          </li>
        </ul>

        <Switch>
          <Route exact path="/">
            <Home />
          </Route>
          <Route path="/old-match">
            <Redirect to="/will-match" />
          </Route>
          <Route path="/will-match">
            <WillMatch />
          </Route>
          <Route path="*">
            <NoMatch />
          </Route>
        </Switch>
      </div>
    </Router>
  );
}

function Home() {
  return <h3>Home</h3>;
}

function WillMatch() {
  return <h3>Matched!</h3>;
}

function NoMatch() {
  let location = useLocation();

  return (
    <div>
      <h3>
        No match for <code>{location.pathname}</code>
      </h3>
    </div>
  );
}
```

### Query parameter

- v4では`location.query`が使用できないので、location.searchをparseする必要がある

```typescript
import React from "react";
import {
  BrowserRouter as Router,
  Link,
  useLocation
} from "react-router-dom";

export default function QueryParamsExample() {
  return (
    <Router>
      <QueryParamsDemo />
    </Router>
  );
}

// useLocation().search
function useQuery() {
  return new URLSearchParams(useLocation().search);
}

function QueryParamsDemo() {
  let query = useQuery();

  return (
    <div>
      <div>
        <h2>Accounts</h2>
        <ul>
          <li>
            <Link to="/account?name=netflix">Netflix</Link>
          </li>
          <li>
            <Link to="/account?name=zillow-group">Zillow Group</Link>
          </li>
          <li>
            <Link to="/account?name=yahoo">Yahoo</Link>
          </li>
          <li>
            <Link to="/account?name=modus-create">Modus Create</Link>
          </li>
        </ul>

        <Child name={query.get("name")} />
      </div>
    </div>
  );
}

function Child({ name }) {
  return (
    <div>
      {name ? (
        <h3>
          The <code>name</code> in the query string is &quot;{name}
          &quot;
        </h3>
      ) : (
        <h3>There is no name in the query string</h3>
      )}
    </div>
  );
}
```

+++ 
draft = true
date = 2021-02-24T15:30:12+08:00
title = "Most adequate guide to functional programming"
description = "Summary to mostly adequate guide to functional programming"
slug = ""
authors = []
tags = ["functional programming"]
categories = []
externalLink = ""
series = []
+++


# Summary for mostly adequate guide to functional programming

[mostly adequate guide to functional programming Github](https://github.com/MostlyAdequate/mostly-adequate-guide)


這篇文章是閱讀完 Professor Frisby's Mostly Adequate Guide to Functional Programming 這篇文章的心得重點整理

這篇文章主要是紀錄一些名詞以及基本定義.

所以內容並不會完全跟著原文的順序

內容大略分為 `Concept` / `Toolkits` / `Theory`

實際內容跟範例還是看原文比較好喔

---

## Concept

觀念跟專有名詞解析

---

### First class

* 當在該程式語言中 function 可以被視為變數 -> `First-class`
* Example: 在 javascript 中 function 可以當 input 傳遞給 function 或者作為回傳值傳遞回來

---

### immutable & mutable

* Function programming 的核心概念之一: 變數一定是 immutable
* No side-effects
* 更好追蹤變數
* 所有操作都是回傳新的 immutable data

---

### Pure function

> A pure function is a function that, given the same input, will always return the same output and does not have any observable side effect.


### Why Pure function ?

* Memoize function
    * 可以根據 input 快取

* Portable / Self Documenting
    * 對依賴透明誠實
    * Dependency Injection

* Testable
    * No mock

* Reasonable
    * 引用透明性 `Referential Transparency`: 當可以用 result 替代程式碼(完全不改動), 此段程式具有引用透明性
    * 方便 Equational reasoning(等式推導) 分析程式碼

* Parallel Code
    * 因為不需要 access shared memory. pure function 完全可以並行執行

---

### Pointfree

* Pointfree style means never having to say your data

```javascript
// 非 pointfree，因為我們提到資料：name
var initials = function(name) {
  return name.split(' ').map(compose(toUpperCase, head)).join('. ');
};

// pointfree
var initials = compose(join('. '), map(compose(toUpperCase, head)), split(' '));

initials("hunter stockton thompson");
// 'H. S. T'
```

---

### Declatative Coding

__宣告式開發__

> 告訴電腦做什麼而不是怎麼做

> 類似 SQL, 宣告要做什麼而不是一步步寫下去

```javascript
// 命令式
var authenticate = function(form) {
var user = toUser(form);
    return logIn(user);
};

// 宣告式
var authenticate = compose(logIn, toUser);
```

---

### Hindley-Milner Type System

__FP 描述方法__

[Wiki](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system)

```javascript
// setLength :: String -> Number
const strLength = s => s.length

// join :: String -> [String] -> String
const join = curry((what, xs) => xs.join(what));

// match :: Regex -> String -> [String]
const match = curry((reg, s) => s.match(reg));

// replace :: Regex -> String -> String -> String
const replace = curry((reg, sub, s) => s.replace(reg, sub));

// head :: [a] -> a
const head = xs => xs[0];

// filter :: (a -> Bool) -> [a] -> [a]
const filter = curry((f, xs) => xs.filter(f));

// reduce :: ((b, a) -> b) -> b -> [a] -> b
const reduce = curry((f, x, xs) => xs.reduce(f, x));
```

#### Constraints: 約束 interface

```javascript
// sort :: Ord a => [a] -> [a]
```

這樣的寫法表示 `a` 需要實作 `Ord` interface


#### Narrowing the possibility 縮小可能性

* [`Parametricity`](https://en.wikipedia.org/wiki/Parametricity)

```javascript
// head :: [a] -> a
```

因為沒有明確說明 a 的型態, a 可以是任何型態 => head 必需支援所有型態.

head 語意上表示第一個 => 足夠提示去猜測 head 用法

---

### The Mightly Container

什麼是 Container ?

```javascript
class Container {
    constructor(x) {
        this.$value = x;
    }
    static of(x) {
        return new Container(x);
    }
}
```

---

### Functor

> A Functor is a type that implement `map` and obeys some laws

> Functor is `Mapable`

> Also called `Identity`

```javascript
Container.protype.map = function (f) {
    return Container.of(f(this.value));
};
```

---

### Schrödinger’s Maybe

```javascript
class Maybe {
    static of(x) {
        return new Maybe(x);
    }

    get isNothing() {
        return this.$value === null || this.$value === undefined;
    }

    constructor (x) {
        this.$value = x;
    }

    map(fn) {
        return this.isNothing ? this : Maybe.of(fn(this.$value));
    }

    inspect() {
        return this.isNothing ? 'Nothing' : `Just(${inspect(this.$value)})`;
    }
}
```

#### Usecase

* Maybe 會在每個步驟中檢查是否 `null`

```javascript
Maybe.of('Malkovich Malkovich').map(match(/a/ig));
// Just(True)

Maybe.of(null).map(match(/a/ig));
// Nothing

Maybe.of({ name: 'Boris' }).map(prop('age')).map(add(10));
// Nothing

Maybe.of({ name: 'Dinah', age: 14 }).map(prop('age')).map(add(10));
// Just(24)
```

* 透過 `Maybe` 在發生錯誤時 return nothing 則 `map` 並不會觸發後面的步驟

```javascript
// withdraw :: Number -> Account -> Maybe(Account)
const withdraw = curry((amount, { balance }) =>
  Maybe.of(balance >= amount ? { balance: balance - amount } : null));

// This function is hypothetical, not implemented here... nor anywhere else.
// updateLedger :: Account -> Account
const updateLedger = account => account;

// remainingBalance :: Account -> String
const remainingBalance = ({ balance }) => `Your balance is $${balance}`;

// finishTransaction :: Account -> String
const finishTransaction = compose(remainingBalance, updateLedger);


// getTwenty :: Account -> Maybe(String)
const getTwenty = compose(map(finishTransaction), withdraw(20));

getTwenty({ balance: 200.00 }); 
// Just('Your balance is $180')

getTwenty({ balance: 10.00 });
// Nothing
```

#### Releasing the value

__If a program has no observable effect, does it even run?__

* 透過檢查空值的 `carry` function: `maybe`, 最終我們完成了整個 flow. `getTwenty` 只會有兩種狀態 broke or balance

> 這邊 `maybe` 意義上等於 `if (x !== null) { return f(x) }`, 但我們在撰寫的時候是透過宣告的方式, 而不是 return 再檢查

```javascript
// maybe :: b -> (a -> b) -> Maybe a -> b
const maybe = curry((v, f, m) => {
  if (m.isNothing) {
    return v;
  }

  return f(m.$value);
});

// getTwenty :: Account -> String
const getTwenty = compose(maybe('You\'re broke!', finishTransaction), withdraw(20));

getTwenty({ balance: 200.00 }); 
// 'Your balance is $180.00'

getTwenty({ balance: 10.00 }); 
// 'You\'re broke!'
```

---

### Pure error handler

#### Either

```javascript
class Either {
  static of(x) {
    return new Right(x);
  }

  constructor(x) {
    this.$value = x;
  }
}

// `Left` -> 忽略 `map` 直接 return value
class Left extends Either {
  map(f) {
    return this;
  }

  inspect() {
    return `Left(${inspect(this.$value)})`;
  }
}

// `Right` -> `Container`
class Right extends Either {
  map(f) {
    return Either.of(f(this.$value));
  }

  inspect() {
    return `Right(${inspect(this.$value)})`;
  }
}

const left = x => new Left(x);
```

* 透過 `Either` 來做 Error handler, 如果錯誤會 return `Left`

* Example:

```javascript
const moment = require('moment');

// getAge :: Date -> User -> Either(String, Number)
const getAge = curry((now, user) => {
  const birthDate = moment(user.birthDate, 'YYYY-MM-DD');

  return birthDate.isValid()
    ? Either.of(now.diff(birthDate, 'years'))
    : left('Birth date could not be parsed');
});

getAge(moment(), { birthDate: '2005-12-12' });
// Right(9)

getAge(moment(), { birthDate: 'July 4, 2001' });
// Left('Birth date could not be parsed')


//
////
//

// fortune :: Number -> String
const fortune = compose(concat('If you survive, you will be '), toString, add(1));

// zoltar :: User -> Either(String, _)
const zoltar = compose(map(console.log), map(fortune), getAge(moment()));

zoltar({ birthDate: '2005-12-12' });
// 'If you survive, you will be 10'
// Right(undefined)

zoltar({ birthDate: 'balloons!' });
// Left('Birth date could not be parsed')
```

#### `either`

* 跟 `Maybe` 有 `maybe` 一樣. `Either` 也有 `either`

```javascript
// either :: (a -> c) -> (b -> c) -> Either a b -> c
const either = curry((f, g, e) => {
  let result;

  switch (e.constructor) {
    case Left:
      result = f(e.$value);
      break;

    case Right:
      result = g(e.$value);
      break;

    // No Default
  }

  return result;
});

// zoltar :: User -> _
const zoltar = compose(console.log, either(id, fortune), getAge(moment()));

zoltar({ birthDate: '2005-12-12' });
// 'If you survive, you will be 10'
// undefined

zoltar({ birthDate: 'balloons!' });
// 'Birth date could not be parsed'
// undefined
```

---

### IO Container


* `getFromStorage` 不是 pure function. 他的 return 會依賴於外部環境 -> 相同輸入不會有相同 return

```javascript
// getFromStorage :: String -> (_ -> String)
const getFromStorage = key => () => localStorage[key];
```

* 為了解決這個問題, 需要有一個 container `IO` 把他包起來
* `IO` 會把 impure action 延遲到後面才執行, 可以理解是 `[funcA, funcB, funcB, ...]` 被累積在 queue 中, 

```javascript
class IO {
  // IO(() => x) 這一段延遲了執行
  static of(x) {
    return new IO(() => x);
  }

  constructor(fn) {
    this.$value = fn;
  }

  map(fn) {
    return new IO(compose(fn, this.$value));
  }

  inspect() {
    return `IO(${inspect(this.$value)})`;
  }
}
```

```javascript
// 下面的顯示值都是未執行的, 方便閱讀. 實際上我們並不知道實際的值.

// ioWindow :: IO Window
const ioWindow = new IO(() => window);

ioWindow.map(win => win.innerWidth);
// IO(1430)

ioWindow
  .map(prop('location'))
  .map(prop('href'))
  .map(split('/'));
// IO(['http:', '', 'localhost:8000', 'blog', 'posts'])


// $ :: String -> IO [DOM]
const $ = selector => new IO(() => document.querySelectorAll(selector));

$('#myDiv').map(head).map(div => div.innerHTML);
// IO('I am some inner html')
```

* 在 `$value()` 被調用之前, 都是 pure function. 最後 call `$value()` 的調用者承擔了運行的責任

```javascript
// url :: IO String
const url = new IO(() => window.location.href);

// toPairs :: String -> [[String]]
const toPairs = compose(map(split('=')), split('&'));

// params :: String -> [[String]]
const params = compose(toPairs, last, split('?'));

// findParam :: String -> IO Maybe [String]
const findParam = key => map(compose(Maybe.of, find(compose(eq(key), head)), params), url);

// -- Impure calling code ----------------------------------------------

// run it by calling $value()!
findParam('searchTerm').$value();
// Just(['searchTerm', 'wafflehouse'])
```

---

### Asynchronous Tasks

* 範例是一個 get DB connection 的 Asynchronous Task
* FP 的寫法一樣適用於 Asynchronous control.

```javascript
// Postgres.connect :: Url -> IO DbConnection
// runQuery :: DbConnection -> ResultSet
// readFile :: String -> Task Error String

// -- Pure application -------------------------------------------------

// dbUrl :: Config -> Either Error Url
const dbUrl = ({ uname, pass, host, db }) => {
  if (uname && pass && host && db) {
    return Either.of(`db:pg://${uname}:${pass}@${host}5432/${db}`);
  }

  return left(Error('Invalid config!'));
};

// connectDb :: Config -> Either Error (IO DbConnection)
const connectDb = compose(map(Postgres.connect), dbUrl);

// getConfig :: Filename -> Task Error (Either Error (IO DbConnection))
const getConfig = compose(map(compose(connectDb, JSON.parse)), readFile);


// -- Impure calling code ----------------------------------------------

getConfig('db.json').fork(
  logErr('couldn\'t read file'),
  either(console.log, map(runQuery)),
);
```

---

### Point functor factory 

#### Pointed

> A pointed functor is a functor with an `of` method

`IO`, `Task` 的 constructors function(不知道中文翻譯, 姑且叫它構造函數) 期望 function as argument, 但 `Maybe`, `Either` 沒有.

`of` 的用途就很簡單明顯了. 為了方便讓我們把值放入 functor.

---

### Monadic Onions: Monad

[wiki](https://en.wikipedia.org/wiki/Monad_(functional_programming))


> 任何 functor 有定義 `join` && `of` method, 然後服從一些基本定義就是 `monad`.

> Monads 是可以攤平 (透過 `join`) 的 Pointed functor (有定義 `of`)

> Monada 的特性是 排序計算, 分配 variable, 停止進一步執行.

```javascript
Maybe.prototype.join = function join() {
  return this.isNothing() ? Maybe.of(null) : this.$value;
};

IO.prototype.join = () => this.unsafePerformIO();
```

```javascript
const mmo = Maybe.of(Maybe.of('nunchucks'));
// Maybe(Maybe('nunchucks'))

mmo.join();
// Maybe('nunchucks')

const ioio = IO.of(IO.of('pizza'));
// IO(IO('pizza'))

ioio.join();
// IO('pizza')

const ttt = Task.of(Task.of(Task.of('sewers')));
// Task(Task(Task('sewers')));

ttt.join();
// Task(Task('sewers'))
```

---

### Transform

跟一般程式語言的 `intToStr`, `strToInt` 相同.

我們也可以把 functor 轉換為另外一種 functor


```javascript
// idToMaybe :: Identity a -> Maybe a
const idToMaybe = x => Maybe.of(x.$value);

// idToIO :: Identity a -> IO a
const idToIO = x => IO.of(x.$value);

// eitherToTask :: Either a b -> Task a b
const eitherToTask = either(Task.rejected, Task.of);

// ioToTask :: IO a -> Task () a
const ioToTask = x => new Task((reject, resolve) => resolve(x.unsafePerform()));

// maybeToTask :: Maybe a -> Task () a
const maybeToTask = x => (x.isNothing ? Task.rejected() : Task.of(x.$value));

// arrayToMaybe :: [a] -> Maybe a
const arrayToMaybe = x => Maybe.of(x[0]);
```

根據 [Natural Transform](###https://Natural Transformation) 的定義. `doListyThings` == `doListyThings_`

```javascript
// arrayToList :: [a] -> List a
const arrayToList = List.of;

const doListyThings = compose(sortBy(h), filter(g), arrayToList, map(f));
const doListyThings_ = compose(sortBy(h), filter(g), map(f), arrayToList); // law applied
```

---

### Monoids

> Monoids are about combination.

> What is combination?
> > accumulation to concatenation to multiplication to choice, composition, ordering, evaluation.

#### Semigroup

> A Semigroup is a type with a concat method

```javascript
// A binary operation
1 + 1 = 2

// We can run this on any amount of numbers
1 + 7 + 5 + 4 + ...

// Associativity
(1 + 2) + 3 = 6
1 + (2 + 3)= 6

// Semigroup
const Sum = x => ({
  x,
  concat: other => Sum(x + other.x)
})

// Sum concat some other Sum always return a Sum
Sum(1).concat(Sum(3))  // Sum(4)
Sum(4).concat(Sum(37))  // Sum(41`)

// why is this useful?
// Well, as with any interface
// we can swap out our instance to achieve different results

const Product = x => ({ x, concat: other => Product(x * other.x) })

const Min = x => ({ x, concat: other => Min(x < other.x ? x : other.x) })

const Max = x => ({ x, concat: other => Max(x > other.x ? x : other.x) })
```

#### All my favourite functors are semigroups.

```javascript
Identity.prototype.concat = function(other) {
  return new Identity(this.__value.concat(other.__value))
}

Identity.of(Sum(4)).concat(Identity.of(Sum(1)))
// Identity(Sum(5))

// It is a semigroup if and only if its __value is a semigroup

Identity.of(4).concat(Identity.of(1))
// TypeError: this.__value.concat is not a function
```

借由這樣的特性, concat 可以幫助我們堆疊這些 segigroups 成 cascading(級聯) 組合

並且很清楚的被表示

> Anything made up entirely of semigroups, is itself, a semigroup.

```javascript
// Example 1:

// formValues :: Selector -> IO (Map String String)
// validate :: Map String String -> Either Error (Map String String)

formValues('#signup').map(validate).concat(formValues('#terms').map(validate))
// IO(Right(Map({username: 'andre3000', accepted: true})))
formValues('#signup').map(validate).concat(formValues('#terms').map(validate))
// IO(Left('one must accept our totalitarian agreement'))

serverA.get('/friends').concat(serverB.get('/friends'))
// Task([friend1, friend2])

// loadSetting :: String -> Task Error (Maybe (Map String Boolean))

loadSetting('email').concat(loadSetting('general'))
// Task(Maybe(Map({backgroundColor: true, autoSave: false})))
```

```javascript
// Example 2:

const Analytics = (clicks, path, idleTime) => ({
  clicks,
  path,
  idleTime,
  concat: other =>
    Analytics(clicks.concat(other.clicks), path.concat(other.path), idleTime.concat(other.idleTime))
})

Analytics(Sum(2), ['/home', '/about'], Right(Max(2000))).concat(Analytics(Sum(1), ['/contact'], Right(Max(1000))))
// Analytics(Sum(3), ['/home', '/about', '/contact'], Right(Max(2000)))
```

```javascript
// Case where we ignore what's inside and combine the containers themselves.
// Consider a type like Stream.

const submitStream = Stream.fromEvent('click', $('#submit'))
const enterStream = filter(x => x.key === 'Enter', Stream.fromEvent('keydown', $('#myForm')))

submitStream.concat(enterStream).map(submitForm) // Stream()
```

#### Zero acts

> Zero acts as identity meaning any element added to 0, will return that very same element.

> a.k.a neutral/empty element

> 實際用途上它們是扮演 default 值的角色

```javascript
// identity
1 + 0 = 1
0 + 1 = 1

Array.empty = () => []
String.empty = () => ""
Sum.empty = () => Sum(0)
Product.empty = () => Product(1)
Min.empty = () => Min(Infinity)
Max.empty = () => Max(-Infinity)
All.empty = () => All(true)
Any.empty = () => Any(false)

const settings = (prefix="", overrides=[], total=0) => ...
const settings = (prefix=String.empty(), overrides=Array.empty(), total=Sum.empty()) => ...
```

#### Folding down the house

如果對 empty array 使用 concat 會導致 TypeError. 但如果搭配 Zero Acts, 就像下面的 `fold` function 一樣會帶來意想不到的效果

```javascript
// concat :: Semigroup s => s -> s -> s
const concat = x => y => x.concat(y)

[Sum(1), Sum(2)].reduce(concat) // Sum(3)

[].reduce(concat) // TypeError: Reduce of empty array with no initial value

// fold :: Monoid m => m -> [m] -> m
const fold = reduce(concat)

fold(Sum.empty(), [Sum(1), Sum(2)])
// Sum(3)
fold(Sum.empty(), [])
// Sum(0)

fold(Any.empty(), [Any(false), Any(true)])
// Any(true)
fold(Any.empty(), [])
// Any(false)


fold(Either.of(Max.empty()), [Right(Max(3)), Right(Max(21)), Right(Max(11))])
// Right(Max(21))
fold(Either.of(Max.empty()), [Right(Max(3)), Left('error retrieving value'), Right(Max(11))])
// Left('error retrieving value')

fold(IO.of([]), ['.link', 'a'].map($))
// IO([<a>, <button class="link"/>, <a>])
```

#### Not quite a monoid

有些 semigroups 不是 monoids. 無法提供初始 empty value. Like `First`

```javascript
const First = x => ({ x, concat: other => First(x) })

Map({id: First(123), isPaid: Any(true), points: Sum(13)}).concat(Map({id: First(2242), isPaid: Any(false), points: Sum(1)}))
// Map({id: First(123), isPaid: Any(true), points: Sum(14)})
```

#### Grand unifying theory

##### Composition as a monoid

Functions of type `a -> a`,
where the domain is in the same set as the codemain, are called `endomorphisms`.
我們可以實作 `Endo` function 去達成

```javascript
const Endo = run => ({
  run,
  concat: other =>
    Endo(compose(run, other.run))
})

Endo.empty = () => Endo(identity)


// in action

// thingDownFlipAndReverse :: Endo [String] -> [String]
const thingDownFlipAndReverse = fold(Endo(() => []), [Endo(reverse), Endo(sort), Endo(append('thing down')])

thingDownFlipAndReverse.run(['let me work it', 'is it worth it?'])
// ['thing down', 'let me work it', 'is it worth it?']
```

##### Monad as a monoid

這個範例有些複雜, 建議 Google

https://medium.com/@michelestieven/a-monad-is-just-a-monoid-a02bd2524f66

##### Applicative as a monoid

```javascript
// concat :: f a -> f b -> f [a, b]
// empty :: () -> f ()

// ap :: Functor f => f (a -> b) -> f a -> f b
const ap = compose(map(([f, x]) => f(x)), concat)
```

---

## Toolkits

---

### Carry function

```javascript
var add = function(x) {
    return function(y) {
        return x + y
    }
}
```

* 你可以一次性呼叫 curry function, 也可以每次只傳遞一部份參數
* 每傳遞一個參數就回傳一個 function 處理剩下的參數
* pre-load

---

### Compose function

```javascript
var compose = function(f, g) {
  return function(x) {
      return f(g(x));
  };
};
```

* `g` 先執行, 再執行 `f`, `compose` 在 `g`, `f` 中建立了由右而左的資料流

* `Associativity` 結合律, 無論怎麼組合結果都是相同的

```javascript
var associative = compose(f, compose(g, h)) == compose(compose(f, g), h);
```

---

### Chain pattern

__Also called flatMap or `>>= (bind)`. Call join after map__

```javascript
// Chain :: Monad m => (a -> m b) -> ma -> m b
const chain = curry((f, m) => m.map(f).join());

// or

// Chain :: Monad m => (a -> m b) -> m a -> m b
const chain = f => compose(join, map(f))
```

這邊是用 `chain` 重構 `map + join` 的例子

```javascript
// map/join
const firstAddressStreet = compose(
  join,
  map(safeProp('street')),
  join,
  map(safeHead),
  safeProp('addresses'),
);

// chain
const firstAddressStreet = compose(
  chain(safeProp('street')),
  chain(safeHead),
  safeProp('addresses'),
);

// map/join
const applyPreferences = compose(
  join,
  map(setStyle('#main')),
  join,
  map(log),
  map(JSON.parse),
  getItem,
);

// chain
const applyPreferences = compose(
  chain(setStyle('#main')),
  chain(log),
  map(JSON.parse),
  getItem,
);
```

---

### Applicative Functors

> __An applicative functor is a pointed functor with an `ap` method

#### `ap` function

```javascript
// 基本定義
Container.prototype.ap = function (otherContainer) {
  return otherContainer.map(this.$value);
};
```

> `map` `f` is equivalent to `ap` a functor of f.

> We can place `x` into our container and `map(f)` OR we can lift both `f` & `x` into our constainer and `ap` them.

> of/ap is equivalent to `map`

```javascript
F.of(x).map(f) === F.of(f).ap(F.of(x));
```


```javascript
// 簡單範例

Maybe.of(add).ap(Maybe.of(2)).ap(Maybe.of(3));
// Maybe(5)

Task.of(add).ap(Task.of(2)).ap(Task.of(3));
// Task(5)
```

```javascript

// Http.get :: String -> Task Error HTML

const renderPage = curry((destinations, events) => { /* render page */ });

Task.of(renderPage).ap(Http.get('/destinations')).ap(Http.get('/events'));
// Task("<div>some page with dest and events</div>")

// Http calls 會一起發動, 然後 render page 因為是 curry function 所以並不會等兩個都完成才 render.
```

> `ap` function 的一項好處是可以 concurrently 執行

> `ap` will never change container types on us

#### Laws of ap function

```javascript
// Identity 
A.of(id).ap(v) === v;

// Identity example.
const v = Identity.of('Pillow Pets');
Identity.of(id).ap(v) === v;

// Homomorhpism
A.of(f).ap(A.of(x)) === A.of(f(x));

// Homomorhpism example.
Either.of(toUpperCase).ap(Either.of('oreos')) === Either.of(toUpperCase('oreos'));

// Interchange: doesn't matter if we choose to lift our function into left or right side of `ap`
v.ap(A.of(x)) == A.of(f => f(x)).ap(v);

// Composition: A way to check that our standard function composition holds when applying inside of containers.
A.of(compose).ap(u).ap(v).ap(w) === u.ap(v.ap(w));
```

### Traversable interface

> Traversable is a powerful interface that gives us the ability to rearrange our types with the ease of a telekinetic interior decorator. We can achieve different effects with different orders as well as iron out those nasty type wrinkles that keep us from joining them down

Traversable 有兩個重要的 function `sequence`, `traverse`

```javascript
// sequence :: (Traversable t, Applicative f) => (a -> f a) -> t (f a) -> f (t a)
const sequence = curry((of, x) => x.sequence(of));

// traverse
traverse(of, fn) {
  return this.$value.reduce(
    (f, a) => fn(a).map(b => bs => bs.concat(b)).ap(f),
    of(new List([])),
  );
}
```

```javascript
// Example 1

// readFile :: FileName -> Task Error String

// firstWords :: String -> String
const firstWords = compose(intercalate(' '), take(3), split(' '));

// tldr :: FileName -> Task Error String
const tldr = compose(map(firstWords), readFile);

map(tldr, ['file1', 'file2']);
// [Task('hail the monarchy'), Task('smash the patriarchy')]

// 這邊的 result 是 List of Tasks. 但更好的話會希望是 list of results


traverse(Task.of, tldr, ['file1', 'file2']);
// Task(['hail the monarchy', 'smash the patriarchy']);
// After refactor
```

```javascript
// Example 2
// getAttribute :: String -> Node -> Maybe String
// $ :: Selector -> IO Node

// getControlNode :: Selector -> IO (Maybe (IO Node))
const getControlNode = compose(map(map($)), map(getAttribute('aria-controls')), $);

const getControlNode = compose(chain(traverse(IO.of, $)), map(getAttribute('aria-controls')), $);
// After refactor
```

#### Natural Consequence

```javascript
traverse(A.of, A.of) === A.of;
```

---

## Theory

### Free in Theorem

```javascript
// head :: [a] -> a
compose(f, head) === compose(head, map(f));

// filter :: (a -> Bool) -> [a] -> [a]
compose(map(f), filter(compose(p, f))) === compose(filter(p), map(f));
```

head 跟 filter 這兩個 example 的結果是一樣的. 當然效能上有差, 但結果來說沒有問題

---

### Natural Transformation 

![](/img/mostly-adequate-guide-to-fp/natural_transformation.png)


__待補__

## Source

https://www.youtube.com/watch?v=Nrp_LZ-XGsY&ab_channel=NDCConferences
https://www.cs.ox.ac.uk/jeremy.gibbons/publications/iterator.pdf

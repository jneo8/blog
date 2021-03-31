+++ 
date = 2021-03-30T22:11:18+08:00
title = "Summary of The Functional Programmer's Toolkit"
description = "Some notes for The Functional Programmer's Toolkit talk from Scott Wlaschin"
slug = ""
authors = []
tags = ["functional programming"]
categories = ["notes"]
externalLink = ""
series = []
+++

Summary for https://www.youtube.com/watch?v=Nrp_LZ-XGsY&ab_channel=NDCConferences

## The Functional Toolbox

__The functional toolbox is for solved problems__

### Functional Toolbox FP jargon version

* Composition/Aggregation: `Monoid`
* Working with effects
    * Mixing effects and non-effects: `Functor`
    * Chaining effects in series: `Monad`
    * Working with effects in parallel: `Applicative`


> Most of the tools in the functional toolbox are *function transformers* that convert functions to functions

## Core principles of (statically-typed) FP

### Functions are things

* A functional is a standalone thing, not attached to a class

### Composition everywhere (就像樂高)

1. All pieces are designed to connect

2. Connect two pices together and get another "piece" that can still be connected

3. The pieces are reusable in many contexts
    * They are self contained. No strings attached (literally)

## Functional Programming Philosophy

* Design functions that do one thing well
    - Functions can be reused in different contexts.

* Design functions to work together 
    - Expect the output of every function to become the input to another, as yet unknown, function

* Use types to ensure that input match outputs

---

## Function Composition: Monoid

__You start with a bunch of things, and some way of combining them two at a time.__

### Rules

1. Closure:

$$1 + 2 = 3$$

> The result of combining two things is always another one of the things.

2. Associativity

$$1 + (2 + 3) = (1 +2) + 3$$

> When combining more than two things, which pairwise combination you do first doesn't matter.

3. Identity element

$$1 + 0 = 1$$
$$0 + 1 = 1$$
> 0 is a special kind of thing that when you combine it with something, just give you back the original something.

> There is a special thing called `zero` such that when you combine any thing with `zero` you get the original thing back.

### Cons

#### Benefit of Closure:
> Converts pairwise operations into operations that work on lists.

```
1 + 2 + 3 + 4

[1;2;3;4] |>  List.reduce(+)
```

#### Benefit of Associativity:
> Divide and conquer, parallelization, and incremental accumulation.

* Parallelization:

$$1 + 2 + 3 + 4 = (1 + 2) + (3 + 4)$$

`(1 +2)` && `(3 + 4)` can process in parallelization.

* Incremental accumulation: 

First time:

$$1 + 2 + 3 = 6$$

Now say we need `4`:

$$(1 + 2 + 3) + 4 = (6) + 4$$

Just take the result `6` from the first time and continue.

#### Benefit of Identity element
> Initial vlaue for empty or missing data

If zeror if missing, it is called a semigroup


### Tips

* Simple agg with Monoid
* Map/Reduce is about Monid.
    - Map: Turn Not a monoid to a monid
    - Reduce: Combining monid together.
* [Hadoop make me a sandwich](https://twitter.com/kestelyn/status/532668488109002752?s=20)

### Monid is everywhere

* Alternative metrics guideline: Make sure your metrics are monoids
    - incremental updates
    - can handle missing data

* Many design patterns are monoids
    - Composite Pattern
    - Null Object Pattern
    - Composable commands
    - Closure of operations(DDD)

### Summary

* A set of values and a combining function:
> combine ( aka concat, plus, <>, <+> )

* Closed and associative and has a zero value

* Uses:
    - Reduce a list of values to a single value
    - Do parallel calculations
    - Do incremental calculations

---

## What is an effect?

* A generic type
* A type enhanced with extra data
* A type that can change the outside world
* A type that carries state

### Problem How to do stuff in an effects world?

> Wrong way

![](/img/fp/how_to_do_stuff_in_an_effects_world_wrong.png)

> Keep stay in option world. Only come back at the end if have to.

> How ? -> Moving functions between worlds with `map`

![](/img/fp/how_to_do_stuff_in_an_effects_world.png)

---

## Moving functions between worlds with `map`

```c
// Wrong example 1

let add42 x = x + 42

add42 1 // 43
add42(Some 1) // error.  Only works on non-option values.
```

```c
// Wrong example 2

let add42ToOption opt = 
    if opt.IsSome then  // Unwrap
        let newVal = add42 opt.Value  // Apply
        Some newVal // Wrap again
    else
        None
```

![](/img/fp/how_to_do_stuff_in_an_effects_world_map.png)

```c
// A function in normal world
let add42 x = ...

// A function in Option world
let add42ToOption = Option.map add42
add42ToOption( Some 1)  // Some 43

// Normally just use inline
(Option.map add42) (Some 1)
```

### Guideline

* Most wrapped generic types have a `map`. Use it!
* If you create your own generic type, create a `map` for it.

---

## FP terminology: Functor

A `Functor` is

* An effect type
* Plus a `map` function that `lifts(a.k.a select, lift)` a function to the effects world
* And it must have a sensible implementation
    - the Functor laws

---

## Moving functions between worlds with `return`

![](/img/fp/how_to_do_stuff_in_an_effects_world_return.png)

```c
// A value in normal world
let x = 42

// A value in List world
let intList = [x]
```

---

## Chaining world-crossing functions with `bind`

### What's a world crossing function?

```c
let range max = [1...max]

// int -> List<int>
```

### Problem: How do you chain world crossing function together?

```c
// Wrong example
// The pyramid of doom

// Nested checks here
let example input = 
    let x = doSomething input // A world-crossing function
    if x.IsSome then
    let y = doSomethingElse (x.Value)
        if y.IsSome then
            let z = doAThirdThing(y.Value)
            if z.IsSome then
                let result = z.Value
                Some result
            else
                None
        else
            None
    else
        None
```

```c
// There is a pattern we can exploit
if opt.IsSome then
    // do something with opt.value
else
    None
```

```c
// Some helpful func
let ifSomeDo f opt = 
    if opt.IsSome then
        f.opt.Value
    else
        None

// Then refactor like this...
let example input = 
    doSomething input
    |> ifSomeDo doSomethingElse
    |> ifSomeDo doAThirdThing
    |> ifSomeDo ...
```

### Let's use a railway analogy

![](/img/fp/railway_analogy_1.png)
![](/img/fp/railway_analogy_2.png)
![](/img/fp/railway_analogy_3.png)
![](/img/fp/railway_analogy_4.png)
![](/img/fp/railway_analogy_5.png)
![](/img/fp/railway_analogy_6.png)

### Problem: How to combine the mismatch functions?

> `Bind` is the answer! Bind all the things!

```c
// Pattern: Use bind to chain options

let bind nextFunction optionInput = 
    match optionInput with
    | Some s -> nextFunction s
    | None -> None
```

```c
// Some after using bind

// f is same as "ifSomeDo"
let bind f opt = 
    match opt with
    | Some v -> f v
    | None -> None

let example input = 
    doSomething input
    |> bind doSomethingElse
    |> bind doAThirdThing
    |> bind ...
```

### Pattern: Use bind to chain tasks

![](/img/fp/use_bind_to_chain_tasks.png)

### Problem: How to handle errors elegantly ?

> Use a Result type for error handling

> function return Error as result if failure.

![](/img/fp/error_handling.png)

### Why is bind so important?

> It makes world-crossing functions composable

![](/img/fp/bind.png)

---

## FP terminology: Monad

A `monad` is

* An effect type
* Plus a return function
* Plus a bind function that converts a "diagonal"(world-crossing) function into "horizontal"(Effects-world-only) function
    - a.k.a `>>=`, `flatMap`, `SelectMany`
* And bind/return must have sensible implementations
    - the Monad laws

### TLDR

> If you want to chain effects-generating functions in series, use a Monad


---

## Combining effects in parallel with applicatives

> The general term for this is `applicative functor`

> Option, List, Async are all applicatives

### Problem: How to validate multiple fields in parallel?

![](/img/fp/run_in_parallel.png)
![](/img/fp/result_world.png)

---

## FP terminology: applicative(functor)

* A effect type
    - e.g. `Option<>`, `List<>`, `Async<>`

* Plus return function
    - a.k.a pure unit

* Plus a function that combines two effects into one
    - a.k.a. <*> apply pair

* And apply/return must have sensible implementations
    - the applicative functor laws

---

## Toolkits Summery

* Combine

Combines two values to make another one of the same kind

* Reduce

Reduces a list to a single value by using 'combine' repeatedly

* Map

Lifts functions into an effects world

* Return

Lifts values into an effects world

* Bind

Converts 'diagonal' functions into 'horizontal' ones so they can be composed

* Apply

Combines two effects in parallel

`map2`, `left2`, `left3` are specialized versions of `apply`

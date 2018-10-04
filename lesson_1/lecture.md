# Lesson 1 Lecture

## Motivation

Software Engineer is hard.
Sure, making a Rails site is easy.
Making a basic React frontend is easy.
Making a few database queries is easy.

But Software Engineering is hard.
There's a bunch of edge cases you have to test.
You're working with other people and you need to communicate with them.
Eventually, somebody is going to want your program to use multiple threads.
Eventually, somebody is going to want you to write a really *big* program, and you're going to want to have nice, composable abstractions.

Haskell can help you with these things.
Haskell does so by making you write code in a very, very weird way.
This is going to be a little bit difficult.
I tried to learn Haskell several times, and I only succeded on the last.
This "course" will (hopefully) be taught in such a way to make it easier.

## Functions and Information

Let's talk about functions.
Here's a function:

```c++
int gcd(int a, int b);
```

This function is pretty obvious.
It returns the GCD.
Let's look at another function:

```java
class House {
  public House applyPanting(Color color, GlossType gloss);
}
```

Okay, this is also fairly okay, but I have some questions.

1. Does this function modify the current `House` and return `this`, or does it make a new house with the modifications?
2. Can this return null?
3. Is this function going to write out a log line somewhere?
4. Is this function going to write to or read from any `static` variables, in `House` or otherwise?
5. Can this handle null arguments?

Here is the Haskell version of this function:

```haskell
applyColor :: House -> Color -> Gloss -> House
```

You can read this as "applyColor is a function taking a `House`, a `Color`, and a `Gloss`, and returning a `House`."
We will see later that this is *not* the best way to read it, but for now it's close enough.

In Haskell, a function like this has the following properties:

1. You can't mutate any of the arguments in any way.
2. You can't return the Haskell equivalent of `null`
3. You cannot write out a log line, or do *any kind of IO*
4. You cannot modify *any global variables in any way*
5. You *cannot pass the Haskell equivalent of `null` for any of the arguments*.

These are *very* good things to know about this function.

## Our first functions

Run the command `ghci`.
This is "Glasgow Haskell Compiler Interactive," which is a REPL for Haskell.
REPL stands for *R*ead *E*val *P*rint *L*oop.
It reads in a line of Haskell code, evaluates it, prints the result, and then loops again.
It is highly useful for messing around in the language.

Let's use some functions:

```haskell
> 1 + 2
-- 3
```

Here, we use the `+` function.
It has type:

```haskell
(+) :: Int -> Int -> Int
```

In Haskell, to define, type, or inspect operators, we surround them with parentheses.
Let's try something else:

```ghci
> "hack" ++ "fraud"
-- "hackfraud"
```

Here we use the `++` function.
It has type:

```haskell
(++) :: String -> String -> String
```

GHCI can tell us the types of things.
Let's try that now!

```ghci
> :t (+)
-- (+) :: (Num a) => a -> a -> a
```

Oh dear.
I've lied to you.
But, I promise I had a very good reason for it!
You see, Haskell is very *polymorphc*.
That means that it lets you write functions that work for as many types as possible.
In this case, the `(+)` function is defined to work on *all numbers*.
That's what the `(Num a)` means&mdash;this function is a function over *numbers*.
More specifically, `Num` is a `type class`.
The `class` here doesn't mean a `class` like in an object-oriented language, but rather a `class` as in a `classification`.
`(+)` can thus be said to work for *all types classified as Numbers*.
We'll talk about this in *much* more depth later.
But, for now, let's move onto something else.

## Lists

Well, hey, just adding numbers is boring.
Let's try to use another, more fundamental datatype: a *List*.
You know about Lists.
You might have used the `ArrayList` class, or written a Linked List.
Either way, we know that a `List` works like this:

1. We have zero or more elements
2. The elements are in some order

That's basically it.
In Haskell, we write a list like this:

```haskell
list = [1, 2, 3, 4, 5]
```

This is quite simple.
Let's try some things out.

### Exploring lists

Load up GHCI again.
First off, type this:

```haskell
list = [1, 2, 3, 4, 5]
```

This will let us work with one common list for all our functions.
First up, we have the `head` function:

```ghci
> head list
-- 1
```

`head` returns the first element of the given list.
But, wait a minute.
What's the type of `head`?
Well, let's check it:

```ghci
> :t head
-- head :: [a] -> a
```

In Haskell, *all* types start with a capital letter.
So, what's that lowercase `a` doing there?
Well, that `a` is a *type variable*.
You can think of it as being kind of akin to a template parameter.
It means that we can put in any type, and it'll work.
For example, when we write `head list`, we are using the `head` function that has a type of:

```haskell
head :: [Int] -> Int
```

We could also do:

```haskell
head [True, True, False]
```

In this case, `head` has the type:

```haskell
head :: [Bool] -> Bool
```

This is quite useful!
It means that we can write functions that work on a list, *without knowing what's in the list*.

Let's try some more functions:

```ghci
> tail list
-- [2, 3, 4, 5]
```

`tail` returns everything that isn't the `head`.
It's pretty simple.
There's quite a number of functions that work with lists, but it'd be boring to explore them all.
Instead, let's go and write a function of our own.

### Mapping

Let's say I need to add two to some numbers.
The reasons why are unimportant, but I know I need to add two to so *many* numbers that I want a function to do just that.
How can I do that?

Let's write the definition first, then see how it works later.

```haskell
addTwo x = x + 2
```

Okay, wow.
This is radically different from how this function would work in other languages.
Let's think of all the ways how:

1. I didn't write a type signature
2. I never wrote brackets
3. I never wrote the word "return"
4. I defined it with an equals sign

There may be more, but these stand out to me.
Let's go over the reasons for them one by one.

### No type signature

The reason for this is easy: Haskell can *infer* the signature of a function.
This means that Haskell can look at the definition and know what type it is.
Now, there are a few restrictions on that, but almost all of them are fairly easily eliminated.
The result: you very rarely have to write a type in Haskell, even if sometimes you might want to for readability purposes.

### Everything else

The other weird things are actually all lumped together.
You see, in other languages, you specify *how* to do something.
You write out a list of steps, then `return` the result.
Here, look at the `addTo` function in `c++`

```c++
int addTwo(int a, int b) {
  int c = a + b;
  return c;
}

// or

int addTwo2(int a, int b) { return a + b; }
```

The word `return` is quite literal here: it's the value that you're going to `return` to your caller!
This is fine, of course, but Haskell works differently.
In Haskell, you write an *equation* as opposed to a definition.

Here's how we'd define our `addTwo` function using mathematical language:

```math
addTwo(x) = x + 2
```

The Haskell definition is *near-identical* because it's doing the same thing.
You're writing what the function *is* as opposed to what it *does*.
This is a very useful way of thinking about things, as it turns out.
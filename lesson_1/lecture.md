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
But, for now, let's get to writing functions of our own.

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

### Exercises

1. Write a function that doubles any input number.
2. Write a function that triples any input number.

## Guard Syntax
Let's say we want to use a conditional expression in Haskell.
More specifically, let's define a function `isOne :: Int -> Bool`, which will tell us if a given number is one.
How might we define that?

```haskell
isOne x
  | x == 1 = True
  | Otherwise = False
```

## Pattern Matching

Let's say that we want to write a function `isOne :: Int -> Bool`.
This will tell us if a given input is equal to one.
Here's one way to write it:

```haskell
isOne x = x == 1
```

This is a perfectly fine way of writing the `isOne` function.
But there's another way!
In Haskell, we're allowed to use *pattern matching*.
This means that we can write out one or more "patterns" for a function, and the compiler will smartly pick among them.
Perhaps an example is in order:

```haskell
isOne 1 = True
```

This function will return "True" when passed "1" as an argument!
Now, we have a problem, of course.
What if we pass anything else?

Well, we could do this:

```haskell
isOne 1 = True
isOne 2 = False
isOne 3 = False
isOne 4 = False
--- Continue forever
```

But we'll be sitting and typing for a *long* time.
Instead, we can tell the compiler that we "don't care" about the arugment.
Like so:

```haskell
isOne 1 = True
isOne _ = False
```

Fairly simple, yes?

### More complex patterns

Let's write another function, `eitherIsOne :: Int -> Int -> Bool`
This will take two arguments and return `True` if *either* is `1`.
We could write it like this:

```haskell
eitherIsOne a b = a == 1 || b == 1
```

However, it's also possible to write the function like this:

```haskell
eitherIsOne 1 _ = True
eitherIsOne _ 1 = True
eitherIsone _ _ = False
```

Haskell doesn't require that you pattern match on only constants or ignored arguments.
You can also replace any argument with a variable, and use it normally.
Here's an example:

```haskell
interesting :: Int -> Int -> Int
interesting a 0 = a
interesting a b = a * b
```

Note that Haskell pattern-matches *in order*.
Look at this function:

```haskell
interesting :: Int -> Int -> Int
interesting a b = a * b
interesting a 0 = a
```

It will always return `a * b`.

Pattern matching is a very interesting way to write functions, but it's kind of hard to use at first.
In simple examples it may seem strictly worse than writing without pattern matching.
Pattern matching in conjunction with Algebraic Data Types, however, is utterly sublime.
It makes expressing certain things much, much easier than what would be possible in other languages.

## ADTs

Let's say that I'm writing a program to determine the subjective qualities of numbers.
More specifically, let's say that I *love* numbers that are even and multiples of five, *like* numbers that are even or multiples of five, and *dislike* all other numbers.
How can we express that?
Well, we could have a series of functions:

```haskell
loveNumber :: Int -> Bool
likeNumber :: Int -> Bool
dislikeNumber :: Int -> Bool
```

However, this isn't as expressive as it could be.
For one, I *like* all numbers that I *love*.
If we get in a situation where we want to do separate things with liked and loved numbers, we need to remember to check for love first.
This can get burdensome on us.

In this case, most would reach for an *enum* instead.
We could define some enum called `NumberFeeling`, with cases of `Love`, `Like`, and `Dislike`.
In Haskell, however, we don't define `Enum`s as separate types of data.
Instead, we define them as *Algebriac Data Types*, like most non-function things in Haskell.
More specifically, our definition looks like this:

```haskell
data NumberFeeling = Love | Like | Dislike
```

Now, before we get into how this works, let's have a few examples of how to use this new data type.
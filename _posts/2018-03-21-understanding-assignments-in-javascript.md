---
layout: post
comments: true
title: "Understanding variable assignment in JavaScript"
author: Fotis
---

### Hello `var`, old friend
In days of yore, using `var` was the only way to declare a variable. Those were interesting times, when developers dealt with hoisting all the time, leading to hair-pulling bugs and unexpected behavior. To better understand what hoisting is, think of the following example:

```javascript
a = 5;
var a;

console.log(a);
```
This would actually print `5` instead of `undefined`, since the compiler *hoist* the variable declaration within the associated scope and translate the snippet above into
```javascript
var a;
....
a = 5;
console.log(a)
```
Same principle applies to functions so the following snippet
```javascript
foo();

function foo() {
  // magic here
}
```
where the function declaration will get hoisted within the scope but please note this isn't the case of function expressions, which means that the following example
```javascript
foo();

var foo = function () {};
```
would throw a `TypeError` such as `Uncaught TypeError: foo is not a function`

### ES2015: `let` and `const` are introduced

Fast forward a few years, the `let` and `const` keywords got introduced which, along with `var`, are more ways to bind declarations to their associated scope. By using `let` we're able to declare bindings that can be reassigned, such as
```javascript
let a = 5;
...
a = i + b + n;
```
and so on. This isn't the case with `const` though, since creates bindings that can only be assigned once, meaning that a block like the following
```javascript
const a = 5;
a = 12;
```
would throw a `TypeError` such as `Uncaught TypeError: Assignment to constant variable` and so would assignment operators do like `a += 10`, `a++` or even bitwise operators like `a <<= 1`.

Now, a common misconception that people make (myself included in the past), is that `const` creates immutable variables which is not the case. `const` variables are perfectly mutable as shown in the following (working) example:
```javascript
const obj = { a: 1, b: 2 };
obj.c = 3;
console.log(obj);

// Prints  {a: 1, b: 2, c: 3}
```

In order to actually make an object immutable, one should use the [`Object.freeze()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze) method which on strict mode would raise an error, or fail silently otherwise. Please note though, this only performs a shallow freeze, which means we're still able to mutate the properties of the nested `obj.o` object as on the following (working) example:

```javascript
const obj = Object.freeze({
  a: 1,
  o: { name: "G.I. Joe", cobra: false },
});

obj.o.cobra = true;
console.log(obj);

// Prints { a: 1, o: { name: "G.I. Joe", cobra: true } }
```

To make matters a bit more complex, JavaScript provides the [`Object.seal()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/seal) method, which prevents new properties from being added to an object and marks all existing properties as non-configurable, but also [`Object.preventExtensions()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/preventExtensions) which only prevents new properties from ever being added to an object.

If we'd like to compare the three, we'd summarize as follows:

- [`Object.freeze()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze) makes an object's properties immutable, while nested objects' properties are still mutable. Example in non-strict mode:
  ```javascript
  const frozen = Object.freeze({ a: 1, b: 2 });
  frozen.a = 4;
  delete frozen.b; // returns false
  console.log(frozen);
  // Prints the object in its original shape  { a: 1, b: 2 }
  ```

- [`Object.seal()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/seal) allows properties to be changed, prevents them from being added or deleted. Example in non-strict mode:
  ```javascript
  const sealed = Object.seal({ a: 1, b: 2 });
  sealed.a = 5; // property "a" now has a new value
  sealed.c = 12;
  delete sealed.b; // returns false
  console.log(sealed);
  // Prints the object without the new properties added but with property "a" mutated  {a: 5, b: 2}
  ```

- [`Object.preventExtensions()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/preventExtensions) allows properties to be changed and deleted, prevents new properties from being added. Example in non-strict mode:
  ```javascript
  const prev = Object.preventExtensions({ a: 1, b: 2 });
  prev.a = 5;
  delete prev.b; // returns true
  console.log(prev);
  // Prints the object with a new value for property "a", without the deleted property "b"  {a: 5}
  ```

##### Credits
- "ES2015 const is not about immutability" by [Mathias Bynens](https://mathiasbynens.be/notes/es6-const)
- "Hoisting" on [You Dont Know JS](https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20%26%20closures/ch4.md#chapter-4-hoisting)
- "Block Scoping Revisited" on [You Dont Know JS](https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20%26%20closures/ch5.md#block-scoping-revisited)
- Object methods on [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object)

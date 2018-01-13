---
layout: post
comments: true
title: A couple of interview questions I always ask JavaScript candidates during technical interviews
author: Fotis
---
#### What is the main difference between `let` and `var`
**Answer**: The `let` statement declares a block scope **local** variable, optionally initializing it to a value while `var` declares a module scope (or global).

**Why I ask that**: Because it's a good and easy question that filters out non ES6-experienced developers

#### What is the main difference between arrow functions and functions
**Answer**: Say we have the following block:
```javascript
function hello() {
    this.foo    = 'bar';
    this.hello  = 'world';
    return this;
}
```
The keyword `this` now refers to the function body and if eg. the function is declared as a closure and we need to access the parent context, we need to assign `this` in the parent context to an intermediate variable, like this:
```javascript
function myParentFunc() {
  var self = this;
  function () {
    self.foo = 'bar';
    this.hello = 'world';
  }
}
```
Arrow functions maintain context and solve this problem as follows:
```javascript
class Hello {
  getFoo() {
    return this.foo || "Not set";
  }

  testFunction () {
    const f = () => {
        this.foo = "OK, It's now set";
    }
  }
}
```
**Why I ask that**: Arrow functions are a fundamental concept in modern JavaScript syntax, we need to make sure we use them right

#### What is your experience with task runners, Which one do you prefer and why?
**What do I look for**: Anything related to `gulp`, `grunt` or `webpack`. It's crucial that the candidate is aware and experienced in this area.
**Why I ask that**: Webpack is really tricky to set up properly so if they have some experience with webpack it's really good, it means that
pretty much they'd cover gulp & grunt as well

#### What is your experience with Angular Components? 
**What do I look for**: A description that would make me confident in terms of code organisation. eg. "We need 2 components to build that one would do A, the other would do B". It would be awesome if they mentioned the words **isolated scope** as well.

#### Assume you have two nested components, eg. component B inside Component A. What's an appropriate way to call a function from the child component (B) to the parent component (A) in angular 1.5?
**Answer** The answer here would be something like a function binding. For example:

```
class ControllerA {
    public childFunctionHook;
}

class ComponentA {
    ...
}
```

ChildFunctionHook is undefined at first

```
class ControllerB {
    public functionHook;
    
    public $onInit() {
        this.functionHook = () => {
            return "content from child component to parent";
        };
    }
}

class ComponentB {
    ....
    public bindings = {
        functionHook: "="
    };
}
```
Now that the binding is done, the instance of ControllerA has a function childFunctionHook defuned which returns the text `return "content from child component to parent";`

**Why I ask that**: Because if the candidate focuses on a hacky solution this probably means they're going to apply this solution to the codebase as well, whilst if they know the pattern, it's a lot cleaner.

#### Which one will log first? 
```
setTimeout( () => console.log("Hello"), 0 );
console.log("World");
```
**Answer**: The second over the first because `setTimeout` means that the callback gets enqueued. It's a fairly easy question if the candidate understands the basics of how JavaScript works.

More resources:
[https://www.toptal.com/javascript/interview-questions](https://www.toptal.com/javascript/interview-questions)

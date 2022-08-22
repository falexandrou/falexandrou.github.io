---
layout: post
title: "The three “E”s I’m looking for when reviewing code"
excerpt: ""
comments: true
author: Fotis
---
When reviewing code, either written by one of my colleagues or even the mine, I always try to find
three qualitative metrics that assure me I can approve the changes or merge this piece of code.
These metrics, ranked by how easy is it to spot them are:

### Efficiency
An efficient solution is a solution where the problem is solved 100%
<!-- Efficiency -->

### Elegance
For starters let me clarify that I'm talking about elegant solutions rather than elegant code itself.
An elegant solution is a piece of work that showcases that the contributor fully understands the problem they're trying to solve,
they followed the simplest approach available and they solved the problem in its entirety, allowing
the system to scale, without over-engineering it. It sounds and is tough so let's break it down

1. Full understanding of the problem: To judge if the contributor fully understands the problem they're solving,
the reviewer needs to fully understand the problem themselves and this has to be done prior to any code-reading.
I can't stretch enough the "prior to any code-reading" part, since reading the code might introduce some kind of bias towards the existing
piece of work, instead of something radically different. If possible, the reviewer should participate or review
design / architectural discussions, review the problem definition and acceptance criteria and outline
one or more solutions themselves.



Clean code is the subject of many books, blog posts, talks or workshops, yet large portions of our 
time, are consumed in cleaning up code we qualify as "legacy", "patch", "hack", "temporary solution", "work in progress"
or otherwise. Writing elegant code is not always feasible, as one has to deal with business requirements,
outdated libraries, deadlines, inexperienced contributors and sometimes an elegant solution could be more time-consuming.
Reviewing and appreciating elegant code on the other hand, is rewarding and satisfying and might work as a great example
for the next person.

Enforcing elegance as the reviewer is not an easy task. One has to have fully understand the scope
of the problem the code is trying to solve. To do so, we have to start early – ideally before any code is written: 

1. Study the problem, think about a solution before you start reading the code
2. If possible, participate in design / architecture discussions and ask questions
3. Whenever something seems complex ask for a simpler solution.

If the above is not feasible, the code review will be longer as you'll be trying to understand
what the nature of the problem is as you read through what is usually git patch diffs.

Elegance 

### Empathy
<!-- Elegance -->
<!-- Empathy -->


### Give praise to the contributor

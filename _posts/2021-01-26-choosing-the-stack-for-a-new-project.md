---
layout: post
comments: true
title: "Choosing the tech stack for a new project"
excerpt: "Things to consider when you are creating a fresh codebase from scratch"
author: Fotis
---

When it comes to creating a new stack, all options are on the table. Some people find it as a fine
opportunity to learn a new stack, others prefer stuff they're already familiar with, some others
prefer to distribute their codebase in microservices consisting of various micro-stacks. This process,
has triggered a lot of flame wars on Twitter and offices around the world but, believe it or not,
performance benchmarks and your peers opinions are not the only metrics you can take into account.

Selecting a technology stack is hard, and requires serious thought, so let's break down the major
things you need to consider before creating that git repository and we’ll do that by going through
my professional experience, mistakes and flame-wars I had been a part of, so that you don't have to.

<div class="image fit">
  <img src="/img/posts/tt.jpg" alt="Tech team" />
  <span>Photo by <a href="https://unsplash.com/@heylagostechie?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">heylagostechie</a> on <a href="https://unsplash.com/s/photos/tech-team?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span>
</div>

### The right tool for the people involved
Any tech stack will be as useful as the hours and hair it saves for the people developing on it and
operating it. Having said that, it's only obvious that your choice should be directly related to your
team, whether it's present or not. Two distinct cases here, first would be that the team is already
in place which means that the stack’s choice should be based on the team’s modus operandi and another
one, for when the team is work in progress.

When the team is already in place, the obvious choice would be to go with what they already know.
However, there's certain fatigue after some time, or the technology that the team is already working on
might start to feel outdated. That's when you need to get in touch with your team leaders and really
listen to them. Diversing your stack means that you’ll need to have people that are experts in the new
field and besides that, you’ll have to factor in the cost for their learning, the technical debt and operations.
There also has to be a critical mass that shares the same expertise, since you can’t rely on a single team member
to be the source of truth.

Regarding the second case now, you're on a clean slate. You have the freedom to choose anyone, however
I’d do some research first; I would research the developer communities for the stack choices I'd have
in mind, then look into their rates and activity and compare it with the prospect team size I'd have in mind.
It may sound trivia and you might think “oh! the internets will help me find candidates” but it may not
seem as easy as it sounds. Building a development team, is actually more on making highly skilled professionals
work well with each other so you might have to think twice about your team’s structure.


### The right tool for the job
The tech stack is a fun playground where projects come into life, however, projects are defined by
timeline, budget, project scope, integrations and scale, among others. Breaking them down into chunks,
will help us decide what the right tech stack for the job is:

**Tight deadline, limited budget or disposable projects**: Most of the times, the right tool for such
jobs is something that's “batteries included”, meaning that the suggested solution, should provide
all the necessary tooling out of the box or in a way that's saving considerable amounts manual labor
and time compared to another solution. For example, a rapid prototype for a product, a disposable
“proof of concept” app for a startup, can be made in such a way by using a framework, CMS or site-builder
that’s basically designed around solving this problem fast and efficiently.


**Highly performant projects**: For a project that is designed to receive thousands of requests per
second right from the beginning of its lifetime, you may need to bring back in those performance 
benchmarks we mentioned earlier. Beware, there's a trap here: if you ask the project’s shareholders
what the traffic projections for the project are going to be, they will most likely reply with massive
numbers and it's expected, since they're vested into the business and they aim for success. However,
experience shows that scaling issues will come up gradually and not from day one, allowing you to 
mitigate them which is cheaper than bullet-proofing your app to prevent them. I'm not implying you
should violate all rules and build something that's slow, all I'm saying is don’t over-engineer the
project and don’t build for massive scale before you wet your feet first.

**Projects that rely on existing integrations**: Usually, the integrations that need to take place,
are well established software that are either deeply integrated into the project (ie. the project is
built around a specific piece of software by using some adapter), or act as an external service, often
via an SDK that allows communication over networking. In the first case, the technology is sort of
dictated by the integration itself, for example if you want to build a library around Ansible, it
has to be done in Python because Ansible itself is written in Python and it would take a lot of effort
to use another language, so the decision is easy. In the second case, there are more options however,
you need to check whether there is an SDK available and whether it's a stable, fully-featured library.

**Open source or portfolio projects**: These types of projects provide plenty of room for experimentation,
and is actually the right place to show off and play around with various new technologies. I think
it's safe to say that other criteria (see below) will apply to these projects

<div class="image fit">
  <img src="/img/posts/tool.jpg" alt="Tools" />
  <span>Photo by <a href="https://unsplash.com/@hnhmarketing?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Hunter Haley</a> on <a href="https://unsplash.com/s/photos/tool-set?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span>
</div>

### Choose technology that is already familiar, documented, proven & stable
One mistake most of us have ran into, when it comes to using some new technology is that we fall into
the hype trap. The internet is a magical place full of potential, advertisements and hyped up new
technologies and we, developers like to experiment with all the shiny new objects!

While integrating a piece of technology into your stack, you might need to look into the maturity,
stability and documentation of it. It also has to be actively maintained and adequately documented.
A large following on StackOverflow wouldn't hurt either.

Speaking from experience, my team once integrated a fairly young document-based database into one
of our projects and I bet you know the favorite product owner line: “since this worked for this
feature, let’s build on top of that for the next 5 features”. Pretty soon, after torturing ourselves
with poor adoption which leads to poor documentation online compared to its older rivals,
this database became mission-critical but we were happy. Until one day they ran out of money
and time, and their contributors decided to jump ship, and then we were sad. We didn‘t have the time
or resources to maintain the database ourselves of course, so we had to migrate everything into our
existing PostgreSQL database which was introduced in 1996 and it’s still one of the most popular
open source relational database systems available. This is of course an edge case and doesn’t
happen every day, however I’ve seen frameworks, libraries and other utilities die frequently
so try to be cautious by making sure everything my team relies upon is current, actively maintained,
well documented, stable and most importantly, properly tested.

### If your team is small, a monolith is just fine
I think the title is self-explanatory here, but let me explain why in a screaming
[Adam Sandler](/img/posts/as.gif){:target="_blank"} voice: because of all the duplication and
networking requests and the operational maintenance your team has to go through. Which leads
me to the next chapter:

### Running & maintenance costs
There are two types of costs when working with a new technology stack: Implementation and running
cost. The first is pretty straight forward, the latter can be predicted, but what about hidden costs?
For example how much does it cost to replace a certain piece of the stack and how much technical dept
would it introduce?

<div class="image fit">
  <img src="/img/posts/sib.jpg" alt="Simple is beautiful”" />
  <span>Photo by <a href="https://unsplash.com/@jeffreymwegrzyn?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Jeffrey Wegrzyn</a> on <a href="https://unsplash.com/s/photos/simple-is-beautiful?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span>
</div>


### Don't get fancy
They say “Simple is beautiful” and I can’t really stress this enough: if your technology stack uses
10 different technologies, you’ll have to multiply your web searches for hair pulling bugs, times 10,
your package upgrades, your technical debt times 10 and so on. Keeping your stack as simple as you can,
will help you focus less on administrative tasks and more on writing features and their tests,
that will help the business succeed.

### Conclusion
Choosing a technology stack is hard and requires a lot of thought. It’s also a process which affects
you team’s day-to-day life and may introduce more costs than you initially accounted for. Don’t get
blinded by shinny new objects, choose what works best for your team and your business. Even if it’s
a fairly old, boring “been there, done that” piece of software.

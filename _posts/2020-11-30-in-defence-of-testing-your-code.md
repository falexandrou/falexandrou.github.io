---
layout: post
comments: true
title: "Testing your code is not optional."
excerpt: "The benefits of having an efficient and detailed testing suite in place"
author: Fotis
---

### Let’s start with a story...
A quadrillion years ago, I used to work for companies none of which had automated tests in place and believe it or not,
testing was not that popular; We wrote the code, tested manually on our local machines, deployed our newly committed
piece of art and called it a day. If however, something went wrong, we tried to replicate the issue on a test environment,
fixed it, deployed the fix and so on, usually hoping that the fix wouldn't introduce a [regression](https://en.wikipedia.org/wiki/Software_regression).

Then, writing unit tests somehow gained traction and became popular among developers who liked following best practices but still,
there was a lot of ground to be covered in fast-moving startups and agencies, where delivering projects is a time-sensitive thing.
I even remember debating the lead developer of a VC-backed startup, who at some point insisted that testing is a waste of time and that's why they didn't do it.


#### So, is testing our code a waste of time?
No, it's not! Believe it or not though, this was (hopefully isn't anymore) a somehow acceptable opinion a few years back.
While testing may require some development time, it actually helps save enormous amounts of time if done properly.

Let's think of the following scenario:

- A developer works on Feature X for a few days, completes their work and pushes code to the testing environment.
- Then, a QA or the developer themselves tests manually, finds a couple of issues which are then fixed and the project hits production.
- The code then interacts with user-input or other existing data in a database and errors occur.
- The Product Owner raises a ticket, assigns the QA, the QA reproduces the issue, adds technical information to the ticket, sends it to the developer,
they apply a fix and the ticket goes back n forth between the stakeholders until the code hits production.

In the meantime, there might be regression issues and the back n forth continues until at some point the ticket closes, while several others have been raised.

Chaos? Yes. Reminds you of something? It certainly does for me. This was the daily, fire-fighting routine for the lead developer that was mentioned earlier.

Having an efficient and detailed testing suite in place, saves you some of this trouble; The code and tests are written, the QA does what they're supposed to do,
(make sure the finished product meets certain quality standards), instead of getting blocked becaused they stumbled upon a tiny mistake that could have been caught beforehand.
Ideal? Maybe. Let's now break down the several ways we can save time.


#### Testing is a safety net, but also a documentation and developer onboarding tool
Usually, the scope of a function is (or should be) somehow limited and, depending on the input, there are certain outcomes.
Covering a few default cases, should be a nice way to test said function and save ourselves (and the QA) some time being stopped by runtime errors that would easily be prevented.

If however not all cases were covered and some bug gets reported, it's fine (in fact great!) because this means we're enhancing the testing suite with another case,
making our code even more resilient.

Along with this benefit, there lies another: Tests are a great (yet, not the only) documentation and onboarding tool, which
means that they should be clear, descriptive and be able to provide a high level overview of what the code should accomplish.

For example, here is an excerpt from a few tests I wrote for a Django view that launches deployment operations:

```python
def it_creates_and_runs_an_operation_given_a_commit_reference(mock_user, create_operation_data):
    # ...
    assert response.status_code == 201
    assert response.data['id']
    assert response.data['kind'] == 'deployment'
    # ...
    assert operation.is_running

def it_creates_and_runs_an_operation_without_a_commit_reference(...):
    # ....
    assert operation.is_running
    assert mock_celery_task.call_count == 1
    assert operation.reference == expected_commit_information['reference']

def it_does_not_start_the_operation_when_another_is_queued_prior_to_it(...):
    # Create an operation that is queued prior to the one we're queueing
    prior = operation_factory.create(...)
    # ...
    assert response.status_code == 201
    # ...
    assert not operation.can_start()
    assert not operation.is_running
    assert not mock_celery_task.call_count
    assert operation.is_queued
```

It's a set of tests, groupped together with descriptive names, that provide a high level overview
that an operation can be started with or without a given reference, and what the expected statuses for the model in the database
and the returned HTTP status code should be. When I revisit this example in the future, or whenever a new hire joins the project,
it will hopefully be obvious to them, what the expected behavior should be without having to read long documentation.
Also, it covers three of the most common cases in the system, related to the "operations" feature.


#### Keeping tests fast & testing the right things
Assuming you are using a web framework like Django or Ruby on Rails and you need to test an ORM or an ActiveRecord model,
it doesn't make any sense to test the `.save` or `.get` methods, because they're already tested for you by 
the amazing people that build the framework of choice. However, testing a custom validator you have
added to your model is a requirement.

The scope of a test should be limited as well. Let's take the following real-world example where we use pytest (with some syntactic sugar)
to test a [celery task](https://docs.celeryproject.org/en/stable/userguide/index.html) that starts a queued deployment operation.
The `create_container` function runs a Docker container, but testing this is a) out of the given scope and b) slow if we create the actual container.
The solution to this issue would be to [mock](https://en.wikipedia.org/wiki/Mock_object) the `create_container` call within the current scope:

```python
@pytest.mark.django_db
def describe_start_operation_task():
    def it_runs_the_task(queued_deployment, mock_container):
        allow(tasks).create_container.and_return(mock_container)
        assert not queued_deployment.task_id
        assert not queued_deployment.container_id

        # run the task
        celery_task = tasks.start_operation.s(operation_id=queued_deployment.id).apply_async()

        # make sure the deployment fields were populated accordingly
        queued_deployment.refresh_from_db()
        assert queued_deployment.task_id == celery_task.id
        assert queued_deployment.container_id == mock_container.id
```

[Sandi Metz](https://twitter.com/sandimetz) and [Katrina Owen](https://twitter.com/kytrinyx) in their
great book [99 Bottles of OOP](https://sandimetz.com/99bottles), clearly and constantly state that 
the tests should run upon every line of code that gets changed and they're right. In practice, this
means that you should be able to run all your test suite as fast as possible.

In our example, we managed to save quite some time by mocking the docker container creation, which 
is handled internally by a well tested library. Other examples might include external network requests,
big files loaded, email sending etc.

You might also have noticed in my examples that there is a certain degree of duplication. This is fine.
The tests are not a place to practice [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself); they
should be explicit and detailed in order for the other person to be able to understand every tiny bit of the process,
but also, doing fancy things usually leads to errors and you do want your tests to be straight-forward and valid.


#### Meet your new best friends
In the examples provided above, I introduced a few concepts that you might not be familiar with so far, 
but will become your new best friends when you dive deep into testing: Mocks, Fakes, Stubs, Factories and Fixtures.
Here's some basic guidelines that would help you decide what you need each time:

 - If you want an object and with random data, register a factory.
 - If you need an object with specific, predictable data, go for a fixture.
 - If you need a simplified version of a method or a class, fake it.
 - If you need a set of predefined data returned by a method, stub it.
 - If you just need to count the calls to a method or, mock it.


#### How having a proper test suite improves your code
Writing code with testability in mind, eventually leads to cleaner code, simply because in order to keep the tests simple,
one has to write short-scoped code that is limited to specific things. Long methods that do several things
are as hard to test as to maintain so, having testability in mind, meaning that you **have** to test such pieces of code,
practically acts as an incentive to keep the code maintainable.

Finally, refactoring and cleanup tasks, are a lot safer when the code is covered by reliable tests that will
stop your deployment when something breaks, which makes such tasks a breeze for the developer.


#### There's no strategy that's better than others
I am aware that picking a testing strategy and policy could be a difficult task, however I don't think that a team should stress about it, also it should be a choice
that's adapted to the team's modus operandi, so that they adapt easily to it and it doesn't seem like a huge shift from what they had been doing so far.

If the team wants to practice [BDD](https://en.wikipedia.org/wiki/Behavior-driven_development) and that's something that suits the project,
it should be OK. If the team doesn't feel OK about doing [TDD](https://en.wikipedia.org/wiki/Test-driven_development) where they should write tests in advance,
that should be fine as well, because the purpose is to save the team's time, not force strict policies.
I am aware that methodologies exist for a reason, but experience shows that as long as the team are not practicing
[FDD](https://www.hanselman.com/blog/fear-driven-development-fdd), it should be OK.


#### Conclusion
No matter how experienced or good we are at what we do, we will make that mistake. In order to avoid that annoying RuntimeError that
will disrupt our user's delightful experience, we have to make sure that our code works well no matter what and luckily, we have the tools to do so.
Embrace testing, focus on covering as many scenarios as you can and feel comfortable deploying. Even on Friday...


#### Further reading
 - [Software Testing Strategies](https://web.stanford.edu/class/archive/cs/cs107/cs107.1212/testing.html) - Written by Julie Zelenski, with modifications by Nick Troccoli
 - [TestDouble](https://martinfowler.com/bliki/TestDouble.html) - Martin Fowler
 - [Mocks Aren't Stubs](https://martinfowler.com/articles/mocksArentStubs.html) - Martin Fowler
 - [Test Doubles — Fakes, Mocks and Stubs](https://blog.pragmatists.com/test-doubles-fakes-mocks-and-stubs-1a7491dfa3da) - Michal Lipski

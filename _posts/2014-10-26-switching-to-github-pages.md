---
layout: post
comments: true
title: Switching to Jekyll GitHub pages
author: Fotis
excerpt: How I built this blog and made it super-fast and easy to maintain.
---

## Goal: An easy to maintain personal website

Being a Web Developer is complicated by itself, so, when it comes to maintaining a personal website about ourselves, most of us are terrible at it. We either envy the fancy-designed websites by hipster designers or we enjoy the simplicity of typography-based designs by UX experts.

But, at the end of the day it all comes down to this; maintaining a personal website should be something simple, so it can be done on a regular basis, right?

## Abstracting information

When I decided to re-build my personal website (I take such a decision once every two years or so), I thought I should include all the stuff that all the cool kids do; Portfolio, Client testimonials, Contact form, Pictures of me traveling, Pictures of me giving talks like a rock-star in front of 3 people etc.

**No**. Here's the thing: If i do all of this, then I would have to maintain duplicate information, because I would update my social profiles anyway. Also, I'm not an agency (at least not anymore), so my work is not that frequently updated. I'll add a page with my open source projects in the near future instead.

Contact forms are easily abused by bots, which led to ~150 very enlightening spam email messages every day. Most of them were about shoes, which is really odd. I would either use [CAPTCHA](https://en.wikipedia.org/wiki/CAPTCHA "CAPTCHA") (sic) or create a public email and accept all kinds of spam there.

## Keeping it simple
I've added my social media profiles in my contact page, you may use them freely. Kept my homepage clean with all the posts that are recently posted by me.

## What was my weapon of choice
[Jekyll](http://jekyllrb.com "Jekyll") is a minimalistic static site generator which makes you think how isn't that even more popular. It uses [Markdown](http://daringfireball.net/projects/markdown/syntax "Markdown syntax") and HTML, can be run locally and can be hosted on [GitHub pages](https://pages.github.com) (free).

## Shipping it
On a terminal run

{% highlight bash %}
$ gem install jekyll
{% endhighlight %}
This will install Jekyll as a ruby gem

{% highlight bash %}
$ jekyll new my-awesome-website
{% endhighlight %}
This will create a new website

Then follow a pretty straight-forward git-based process to publish your website to [GitHub pages](https://pages.github.com).

The main benefit is that I don't have to maintain a server, upgrade, care about security updates, running database backups, running a mail server for a mere developer's blog. I can publish to my blog that easily:

{% highlight bash %}
$ git commit --all .
$ git commit -m "My new post"
$ git push origin master
{% endhighlight %}

There it is! I just published a new blog post simply by doing a `git commit` without the need of logging into a control panel and without even leaving my IDE.

So, here it is. My new blog, running on [GitHub pages](https://pages.github.com), powered by [Jekyll](http://jekyllrb.com "Jekyll"), pure [Markdown](http://daringfireball.net/projects/markdown/syntax "Markdown syntax"), HTML and [Emoji](https://en.wikipedia.org/wiki/Emoji). As a friend says: It's back to the future!

Hope you like it :smile: :beer:

---
layout: post
comments: true
title: "Not everyone likes DevOps: why we're building Stackmate"
author: Fotis
---

Over the course of the past few years, I've worked extensively with infrastructure orchestration & automation tools
like [Terraform](https://www.terraform.io/){:target="_blank"} and [Ansible](https://www.ansible.com/){:target="_blank"}.
I was blown away and got so pre-occupied by them, that I kept asking myself "Why isn't this the standard practice?".

### The problem
Turns out the answer to the question **"Why isn't everyone automating their infrastructure"** is simple: **Not everyone likes doing DevOps!**
This is one of the main reasons why people that deploy medium sized apps, still bother with solutions like shared or reseller hosting,
and prefer to use web hosting panels that are inconvenient and dated. Others, turn to cloud solutions that are in fact managed,
but introduce commission fees to the amount paid to cloud providers, or go bare metal and choose to hire a DevOps resource
to help them manage and provision their infrastructure. During calls I had with developers, I got pretty much the same answers:
*"I'd love to be better at DevOps, but I simply don't have the time to"* or even worse... *"I hate doing DevOps, it's like a massive challenge for every project I work on"*.

### Enter Stackmate.io
Even though there are solutions available, they weren't as versatile as we needed to, they locked developers in to some vendor or they offer fully Serverless, Dockerized or Kubernetes-clusterized environments. So, here's what Stackmate does: 

> #### Stackmate.io is an infrastructure & application deployment tool, that offers effortless deployments to AWS & DigitalOcean for developers who want to focus on building great apps instead of DevOps and awkward configs.

In human terms, Stackmate analyzes the infrastructure needed by your application to run, provisions it and deploys your application's code on it,
without you having to write a single line of code, or requiring any DevOps knowledge.

Additionally, it's **the setup you're already familiar with**, meaning we're provisioning and deploying servers and their corresponding managed services,
which you will have access to and **you already know how to manage**.

### Join our waiting list & get a free membership
The plan is to go live by October 2019. Until then, you can join our waiting list and the first 100 people that will, get a free 6-month membership, no credit card required!

<!-- Begin Mailchimp Signup Form -->
<div id="mc_embed_signup">
<form action="https://stackmate.us17.list-manage.com/subscribe/post?u=479e40691dc1b1f4f2610acf4&amp;id=4f5b7daa66" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate>
    <div id="mc_embed_signup_scroll">
<div class="mc-field-group">
  <label for="mce-EMAIL">Email Address  <span class="asterisk">*</span>
</label>
  <input type="email" value="" name="EMAIL" class="required email" id="mce-EMAIL">
</div>
<div class="mc-field-group">
  <label for="mce-FNAME">First Name </label>
  <input type="text" value="" name="FNAME" class="" id="mce-FNAME">
</div>
<div class="mc-field-group">
  <label for="mce-LNAME">Last Name </label>
  <input type="text" value="" name="LNAME" class="" id="mce-LNAME">
</div>
  <div id="mce-responses" class="clear">
    <div class="response" id="mce-error-response" style="display:none"></div>
    <div class="response" id="mce-success-response" style="display:none"></div>
  </div>    <!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups-->
    <div style="position: absolute; left: -5000px;" aria-hidden="true"><input type="text" name="b_479e40691dc1b1f4f2610acf4_4f5b7daa66" tabindex="-1" value=""></div>
    <div class="clear"><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div>
    </div>
</form>
</div>
<script type='text/javascript' src='//s3.amazonaws.com/downloads.mailchimp.com/js/mc-validate.js'></script><script type='text/javascript'>(function($) {window.fnames = new Array(); window.ftypes = new Array();fnames[0]='EMAIL';ftypes[0]='email';fnames[1]='FNAME';ftypes[1]='text';fnames[2]='LNAME';ftypes[2]='text';fnames[3]='ADDRESS';ftypes[3]='address';fnames[4]='PHONE';ftypes[4]='phone';}(jQuery));var $mcj = jQuery.noConflict(true);</script>
<!--End mc_embed_signup-->

### What Stackmate offers
- Static sites, single or multi-tier infrastructure: Deploy a single all-in-one instance that runs your app, or multiple, load-balanced servers that connect to external managed services
- Easily managing your entire infrastructure plan through an intuitive UI that abstracts all the excessive information
- Automatic application deployment upon `git push`
- Automatically deploy new branches pushed to your repository, on an exact replica of your production infrastructure, but scaled down so that you save money
- Manage the configuration for your apps
- Cron Jobs management
- Free SSL installation via Let's Encrypt &trade;
- Supports **Ruby on Rails**, **Django**, **WordPress** and **Gatsby.js** apps
and many more...

See it in action:
<div class="aspect-ratio sixteen-by-nine">
  <iframe src="https://www.youtube.com/embed/I1pmz7Q84fE" frameborder="0" allowfullscreen></iframe>
</div>


We'll keep you posted with our progress and challenges we face along the way.

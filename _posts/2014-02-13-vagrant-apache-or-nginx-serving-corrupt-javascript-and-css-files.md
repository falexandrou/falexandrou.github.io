---
layout: post
title: Vagrant Apache or nginx serving corrupt Javascript and CSS files
header-img: "img/home-bg.jpg"
author: Fotis
excerpt: A very common issue with nginx on Vagrant where the static files are served as corrupt
---

If you prefer a virtualized environment for your web development purposes, you may find Vagrant a really handy solution. Vagrant is a fantastic tool that creates a virtual machine which can be provisioned with Chef or Puppet and be re-packaged for future distribution.

One thing you may need to setup first would be turning off the sendfile option in your web server, otherwise you might end up getting corrupt static files such as javascript or css files. This is actually a VirtualBox bug, as it was documented in Vagrant’s v1.1 documentation and here’s a simple solution to that:

{% highlight bash %}
# A VirtualBox bug forces vagrant to serve
# corrupt files via Apache or nginx
# The solution to that would be to turn off
# the SendFile option in apache or nginx
#
# If you use apache as your main web server
# add this directive in your httpd.conf (or apache.conf)
# configuration file name may vary in various systems
#
EnableSendfile off

# If you use nginx as your main web server
# add this directive in your nginx.conf
sendfile off
{% endhighlight %}

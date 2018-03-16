---
layout: post
comments: true
title: Django Snippets for everyday problems
author: Fotis
---

In late 2015 I found myself working with Python, Django and py.test. I was trying to apply some practices that I had been applying for a very long time with different tools, but Django resisted, so here's the survival kit I had while I was struggling not to compare Django with more modern frameworks. I'm sure a more experienced Django engineer would have found more elegant solutions but these actually did the trick for me.

### 1. HTML arrays in POST requests
Coming from a background that HTML arrays (or Hashes) are posted in forms can cause some pain in Django. If for example you're coming from a Ruby on Rails or PHP background, you may have found easy to access HTML arrays by simply checking the `request` object in Rails or `$_POST` array in PHP. So, for example if you need to post the following form:

{% highlight html %}
<input type="text" name="person[name]" value="John">
{% endhighlight %}

In Rails for example, by accessing `request[:person][:name]` you would get the expected result, while in Django this is not the case. In order to do that, the following snippet is what you need

{% highlight python %}
import re
def get_dict_array(post, key):
    """
    Get an entry from an HTML array eg:
    <input type="text" name="person[name]" value="John">
    Usage:
    get_dict_array(request.POST, "person")
    """
    result = {}
    if post:
        patt = re.compile('^([a-zA-Z_]\w+)\[([a-zA-Z_\-0-9][\w\-]*)\]$')
        for post_name, value in post.items():
            value = post[post_name]
            match = patt.match(post_name)
            if not match or not value:
                continue
            name = match.group(1)
            if name == key:
                k = match.group(2)
                result.update({k:value})
    return result
{% endhighlight %}

### 2. Error message overloading for Unique composite keys

Let's say in your database, there is a table with a composite key, for example in a table of users' Portfolio Items, the fields `user` and `url` should be unique together. In case you need to customise the error message for when a user enters an item which already exists, then you're in for a surprise: You need to overload the model's `unique_error_message` method. Sounds dangerous? Probably because it is...

{% highlight python %}
    def unique_error_message(self, model_class, unique_check):
        if model_class == type(self) and unique_check == ('user', 'url'):
            return _("There already is a portfolio item with the specific url")
        else:
            return super(MyModel, self).unique_error_message(model_class, unique_check)
{% endhighlight %}

### 3. Not able to chain scopes (use QuerySet instead of ModelManager and `objects = QuerySet.as_manager`)

If you have created a model in django and you want to set a few scopes for it, you might need to use a `ModelManager`, right?
Well, sort of... You see, chaining `ModelManager` objects can be painful, so if for example you need to have

{% highlight python %}
Users.objects.active().social_user().all()
{% endhighlight %}

you might get a few not-so-clear error.

The most solid approach I've found, is the following:
 - Declare a `QuerySet` instead of `ModelManager`
 - In your model, you can set `objects = QuerySet.as_manager()` to use your custom objects manager.

 Example:

{% highlight python %}
from django.db import models

class AccountQuerySet(models.QuerySet):
    # ... other scopes here ...

    def active():
      """Filter accounts by active status"""
      return self.filter(is_active=True)

class Account(models.Model):
    # ... fields go here ...
    
    objects = AccountQuerySet.as_manager()
{% endhighlight %}


### 4. Converting `QueryDict` to plain `dict`
Casting a `QueryDict` to a plain `dict` might sound like a trivial thing, but you need to be aware of the following caveat: `QueryDict.dict()` and `dict(QueryDict...)` return different things, as shown in the output below

{% highlight python %}
In [3]: QueryDict("utm_source=email_campaign").dict()
Out[3]: {u'utm_source': u'email_campaign'}

In [4]: dict(QueryDict("utm_source=email_campaign"))
Out[4]: {u'utm_source': [u'email_campaign']}
{% endhighlight %}

### 5. Package seems missing even though you have just installed

You have just installed a package, for example `boto` and you want to run a command, for example `fab`.
If you receive the following error:

{% highlight python %}
ImportError: No module named boto
{% endhighlight %}

all you have to do is:

```sh
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
```

or in order to make the change permanent, you need to add this line to your shell's `rc` file like `.bashrc` or `.zshrc`.


### 6. Uninstall all python packages

Want to start fresh or for some reason remove every python package in your system? There you go:

```sh
pip freeze | xargs pip uninstall -y
```

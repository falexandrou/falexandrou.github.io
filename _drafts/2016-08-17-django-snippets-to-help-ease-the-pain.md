---
layout: post
title: Django Snippets to ease the day-to-day pain
header-img: "img/home-bg.jpg"
author: Fotis
---

These snippets are a necessity because there's too little documentation, or the community is being to "pythonista" to solve.

### Removing the `----` choice label in a `ModelForm`

### Associative arrays as `POST` variables

```python
import re
def get_dict_array(post, key):
    """
    Django sucks when it comes to reading associative arrays from POST / GET
    requests. This is a workaround i found in the following link:
    http://stackoverflow.com/questions/1624863/django-and-html-arrays
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
```

### Error message overloading for Unique composite keys

```python
    def unique_error_message(self, model_class, unique_check):
        """
        This method is the proof that django is useless
        We go through this to customize an error message
        """
        if model_class == type(self) and unique_check == ('user', 'original_url'):
            return _("There already is a Portfolio item with this URL")
        else:
            return super(Portfolios, self).unique_error_message(model_class, unique_check)
```

### Not able to chain scopes (use QuerySet instead of ModelManager and `objects = QuerySet.as_manager`)

If you have created a model in django and you want to set a few scopes for it, you might need to use a `ModelManager`, right?
Well, sort of... You see chaining `ModelManager` objects can be painful, so if for example you need to have

```python
Users.objects.active().social_user().all()
```

you might get a few not-so-clear errors.

The most solid approach I've found, is the following:
 - Declare a `QuerySet` instead of `ModelManager`
 - In your model, you can set `objects = QuerySet.as_manager()` to use your custom objects manager.

 Example:

```python
from django.db import models

class AccountQuerySet(models.QuerySet):
    # ... other scopes here ...

    def active():
      """Filter accounts by active status"""
      return self.filter(is_active=True)

class Account(models.Model):
    # ... fields go here ...
    
    objects = AccountQuerySet.as_manager()
```


### Converting `QueryDict` to plain `dict`

```python
In [3]: QueryDict("utm_source=email_campaign").dict()
Out[3]: {u'utm_source': u'email_campaign'}

In [4]: dict(QueryDict("utm_source=email_campaign"))
Out[4]: {u'utm_source': [u'email_campaign']}
```

### Package seems missing even though you have just installed

You have just installed a package, for example `boto` and you want to run a command, for example `fab`.
If you receive the following error:

```python
ImportError: No module named boto
```

all you have to do is:

```sh
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
```

or in order to make the change permanent, you need to add this line to your shell's `rc` file like `.bashrc` or `.zshrc`.


### Uninstall all python packages

Want to start fresh or for some reason remove every python package in your system? There you go:

```sh
pip freeze | xargs pip uninstall -y
```

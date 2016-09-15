Django Snippets for solving day-to-day pain points. 
==

These snippets are a necessity because there's too little documentation, or the community is being to "pythonista" to solve.

1. Removing the `----` choice label in a `ModelForm`
---

2. Associative arrays as `POST` variables
--

3. Error message overloading for Unique composite keys 
--

4. Not able to chain scopes (use QuerySet instead of ModelManager and `objects = QuerySet.as_manager`)
--

5. Converting `QueryDict` to plain `dict`
--
```
In [3]: QueryDict("utm_source=email_campaign").dict()
Out[3]: {u'utm_source': u'email_campaign'}

In [4]: dict(QueryDict("utm_source=email_campaign"))
Out[4]: {u'utm_source': [u'email_campaign']}
```

<!-- remove all dependencies -->
pip freeze | xargs pip uninstall -y

<!-- Boto related stuff -->
export PYTHONPATH=/usr/local/lib/python2.7/site-packages

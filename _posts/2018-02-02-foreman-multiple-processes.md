---
layout: post
comments: true
title: "How to (selectively) run multiple processes with Foreman"
header-img: "img/home-bg.jpg"
author: Fotis
---
If you're using the [foreman gem](http://ddollar.github.io/foreman/){:target="_blank"} to manage simple Procfile process setups, there will be a time where you'll just need to run 2 or 3 processes separately.
This can be easily achieved if you pass the "formation" parameter or the (undocumented) concurrency parameter to foreman start. So let's say your Procfile is formed as follows

```Procfile
api: bundle exec rails server -e development
listener: bundle exec rake listener:run
workers: bundle exec rake workers:run
```

and you only need to run listener & workers, you'll have to start foreman as follows:

```Procfile
foreman start -c listener=1,workers=1
```

where the number stands for the number of the processes you want to start for this service. So, if for example we wish to start 5 processes for the workers, we can simply change this to:
```Procfile
foreman start -c listener=1,workers=5
```

Additionally, we can use an environment file:

```Procfile
foreman -e env.sh start -c listener=1,workers=5
```

For more options please visit the [foreman documentation page](http://ddollar.github.io/foreman)

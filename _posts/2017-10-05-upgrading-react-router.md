---
layout: post
comments: true
title: "Upgrading React Router v4 on an Isomorphic, Redux-powered React web application"
subtitle: "Hint: It's not as hard as you may think it is"
header-img: "img/home-bg.jpg"
author: Fotis
---

#### The Motivation

When working on the next release of [ezploy.io](https://ezploy.io) (still in the works), among the many changes I've introduced, I had to upgrade react-router to its latest stable version v4. At first I thought it was a bit of a luxury since I tried to roll out this version for a long time, but then again I thought that it would provide great benefits in terms of security, stability, flexibility and speed, so I went ahead and spent that 3-4 hours anyway; here's the story behind that.

#### First things first
You have to carefully read the [Official migration guide](https://github.com/ReactTraining/react-router/blob/master/packages/react-router/docs/guides/migrating.md) that the awesome contributors of [React Router](https://github.com/ReactTraining/react-router) have crafted.

#### Key Concepts
The first thing you need to know is that the `react-router` is broken down to several packages that you need to additionally install, since the `react-router` package is designed as a core package, working both with React and React Native. This is the main reason why you need to familiarize yourself with the `react-router-dom` package, which you'll be using from now on.

Second, there's no need for having all of your Routes in one file. The routes can now be hosted inside components so you need to refactor your main application's component and your existing routes file; Your main application component should host all the top-level routes from now on and your (existing) routes file should now feature an array of routes (more on that on the next paragraph).

Third, if you're using `onEnter`, `onChange` and other hooks like `setRouteLeaveHook`, you may need to perform a deeper dive on the [React Router documentation](https://reacttraining.com/react-router/web/guides/philosophy), and perhaps a quick look at [this thread](https://github.com/ReactTraining/react-router/issues/3854) too, as these have now been removed. There's a section at the end of this post explaining what you need to do if you require user confirmation when navigating away from a page (ie. unsaved changes etc).

Fourth, if you're passing `params` in your data prefetching functions or examining `params` in your props, keep in mind that `params` is now a property of `match` which is the router match object (which we'll talk about in a bit).

Last but not least you may need to spend some time refactoring your imports, since the `<Link>` component, or the `withRouter` wrapper for example, are now located in the `react-router-dom` package.

#### Isomorphic rendering & data prefetching
In order for the server side rendering to work properly we need to have all data pre-fetched and the Redux store hydrated (if you're using Redux on your stack). This is achieved by having each data-fetching component set up as follows:

```javascript
class MyComponent extends React.Component {
  static fetchData(dispatch, match) {
    // ... dispatch the appropriate actions
  }

  componentDidMount() {
    const { dispatch, match } = this.props;
    MyComponent.fetchData(dispatch, match);
    // ...
  }
}
```

Notice how we pass `match` as the second argument of the `fetchData` function, this used to be router's `params` in previous versions, but since `params` is now a property of `match`, we pass the `match` object instead.

Now, remember when we said we don't need to have a central place for your routes? That's sort of true; Not having all your routes in one place, means that each component should be able to declare Routes inside its `render` function for example, meaning that isomorphic rendering with data prefetching becomes a lot trickier. Not anymore, because now's the time to install `react-router-config` and setup a fairly big array of objects, containing all the routes in the system (hence the "sort of true" about this argument), much like that:

```javascript
module.exports = [
  {
    path: '/',
    component: Application,
    routes: [
      {
        path: '/dashboard',
        component: Dashboard,
      },
      // ... more top-level routes here
      // ...
      // a couple of nested routes
      {
        path: '/projects/:id/setup/update',
        component: UpdateProject,
      },
      {
        path: '/projects/:id/setup',
        component: Project,
      },
    ]
  }
]
```

Having done that, you may now use `renderRoutes` and `matchRoutes` on your server side router. You're going to match the route based on the url the user is currently at, then get the components that this route uses, apply the `fetchData` function and done!

The most common pattern for doing server side rendering, is having a middleware (in our case an Express.js middleware) which renders on all urls (catch-all) and delegates the actual routing to react-router.

If what I've mentioned above sounds familiar to you, your existing code (pre-upgrade) probably uses `matchPath` function, like this one:

```javascript
matchPath(req.url, routes).then((error, redirectLocation, renderProps) => {
  // I can has server side rendering in here
});
```

It's now time for that `matchPath` function to retire and match your routes with the `matchRoutes` function, provided by `react-router-config`. Here's the gist of how my server side router looks after applying the changes (make sure you follow the comments in the code):

```javascript
// ...
// import the new StaticRouter from react-router-dom and the functions described above from the config package
import { StaticRouter } from 'react-router-dom';
import { matchRoutes, renderRoutes } from 'react-router-config';

module.exports = () => {
  // you might need to avoid using `import` for the routes file,
  // if you're doing hot reloading on the server and you need them to be reloaded
  let routes = require('./routes');

  // catch-all middleware that delegates routing to react-router
  router.use('*', (req, res, next) => {
    // ...
    const context = {};

    // We're matching the route with `matchRoutes`, then we're adding all of the `fetchData` promises in an Array.
    const dataPromises = matchRoutes(routes, req.originalUrl).map( ({ route, match }) => {
      return route.component.fetchData ? route.component.fetchData(store.dispatch, match) : Promise.resolve(null);
    });

    // Once all of the `fetchData` promises have been resolved, we may now proceed with the rendering
    Promise.all(dataPromises).then( prefetchData => {
      // Create a component wrapped in a `<Provider>` containing the store,
      // then render the router inside the provider
      const InitialComponent = <Provider store={store}>
        <StaticRouter location={req.url} context={context}>
          {renderRoutes(routes)}
        </StaticRouter>
      </Provider>

      // Render your Express.js layout with the app and the Redux store hydrated
      res.render('application', {
        reactApp: ReactDOM.renderToString(InitialComponent),
        initialState: JSON.stringify(store.getState()).replace(/</g, '\\u003c'),
      });
    })
    // ...
  });
};
```

Done! Your app now renders isomorphically, with all the data pre-fetched and the Redux store hydrated. We're not entirely done though, let's just make sure that our client app is up to date, here's the gist again:

```javascript
import { BrowserRouter as Router } from 'react-router-dom';
import { renderRoutes } from 'react-router-config';

// Import the same long array containing all the routes or just render your main application component here
// in case you find this too much.
import routes from "routes";

// ...
const InitialComponent = (
  <Provider store={store}>
    <Router>
      { renderRoutes(routes) }
    </Router>
  </Provider>
);

ReactDOM.render(InitialComponent, document.getElementById("app"));

// ...
```


#### Extra things to consider:
- When using nested routes like for example `/projects/10` and then `/projects/10/member/1`, you may need to mark the first one as `exact`, otherwise you'll end up resolving unexpected components
- On the same subject, let's say we have the following route set up
```javascript
<Route to="/projects/:project_id" component={Project} />
```
and inside the `Project` component you have the following route set up:
```javascript
  // ...
  <Switch>
    // ...
    <Route to="/projects/:project_id/collaborators/:collaborator_id" component={ProjectCollaborator} />
  </Switch>
```

When visiting `/projects/5/collaborators/15`, you may not be able to access the `:component_id` param inside the `Project` component due to [this issue](https://github.com/ReactTraining/react-router/issues/5429).
- If you've been using the `setRouteLeaveHook` hook to prompt your users before navigating away from a page, you can use the [getUserConfirmation](https://reacttraining.com/react-router/web/api/BrowserRouter/getUserConfirmation-func). Now, if you need a bit more granularity prompting your users when navigating away from a page, consider using the [Prompt](https://reacttraining.com/react-router/web/api/Prompt) component, while if you need to render a custom React component or perform a custom hook when confirming / canceling navigation, there's a [nice replacement](https://github.com/ZacharyRSmith/react-router-navigation-prompt) for that.

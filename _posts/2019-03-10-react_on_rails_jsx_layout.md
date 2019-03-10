---
layout: post
comments: true
title: "Using a React Component as a Layout with ReactOnRails"
author: Fotis
---

New year, new codebase for a [side-project of mine](https://stackmate.io){:target="_blank"}, and I decided to go with [ReactOnRails](https://github.com/shakacode/react_on_rails){:target="_blank"}, turbolinks and other sorcery that will help me go faster but won't sacrifice code quality.

An issue I found with this approach is that it wasn't clear to me how to render a React Component as a layout, since the `yield` call in my `application.html.erb` would render the `<%= react_component ... %>` part in the view, as described in the ReactOnRails README file. Here's the way I found in order to do so:

Added a react_layout method in my controller. That way I can overload this method in child classes 

```ruby
# file app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  def react_layout
    'LayoutDefault'
  end

  def react_layout_props
    { user: { id: current_user.id } } # ... fill in your layout props
  end
end
```

Created a `ReactHelper` module with a `react_view` wrapper method, which utilizes `react_component` internally.

```ruby
# file app/helpers/react_helper.rb
module ReactHelper
  def react_view viewname, props: {}, layout: nil, layout_props: {}
    layout ||= controller.react_layout
    layout_component_props = controller.react_layout_props.merge(layout_props)

    react_component(layout, props: layout_component_props.merge({
      component: viewname,
      componentProps: props,
    }))
  end
end
```

Replaced calls to `react_component` with `react_view`, for example
```ruby
# file app/views/dashboard/index.html.erb
<%= react_view("DashboardView", props: @props) %>
```

Dynamically rendered the component requested in the view inside `LayoutDefault.jsx`

```javascript
// store this in a location resolvable by webpacker
import React from 'react';
import PropTypes from 'prop-types';

const LayoutDefault = ({ component, componentProps }) => {
  const ViewComponent = ReactOnRails.getComponent(component);

  return (
    <React.Fragment>
      ... Layout area ...
      <ViewComponent.component {...componentProps} />
      ... Layout area ...
    </React.Fragment>
  );
};

LayoutDefault.propTypes = {
  component: PropTypes.string.isRequired,
  componentProps: PropTypes.object,
};

LayoutDefault.defaultProps = {
  componentProps: {},
};

export default LayoutDefault;
```

And done. The app now renders the react layout and the component I've requested in my view inside.

Pro tip: You need to declare `ReactOnRails` as a global in your eslint config if you're using a linter (which you should)

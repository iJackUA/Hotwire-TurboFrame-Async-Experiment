# TurboFrameAsync

TurboFrameAsync is a Ruby gem that enhances Turbo Frames with asynchronous capabilities. It allows you to handle multiple promises in your Rails views with elegant loading, success, and failure states.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'turbo_frame_async'
```
And then execute:

```bash
bundle install
```

## Usage

### Basic Example

In your controller:

```ruby
class DashboardController < ApplicationController
  include TurboFrameAsync::Helper

  def index
    @user_data = async_execute {
      User.find(params[:id])
    }

    @posts_data = async_execute {
      Post.where(user_id: params[:id])
    }
  end
end
```

In your view:

```erb
<%= turbo_frame_tag_async "dashboard", @user_data, @posts_data do |frame| %>
  <% frame.on_loading do %>
    <div class="loading">Loading dashboard data...</div>
  <% end %>

  <% frame.on_success do |user, posts| %>
    <div class="dashboard">
      <h1><%= user.name %>'s Dashboard</h1>
      <%= render partial: "posts", locals: { posts: posts } %>
    </div>
  <% end %>

  <% frame.on_failure do |error| %>
    <div class="error">
      Error loading dashboard: <%= error.message %>
    </div>
  <% end %>
<% end %>
```

## Configuration

You can configure the executor used for async operations:

```ruby
# config/initializers/turbo_frame_async.rb

TurboFrameAsync.configure do |config|
  config.executor = Concurrent::ThreadPoolExecutor.new(
    min_threads: 1,
    max_threads: 10,
    max_queue: 50,
    fallback_policy: :caller_runs
  )
end
```

Default configuration is provided out of the box, so this step is optional.

### Helper Methods

`async_execute`
Creates a promise that executes the given block asynchronously:

```ruby
data = async_execute {
  # Long-running operation
  User.complex_query
}
```

`turbo_frame_tag_async`
Creates an async Turbo Frame that handles promise states:

```erb
<%= turbo_frame_tag_async "my-frame", promise1, promise2 do |frame| %>
  <% frame.on_loading do %>
    <!-- Loading state content -->
  <% end %>

  <% frame.on_success do |result1, result2| %>
    <!-- Success state content -->
  <% end %>

  <% frame.on_failure do |error| %>
    <!-- Error state content -->
  <% end %>
<% end %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/turbo_frame_async. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/turbo_frame_async/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TurboFrameAsync project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/turbo_frame_async/blob/master/CODE_OF_CONDUCT.md).

# frozen_string_literal: true

module TurboFrameAsync
  # View helper module that provides methods for creating asynchronous Turbo Frames
  # with support for loading, success, and failure states.
  #
  # @since 0.1.0
  module Helper
    # Size of the random hex string used for generating unique async tag IDs
    # @api private
    HEX_SIZE = 12

    # Creates an asynchronous Turbo Frame that handles multiple promises and their states.
    # This helper method sets up a Turbo Frame that can show different content based on
    # the promise states (loading, success, failure) and handles the async updates through
    # Turbo Streams.
    #
    # @param dom_id [String] The DOM ID for the Turbo Frame
    # @param promises [Array<Concurrent::Promise>] One or more promises to handle
    # @yield [handler] Block for defining state contents using the PromiseHandler
    # @yieldparam handler [PromiseHandler] The handler instance for setting up state blocks
    # @return [ActiveSupport::SafeBuffer] The HTML output containing the Turbo Frame
    #
    # @example Basic usage with all states
    #   <%= turbo_frame_tag_async "user-profile", user_data_promise do |frame| %>
    #     <% frame.on_loading do %>
    #       <div class="spinner">Loading user data...</div>
    #     <% end %>
    #
    #     <% frame.on_success do |user| %>
    #       <div class="profile">
    #         <h2><%= user.name %></h2>
    #         <p><%= user.bio %></p>
    #       </div>
    #     <% end %>
    #
    #     <% frame.on_failure do |error| %>
    #       <div class="error">
    #         Failed to load user: <%= error.message %>
    #       </div>
    #     <% end %>
    #   <% end %>
    #
    # @example Multiple promises
    #   <%= turbo_frame_tag_async "dashboard", users_promise, posts_promise do |frame| %>
    #     <% frame.on_success do |users, posts| %>
    #       <div class="dashboard">
    #         <div class="users"><%= render users %></div>
    #         <div class="posts"><%= render posts %></div>
    #       </div>
    #     <% end %>
    #   <% end %>
    def turbo_frame_tag_async(dom_id, *promises)
      async_tag_id = "async_tag_" + SecureRandom.hex(HEX_SIZE)
      handler = PromiseHandler.new(dom_id, async_tag_id, self)

      yield(handler) if block_given?

      output = ActiveSupport::SafeBuffer.new
      output << turbo_stream_from(async_tag_id)
      output << turbo_frame_tag(dom_id) { handler.render_loading }

      handler.handle_promises(promises)

      output
    end

    # Creates a promise that executes the given block on the configured executor
    #
    # @yield Block to be executed asynchronously
    # @return [Concurrent::Promise] A promise that will resolve with the block's result
    # @example
    #   # In your controller:
    #   def index
    #     @user_promise = async_execute { User.find(params[:id]) }
    #     @posts_promise = async_execute { Post.where(user_id: params[:id]) }
    #   end
    #
    #   # In your view:
    #   <%= turbo_frame_tag_async "user-data", @user_promise, @posts_promise do |frame| %>
    #     <% frame.on_success do |user, posts| %>
    #       <%= render "user_dashboard", user: user, posts: posts %>
    #     <% end %>
    #   <% end %>
    def async_execute(&block)
      Concurrent::Promises.future_on(TurboFrameAsync.configuration.executor, &block)
    end
  end
end

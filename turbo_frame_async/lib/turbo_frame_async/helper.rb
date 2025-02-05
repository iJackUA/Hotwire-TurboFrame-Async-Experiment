# frozen_string_literal: true

module TurboFrameAsync
  # View helper module that provides methods for creating asynchronous Turbo Frames
  # with support for loading, success, and failure states.
  #
  # @since 0.1.0
  module Helper
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
    def turbo_frame_tag_async(dom_id, *promises, &block)
      # TODO: Refactor PromiseHandler and give it better name
      # maybe separate "logic"/promises handler and "tag rendering"

      handler = PromiseHandler.new(dom_id, self)

      # Default block should be considered as "success"
      handler.on_success(block) if block_given?

      handler.handle_promises(promises)

      handler
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

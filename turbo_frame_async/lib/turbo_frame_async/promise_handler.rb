# frozen_string_literal: true

module TurboFrameAsync
  # Handles the processing and broadcasting of promise results for asynchronous Turbo Frames.
  # This class manages the lifecycle of promises, their states, and broadcasts the appropriate
  # content through Turbo Streams based on promise resolution or rejection.
  #
  # @since 0.1.0
  # @api private
  class PromiseHandler
    include ActionView::Helpers::CaptureHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    # Initializes a new PromiseHandler instance
    #
    # @param dom_id [String] The DOM ID of the target Turbo Frame element
    # @param async_tag_id [String] The unique identifier for the async tag
    # @param view_context [ActionView::Base] The view context for rendering templates
    # @api private
    def initialize(dom_id, async_tag_id, view_context = nil)
      @dom_id = dom_id
      @async_tag_id = async_tag_id
      @view_context = view_context
      @blocks = default_blocks
    end

    # Sets the loading state content block
    #
    # @yield Block that renders loading state content
    # @return [void]
    # @example
    #   handler.on_loading do
    #     content_tag(:div, "Loading data...", class: "spinner")
    #   end
    def on_loading(&block)
      @blocks[:loading] = block if block_given?
    end

    # Sets the success state content block
    #
    # @yield [*values] Block that renders success state content
    # @yieldparam values [Array] Values from the resolved promises
    # @return [void]
    # @example
    #   handler.on_success do |user, posts|
    #     render partial: "user_dashboard", locals: { user: user, posts: posts }
    #   end
    def on_success(&block)
      @blocks[:success] = block if block_given?
    end

    # Sets the failure state content block
    #
    # @yield [error] Block that renders failure state content
    # @yieldparam error [StandardError] The error from the rejected promise
    # @return [void]
    # @example
    #   handler.on_failure do |error|
    #     content_tag(:div, error.message, class: "alert alert-error")
    #   end
    def on_failure(&block)
      @blocks[:failure] = block if block_given?
    end

    # Processes the given promises and handles their resolution/rejection
    #
    # @param promises [Array<Concurrent::Promise>] The promises to handle
    # @return [void]
    # @api private
    def handle_promises(promises)
      return if promises.empty?

      # Wait promises
      Concurrent::Promises
        .zip(*promises)
        .then_on(TurboFrameAsync.configuration.executor) { |*values| broadcast_success(values) }
        .rescue_on(TurboFrameAsync.configuration.executor) do |error|
          Rails.error.report(error)
          broadcast_failure(error)
        end
    rescue StandardError => e
      Rails.error.report(e)
      broadcast_failure(e)
    end

    # Renders the initial loading state content
    #
    # @return [String] The HTML content for loading state
    # @api private
    def render_loading
      render_block(@blocks[:loading])
    end

    private

    # Returns the default content blocks for each state
    #
    # @return [Hash] Hash containing default blocks for loading, success, and failure states
    # @api private
    def default_blocks
      {
        loading: -> { content_tag(:div, "Loading...") },
        success: ->(*) { content_tag(:div, "Content loaded!") },
        failure: ->(*) { content_tag(:div, "Error loading content") }
      }
    end

    # Broadcasts success content to the Turbo Stream
    #
    # @param values [Array] The resolved promise values
    # @return [void]
    # @api private
    def broadcast_success(values)
      return unless @blocks[:success]

      html_content = render_block(@blocks[:success], *values)
      broadcast_content(html_content)
    end

    # Broadcasts failure content to the Turbo Stream
    #
    # @param error [StandardError] The error from rejected promise
    # @return [void]
    # @api private
    def broadcast_failure(error)
      return unless @blocks[:failure]

      html_content = render_block(@blocks[:failure], error)
      broadcast_content(html_content)
    end

    # Safely renders a block with the given arguments
    #
    # @param block [Proc] The block to render
    # @param args [Array] Arguments to pass to the block
    # @return [String] The rendered HTML content
    # @api private
    def render_block(block, *args)
      if @view_context
        @view_context.capture(*args, &block)
      else
        capture(*args, &block)
      end.strip.html_safe
    end

    # Broadcasts content to the Turbo Stream
    #
    # @param html_content [String] The HTML content to broadcast
    # @return [void]
    # @api private
    def broadcast_content(html_content)
      Turbo::StreamsChannel.broadcast_replace_to(@async_tag_id, target: @dom_id, html: html_content)
    end
  end
end

# frozen_string_literal: true

require "concurrent"
require "concurrent-edge"
require "turbo-rails"
require "turbo_frame_async/version"
require "turbo_frame_async/configuration"
require "turbo_frame_async/promise_handler"
require "turbo_frame_async/helper"
require "turbo_frame_async/railtie" if defined?(Rails)

module TurboFrameAsync
  class Error < StandardError; end
end

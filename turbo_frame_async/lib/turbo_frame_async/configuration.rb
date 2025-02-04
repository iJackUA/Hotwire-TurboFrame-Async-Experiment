# frozen_string_literal: true

module TurboFrameAsync
  # Configuration class for TurboFrameAsync gem that handles async operations settings.
  # Provides configuration options for the executor that processes async promises.
  class Configuration
    # Dafault defaults
    DEFAULT_EXECUTOR_OPTIONS = {
      min_threads: 1,
      max_threads: 5,
      max_queue: 100,
      fallback_policy: :caller_runs
    }

    # The executor instance used for handling concurrent promises
    attr_writer :executor

    # Config for default Concurrent::ThreadPoolExecutor
    attr_writer :default_executor_options

    def initialize
      @default_executor_options = {}
    end

    def wrapping_executor(executor)
      RailsWrappingExecutor.new(executor)
    end

    def executor
      @executor ||= wrapping_executor(default_executor)
    end

    private

    # Builds the default executor with predefined settings.
    # Uses ThreadPoolExecutor for better thread management and fallback handling.
    # https://ruby-concurrency.github.io/concurrent-ruby/master/Concurrent/ThreadPoolExecutor.html
    #
    # @return [Concurrent::ThreadPoolExecutor] A new executor instance with default settings
    # @api private
    def default_executor
      opts = DEFAULT_EXECUTOR_OPTIONS.merge(@default_executor_options)
      Concurrent::ThreadPoolExecutor.new(opts)
    end
  end

  class << self
    # Returns the current configuration instance.
    # Creates a new configuration with default settings if none exists.
    #
    # @return [Configuration] The current configuration instance
    # @see Configuration#initialize
    def configuration
      @configuration ||= Configuration.new
    end

    # Configures the gem using a block.
    # Yields the current configuration instance for modification.
    def configure
      yield(configuration)
    end
  end
end

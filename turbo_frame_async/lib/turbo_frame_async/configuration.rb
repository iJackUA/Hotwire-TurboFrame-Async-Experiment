# frozen_string_literal: true

module TurboFrameAsync
  # Configuration class for TurboFrameAsync gem that handles async operations settings.
  # Provides configuration options for the executor that processes async promises.
  #
  # @since 0.1.0
  # @example Configure custom executor
  #   TurboFrameAsync.configure do |config|
  #     config.executor = Concurrent::ThreadPoolExecutor.new(max_threads: 10)
  #   end
  # @example Use default configuration
  #   # No configuration needed, uses default executor
  #   TurboFrameAsync.configuration.executor
  class Configuration
    # Default minimum number of threads in the executor pool
    # @api private
    DEFAULT_MIN_THREADS = 0

    # Default maximum number of threads in the executor pool
    # @api private
    DEFAULT_MAX_THREADS = 5

    # Default maximum size of the task queue
    # @api private
    DEFAULT_MAX_QUEUE = 100

    # Default policy for handling tasks when queue is full
    # @api private
    DEFAULT_FALLBACK_POLICY = :caller_runs

    # The executor instance used for handling concurrent promises
    # @return [Concurrent::ThreadPoolExecutor] The configured executor instance
    # @example Set custom executor
    #   config.executor = Concurrent::ThreadPoolExecutor.new(max_threads: 10)
    attr_accessor :executor

    # Initializes a new Configuration instance with default settings.
    # Creates a default executor if none is provided.
    #
    # @return [Configuration] A new configuration instance
    # @see #build_default_executor
    def initialize
      @executor = build_default_executor
    end

    private

    # Builds the default executor with predefined settings.
    # Uses ThreadPoolExecutor for better thread management and fallback handling.
    #
    # @return [Concurrent::ThreadPoolExecutor] A new executor instance with default settings
    # @api private
    def build_default_executor
      Concurrent::ThreadPoolExecutor.new(
        min_threads: DEFAULT_MIN_THREADS,
        max_threads: DEFAULT_MAX_THREADS,
        max_queue: DEFAULT_MAX_QUEUE,
        fallback_policy: DEFAULT_FALLBACK_POLICY
      )
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
    #
    # @yield [config] Configuration instance
    # @yieldparam config [Configuration] The configuration instance to modify
    # @return [void]
    # @example Configure custom executor
    #   TurboFrameAsync.configure do |config|
    #     config.executor = Concurrent::ThreadPoolExecutor.new(
    #       min_threads: 1,
    #       max_threads: 10,
    #       max_queue: 50,
    #       fallback_policy: :caller_runs
    #     )
    #   end
    def configure
      yield(configuration)
    end
  end
end

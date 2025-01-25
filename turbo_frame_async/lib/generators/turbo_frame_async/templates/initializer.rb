# frozen_string_literal: true

TurboFrameAsync.configure do |config|
  # Configure custom executor if needed
  # config.executor = Concurrent::WrappingExecutor.new(
  #   min_threads: 0,
  #   max_threads: 10,
  #   max_queue: 100,
  #   fallback_policy: :caller_runs
  # )
end

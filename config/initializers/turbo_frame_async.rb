TurboFrameAsync.configure do |config|
  config.default_executor_options = {
    min_threads: 1,
    max_threads: 10,
    max_queue: 500
  }
end

class ErrorSubscriber
  def report(error, handled:, severity:, context:, source: nil)
    Rails.logger.error([error.inspect, error.backtrace])
  end
end

Rails.error.subscribe(ErrorSubscriber.new)

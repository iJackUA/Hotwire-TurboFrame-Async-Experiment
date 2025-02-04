# frozen_string_literal: true

module TurboFrameAsync
  # Rails integration for TurboFrameAsync
  # @since 0.1.0
  class Railtie < Rails::Railtie
    # Includes the helper in ActionView
    initializer "turbo_frame_async.helper" do
      ActiveSupport.on_load(:action_view) do
        include TurboFrameAsync::Helper
      end
    end
  end
end

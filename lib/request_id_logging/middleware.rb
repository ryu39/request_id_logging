require 'request_id_logging/constants'

module RequestIdLogging
  # Rack middleware for logging with request_id.
  #
  # Please insert after ActionDispatch::RequestId in your application.rb like as follows.
  #
  #   module YourApp
  #     class Application < Rails::Application
  #       # some configurations...
  #
  #       config.middleware.insert_after ActionDispatch::RequestId, RequestIdLogging::Middleware
  #     end
  #   end
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request_id = env['action_dispatch.request_id']
      Thread.current[RequestIdLogging::FIBER_LOCAL_KEY] = request_id
      @app.call(env)
    ensure
      Thread.current[RequestIdLogging::FIBER_LOCAL_KEY] = nil
    end
  end
end

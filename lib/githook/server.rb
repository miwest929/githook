require 'rack'

module Githook
  class Server
    attr_accessor :bot

    GITHUB_EVENT_HEADER = 'HTTP_X_GITHUB_EVENT'

    def initialize(bot)
      @bot = bot
    end

    def listen(route = nil)
      app = Proc.new do |env|
        callback_route = route.start_with?('/') ? route : "/#{route}"
        if env['PATH_INFO'] == callback_route
          body = JSON.parse(env['rack.input'].gets)
          @bot.process(body, env[GITHUB_EVENT_HEADER])

          ['200', {'Content-Type' => 'application/json'}, ["{\"message\": \"Success\"}"]]
        else
          ['404', {'Content-Type' => 'application/json'}, ["{\"message\": \"Not Found\"}"]]
        end
      end

      bot_server = Rack::Server.new(
        app: app,
        server: 'webrick',
        Port: 3002
      )

      bot_server.start
    end
  end
end

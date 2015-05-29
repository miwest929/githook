require 'rack'
require 'byebug'

module Githook
  class Server
    attr_accessor :bot

    def initialize(bot)
      @bot = bot
    end

    def listen(route = nil)
=begin
{"GATEWAY_INTERFACE"=>"CGI/1.1", "PATH_INFO"=>"/blah", "QUERY_STRING"=>"", "REMOTE_ADDR"=>"127.0.0.1", "REMOTE_HOST"=>"localhost", "REQUEST_METHOD"=>"GET", "REQUEST_URI"=>"http://localhost:3002/blah", "SCRIPT_NAME"=>"", "SERVER_NAME"=>"localhost", "SERVER_PORT"=>"3002", "SERVER_PROTOCOL"=>"HTTP/1.1", "SERVER_SOFTWARE"=>"WEBrick/1.3.1 (Ruby/2.1.2/2014-05-08)", "HTTP_USER_AGENT"=>"curl/7.30.0", "HTTP_HOST"=>"localhost:3002", "HTTP_ACCEPT"=>"*/*", "rack.version"=>[1, 3], "rack.input"=>#<StringIO:0x007f92e0eac110>, "rack.errors"=>#<IO:<STDERR>>, "rack.multithread"=>true, "rack.multiprocess"=>false, "rack.run_once"=>false, "rack.url_scheme"=>"http", "rack.hijack?"=>true, "rack.hijack"=>#<Proc:0x007f92e0eac688@/Users/mwest/.rvm/gems/ruby-2.1.2/gems/rack-1.6.0/lib/rack/handler/webrick.rb:77 (lambda)>, "rack.hijack_io"=>nil, "HTTP_VERSION"=>"HTTP/1.1", "REQUEST_PATH"=>"/blah"}
=end
      app = Proc.new do |env|
        callback_route = route.start_with?('/') ? route : "/#{route}"
        if env['PATH_INFO'] == callback_route
          body = JSON.parse(env['rack.input'].gets)
          @bot.process(body)
          ['200', {'Content-Type' => 'application/json'}, ["{\"message\": \"Success\"}"]]
        else
          ['404', {'Content-Type' => 'application/json'}, ["{\"message\": \"Not Found\"}"]]
        end
      end

      bot_server = Rack::Server.new(
        app: app,
#        daemonize: true,
        server: 'webrick',
        Port: 3002
      )

      bot_server.start
    end
  end
end

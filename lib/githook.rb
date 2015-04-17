module Githook
  ANY_ACTION = []

  class Bot
    def initialize
      @registry = {}
    end

    def registry
      @registry
    end

    def on(event_type, event_action = nil, &handler)
      event_keys = if event_action
        event_action.map {|ea| "#{event_type}-#{ea}"}
      else
        [event_type]
      end

      event_keys.each {|key| @registry[key] = handler}
    end

    def process(body)
      event_info = github_event(body)

      handler = (@registry["#{event_info['event']}-#{event_info['action']}"] || @registry[event_info['event']])

      handler.call if handler
    end

  private
    def github_event(body)
      # Normally the GitHub event is present in the X-GitHub-Event headers but sometimes
      # that header is absent in which case we need to brute force it.
      events = %w(commit_comment create delete deployment deployment_status fork gollum issue_comment issues pull_request)

      event = (body.keys & events).first # should only ever be one

      {'action' => body['action'], 'event' => event}
    end
  end
end

module Githook
  class Bot
    @access_token = nil

    def initialize(configs = {})
      @access_token = configs[:access_token]
      raise "No Github access token was provided. Your bot will be unable to perform Github actions on your behalf." unless @access_token

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

      pr_info = body['pull_request']
      pr = Githook::PullRequest.new(pr_info['title'], pr_info['body'], pr_info['head']['repo']['full_name'], pr_info['user']['login'])
      handler.call(pr) if handler
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

module Githook
  @registry = {}

  def self.on(event_type, event_action = nil, &handler)
    event_key = event_action ? "#{event_type}-#{event_action}" : event_type

    @registry[event_key] = handler
  end

  def process(body)
    event_info = github_event(body)

    handler = (@registry["#{event_type}-#{event_action}"] || @registry[event_type])

    handler.call if handler
  end

private
  def github_event(body)
    # Normally the GitHub event is present in the X-GitHub-Event headers but sometimes
    # that header is absent in which case we need to brute force it.
    events = %w(commit_comment create delete deployment deployment_status fork gollum issue_comme    nt issues pull_request)

    event = (body.keys & events).first # should only ever be one

    {'action' => body['action'], 'event' => event}
  end
end

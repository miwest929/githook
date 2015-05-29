require 'logger'

module Githook
  class Bot
    attr_accessor :github_client

    # TODO: Grow list will grow in future changes.
    SUPPORTED_ACTIONS = %w(issue_comment issues pull_request pull_request_review_comment)

    def initialize(configs = {})
      access_token = configs[:access_token]
      @logger = configs[:logger] || Logger.new(STDOUT)

      raise "No Github access token was provided. Your bot will be unable to perform Github actions on your behalf." unless access_token

      @github_client = Octokit::Client.new(access_token: access_token)
      @registry = {}
    end

    def registry
      @registry
    end

    def perform(&handler)
      event_keys = if !@actions.empty?
        @actions.map {|a| "#{@event_type}-#{a}"}
      else
        [@event_type]
      end

      event_keys.each {|key| @registry[key] = handler}
    end

    @actions = []
    def when(event_action)

      @actions << event_action

      self
    end

    @event_type = nil
    def on(event_type)
      raise "Github event '#{event}' is not supported by Githook" unless SUPPORTED_ACTIONS.include?(event_type)

      @event_type = event_type
      @actions = []

      self
    end

    def process(body, event)
      unless SUPPORTED_ACTIONS.include?(event)
        @logger.info("Github event '#{event}' is not supported by Githook")
        return
      end

      action = body['action']
      @logger.info("Detected the following GitHub event: action: #{action} event: #{event}")

      handler = (@registry["#{event}-#{action}"] || @registry[event])

      if handler
        pr_info = body['pull_request'] || body['issue']
        repo_name = pr_info['head'] ? pr_info['head']['repo']['full_name'] : nil
        pr = Githook::PullRequest.new(pr_info['title'], pr_info['body'], repo_name, body['number'], pr_info['user']['login'], self.github_client)
        handler.call(pr)
      end
    end
  end
end

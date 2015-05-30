module Githook
  class PullRequest
    attr_accessor :title, :description, :repo, :author, :assignee, :state, :number

    def initialize(title, description, full_repo_name, number, author, assignee, state, client)
      @title = title
      @description = description
      @number = number
      @repo = full_repo_name
      @author = author
      @assignee = assignee
      @state = state
      @client = client
    end

    def comment(message)
      puts "Made comment to #{github_pr_url} with message '#{message}'"

      @client.post("#{github_pr_url}/comments", {
        body: message
      })
    end
  private

    def github_pr_url
      "/repos/#{@repo}/issues/#{@number}"
    end
  end
end

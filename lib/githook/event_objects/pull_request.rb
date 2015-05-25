module Githook
  class PullRequest
    attr_accessor :title, :description, :repo, :author

    def initialize(title, description, full_repo_name, number, author, client)
      @title = title
      @description = description
      @number = number
      @repo = full_repo_name
      @author = author
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

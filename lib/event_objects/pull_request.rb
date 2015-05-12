module Githook
  class PullRequest
    attr_accessor :title, :description, :repo, :author

    def initialize(title, description, repo, author)
      @title = title
      @description = description
      @repo = repo
      @author = author
    end
  end
end

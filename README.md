# Githook

A simple Ruby DSL for describing a Github bot. Github webhooks are the events that the bot must react to.

> NOTE: This gem is under heavy development. It's quite possible there are some bugs. If you discover a bug do not panic.
> Simply open an issue for it and one of the contributers will fix it in no time. Also, Pull requests are always welcomed!

## Installation
First, you need to install this gem. You need to have Ruby and Rubygems installed.
  $ gem install githook

## What Github events and actions are supported?

* [issue_comment](https://developer.github.com/v3/activity/events/types/#issuecommentevent) - Triggered when an issue comment.  
   **Supported actions:** `created`
* [issues](https://developer.github.com/v3/activity/events/types/#issuesevent) - Triggered when an issue is assigned, unassigned, labeled, unlabeled, opened, closed, or reopened.  
   **Supported actions:** `assigned, unassigned, labeled, unlabeled, opened, closed, reopened`
* [pull_request](https://developer.github.com/v3/activity/events/types/#pullrequestevent) - Triggered when a pull request is assigned, unassigned, labeled, unlabeled, opened, closed, reopened, or synchronized (a new push to the branch that the pull request is tracking).  
  **Supported actions:** `assigned, unassigned, labeled, unlabeled, opened, closed, reopened, synchronize`
* [pull_request_review_comment](https://developer.github.com/v3/activity/events/types/#pullrequestreviewcommentevent) - Triggered when a comment is created on a portion of the unified diff of a pull request.  
  **Supported actions:** `created`

## Example

```ruby
require 'githook'

# You must provide an 'access_token' so that your bot is authorized to perform Github actions to your repos
mybot = Githook::Bot.new(access_token: <your-access-token>)

# When a pull_request event is received with action that is either 'opened' or 'reopened'
# then invoke block
mybot.on("pull_request").when("opened").when("reopened").perform do |pr|
  if pr.description.empty?
    pr.comment("Hey, add a description! You think we're mind readers!?")
  end
  
  if pr.title.contains?("cheese")
    pr.comment("Why is there cheese in the title?")
  end
end

# This will launch the bot server. In this example, /payload is the route that handles
# Github webhook requests. When no route is specified then it defaults to the root route.
Githook::Server.new(mybot).listen('/payload')
```

## How to configure your bot to receive web hooks from Github
[Instructions on configuring your bot in Github](./docs/configure-webhooks-github.md)

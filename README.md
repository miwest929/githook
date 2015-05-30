# Githook

A simple Ruby DSL for describing a Github bot. Github webhooks are the events that the bot must react to.

## Installation
First, you need to install this gem. You need to have Ruby and Rubygems installed.
  $ gem install githook

## What Github events and actions are supported?


## Example

```ruby
requite 'githook'

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
  
  pr.add_label("needs-work")
end

# This will launch the bot server. In this example, /payload is the route that handles
# Github webhook requests. When no route is specified then it defaults to the root route.
Githook::Server.new(mybot).listen('/payload')
```

## How to configure your bot to receive web hooks from Github
[Instructions on configuring your bot in Github](./docs/configure-webhooks-github.md)

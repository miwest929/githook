# Githook

A simple Ruby DSL for specifying your very own Github bot. Github webhooks are the events that the bot must react to.

## Example

```ruby
# When a pull_request event is received with action that is either 'opened' or 'reopened'
# then invoke block

# You must provide an 'access_token' so that your bot is authorized to perform Github actions to your repos
mybot = Githook::Bot.new(access_token: <your-access-token>)
mybot.on("pull_request", ["opened", "reopened"]) do |pr|
  if pr.description.empty?
    pr.comment("Hey, add a description! You think we're mind readers!?")
  end
  
  if pr.title.contains?("cheese")
    pr.comment("Why is there cheese in the title?")
  end
  
  pr.add_label("needs-work")
end

# Start server that will listen for requests made to '/payload'
Githook.listen("/payload")
```

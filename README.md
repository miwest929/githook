# Githook

A simple Ruby DSL for specifying your very own Github bot. Github webhooks are the events that the bot must react to.

## Configuration

```ruby
  Githook.config(access_token: <your-access-token>)
```

## Example

```ruby
# When a pull_request event is received with action either 'opened' or 'reopened' then
# invoke block
Githook.on("pull_request", ["opened", "reopened"]) do |pr|
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

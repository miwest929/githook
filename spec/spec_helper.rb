SPEC_DIR = File.expand_path('..', __FILE__)

require 'bundler'
require 'byebug'
require 'rspec'
require 'json'
require 'githook'

Bundler.setup

webhook_requests = {}
Dir['spec/webhooks/*'].each do |wh|
  file = File.read(wh)
  puts wh
  webhook_requests[wh] = JSON.parse(file)
end

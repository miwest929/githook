SPEC_DIR = File.expand_path('..', __FILE__)

require 'bundler'
require 'byebug'
require 'rspec'
require 'json'
require 'githook'

Bundler.setup

WEBHOOK_REQUESTS = {}
Dir['spec/webhooks/*'].each do |wh|
  file = File.read(wh)
  puts wh
  WEBHOOK_REQUESTS[wh] = JSON.parse(file)
end

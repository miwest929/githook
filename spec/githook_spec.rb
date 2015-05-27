require 'spec_helper'

describe Githook do
  context 'initializing your Githook::Bot' do
    it "raises error if no 'access_token' is provided" do
      expect{ Githook::Bot.new }.to raise_error(StandardError)
    end
  end

  context "processing Github events in 'process'" do
    let(:mybot) { Githook::Bot.new(access_token: 'xxxxxxfakexxxx') }
    let(:handler) { Proc.new {|pr| true} }

    it 'invokes the handler that matches the event type and action' do
      mybot.on('pull_request').when('opened').perform(&handler)
      expect(handler).to receive(:call)
      mybot.process(WEBHOOK_REQUESTS['spec/webhooks/opened_pr.json'])
    end

    it 'passes an appropriate object to the invoked block' do
      complex_handler = Proc.new do |pr|
        unless pr.class == Githook::PullRequest
          raise "pr is not of type Githook::PullRequest"
        end
      end

      mybot.on('pull_request').when('opened').perform(&complex_handler)
      expect{ mybot.process(WEBHOOK_REQUESTS['spec/webhooks/opened_pr.json']) }.to_not raise_error
    end
  end

  context "registering new webhook action by invoking 'on'" do
    let(:mybot) { Githook::Bot.new(access_token: 'xxxxxxfakexxxx') }

    it "successfully registers appropriate handler for the event#action specified" do
      handler = Proc.new {|pr| true}
      mybot.on('pull_request').when('opened').perform(&handler)

      expect(mybot.registry['pull_request-opened']).to eq(handler)
      expect(mybot.registry['pull_request']).to eq(nil)
    end

    it "registers handler only for the event if no action is specified" do
      handler = Proc.new {|pr| true}
      mybot.on('pull_request').perform(&handler)

      expect(mybot.registry['pull_request']).to eq(handler)
    end

    it "registers handler only for each event#action  specified" do
      handler = Proc.new {|pr| true}
      mybot.on('pull_request').when('opened').when('reopened').perform(&handler)

      expect(mybot.registry['pull_request-opened']).to eq(handler)
      expect(mybot.registry['pull_request-reopened']).to eq(handler)
    end
  end
end

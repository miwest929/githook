require 'spec_helper'

describe Githook do
  context "processing Github events in 'process'" do
    let(:mybot) { Githook::Bot.new }
    let(:handler) { Proc.new {|pr| true} }

    it 'invokes the handler that matches the event type and action' do
      mybot.on('pull_request', ['opened'], &handler)
      expect(handler).to receive(:call)
      mybot.process({'action' => 'opened', 'pull_request' => {}})
    end
  end

  context "registering new webhook action by invoking 'on'" do
    let(:mybot) { Githook::Bot.new }

    it "successfully registers appropriate handler for the event#action specified" do
      handler = Proc.new {|pr| true}
      mybot.on('pull_request', ['opened'], &handler)

      expect(mybot.registry['pull_request-opened']).to eq(handler)
      expect(mybot.registry['pull_request']).to eq(nil)
    end

    it "registers handler only for the event if no action is specified" do
      handler = Proc.new {|pr| true}
      mybot.on('pull_request', &handler)

      expect(mybot.registry['pull_request']).to eq(handler)
    end

    it "registers handler only for each event#action  specified" do
      handler = Proc.new {|pr| true}
      mybot.on('pull_request', ['opened', 'reopened'], &handler)

      expect(mybot.registry['pull_request-opened']).to eq(handler)
      expect(mybot.registry['pull_request-reopened']).to eq(handler)
    end
  end
end

require 'spec_helper'

describe Githook do
  context "registering new webhook action by invoking 'on'" do
    let(:mybot) { Githook::Bot.new }

    it "successfully registers appropriate handler" do
      handler = Proc.new {|pr| true}
      mybot.on('pull_request', ['opened'], &handler)

      expect(mybot.registry['pull_request-opened']).to eq(handler)
    end
  end
end

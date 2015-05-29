require 'spec_helper'

describe Githook::Server do
  context '#listen' do
    let(:mybot) { Githook::Bot.new(access_token: 'xxxxxxfakexxxx') }
    let(:myserver) { Githook::Server.new(mybot) }

    it 'calls listen' do
      expect{ myserver.listen('/payload') }.to_not raise_error
    end
  end
end


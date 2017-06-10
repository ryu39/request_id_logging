# frozen_string_literal: true

require 'spec_helper'

describe RequestIdLogging::Middleware do
  # rubocop:disable RSpec/VerifiedDoubles
  let(:app) { double('app') }
  # rubocop:enable RSpec/VerifiedDoubles
  let(:middleware) { RequestIdLogging::Middleware.new(app) }

  describe '#call' do
    subject { middleware.call(env) }

    let(:req_id) { 'req_id' }
    let(:env) { { 'action_dispatch.request_id' => req_id } }

    before do
      allow(app).to receive(:call).and_return('result')
    end

    it 'calls app#call with env and returns its result' do
      should eq('result')
      expect(app).to have_received(:call).with(env)
    end
    it 'clears a fiber local variable which is stored in this method' do
      subject
      expect(Thread.current[RequestIdLogging::FIBER_LOCAL_KEY]).to be_nil
    end
  end
end

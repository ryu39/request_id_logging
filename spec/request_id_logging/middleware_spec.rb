require 'spec_helper'

describe RequestIdLogging::Middleware do
  let(:app) { double('app') }
  let(:middleware) { RequestIdLogging::Middleware.new(app) }

  describe '#call' do
    let(:req_id) { 'req_id' }
    let(:env) { { 'action_dispatch.request_id' => req_id } }
    before do
      allow(app).to receive(:call)
    end

    subject { middleware.call(env) }

    it 'calls app#call with env and returns its result' do
      expect(app).to receive(:call).with(env).and_return('result')
      should eq('result')
    end
    it 'clears a fiber local variable which is stored in this method' do
      subject
      expect(Thread.current[RequestIdLogging::FIBER_LOCAL_KEY]).to be_nil
    end
  end
end

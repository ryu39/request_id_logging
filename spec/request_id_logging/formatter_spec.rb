# frozen_string_literal: true

require 'spec_helper'
require 'English'

describe RequestIdLogging::Formatter do
  describe '#call' do
    let(:formatter) { RequestIdLogging::Formatter.new }

    let(:severity) { 'INFO' }
    let(:time) { Time.now }
    let(:progname) { 'progname' }
    let(:msg) { 'message' }

    let(:req_id) { 'req_id' }
    before do
      Thread.current[RequestIdLogging::FIBER_LOCAL_KEY] = req_id
    end

    let(:time_str) { time.strftime('%Y-%m-%dT%H:%M:%S.%6N '.freeze) }

    subject { formatter.call(severity, time, progname, msg) }

    it 'returns formatted string with request_id' do
      expected = format(Logger::Formatter::Format, severity[0], time_str, $PROCESS_ID,
                        severity, progname, "[#{req_id}] #{msg}")
      should eq(expected)
    end

    context 'when msg is Exception' do
      let(:msg) { StandardError.new }

      it 'generates message from Exception and returns formatted string with request_id' do
        msg_str = "[#{req_id}] #{msg.message} (#{msg.class})\n#{(msg.backtrace || []).join("\n")}"
        expected = format(Logger::Formatter::Format, severity[0], time_str, $PROCESS_ID,
                          severity, progname, msg_str)
        should eq(expected)
      end
    end

    context 'when msg is not String or Exception' do
      let(:msg) { %w(aaa bbb) }

      it 'generates message using #inspect and returns formatted string with request_id' do
        msg_str = "[#{req_id}] #{msg.inspect}"
        expected = format(Logger::Formatter::Format, severity[0], time_str, $PROCESS_ID, severity,
                          progname, msg_str)
        should eq(expected)
      end
    end

    context 'when formatter is specified' do
      let(:original_formatter) { double('original_formatter') }
      let(:formatter) { RequestIdLogging::Formatter.new(formatter: original_formatter) }

      it 'calls original_formatter#call with message including request_id and returns its result' do
        expect(original_formatter).to receive(:call)
                                        .with(severity, time, progname, "[#{req_id}] #{msg}")
                                        .and_return('result')
        should eq('result')
      end
    end

    context 'when req_id_proc is specified' do
      let(:req_id_proc) { ->(id) { id.upcase } }
      let(:formatter) { RequestIdLogging::Formatter.new(request_id_proc: req_id_proc) }

      it 'returns formatted string with req_id_proc result string' do
        expected = format(Logger::Formatter::Format, severity[0], time_str, $PROCESS_ID, severity,
                          progname, "[#{req_id.upcase}] #{msg}")
        should eq(expected)
      end
    end
  end
end

# frozen_string_literal: true

require 'request_id_logging/constants'
require 'logger'

module RequestIdLogging
  # A logger formatter which prepends request_id to message.
  class Formatter < Logger::Formatter
    DEFAULT_REQ_ID_PROC = ->(id) { id }

    # Initialize RequestIdLogging::Formatter
    #
    # @param [Logger::Formatter] formatter Optional, if you have original formatter,
    #   please specify it to this arg.
    #   This formatter prepends request_id to message, and calls your formatter #call method.
    #   If not specified, then message is generated in this formatter.
    # @param [Proc] request_id_proc Optional, proc object or lambda to customize logged request_id.
    #   If not specified, then raw request_id is used.
    def initialize(formatter: nil, request_id_proc: DEFAULT_REQ_ID_PROC)
      super()
      @original_formatter = formatter
      @req_id_proc = request_id_proc || DEFAULT_PROC
    end

    def call(severity, time, progname, msg)
      if @original_formatter
        @original_formatter.call(severity, time, progname, new_msg(msg))
      else
        super(severity, time, progname, new_msg(msg))
      end
    end

    private

    def new_msg(msg)
      "[#{request_id}] #{msg2str(msg)}"
    end

    def request_id
      id = Thread.current[RequestIdLogging::FIBER_LOCAL_KEY]
      @req_id_proc.call(id)
    end
  end
end

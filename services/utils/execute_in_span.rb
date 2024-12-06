# frozen_string_literal: true

module Utils
  class ExecuteInSpan
    class << self
      def call(*args, **kwargs, &blk)
        new(*args, **kwargs).execute(&blk)
      end
    end

    def initialize(tracer: LOCAL_TRACER, baggage_data: {})
      @tracer = tracer
      @baggage_data = baggage_data
    end

    def execute
      result = nil
      @tracer.in_span('External call', kind: :client) do |_span, context|
        new_context = OpenTelemetry::Baggage.build(context: context) do |builder|
          baggage_data.each do |key, value|
            builder.set_value(key.to_s, value.to_s)
          end
        end
        cont_id = OpenTelemetry::Context.attach(new_context)

        result = yield if block_given?
        OpenTelemetry::Context.detach(cont_id)
      end
      result
    end

    private

    attr_reader :tracer,
                :baggage_data
  end
end

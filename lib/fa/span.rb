# frozen_string_literal: true

module FA
  # FontAwesome 5 (Pro) Helper for generating spans (counters and text)
  class Span < FA::Base
    def initialize(fa, text = '', options = {})
      if fa.is_a?(Hash)
        set_options(fa[:type].to_sym, fa[:text], fa[:options])
      elsif fa.is_a?(String) || fa.is_a?(Symbol)
        set_options(fa.to_s, text, options)
      else
        raise ArgumentError, 'Unexpected argument type.'
      end
    end

    def raw
      parse_span(@type, @text, @options)
    end

    private

    def set_options(type, text, options)
      @type = type
      @text = text
      @options = options
    end
  end
end

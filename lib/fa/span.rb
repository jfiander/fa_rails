# frozen_string_literal: true

class FA::Span < FA
  def initialize(fa, text = '', options = {})
    @options = options
    if fa.is_a?(Hash)
      @type = fa[:type].to_sym
      @text = fa[:text]
      @options = fa[:options]
    elsif fa.is_a?(String) || fa.is_a?(Symbol)
      @type = fa.to_s
    else
      raise ArgumentError, 'Unexpected argument type.'
    end
  end

  def raw
    parse_span(@type, @text, @options)
  end
end

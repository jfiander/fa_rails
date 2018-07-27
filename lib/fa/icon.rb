# frozen_string_literal: true

module FA
  # FontAwesome 5 (Pro) Helper for generating icons
  class Icon < FA::Base
    def initialize(fa, options = {})
      @options = options
      if fa.is_a?(Hash)
        @name = fa[:name]
        @options = fa[:options]
      elsif fa.is_a?(String) || fa.is_a?(Symbol)
        @name = fa.to_s
      else
        raise ArgumentError, 'Unexpected argument type.'
      end
    end

    def raw
      parse_icon(@name, @options)
    end
  end
end

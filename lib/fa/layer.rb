# frozen_string_literal: true

module FA
  # FontAwesome 5 (Pro) Helper for generating layered icons and spans
  class Layer < FA::Base
    # Creates a new Layer instance
    #
    # Add icons or spans to the stack from bottom to top
    #
    # Note: scaling counters does not work well with :grow, so should use the
    # older "fa-3x" syntax in :css instead.
    #
    # @param [Array] icons The complete hash configurations for each icon/span
    # @param [String] title The tooltip text
    # @param [Integer] grow An additional global scaling factor added in
    # @param [String] css Additional arbitrary CSS classes, space-delimited
    def initialize(icons = {}, title: nil, grow: 0, css: '')
      @icons = icons
      @title = title
      @grow = grow
      @css = css
    end

    # Outputs the formatted stack of icons and spans directly.
    def raw
      @icons.each do |i|
        i[:options] = combine_options(i, combine_grows(i, @grow))
        i[:options][:title] = @title
      end

      build { parse_all(@icons).join }
    end

    private

    def build
      "<span class='icon fa-layers fa-stack fa-fw #{@css}' " \
      "title='#{@title}'>#{yield}</span>"
    end
  end
end

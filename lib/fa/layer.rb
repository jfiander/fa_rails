# frozen_string_literal: true

module FA
  # FontAwesome 5 (Pro) Helper for generating layered icons and spans
  class Layer < FA::Base
    def initialize(icons = {}, title: nil, grow: 0, css: '')
      # Add icons to the stack bottom to top
      #
      # Note: scaling counters does not work well with :grow, so should use the
      # older "fa-3x" syntax in :css instead.
      @icons = icons
      @title = title
      @grow = grow
      @css = css
    end

    def raw
      span_top = "<span class='icon fa-layers fa-fw #{@css}' title='#{@title}'>"
      span_bottom = '</span>'

      @icons.each do |i|
        i[:options] = combine_options(i, combine_grows(i, @grow))
      end

      span_top + parse_all(@icons).join + span_bottom
    end
  end
end

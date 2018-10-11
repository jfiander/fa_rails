# frozen_string_literal: true

module FA
  # FontAwesome 5 (Pro) Helper for piecewise building layered icons and spans
  class Build < FA::Layer
    # Creates a new Layer instance
    #
    # Add icons or spans to the stack from bottom to top
    #
    # This is a variand of FA::Layer, to allow for DSL building stacks
    #
    # Note: scaling counters does not work well with :grow, so should use the
    # older "fa-3x" syntax in :css instead.
    #
    # @param [Array] icons The complete hash configurations for each icon/span
    # @param [String] title The tooltip text
    # @param [Integer] grow An additional global scaling factor added in
    # @param [String] css Additional arbitrary CSS classes, space-delimited
    def initialize(icons = {}, title: nil, grow: 0, css: '')
      super
      @contents = ''
      yield(self) if block_given?
    end

    # Outputs the formatted stack of icons and spans directly.
    def raw
      build { @contents }
    end

    # Adds an icon to the stack using the same argument format.
    def icon(icon, **options)
      @contents += FA::Icon.p(icon, full_options(options))
      self
    end

    # Adds a span to the stack using the same argument format.
    def span(type, text, **options)
      @contents += FA::Span.p(type, text, full_options(options))
      self
    end

    # Shortcut for create and output safe
    def self.p(*args, &block)
      new(*args).instance_eval(&block).safe
    end

    private

    def default_options
      { title: @title, grow: @grow, css: @css, size: 1, fa: '' }
    end

    def full_options(options)
      options = default_options.merge(options)
      options[:fa] += " stack-#{options[:size]}x"
      options
    end
  end
end

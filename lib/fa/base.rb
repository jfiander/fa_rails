# frozen_string_literal: true

module FA
  # FontAwesome 5 (Pro) Helper core class
  class Base
    def raw
      #
    end

    def safe
      safe_output(raw)
    end

    private

    def safe_output(output)
      # html_safe: No user content
      output.respond_to?(:html_safe) ? output.html_safe : output
    end

    def parse_all(icons)
      icons.map do |icon|
        name = icon[:name]
        options = icon[:options] || {}

        if %i[counter text].include?(name.to_sym)
          parse_span(name, icon[:text], options)
        else
          parse_icon(name, options)
        end
      end
    end

    def parse_icon(name, options = {})
      options = fa_options(options)
      parse_options(options)
      title = options[:title]

      @classes << "fa-#{name}"
      @classes << "fa-#{size_x(options[:size])}" if !!options[:size]
      css = @classes.flatten.join(' ')
      transforms = @transforms.join(' ')

      "<i class='#{css}' data-fa-transform='#{transforms}' title='#{title}'></i>"
    end

    def parse_span(type, text, options = {})
      options.delete(:style)
      options = fa_options(options)
      parse_options(options)
      pos = options.delete(:position)
      position = long_position(pos) if !!pos

      @classes << "fa-layers-#{type}"
      @classes << (!!position ? "fa-layers-#{position}" : '')
      css = @classes.flatten.reject { |c| c.to_s.match?(/^fa.$/) }.join(' ')
      transforms = @transforms.join(' ')

      "<span class='#{css}' data-fa-transform='#{transforms}'>#{text}</span>"
    end

    def fa_options(options)
      default = { style: :solid, css: '', fa: '' }

      default.merge(options.to_h)
    end

    def combine_grows(i, grow)
      if i.key?(:options) && i[:options].key?(:grow)
        i[:options][:grow] + grow
      else
        grow
      end
    end

    def combine_options(i, combined_grow)
      if i.key?(:options)
        i[:options].merge(grow: combined_grow)
      else
        { grow: combined_grow }
      end
    end

    def size_x(size)
      return '' unless !!size || size == 1
      "#{size}x"
    end

    def long_position(position)
      return 'top-right' if position == :tr
      return 'top-left' if position == :tl
      return 'bottom-right' if position == :br
      return 'bottom-left' if position == :bl
    end

    def parse_options(options)
      parse_classes(options)
      parse_transforms(options)
    end

    def parse_classes(options)
      @classes = []
      @classes << parse_style(options[:style])
      @classes << options[:fa].to_s.split(' ').map { |c| "fa-#{c}" }
      @classes << options[:css].to_s.split(' ')
    end

    def parse_transforms(options)
      @transforms = []
      %i[grow shrink rotate up down left right].each do |transform|
        if !!options[transform]
          @transforms << "#{transform}-#{options[transform]}"
        end
      end
    end

    def parse_style(style)
      return 'fas' unless %i[solid regular light brands].include?(style)

      'fa' + { solid: 's', regular: 'r', light: 'l', brands: 'b' }[style]
    end
  end
end
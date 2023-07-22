# frozen_string_literal: true

module FA
  # FontAwesome 6 (Pro) Helper core class for inheritance
  class Base
    STYLES = {
      nil => 's',
      solid: 's', regular: 'r', light: 'l', thin: 't',
      duotone: 'd', brands: 'b', kit_upload: 'k'
    }.freeze

    MODES = {
      nil => '',
      sharp: 's'
    }.freeze

    # Outputs the formatted string directly.
    def raw
      #
    end

    # Attempts to call `.html_safe` on the the output of `raw`, if available.
    def safe(html = nil)
      output = html || raw
      output.respond_to?(:html_safe) ? output.html_safe : output
    end

    # Shortcut for create and output safe
    def self.p(*args)
      new(*args).safe
    end

    private

    def parse_all(icons)
      icons.map do |icon|
        options = fa_options(icon[:options])
        options[:fa] += " stack-#{options[:size]}x"

        if %i[counter text].include?(icon[:name].to_sym)
          parse_span(icon[:name], icon[:text], options)
        else
          parse_icon(icon[:name], options)
        end
      end
    end

    def parse_icon(name, options = {})
      options = fa_options(options)
      parse_options(options)

      @classes << "fa-#{name}"
      @classes << "fa-#{options[:size]}x"
      css = @classes.flatten.join(' ').sub(/\A\s+/, '')
      transforms = @transforms.join(' ')

      "<i class='#{css}' id='#{options[:id]}' style='#{@styles}' " \
      "data-fa-transform='#{transforms}' title='#{options[:title]}'></i>"
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

      "<span class='#{css}' id='#{options[:id]}' style='#{@styles}' " \
      "data-fa-transform='#{transforms}'>#{text}</span>"
    end

    def fa_options(options)
      default = { style: :solid, css: '', raw_css: {}, fa: '', size: 1 }

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

    def long_position(position)
      return 'top-right' if position == :tr
      return 'top-left' if position == :tl
      return 'bottom-right' if position == :br
      return 'bottom-left' if position == :bl
    end

    def parse_options(options)
      parse_classes(options)
      options = merge_fa_styles(options)
      parse_styles(options)
      parse_transforms(options)
    end

    def parse_classes(options)
      @classes = []
      @classes << parse_style(options)
      @classes << format_classes(options[:fa], prefix: 'fa-')
      @classes << format_classes(options[:css])
    end

    def format_classes(classes, prefix: nil)
      classes = classes.to_s.split(' ') unless classes.is_a?(Array)
      classes.map { |c| "#{prefix}#{c}" }
    end

    def merge_fa_styles(options)
      fa_styles = options.delete(:fa_styles)
      return options unless fa_styles

      fa_styles = fa_styles.each_with_object({}) do |(k, v), hash|
        hash["--fa-#{k.to_s.tr('_', '-')}"] = v.to_s
      end
      options[:raw_css] = options[:raw_css].merge(fa_styles)
      options
    end

    def parse_styles(options)
      @styles = options[:raw_css].map { |k, v| "#{k}: #{v};" }.join(' ')
    end

    def parse_transforms(options)
      @transforms = []
      %i[grow shrink rotate up down left right].each do |transform|
        if !!options[transform]
          @transforms << "#{transform}-#{options[transform]}"
        end
      end
    end

    def parse_style(options)
      if options[:css].to_s =~ /\bfa[#{MODES.values.uniq.join}]?[#{STYLES.values.uniq.join}]\b/
        return # Don't overwrite a manual style [& mode] class
      end

      style = 'fa'
      style += MODES[options[:mode]]
      style += STYLES[options[:style]]
    end
  end
end

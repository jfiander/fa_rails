# frozen_string_literal: true

module FA
  # FontAwesome 5 (Pro) Helper for generating CDN links
  class Link < FA::Base
    # Outputs the CDN link.
    def initialize(version: nil, integrity: nil, kit: nil, pro: true)
      unless (version && integrity) || kit
        raise ArgumentError, 'Must specify version and integrity or kit.'
      end

      @version = version
      @integrity = integrity
      @kit = kit
      @subdomain = pro ? 'pro' : 'use'
    end

    # Outputs the formatted link directly.
    def raw
      "<link rel=\"stylesheet\" href=\"#{url}\" " \
      "integrity=\"#{@integrity}\" crossorigin=\"anonymous\">"
    end

    # Outputs the formatted kit link directly.
    def kit
      "<script src=\"https://kit.fontawesome.com/#{@kit}.js\"></script>"
    end

    def self.kit(kit_id)
      k = new(kit: kit_id)
      k.safe(k.kit)
    end

    private

    def url
      "https://#{@subdomain}.fontawesome.com/releases/#{@version}/css/all.css"
    end
  end
end

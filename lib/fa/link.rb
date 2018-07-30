# frozen_string_literal: true

module FA
  # FontAwesome 5 (Pro) Helper for generating CDN links
  class Link < FA::Base
    # Outputs the CDN link.
    def initialize(version:, integrity:, pro: true)
      @version = version
      @integrity = integrity
      @subdomain = pro ? 'pro' : 'use'
    end

    # Outputs the formatted link directly.
    def raw
      "<link rel=\"stylesheet\" href=\"#{url}\" " \
      "integrity=\"#{@integrity}\" crossorigin=\"anonymous\">"
    end

    private

    def url
      "https://#{@subdomain}.fontawesome.com/releases/#{@version}/css/all.css"
    end
  end
end

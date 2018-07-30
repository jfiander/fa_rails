# frozen_string_literal: true

# FontAwesome 5 (Pro) Helper
#
# @author Julian Fiander
# @since 0.1.0
module FA
  require 'fa/base'
  require 'fa/icon'
  require 'fa/span'
  require 'fa/layer'

  def fa_cdn_link(version:, integrity:, pro: true)
    subdomain = pro ? 'pro' : 'use'
    url = "https://#{subdomain}.fontawesome.com/releases/#{version}/css/all.css"

    "<link rel=\"stylesheet\" href=\"#{url}\" " \
    "integrity=\"#{integrity}\" crossorigin=\"anonymous\">"
  end
end

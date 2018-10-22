require 'settingslogic'

module Cssz

  def self.config_file
    ENV.fetch('CSSZ_CONFIG_FILE') { Rails.root.join('config', 'cssz.yml') }
  end

  class Settings < ::Settingslogic
    source (File.exists?(Cssz.config_file) ? Cssz.config_file : {})

    # namespace Rails.env
  end
end

require 'cssz/service'
require 'cssz/request'

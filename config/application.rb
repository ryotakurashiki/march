require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module March
  class Application < Rails::Application
    config.active_record.default_timezone = :local
    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Avoid "Circular dependency detected while autoloading constant" Error
    #config.autoload_paths += %W(#{config.root}/lib)
    config.eager_load_paths += %W(#{config.root}/lib/)
    config.eager_load_paths += %W(#{config.root}/app/models/MediumArtistRelation.rb)
    config.eager_load_paths += %W(#{config.root}/app/models/Artist.rb)
    config.eager_load_paths += %W(#{config.root}/app/models/AppearanceArtist.rb)
  end
end

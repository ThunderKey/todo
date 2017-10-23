require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Todo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    if ENV['TRAVIS'] != 'true'
      # Attempt to read encrypted secrets from `config/secrets.yml.enc`.
      # Requires an encryption key in `ENV["RAILS_MASTER_KEY"]` or
      # `config/secrets.yml.key`.
      config.read_encrypted_secrets = true
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

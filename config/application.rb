require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
module BillingSystem
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Auto load libs
    config.autoload_paths << Rails.root.join('lib')

    # Handle 404, 442, 500 exceptions by ourself, check app/controllers/errors_controller.rb
    config.exceptions_app = self.routes

    # Prepare overrides
    overrides = "#{Rails.root}/app/overrides"
    Rails.autoloaders.main.ignore(overrides)
    config.to_prepare do
      Dir.glob("#{overrides}/**/*_override.rb").each do |override|
        load override
      end
    end

    # Auto correct rubocop
    config.generators.after_generate do |files|
      system("bundle exec rubocop -A --fail-level=E #{files.shelljoin}", exception: true)
    end
  end
end

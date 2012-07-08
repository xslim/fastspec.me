# Load the rails application
require File.expand_path('../application', __FILE__)

APP_CONFIG = (YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env] rescue ENV)

# Initialize the rails application
Fastspec::Application.initialize!

# Load the rails application
require File.expand_path('../application', __FILE__)

APP_CONFIG = (YAML.load_file("#{Rails.root}/../config/fastspec.yml")[Rails.env] rescue nil)

# Initialize the rails application
Fastspec::Application.initialize!

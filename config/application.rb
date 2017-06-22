require_relative "boot"

require "rails/all"

require File.expand_path("../boot", __FILE__)

Bundler.require(*Rails.groups)

module RailsTutorial
  class Application < Rails::Application
    config.load_defaults 5.1
  end
end

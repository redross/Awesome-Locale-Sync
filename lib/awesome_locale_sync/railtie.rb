require 'awesome_locale_sync'
require 'rails'
module AwesomeLocaleSync
  class Railtie < Rails::Railtie
    railtie_name :awesome_locale_sync

    rake_tasks do
      load "tasks/sync.rake"
    end
  end
end
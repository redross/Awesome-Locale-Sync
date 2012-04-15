namespace :locales do
  desc 'Sync locales'
  task :sync => :environment do
    AwesomeLocaleSync::AwesomeLocaleSync.new.sync
  end
end
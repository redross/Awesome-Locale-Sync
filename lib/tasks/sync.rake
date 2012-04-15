namespace :locales do
  desc 'Sync locales'
  task :sync => :environment do
    LocaleSync.new.sync
  end
end
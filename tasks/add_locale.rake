namespace :locales do
  desc 'Sync locales'
  task :add_locale => :environment do
    puts "Not implemented yet"
    return true
    LocaleSync.new.sync
  end
end
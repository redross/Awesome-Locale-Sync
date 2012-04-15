require 'yaml'
require 'ya2yaml'
require "awesome_locale_sync/version"
require "awesome_locale_sync/hash"
require "awesome_locale_sync/array"
require "awesome_locale_sync/ya2yaml"
Dir["tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)

module AwesomeLocaleSync
  class AwesomeLocaleSync
    def self.tag_updated(value, tag)
      value.to_s.gsub(/\[Updated! TO \(.*\)\]$/, '') + "[Updated! TO (#{tag})]"
    end

    def init_base_locale(options = {})
      base_locale_file = Rails.root.join('config', 'locales', 'base_locale', 'base.yml')
      unless FileTest.exists?(base_locale_file) and not options[:reset]
        puts "Refreshing base locale file"
        base_hash = {'base' => default_translations }
        File.open(base_locale_file, 'w') do |file|
          file.write(base_hash.to_yaml)
        end
      end
    end

    def sync
      init_base_locale

      main_locale = I18n.default_locale.to_s
      main_hash = {:en => default_translations(main_locale) }

      empty_hash = main_hash.prune_leafs('[MISSING_TRANSLATION]', true).first.last
      I18n.load_path.select { |path| path =~ /#{Rails.root}.*\/.{2}\.yml$/ }.each do |f|
        next if f =~ /#{main_locale}.yml/

        locale, foreign_hash = YAML::load(File.read(f)).first
        merged_hash = { locale => empty_hash.deep_subtract(foreign_hash, true).detect_diff(base_translations, default_translations(main_locale)) }

        new_file = f.gsub(/.yml/) { |locale| ".yml" }
        File.open(new_file, "w") do |file|
          puts "#{Pathname(f).basename} => #{Pathname(new_file).basename}"
          file.write(merged_hash.ya2yaml)
        end
      end

      init_base_locale(:reset => true)
    end

    def default_translations(locale = I18n.default_locale.to_s)
      puts "Using #{locale} as reference locale"

      I18n.backend.send(:init_translations)
      I18n.backend.send(:translations)[locale.to_sym].deep_stringify_keys
    end

    def base_translations
      base_locale_file = Rails.root.join('config', 'locales', 'base_locale', 'base.yml')
      YAML::load(File.read(base_locale_file)).first.last
    end

    def self.add_new_locale(name)
      locale_file_path = Rails.root.join("config/locales/#{name}.yml")
      unless FileTest.exists?(locale_file_path)
        File.open(locale_file_path, "w") do |file|
          puts "Creating new locale file #{name}.yml"
          encoded_name = name.to_s.encode(Encoding::UTF_8)
          file.write({ encoded_name => {"locale_name".encode(Encoding::UTF_8) => encoded_name}}.ya2yaml)
        end
        I18n.load_path += Dir[Rails.root.join('config', 'locales', "#{name}.yml").to_s]
        true
      else
        puts "Locale file already exists. Exiting.."
        false
      end
    end
  end
end

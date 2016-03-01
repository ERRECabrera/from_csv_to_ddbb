require 'yaml'
require 'pry'

require_relative './../backup_csv/folder.rb'
require_relative './../backup_csv/csv_file.rb'

namespace :csv do
  desc "create models from csv backup files"
  task create_models: :environment do
    _PATH_YML = "lib/backup_csv/paths.yml"
    paths = YAML.load_file(_PATH_YML)
    files = Folder.new(paths['path']['csv']).load
    files.each do |file|
      model = Csv_File.new(file)
      if !check_model_exist(model.name,paths['path']['models'])
        attributes = ''
        keys = model.keys
        header_csv = model.keys_with_datatype
        keys.each {|attribute| attributes += "#{attribute}:#{header_csv[attribute]} "}
        puts "rails generate scaffold #{model.name} #{attributes}"
      end
    end
  end

  desc "restore bbdd from csv backup files"
  task restore_datas: :environment do
  end

end

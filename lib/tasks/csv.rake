require 'yaml'
require 'pry'

require_relative './../backup_csv/folder.rb'
require_relative './../backup_csv/csv_file.rb'
require_relative './../backup_csv/model_file.rb'

namespace :csv do
  desc "create models from csv backup files"
  task create_models: :environment do
    _PATH_YML = "lib/backup_csv/paths.yml"
    paths = YAML.load_file(_PATH_YML)
    csv_files = Folder.new(paths['path']['csv']).load
    csv_files.each do |file|
      csv = Csv_File.new(file)
      if !check_if_model_exist(csv.name,paths['path']['models'])
        attributes = ''
        keys = csv.keys
        datatypes = csv.keys_with_datatype
        header_csv = csv.keys_with_datatype
        keys.each {|attribute| attributes += "#{attribute}:#{header_csv[attribute]} "}
        system "rails generate scaffold #{csv.name} #{attributes}"
        models = Folder.new(paths['path']['models']).load
        models.each do |model|
          Model.new(datatypes).add_validation_presence_to(model)
        end
      else
        puts "> model #{csv.name} already exists!"
      end
    end
  end

  desc "restore bbdd from csv backup files"
  task restore_datas: :environment do
    _PATH_YML = "lib/backup_csv/paths.yml"
    paths = YAML.load_file(_PATH_YML)
    csv_files = Folder.new(paths['path']['csv']).load
    csv_files.each do |file|
      csv = Csv_File.new(file)
      data_instances = csv.datas
      data_instances.each_with_index do |data_instance,index|
        if Model.new(nil,data_instance).create(csv.name)
          puts "-Instance#{index} was saved!"
        else
          puts "-Instance#{index} was not saved!"
        end
      end
    end
  end

end

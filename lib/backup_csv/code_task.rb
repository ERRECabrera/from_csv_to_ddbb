require 'pry'

require_relative 'folder.rb'
require_relative 'csv_file.rb'

#_PATH_CSV = "db/backup_csv/*.csv"
_PATH_CSV = "../../db/backup_csv/*.csv"
_PATH_MODEL = "../../app/models/*.rb"

#file = 'hoja_de_calculo.csv'
files = Folder.new(_PATH_CSV).load
files.each do |file|
  example = Csv_File.new(file)
  puts check_model_exist(example.name,_PATH_MODEL)
  puts example.keys_with_datatype
  #puts example.datas
end


require 'csv'
require_relative 'helpers.rb'

class Csv_File

  attr_reader :name, :keys, :keys_with_datatype, :datas

  def initialize(file)
    @file = file
    @name = split_file_name(file)
    @csv = CSV.read(file, col_sep: ';')
    @keys = get_keys_from_csv_header
    @keys_with_datatype = return_hash_with_key_and_datatype
    @datas = get_data_rows
  end

  private

  def get_keys_from_csv_header
    header = @csv[0]
    @keys = header.map do |key|
      key.downcase.gsub(' ','_')
    end
  end

  def get_data_rows
    data_instances = []
    @csv.shift
    rows_datas = @csv
    rows_datas.each do |row|
      row.each_with_index do |celd,index|
        datas = {}
        datas[@keys[index]] = celd
        data_instances << datas
      end
    end
    return data_instances
  end

  def return_type_of(data)
    case data
    when /\A\d{2}\/\d{2}\/\d{2}\z/
      return 'date'
    when /(\Asi\z|\Así\z|\Ano\z)/i
      return 'boolean'
    else
      return 'string'
    end
  end

  def get_datatypes_from_csv_row
    type_of_datas = []
    row = @csv[1]
    row.each {|celd| type_of_datas << return_type_of(celd)}
    return type_of_datas
  end

  def return_hash_with_key_and_datatype
    hash = {}
    type_of_datas = get_datatypes_from_csv_row
    @keys.each_with_index {|key,index| hash[key] = type_of_datas[index]}
    return hash
  end

end
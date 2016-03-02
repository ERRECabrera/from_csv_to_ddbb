require 'csv'
require_relative 'helpers.rb'

class Csv_File

  attr_reader :name, :keys, :keys_with_datatype, :datas

  def initialize(file)
    @lang = 'es'
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
    keys = []
    chars = set_chars_to_change
    header.map do |key|
      chars.each {|c| key = key.downcase.gsub(c[0],c[1])}
      keys << key
    end
    return keys
  end

  def set_chars_to_change
    chars_base = [[' ','_']]
    es_chars = [['á','a'],['é','e'],['í','i'],['ó','o'],['ú','u']]
    chars_to_change = (@lang == 'es')? chars_base + es_chars : chars_base
  end

  def get_data_rows
    data_instances = []
    @csv.shift
    rows_datas = @csv
    rows_datas.each do |row|
      row_instance = []
      datas = {}
      row.each_with_index do |celd_data,index|
        case return_type_of(celd_data)
          when 'date'
            date = celd_data.split('/')
            datas[@keys[index]] = (@lang == 'es')? Date.new(('20'+date[2]).to_i,date[1].to_i,date[0].to_i) : nil
          when 'boolean'
            datas[@keys[index]] = (celd_data.downcase =~ /\As/)? true : false
          else
            datas[@keys[index]] = celd_data    
        end
      end
      row_instance << datas
      data_instances << row_instance
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
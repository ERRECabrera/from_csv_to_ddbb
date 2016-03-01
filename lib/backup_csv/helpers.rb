def split_file_name(file)
  name = file.split('.')[-2].split('/')[-1]
end

def check_model_exist(file_name,path)
  files = Folder.new(path).load
  found = files.find {|f| split_file_name(f) == file_name}
  return found ? true : false
end
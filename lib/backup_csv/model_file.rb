def add_validation_presence_to(model,attributes)
  ruby_code = ''
  f = File.open(model,"r")
  lines = f.readlines
  ruby_code += lines[0]
  attributes.each {|attribute| ruby_code += "  validates :#{attribute}, presence: true\n"}
  ruby_code += lines[-1]
  File.write(model,ruby_code)
end
class Model

  attr_accessor :attributes

  def initialize(keys_with_datatype,attributes=nil)
    @keys = keys_with_datatype
    @attributes = attributes    
  end

  def add_validation_presence_to(model)
    ruby_code = ''
    f = File.open(model,"r")
    lines = f.readlines
    ruby_code += lines[0]
    @keys.each {|key,value| ruby_code += (value != 'boolean')? "  validates :#{key}, presence: true\n" : "  validates_inclusion_of :#{key}, :in => [true, false]\n"}
    ruby_code += lines[-1]
    File.write(model,ruby_code)
  end

  def create(model_name)
    model = model_name.capitalize
    new_instance = eval("#{model}.new")
    attributes = @attributes[0].to_a
    attributes.each {|attribute| new_instance[attribute[0]] = attribute[1]}
    new_instance.save
  end

end




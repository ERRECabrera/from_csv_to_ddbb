class Folder

  attr_reader :load

  def initialize(path)
    @load = Dir[path]
  end
  
end
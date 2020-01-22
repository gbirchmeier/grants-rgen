class Model
  attr_reader :name, :attributes, :associations

  def initialize(name)
    @name = name
    @attributes = []
    @associations = []
  end
end

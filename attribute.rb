class Attribute
  attr_reader :name, :datatype, :nullable, :unique

  def initialize(name, datatype, nullable: true, unique: false, factory_sequence: false)
    @name = name
    @datatype = datatype
    @nullable = !!nullable
    @unique = !!unique
    @factory_sequence: !!factory_sequence
  end
end

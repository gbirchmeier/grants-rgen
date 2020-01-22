class Rgen::Struct::Attribute
  attr_reader :name, :datatype, :presence, :unique, :factory_sequence

  def initialize(name, datatype, presence: false,
                                 unique: false,
                                 factory_sequence: false)
    @name = name
    @datatype = datatype
    @presence = !!presence
    @unique = !!unique
    @factory_sequence = !!factory_sequence
  end
end

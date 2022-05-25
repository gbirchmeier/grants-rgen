class Rgen::Struct::Model
  attr_reader :name, :attributes, :belong_tos, :enums

  def self.from_hash(input)
    inp = input['model'] or raise "expected to find top-level yaml key 'model'"

    name = inp['name'] or raise "can't find a model name"
    rv = Rgen::Struct::Model.new(name)

    inp['attributes']&.each do |k,v|
      rv.attributes << Rgen::Struct::Attribute.create(k, v)
    end
    inp['belongs_to']&.each do |k,v|
      rv.belong_tos << Rgen::Struct::BelongTo.create(k, v || {})
    end

    rv
  end

  def initialize(name)
    raise "model/name must be CamelCase" if /^[a-z]/.match(name[0])
    @name = name
    @attributes = []
    @belong_tos = []
  end
end

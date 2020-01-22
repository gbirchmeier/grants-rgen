require 'pry'
require_relative 'lib/rgen'

model = Rgen::Struct::Model.new('DrugCompany')

model.belong_tos << Rgen::Struct::BelongTo.new('region', optional: true, plural_inverse: true)

model.attributes << Rgen::Struct::Attribute.new('name', 'string',
                      presence: true, unique: true, factory_sequence: true)


mogen = Rgen::Gen::ModelGenerator.new

puts mogen.generate(model)

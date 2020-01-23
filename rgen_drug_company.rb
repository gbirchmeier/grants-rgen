require 'pry'
require_relative 'lib/rgen'

model = Rgen::Struct::Model.new('DrugCompany')

model.belong_tos << Rgen::Struct::BelongTo.new('region', optional: true, plural_inverse: true)

model.attributes << Rgen::Struct::Attribute.new('name', 'string',
                      presence: true, unique: true, factory_sequence: true)


mogen = Rgen::Gen::ModelGenerator.new
#puts mogen.generate(model)
#puts "--"
#puts

specgen = Rgen::Gen::SpecGenerator.new
#puts specgen.generate(model)

factorygen = Rgen::Gen::FactoryGenerator.new
#puts factorygen.generate(model)

aagen = Rgen::Gen::ActiveAdminGenerator.new
#puts aagen.generate(model)

mcgen = Rgen::Gen::MigrationCommandGenerator.new
puts mcgen.generate(model)

require 'pry'
require_relative 'lib/rgen'
require 'active_support/inflector'

model = Rgen::Struct::Model.new('Order')

model.belong_tos << Rgen::Struct::BelongTo.new('drug_instrument', optional: false, plural_inverse: true)
model.belong_tos << Rgen::Struct::BelongTo.new('organization', optional: false, plural_inverse: true)

model.attributes << Rgen::Struct::Attribute.new('amount', 'integer', presence: true) # todo >0
model.attributes << Rgen::Struct::Attribute.new('state', 'integer', presence: true)


mogen = Rgen::Gen::ModelGenerator.new
specgen = Rgen::Gen::SpecGenerator.new
factorygen = Rgen::Gen::FactoryGenerator.new
aagen = Rgen::Gen::ActiveAdminGenerator.new
mcgen = Rgen::Gen::MigrationCommandGenerator.new

mopath = "app/models/#{model.name.underscore}.rb"
specpath = "spec/models/#{model.name.underscore}_spec.rb"
factorypath = "spec/factories/#{model.name.pluralize.underscore}.rb"
aapath = "app/admin/#{model.name.pluralize.underscore}.rb"

puts "Writing files:"

File.write(mopath, mogen.generate(model))
File.write(specpath, specgen.generate(model))
File.write(factorypath, factorygen.generate(model))
File.write(aapath, aagen.generate(model))

puts "Here's your migration command:"
puts
puts "  mcgen.generate(model)"
puts
puts "NOTE: don't forget to add default values to the migration"

# gvim -o db/migrate/20200123184347_create_orders.rb app/models/order.rb spec/models/order_spec.rb spec/factories/orders.rb app/admin/orders.rb

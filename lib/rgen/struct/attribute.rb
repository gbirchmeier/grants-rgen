class Rgen::Struct::Attribute
  attr_reader :name, :datatype, :presence, :unique, :factory_sequence

  def self.create(name, settings)
    datatype = find_datatype(settings)
    raise "can't be both optional AND required" if settings.include?('optional') && settings.include?('required')
    raise 'only strings can have factory_sequence' if settings.include?('factory_sequence') && !settings.include?('string')

    Rgen::Struct::Attribute.new(name,
      datatype,
      presence: settings.include?('required'),
      unique: settings.include?('unique'),
      factory_sequence: settings.include?('factory_sequence'))
  rescue => e
    raise #need custom errors
  end

  def self.find_datatype(settings)
    found = %w[string integer decimal boolean].select {|typ| settings.include?(typ)}
    raise "attribute has conflicting datatypes" if found.count > 1
    raise "attribute does not have a recognized datatype" if found.count==0
    found.first
  end

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

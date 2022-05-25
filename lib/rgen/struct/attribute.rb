class Rgen::Struct::Attribute
  attr_reader :name, :datatype, :presence, :unique, :factory_sequence, :enums

  def self.create(name, settings_string)
    enums = nil
    if settings_string.start_with?('enum')
      # extract bracketed section, then remove from settings_string
      # (regex is a gross thing from the internet that I don't totally understand.
      #  I may rewrite later.)
      matchdata = enum_string = settings_string.match /(?<=\[).*?(?=\])/
      if matchdata
        settings_string.sub!(/(?<=\[).*?(?=\])/, '')
        settings_string.sub!('[]', '')
        enums = matchdata[0].split(',').collect(&:strip)
      end
    end

    settings = settings_string.split(' ')

    datatype = find_datatype(settings)
    raise "can't be both optional AND required" if settings.include?('optional') && settings.include?('required')
    raise 'only strings can have factory_sequence' if settings.include?('factory_sequence') && !settings.include?('string')

    Rgen::Struct::Attribute.new(name,
      datatype,
      presence: settings.include?('required'),
      unique: settings.include?('unique'),
      factory_sequence: settings.include?('factory_sequence'),
      enums: enums
    )

  rescue => e
    raise #need custom errors
  end

  def self.find_datatype(settings)
    found = %w[string integer decimal boolean enum].select {|typ| settings.include?(typ)}
    raise "attribute does not have a recognized datatype" if found.count==0
    found.first
  end

  def initialize(name, datatype, presence: false,
                                 unique: false,
                                 factory_sequence: false,
                                 enums: nil)
    @name = name
    @datatype = datatype
    @presence = !!presence
    @unique = !!unique
    @factory_sequence = !!factory_sequence
    @enums = enums
  end
end

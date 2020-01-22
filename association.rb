class Association
  attr_reader :model, :unique, :nullable

  def initialize(model, unique: false, nullable: true)
    @model = model
    @unique = !!unique
    @nullable = !!nullable
  end
end

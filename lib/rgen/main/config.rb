class Rgen::Main::Config
  attr_reader :filegens, :stdouts

  def self.from_hash(input)
    filegen_hash = input['destinations'] || {}
    stdout_hash = input['stdout'] || {}
    Rgen::Main::Config.new(filegen_hash, stdout_hash)
  end


  def initialize(filegen_hash, stdout_hash)
    @filegens = filegen_hash
    @stdouts = stdout_hash
  end
end

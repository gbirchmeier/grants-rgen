require 'psych'

class Rgen::Main::Runner
  def self.run(model_config)
    target_file = File.join(Dir.pwd, model_config)
    target_dir = File.dirname(target_file)
    config_file = File.join(target_dir, "rgen.config.yaml")

    unless File.exist?(target_file) && File.exist?(target_file)
      raise "target file not found or can't be read: #{target_file}"
    end

    unless File.exist?(config_file) && File.exist?(config_file)
      raise "target file not found or can't be read: #{config_file}"
    end

    config = Rgen::Main::Config.from_hash(Psych.load_file(config_file))
    model = Rgen::Struct::Model.from_hash(Psych.load_file(target_file))

    config.filegens.each do |name, destination|
      fullpath = destination.start_with?('/') ? destination : File.join(target_dir, destination)
      generate_file(name, fullpath, model)
    end

    puts "\n" unless config.stdouts.empty?
    config.stdouts.each do |name|
      generate_stdout(name, model)
    end
  end

  def self.generate_file(name, destination, model)
    generator = get_file_generator(name)
    puts "Generating #{name}:"
    unless Dir.exist?(destination) && File.writable?(destination)
      raise "  ERROR: Destination dir does not exist or is not writable: #{destination}"
    end
    fullfilename = generator.generate_file(model, destination)
    puts "  wrote: #{fullfilename}"
  end

  def self.generate_stdout(name, model)
    generator = get_stdout_generator(name)
    puts generator.generate_stdout(model)
  end

  def self.get_file_generator(name)
    case name
    when 'rails_model'
      Rgen::Gen::ModelGenerator.new
    when 'rspec'
      Rgen::Gen::SpecGenerator.new
    when 'factory_bot'
      Rgen::Gen::FactoryGenerator.new
    when 'active_admin'
      Rgen::Gen::ActiveAdminGenerator.new
    else
      raise "unknown file generator: #{name}"
    end
  end

  def self.get_stdout_generator(name)
    case name
    when 'migration_cmd'
      Rgen::Gen::MigrationCommandGenerator.new
    else
      raise "unknown stdout generator: #{name}"
    end
  end
end

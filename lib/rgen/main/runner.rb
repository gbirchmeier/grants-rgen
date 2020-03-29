require 'psych'

class Rgen::Main::Runner
  def self.run(model_config)
    target_file = File.join(Dir.pwd, model_config)
    target_dir = File.dirname(target_file)
    config_file = File.join(target_dir, "rgen.config.yaml")

    unless File.exists?(target_file) && File.exists?(target_file)
      raise "target file not found or can't be read: #{target_file}"
    end

    unless File.exists?(config_file) && File.exists?(config_file)
      raise "target file not found or can't be read: #{config_file}"
    end

#    config_yaml_hash = Psych.load_file(config_file)

    model = Rgen::Struct::Model.from_hash(Psych.load_file(target_file))
require 'pry'
binding.pry
  end
end

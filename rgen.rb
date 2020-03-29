require_relative 'lib/rgen'

def desc
  <<DESC
Usage:
  ruby -I lib rgen.rb <model_config>
  IMPORTANT: This looks for "rgen.config" in the same directory as <model_config>,
             and will error out if it doesn't find it.
DESC
end

if ARGV.count < 1 || ARGV.include?('-h') || ARGV.include?('--help')
  puts desc
  exit(0)
end

if ARGV.count > 1
  puts "** Too many args.  Only one model-config allowed at a time."
  puts desc
end

Rgen::Main::Runner.run(ARGV.shift)

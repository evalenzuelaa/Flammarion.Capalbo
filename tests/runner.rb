require 'optparse'
require_relative "../lib/flammarion.rb"

$options = {}

def options; $options; end

OptionParser.new do |o|
  {
    # '-a' => :all,
    # '-p' => :parallel,
    '-r' => :reload
  }.each do |k,v|
    o.on(k) {|p| options[v] = p}
  end
  o.parse!
end

def sample(name)
  return if ARGV[0] and name.to_s != ARGV[0]
  puts "Showing: #{name}"
  f = Flammarion::Engraving.new(title:name.to_s.split("_").collect{|w| w[0] = w[0].upcase; w}.join(" "))
  yield(f)
  if options[:reload] then
    f.on_connect = Proc.new {yield(f)}
    sleep 1000 while true
  else
    f.wait_until_closed
  end
end

require_relative "samples.rb"

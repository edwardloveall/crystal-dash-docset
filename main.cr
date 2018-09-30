require "./crystal-docset-generator"

if ARGV.empty?
  puts "Please supply a version:"
  puts "./crystal-docset-generator 0.1.2"
  exit(1)
end

Cdg::Generator.new(version: ARGV[0]).generate!

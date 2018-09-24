require "./crystal-docset-generator"

Cdg::Generator.new(version: ARGV[0]).generate!

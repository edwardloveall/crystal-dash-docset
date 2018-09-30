require "http"
require "json"
require "habitat"
require "sqlite3"
require "./crystal-docset-generator/types/*"
require "./crystal-docset-generator/*"

Cdg.configure do |settings|
  settings.online_path = "https://crystal-lang.org/api/"
  settings.docset_path = "crystal.docset"
  settings.resource_path = "#{settings.docset_path}/Contents/Resources"
  settings.docs_path = "#{settings.resource_path}/Documents"
end

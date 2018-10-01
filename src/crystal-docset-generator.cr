require "http"
require "json"
require "habitat"
require "sqlite3"
require "./crystal-docset-generator/*"

Cdg.configure do |settings|
  settings.online_path = "https://crystal-lang.org/api/"
  settings.docset_path = "crystal.docset"
  settings.resource_path = "#{settings.docset_path}/Contents/Resources"
  settings.docs_path = "#{settings.resource_path}/Documents"
  settings.db_path = "#{settings.resource_path}/docSet.dsidx"
  settings.db_url = "sqlite3://#{settings.db_path}"
end

require "./crystal-docset-generator"

begin
  Cdg::Generator.new.generate!
ensure
  Cdg.settings.db.close
end

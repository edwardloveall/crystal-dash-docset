module Cdg
  Habitat.create do
    setting version : String
    setting online_path : String
    setting docset_path : String
    setting resource_path : String
    setting docs_path : String
    setting db_path : String
    setting db_url : String
    setting db : DB::Database
  end
end

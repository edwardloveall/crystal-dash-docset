class Cdg::Generator
  ONLINE_PATH = "https://crystal-lang.org/api/"
  DOCSET_PATH = "crystal.docset"
  RESOURCE_PATH = "#{DOCSET_PATH}/Contents/Resources"
  DOCS_PATH = "#{RESOURCE_PATH}/Documents"

  # .program.types[49].path file path to download
  # .program.types[49].name name
  # .program.types[49].types[] namespaced classes

  def initialize(@version : String)
  end

  def generate!
    generate_db!
  end

  def generate_db!
    db_path = "#{Cdg.settings.resource_path}/docSet.dsidx"
    File.delete(db_path) if File.exists?(db_path)
    DB.open("sqlite3://#{db_path}") do |db|
      db.exec <<-SQL
        CREATE TABLE searchIndex(
          id INTEGER PRIMARY KEY,
          name TEXT,
          type TEXT,
          path TEXT
        );
        CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);
      SQL
    end
  end

  def json_index
    HTTP::Client.get("#{ONLINE_PATH}#{@version}/index.json").body
  end
end

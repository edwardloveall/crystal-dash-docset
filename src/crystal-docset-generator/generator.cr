class Cdg::Generator
  @top_level : Cdg::Types::Base
  @db : DB::Database?

  # .program.types[49].path file path to download
  # .program.types[49].name name
  # .program.types[49].types[] namespaced classes

  def initialize(@version : String)
    @top_level = Cdg::Types::Base.from_json(json_index, root: "program")
  end

  def generate!
    generate_db
    process_types
  end

  def generate_db
    db_path = Cdg.settings.db_path
    File.delete(db_path) if File.exists?(db_path)
    DB.open(Cdg.settings.db_url) do |db|
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
    HTTP::Client.get("#{Cdg.settings.online_path}/#{@version}/index.json").body
  end

  def process_types
    @top_level.types.each(&.process)
  end
end

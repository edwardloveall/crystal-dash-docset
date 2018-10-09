class Cdg::Generator
  @top_level : Cdg::Page

  def initialize(version : String)
    @top_level = Cdg::Page.from_json(json_index, root: "program")
    db_path = Cdg.settings.db_path
    File.delete(db_path) if File.exists?(db_path)
    Cdg.configure do |settings|
      settings.db = DB.open(Cdg.settings.db_url)
    end
  end

  def generate!
    generate_db
    process_types
  end

  def generate_db
    Cdg.settings.db.exec <<-SQL
      CREATE TABLE searchIndex(
        id INTEGER PRIMARY KEY,
        name TEXT,
        type TEXT,
        path TEXT
      );
      CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);
    SQL
  end

  def json_index
    url = "#{Cdg.settings.online_path}/0.26.1/index.json"
    HTTP::Client.get(url).body
  end

  def process_types
    @top_level.types.each(&.process)
  end
end

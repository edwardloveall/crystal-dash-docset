class Cdg::Generator
  @top_level : Cdg::Page

  def initialize
    @top_level = Cdg::Page.from_json(json_index, root: "program")
    db_path = Cdg.settings.db_path
    File.delete(db_path) if File.exists?(db_path)
    Utils.create_nested_dir(db_path)
    Cdg.configure do |settings|
      settings.db = DB.open(Cdg.settings.db_url)
    end
  end

  def generate!
    generate_db
    process_types
    copy_plist
    copy_stylesheet
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
    url = "#{Cdg.settings.online_path}/index.json"
    HTTP::Client.get(url).body
  end

  def process_types
    @top_level.types.each(&.process)
  end

  def copy_plist
    FileUtils.cp(
      "src/support/Info.plist",
      "#{Cdg.settings.docset_path}/Contents/"
    )
  end

  def copy_stylesheet
    css_path = "css/style.css"
    css_destination = "#{Cdg.settings.docs_path}/#{css_path}"
    css_url = "#{Cdg.settings.online_path}/#{css_path}"
    Utils.create_nested_dir(css_destination)
    css = HTTP::Client.get(css_url).body
    File.write(css_destination, css)
  end
end

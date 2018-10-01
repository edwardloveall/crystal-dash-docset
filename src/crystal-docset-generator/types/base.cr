class Cdg::Types::Base
  JSON.mapping(
    path: String,
    kind: String,
    name: String,
    types: Array(Base)
  )

  def process
    add_to_database
    puts "processed #{name}"
  end

  def add_to_database
    DB.open(Cdg.settings.db_url) do |db|
      sql = <<-SQL
        INSERT OR IGNORE INTO
          searchIndex(name, type, path)
          VALUES (?, ?, ?);
      SQL
      db.exec(sql, name, type_mapping[kind], path)
    end
  end

  private def type_mapping
    {
      "alias" => "Shortcut",
      "annotation" => "Annotation",
      "class" => "Class",
      "enum" => "Enum",
      "module" => "Module",
      "struct" => "Struct",
    }
  end
end

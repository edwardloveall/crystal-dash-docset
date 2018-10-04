class Cdg::Page
  JSON.mapping(
    path: String,
    kind: String,
    name: String,
    types: Array(Page)
  )

  def process
    add_to_database
    process_methods
    puts "Processed #{path}"
    process_subtypes
  end

  def add_to_database
    sql = <<-SQL
      INSERT OR IGNORE INTO
        searchIndex(name, type, path)
        VALUES (?, ?, ?);
    SQL
    Cdg.settings.db.exec(sql, name, type_mapping[kind], path)
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

  def process_subtypes
    types.each(&.process)
  end
end

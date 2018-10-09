class Cdg::Page
  @doc : Myhtml::Parser?
  @html : String?

  JSON.mapping(
    path: String,
    kind: String,
    name: String,
    types: Array(Page),
    class_methods: Array(Method),
    instance_methods: Array(Method),
    macros: Array(Macro),
  )

  def process
    add_to_database
    process_methods
    save_html
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

  def process_methods
    methods = class_methods + instance_methods + macros
    methods.each do |method|
      method.nillable_page = self
      method.process
    end
  end

  def process_subtypes
    types.each(&.process)
  end

  def save_html
    html_path = "#{Cdg.settings.docs_path}/#{path}"
    Utils.create_nested_dir(html_path)
    File.write(html_path, html_doc.to_html)
  end

  def html_doc
    @doc ||= Myhtml::Parser.new(html)
  end

  def html
    url = "#{Cdg.settings.online_path}/#{path}"
    @html ||= HTTP::Client.get(url).body
  end
end

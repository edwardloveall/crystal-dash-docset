class Cdg::Method
  JSON.mapping(
    id: String,
    name: String,
  )

  property nillable_page : Page?

  def type : String
    "Method"
  end

  def path
    escaped_id = URI.escape(id)
    "#{page.path}##{escaped_id}"
  end

  def process
    add_to_database
    insert_toc_anchor
  end

  def add_to_database
    sql = <<-SQL
      INSERT OR IGNORE INTO
        searchIndex(name, type, path)
        VALUES (?, ?, ?);
    SQL
    Cdg.settings.db.exec(sql, name, type, path)
  end

  def insert_toc_anchor
    doc = page.html_doc
    method_anchor = find_method_node_with_weird_id(id)
    dash_anchor = doc.tree.create_node(:a)
    dash_anchor.attribute_add("name", "//apple_ref/cpp/Method/#{escaped_name}")
    dash_anchor.attribute_add("class", "dashAnchor")

    method_anchor.insert_before(dash_anchor)
  end

  def page : Page
    if page = nillable_page
      page
    else
      raise <<-TEXT

        The #{self.class.name} for #{name} doesn't have a page associated with
        it. The thing is, it needs this page to get its full path. You can
        check the src/crystal-docset-generator/page.cr file, and start with the
        process_methods method to see what's up.

      TEXT
    end
  end

  private def find_method_node_with_weird_id(id)
    all_methods = doc.css(".entry-detail")
    all_methods.find { |node| node.attribute_by("id") == id }
  end

  private def escaped_name
    URI.escape(name)
  end
end

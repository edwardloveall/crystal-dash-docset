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
    sql = <<-SQL
      INSERT OR IGNORE INTO
        searchIndex(name, type, path)
        VALUES (?, ?, ?);
    SQL
    Cdg.settings.db.exec(sql, name, type, path)
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
end
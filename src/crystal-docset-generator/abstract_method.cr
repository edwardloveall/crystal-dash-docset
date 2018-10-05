abstract class Cdg::AbstractMethod
  JSON.mapping(
    id: String,
    name: String,
  )

  property nillable_page : Page?

  abstract def type : String
  abstract def path : String

  def process
    sql = <<-SQL
      INSERT OR IGNORE INTO
        searchIndex(name, type, path)
        VALUES (?, ?, ?);
    SQL
    Cdg.settings.db.exec(sql, name, type, path)
  end
end

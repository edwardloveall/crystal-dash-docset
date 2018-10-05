class Cdg::ClassMethod < Cdg::AbstractMethod
  def type : String
    "Method"
  end

  def path
    escaped_id = URI.escape(id)
    "#{page.path}##{escaped_id}"
  end
end

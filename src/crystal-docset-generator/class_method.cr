class Cdg::ClassMethod < Cdg::AbstractMethod
  def type : String
    "Method"
  end

  def path : String
    if page = nillable_page
      escaped_id = URI.escape(id)
      "#{page.path}##{escaped_id}"
    else
      raise <<-TEXT

        The #{self.class.name} for #{name} doesn't have a page associated with
        it. The thing is, it needs this page to get the path of the class it's
        attached to. You can check the src/crystal-docset-generator/page.cr
        file, and start with the process_methods method to see what's up.

      TEXT
    end
  end
end

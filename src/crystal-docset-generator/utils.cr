class Cdg::Utils
  def self.create_nested_dir(path : String)
    Dir.mkdir_p(File.dirname(path))
  end
end

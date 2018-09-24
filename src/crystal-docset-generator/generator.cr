class Cdg::Generator
  ONLINE_PATH = "https://crystal-lang.org/api/"
  DOCSET_PATH = "crystal.docset"
  RESOURCE_PATH = "#{DOCSET_PATH}/Contents/Resources"
  DOCS_PATH = "#{RESOURCE_PATH}/Documents"

  # .program.types[49].path file path to download
  # .program.types[49].name name
  # .program.types[49].types[] namespaced classes

  def initialize(@version : String)
  end

  def generate!
    json = json_index
    index = Cdg::Types::Index.from_json(json)
    puts index.program.types
  end

  def json_index
    HTTP::Client.get("#{ONLINE_PATH}#{@version}/index.json").body
  end
end

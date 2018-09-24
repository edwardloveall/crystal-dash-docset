class Cdg::Types::Base
  JSON.mapping(
    path: String,
    kind: String,
    name: String,
    types: Array(Base)
  )
end

json.array!(@pigs) do |pig|
  json.extract! pig, :id, :name, :amount
  json.url pig_url(pig, format: :json)
end

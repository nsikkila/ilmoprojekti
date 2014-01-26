json.array!(@projectbundles) do |projectbundle|
  json.extract! projectbundle, :id, :name, :description, :active
  json.url projectbundle_url(projectbundle, format: :json)
end

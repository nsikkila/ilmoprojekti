json.array!(@projects) do |project|
  json.extract! project, :id, :name, :description, :signup_start, :signup_end
  json.url project_url(project, format: :json)
end

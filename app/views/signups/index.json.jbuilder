json.array!(@signups) do |signup|
  json.extract! signup, :id, :student_id, :project_id
  json.url signup_url(signup, format: :json)
end

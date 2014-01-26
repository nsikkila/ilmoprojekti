json.array!(@users) do |user|
  json.extract! user, :id, :firstname, :lastname, :accesslevel
  json.url user_url(user, format: :json)
end

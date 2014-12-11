json.array!(@events) do |event|
  json.extract! event, :id, :deleted_at, :title, :uuid
  json.url event_url(event, format: :json)
end

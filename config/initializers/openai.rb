if Rails.env.production?
  OpenAI.configure do |config|
    config.access_token = ENV['OPENAI_API_KEY']
  end
else
  OpenAI.configure do |config|
    config.access_token = Rails.application.credentials.chatgpt_api_key
  end
end

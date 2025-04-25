Rails.application.config.x.gemini = {
  api_key: ENV["GEMINI_API_KEY"],
  default_model: "gemini-2.0-pro",
  models: {
    pro: "gemini-2.0-pro",
    flash: "gemini-2.0-flash"
  },
  endpoint_template: "https://generativelanguage.googleapis.com/v1beta/models/%{model}:generateContent"
}

Apipie.configure do |config|
  config.app_name                = 'UrlShortenerApi'
  config.api_base_url            = '/'
  config.doc_base_url            = '/docs'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.translate = false
  config.validate = false
end

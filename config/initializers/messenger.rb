Messenger.configure do |config|
  config.verify_token      = ENV['VERIFY_TOKEN'] #will be used in webhook verifiction
  config.page_access_token = ENV['PAGE_ACCESS_TOKEN']
end
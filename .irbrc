require "pry"
require "dotenv"
Dotenv.load

Newgistics.configure do |config|
  config.host_url = ENV.fetch('NEWGISTICS_API_URL', "https://apistaging.newgisticsfulfillment.com")
  config.api_key = ENV['NEWGISTICS_API_KEY']
end

module IntegrationHelpers
  def use_valid_api_key
    Newgistics.configuration.api_key = ENV['NEWGISTICS_API_KEY']
  end

  def use_invalid_api_key
    Newgistics.configuration.api_key = 'INVALID'
  end
end

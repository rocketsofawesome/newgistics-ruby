module FaradayHelpers
  def build_response(attributes = {})
    env = Faraday::Env.from(attributes)
    Faraday::Response.new(env)
  end
end

require "zendesk_api/client_dsl"

class ZendeskApi::Client
  include ZendeskApi::ClientDsl

  class Config
    attr_accessor :token, :username, :host, :logger
  end

  def self.build(&block)
    new(Config.new.tap(&block))
  end

  def initialize(config)
    @config = config
  end

  def auth_request(req)
    req.basic_auth("#{username}/token", token)
    http_client.request(req)
  end

  def logger
    @config.logger
  end

  protected
  def token
    @config.token
  end

  def username
    @config.username
  end

  def host
    @config.host
  end

  def http_client
    return @http_client if defined?(@http_client)

    @http_client = Net::HTTP.new(host, 443)
    @http_client.use_ssl = true
    @http_client
  end
end


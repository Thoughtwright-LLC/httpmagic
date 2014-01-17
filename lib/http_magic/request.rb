require 'net/http'
require 'json'

module HttpMagic
  # Encapsulating class to hold all of the infrastructure to make the actual
  # requests to the api. It receives at a minimum a HttpMagic::Uri object which
  # manages the url building.
  #
  # == Example
  #
  #   uri_object = HttpMagic::Uri.new('http://example.com')
  #
  #   request = Request.new(uri_object)
  #
  #   request.get
  #   => { 'name' => 'Foo Bar' }
  class Request
    def initialize(uri, options = {})
      @uri = uri
      @data = options[:data] || {}
      @options = {
        headers: options[:headers] || {}
      }
    end

    # Makes a GET request to the url provided by the Uri object and returns the
    # resulting JSON data as a Ruby hash.
    #
    # == Example
    #
    #   uri_object = HttpMagic::Uri.new('http://example.com')
    #
    #   request = Request.new(uri_object)
    #
    #   request.get
    #   => { 'name' => 'Foo Bar' }
    def get
      send_request :get
    end

    # Makes a POST request to the url provided by the Uri object and returns the
    # resulting JSON data as a Ruby hash. If data was provided as an optional
    # initialization parameter, then that is also POSTed.
    #
    # == Example
    #
    #   uri_object = HttpMagic::Uri.new('http://example.com')
    #
    #   request = Request.new(uri_object, data: { name: 'New Foo' })
    #
    #   request.post
    def post
      if !@data.empty?
        @options[:headers].merge!( 'content-type' => 'application/json' )
      end

      send_request :post
    end

    private

    def http
      return @http unless @http.nil?
      @http = Net::HTTP.new(@uri.domain, 443)
      @http.use_ssl = true
      @http
    end

    def send_request(method)
      response = http.send_request(method, @uri.urn, @data.to_json, @options[:headers])
      if response && response.is_a?(Net::HTTPSuccess)
        if response.content_type == 'application/json'
          JSON.parse(response.body)
        else
          response.body
        end
      else
        nil
      end
    end
  end
end

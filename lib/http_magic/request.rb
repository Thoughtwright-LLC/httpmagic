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

    # Makes a DELETE request to the url provided by the Uri object and returns
    # the response parsed according to the content type specified in the
    # repsonse.
    #
    # == Example
    #
    #   uri_object = HttpMagic::Uri.new('http://example.com')
    #
    #   request = Request.new(uri_object)
    #
    #   request.delete
    #   => { 'name' => 'Foo Bar' }
    def delete
      parse_response http.delete(@uri.urn, @options[:headers])
    end

    # Makes a GET request to the url provided by the Uri object and returns the
    # response parsed according to the content type specified in the repsonse.
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
      parse_response http.request_get(@uri.urn, @options[:headers])
    end

    # Makes a POST request to the url provided by the Uri object and returns the
    # response parsed according to the content type specified in the repsonse.
    # If data was provided as an optional initialization parameter, then that is
    # also POSTed.
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
        @options[:headers].merge!( 'Content-Type' => 'application/json' )
      end

      parse_response http.request_post(
        @uri.urn,
        @data.to_json,
        @options[:headers]
      )
    end

    # Makes a PUT request to the url provided by the Uri object and returns the
    # response parsed according to the content type specified in the repsonse.
    # If data was provided as an optional initialization parameter, then that is
    # also PUTed.
    #
    # == Example
    #
    #   uri_object = HttpMagic::Uri.new('http://example.com')
    #
    #   request = Request.new(uri_object, data: { name: 'New Foo' })
    #
    #   request.put
    def put
      if !@data.empty?
        @options[:headers].merge!( 'Content-Type' => 'application/json' )
      end

      parse_response http.request_put(
        @uri.urn,
        @data.to_json,
        @options[:headers]
      )
    end

    private

    def http
      return @http unless @http.nil?
      @http = Net::HTTP.new(@uri.domain, 443)
      @http.use_ssl = true
      @http
    end

    def parse_response(response)
      if response && response.is_a?(Net::HTTPSuccess)
        if response.body && response.content_type == 'application/json'
          JSON.parse(response.body)
        else
          response.body.to_s
        end
      else
        nil
      end
    end
  end
end

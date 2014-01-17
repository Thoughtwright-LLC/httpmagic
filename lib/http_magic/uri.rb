
module HttpMagic
  # Helper class that holds the parts of the URI and provides methods to put
  # them together.
  #
  # == Example
  #
  #   uri = HttpMagic::Uri.new('example.com')
  #   uri.build
  #   => "https://example.com/"
  #
  #   uri.namespace = 'api/v2'
  #   uri.build
  #   => "https://example.com/api/v2"
  #
  #   uri.parts = ['path']
  #   uri.build
  #   => "https://example.com/api/v2/path"
  #
  class Uri
    attr_accessor :namespace, :parts

    attr_reader :domain

    def initialize(domain)
      @domain = domain
      @parts = []
    end

    # Builds a full uniform resource identifier.
    #
    # == Example
    #
    #   uri = HttpMagic::Uri.new('example.com')
    #   uri.namespace = 'api/v1'
    #   uri.parts = %w(foo bar)
    #
    #   uri.urn
    #   => "https://example.com/api/v1/foo/bar"
    def build
      "#{url}#{urn}"
    end

    # Uniform resource locator based on @domain value.
    #
    # == Example
    #
    #   uri = HttpMagic::Uri.new('example.com')
    #
    #   uri.url
    #   => "https://example.com/"
    #
    #   uri.url(false)
    #   => "https://example.com"
    def url
      "https://#{@domain}"
    end

    # Uniform resource name for a resource.
    #
    # == Example
    #
    #   uri = HttpMagic::Uri.new('example.com')
    #   uri.namespace = 'api/v1'
    #   uri.parts = %w(foo bar)
    #
    #   uri.urn
    #   => "/api/v1/foo/bar"
    def urn
      resource_name = [@namespace, @parts].flatten.compact.join('/')
      "/#{resource_name}"
    end
  end
end

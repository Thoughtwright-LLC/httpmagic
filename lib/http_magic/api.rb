require 'json'
require 'http_magic/uri'
require 'http_magic/request'

module HttpMagic
  # A magical class that interacts with HTTP resources with a minimal amount of
  # configuration.
  #
  # Assuming an api where the url http://www.example.com/api/v1/foo/99 responds
  # with the following.
  #
  # Header:
  #
  #   Content-Type: application/json
  #
  # Body:
  #
  #   {
  #     "name": "Foo Bar"
  #   }
  #
  # == Example
  #
  #   class ExampleApi < HttpMagic::Api
  #     url 'www.example.com'
  #     namespace 'api/v1'
  #     headers({'X-AuthToken' => 'token'})
  #   end
  #
  #   ExampleApi.foo[99].get['name']
  #   => "Foo Bar"
  #
  #   ExampleApi.foo.create.post(name: 'New Foo')
  #   => { 'name' => 'New Foo' }
  class Api < BasicObject
    # Makes the new method private so that instances of this class and it's
    # children can only be instantiated through the class method method_missing.
    # This is needed to enforce the intended usage of HttpMagic where the class
    # is configured to represent an http location. Once it is configured, the
    # location is interacted with dynamically with chained methods that correspond
    # with parts of URNs found at the location.
    class << self
      private :new
    end

    # Sets or returns the request headers for an HttpMagic based class. The
    # headers will be passed along to each resource request being made.
    #
    # == Example
    #
    #   class ExampleApi < HttpMagic:Api
    #     url 'www.example.com'
    #     headers({'X-AuthToken' => 'token'})
    #   end
    def self.headers(value = :not_provided)
      unless value == :not_provided
        @headers = value
      end
      @headers
    end

    # Sets or returns the namespace for an HttpMagic based class. The namespace
    # will be prefixed to the urn for each request made to the url.
    #
    # Assuming an api where each resource is namespaced with 'api/v1' and where
    # the url http://www.example.com/api/v1/foo/99 responds with the following.
    #
    # Header:
    #
    #   Content-Type: application/json
    #
    # Body:
    #
    #   {
    #     "name": "Foo Bar"
    #   }
    #
    # == Example
    #
    #   class ExampleApi < HttpMagic:Api
    #     url 'www.example.com'
    #     namespace 'api/v1'
    #   end
    #
    #   ExampleApi.foo[99].get['name']
    #   => "Foo Bar"
    #
    def self.namespace(value = :not_provided)
      unless value == :not_provided
        @namespace = value
      end
      @namespace
    end

    # Sets or returns the uniform resource locator for the HTTP resource.
    #
    # == Example
    #
    #   class ExampleApi < HttpMagic::Api
    #     url 'www.example.com'
    #   end
    def self.url(value = :not_provided)
      unless value == :not_provided
        @url = value
      end
      @url
    end

    # Class scoped method_missing that starts the magic of creating urns
    # through meta programming by instantiating an instance of the class
    # and delegating the first part of the urn to that instance. This method
    # is an implementation of the Factory Method design pattern.
    def self.method_missing(name, *args, &block)
      new(@url, @namespace, @headers).__send__(name, *args)
    end

    def initialize(url, namespace, headers)
      @uri = Uri.new(url)
      @uri.namespace = namespace
      @headers = headers
    end

    # Resource index reference intended to allow for the use of numbers in a urn
    # such as the following 'foo/99' being referenced by ExampleApi.foo[99].  It
    # can also be used to allow for HttpMagic methods to be specified for a urn
    # such as 'foo/get' being referenced by ExampleApi.foo[:get]. Finally, it can
    # be used for urn parts that are not valid Ruby methods such as 'foo/%5B%5D'
    # being referenced by ExampleApi.foo["%5B%5D"].
    #
    # * part - a part of a urn such that 'foo' and 'bar' would be parts of the urn
    #   'foo/bar'.
    #
    # Returns a reference to its instance so that urn parts can be chained
    # together.
    def [](part)
      @uri.parts << part.to_s
      self
    end

    # Deletes a resource from the URI.
    #
    # Assuming an api where each resource is namespaced with 'api/v1' and where
    # the url http://www.example.com/api/v1/foo/99 references a specific
    # resource.
    #
    # == Example
    #
    #   class ExampleApi < HttpMagic::Api
    #     url 'www.example.com'
    #     namespace 'api/v1'
    #   end
    #
    #   ExampleApi.foo[99].delete
    #   => ""
    def delete
      request = Request.new(@uri, headers: @headers)
      request.delete
    end

    # Gets a resource from the URI and returns it based on its content type.
    # JSON content will be parsed and returned as equivalent Ruby objects. All
    # other content types will be returned as text.
    #
    # Assuming an api where each resource is namespaced with 'api/v1' and where
    # the url http://www.example.com/api/v1/foo/99 responds with the following.
    #
    # Header:
    #
    #   Content-Type: application/json
    #
    # Body:
    #
    #   {
    #     "name": "Foo Bar"
    #   }
    #
    # == Example
    #
    #   class ExampleApi < HttpMagic::Api
    #     url 'www.example.com'
    #     namespace 'api/v1'
    #   end
    #
    #   ExampleApi.foo[99].get
    #   => { "name" => "Foo Bar" }
    def get
      request = Request.new(@uri,
        headers: @headers
      )
      request.get
    end

    # POST's a resource from the URI and returns the result based on its content
    # type. JSON content will be parsed and returned as equivalent Ruby objects.
    # All other content types will be returned as text.
    #
    # Assuming an api where each resource is namespaced with 'api/v1' and where
    # the url http://www.example.com/api/v1/foo/create responds with the
    # following when a 'name' is sent with the request.
    #
    # Header:
    #
    #   Content-Type: application/json
    #
    # Body:
    #
    #   {
    #     "name": "New Foo"
    #   }
    #
    # == Example
    #
    #   class ExampleApi < HttpMagic::Api
    #     url 'www.example.com'
    #     namespace 'api/v1'
    #   end
    #
    #   ExampleApi.foo.create.post(name: 'New Foo')
    #   => { "name" => "New Foo" }
    def post(data = {})
      request = Request.new(@uri,
        headers: @headers,
        data: data,
      )
      request.post
    end

    # PUT's a resource to the URI and returns the result based on its content
    # type. JSON content will be parsed and returned as equivalent Ruby objects.
    # All other content types will be returned as text.
    #
    # Assuming an api where each resource is namespaced with 'api/v1' and where
    # a GET to the url http://www.example.com/api/v1/foo/99 responds with the
    # following.
    #
    # Header:
    #
    #   Content-Type: application/json
    #
    # Body:
    #
    #   {
    #     "name": "Foo"
    #   }
    #
    # == Example
    #
    #   class ExampleApi < HttpMagic::Api
    #     url 'www.example.com'
    #     namespace 'api/v1'
    #   end
    #
    #   ExampleApi.foo[99].put(name: 'Changed Foo')
    #   => { "name" => "Changed Foo" }
    def put(data = {})
      request = Request.new(@uri,
        headers: @headers,
        data: data,
      )
      request.put
    end

    # Instance scoped method_missing that accumulates the URN parts used in
    # forming the URI. It returns a reference to the current instance so that
    # method and [] based parts can be chained together to from the URN. In the
    # case of ExampleApi.foo[99] the 'foo' method is accumlated as a URN part
    # that will form the resulting URI.
    def method_missing(part, *args, &block)
      @uri.parts << part.to_s
      self
    end
  end
end

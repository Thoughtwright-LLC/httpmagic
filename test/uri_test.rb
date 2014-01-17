require 'test_helper'
require 'http_magic/uri'

describe 'HttpMagic::Uri' do
  before do
    @domain = 'example.com'
    @uri = uri = HttpMagic::Uri.new(@domain)
  end

  it 'must have a domain param' do
    assert_raises ArgumentError do
      HttpMagic::Uri.new
    end
  end

  it 'should return the domain' do
    assert_equal @domain, @uri.domain
  end

  it 'can build a simple uri' do
    assert_equal "https://#{@domain}/", @uri.build
  end

  it 'should have url' do
    assert_equal "https://#{@domain}", @uri.url
  end

  it 'should create urn with parts' do
    @uri.parts = ['path', 'to', 'something']
    assert_equal '/path/to/something', @uri.urn
  end

  it 'should create urn with namespace' do
    @uri.namespace = 'api/v2'
    assert_equal '/api/v2', @uri.urn
  end

  it 'should create urn with namespace and parts combined' do
    @uri.parts = ['path', 'to', 'something']
    @uri.namespace = 'api/v2'
    assert_equal '/api/v2/path/to/something', @uri.urn
  end

  it 'should create the full uri with urn included' do
    @uri.parts = ['path', 'to', 'something']
    @uri.namespace = 'api/v2'
    assert_equal "https://#{@domain}/api/v2/path/to/something", @uri.build
  end
end

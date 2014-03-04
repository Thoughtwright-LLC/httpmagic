require 'test_helper'
require 'http_magic'

class HttpMagicTest < HttpMagic::Api
end

describe 'HttpMagic#post' do
  before do
    @url = HttpMagicTest.url 'www.example.com'
    HttpMagicTest.namespace nil
    HttpMagicTest.headers nil
  end

  it 'should send DELETE request' do
    stub_delete = stub_request(:delete, "https://#{@url}")

    HttpMagicTest.delete
    assert_requested stub_delete
  end

end

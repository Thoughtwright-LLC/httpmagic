require 'test_helper'
require 'http_magic'

class HttpMagicTest < HttpMagic::Api
end

describe 'HttpMagic#put' do
  before do
    @url = HttpMagicTest.url 'www.example.com'
    HttpMagicTest.namespace nil
    HttpMagicTest.headers nil
  end

  it 'should send PUT request' do
    stub_put = stub_request(:put, "https://#{@url}")

    HttpMagicTest.put
    assert_requested stub_put
  end

  it 'should send data with PUT request' do
    expected_data = {
      apple: 'sauce',
      banana: 'bread'
    }
    stub_put = stub_request(:put, "https://#{@url}/foo").with(
      body: expected_data
    )

    HttpMagicTest.foo.put(expected_data)

    assert_requested stub_put
  end
end

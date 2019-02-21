require 'uri'
require 'net/https'
require 'json' # for hash to_json conversion

uri = URI("https://api.pdfshift.io/v2/convert/")
data = {"source" => "https://www.example.com", "sandbox" => true}

Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
  request = Net::HTTP::Post.new(uri.request_uri)
  request.body = data.to_json
  request["Content-Type"] = "application/json"
  request.basic_auth '3536598326b04512a4ae320e8d2c5f34', ''

  response = http.request(request)

  if response.code == '200'
    # Since Ruby 1.9.1 only:
    File.binwrite("result.pdf", response.body)
  else
    # Handle other codes here
    puts "#{response.code} #{response.body}"
  end
end

require 'uri'
require 'net/http'
require 'json' # for hash to_json conversion

url = URI("https://api.pdfshift.io/v2/convert/")
data = { "source" => "https://www.example.com", "sandbox" => true }
headers = {"Content-Type" => "application/json"}

response = Net::HTTP.post(url, data.to_json, headers )

# Ensure that response.code == 200
if response.code == '200'
  # Since Ruby 1.9.1 only:
  File.binwrite("result.pdf", response.body)
else
  # Handle other codes here
end

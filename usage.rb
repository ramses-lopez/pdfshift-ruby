require 'uri'
require 'net/http'
require 'openssl'
require 'json' # for hash to_json conversion

url = URI("https://api.pdfshift.io/v2/convert/")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

data = { "source" => "https://www.example.com", "sandbox" => false }

response = Net::HTTP.post(url,
  data.to_json,
  "Content-Type" => "application/json"
)

# Ensure that response.code == 200
if response.code == '200'
  # Since Ruby 1.9.1 only:
  File.binwrite("result.pdf", response.body)
else
  # Handle other codes here
end

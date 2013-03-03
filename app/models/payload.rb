Rails.application.instance_eval do
  def call(env)
    body = "Omg no no no!"
    [200,  {"Content-Type" => "text/plain", "Content-Length" => body.length.to_s }, [body]]
  end
end

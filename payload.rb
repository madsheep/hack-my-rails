Rails.application.instance_eval do
  def call(env)
body = %{
  <!DOCTYPE html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <meta content='width=device-width, initial-scale=1.0' name='viewport'>
    <link href='http://twitter.github.com/bootstrap/assets/css/bootstrap.css' rel='stylesheet' />
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro|Source+Code+Pro|Yanone+Kaffeesatz' rel='stylesheet' type='text/css'>
    <title>Your application is insecure...</title>
    <style>
body {
  font-family: Source Sans Pro;
  font-size: 2em;
  line-height: 43px;
}
h1 {
  font-size: 3em;
  line-height: 83px;
}
    </style>
  </head>
  <body>
    <div class='container'>
      <div class='row'>
        <h1>
          Your application is insecure...
          <small>Srsly.</small>
        </h1>
        <p>
          Seems like your rails application was not secure. You are running #{Rails.version} which is very old.
          <br />
          Read moar:
          <br />
          <a href='http://www.kalzumeus.com/2013/01/31/what-the-rails-security-issue-means-for-your-startup/'>http://www.kalzumeus.com/2013/01/31/what-the-rails-security-issue-means-for-your-startup/</a>
          <br />
          <a href='https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-security/1h2DR63ViGo'>https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-security/1h2DR63ViGo</a>
        </p>
      </div>
      Ask somebody to help you, this is important. While you wait for them relax. Watch some pandas.
      <embed allowfullscreen='true' allowscriptaccess='always' bgcolor='#000000' flashvars='' height='530' id='explore_player' name='explore_player' src='http://explore.org/live-cams/natgeo_embed/china-panda-cam-1' type='application/x-shockwave-flash' width='942' wmode='opaque'></embed>
    </div>
  </body>
</html>
}.strip

    [200,  {"Content-Type" => "text/html", "Content-Length" => body.length.to_s }, [body]]
  end
end

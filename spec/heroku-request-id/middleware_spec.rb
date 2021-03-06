require 'spec_helper'

describe HerokuRequestId::Middleware do

  include Rack::Test::Methods

  let(:inner_app) do
      lambda { |env| [200, {'Content-Type' => 'text/html'}, ['<body>All good!</body>']] }
  end

  let(:app) { HerokuRequestId::Middleware.new(inner_app) }

  it "prints the request id to stdout by default" do
    output = capture_stdout { get "/" }
    output.should match("heroku-request-id")
  end

  it "does not print the request id to stdout if log_line == false" do
    HerokuRequestId::Middleware.log_line = false
    output = capture_stdout { get "/" }
    output.should_not match("heroku-request-id")
    # reset html_comment so that random test order works
    HerokuRequestId::Middleware.log_line = true
  end

  it "does not add a comment with the Heroku request id by default" do
    capture_stdout { get "/" }
    last_response.body.should_not match("Heroku request id")
  end

  it "does add a comment with the Heroku request id if html_comment == true" do
    HerokuRequestId::Middleware.html_comment = true
    capture_stdout { get "/" }
    last_response.body.should match("Heroku request id")
    # reset html_comment so that random test order works
    HerokuRequestId::Middleware.html_comment = false
  end

  it "makes no change to response status" do
    capture_stdout { get "/" }
    last_response.should be_ok
  end

end

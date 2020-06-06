require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require "sinatra/json"

set :bind, "0.0.0.0"
set :port, 8000

before do
  content_type "application/json"
end

get "/browser" do
  parser = Browser.new(request.env["HTTP_USER_AGENT"])
  json({
    browser: parser.name.downcase,
    version: parser.version.to_s,
    os: parser.platform.name.downcase,
    isMobile: "n/a"
  })
end

get "/device_detector" do
  parser = DeviceDetector.new(request.env["HTTP_USER_AGENT"])
  is_mobile = %w(smartphone tablet).include?(parser.device_type)
  json({
    browser: parser.name.downcase,
    version: parser.full_version.split(".").first,
    os: parser.os_name.downcase,
    isMobile: is_mobile.to_s
  })
end

get "/uap-ruby" do
  parser = UserAgentParser.parse(request.env["HTTP_USER_AGENT"])
  json({
    browser: parser.family.downcase,
    version: parser.version.major.to_s,
    os: parser.os.family.downcase,
    isMobile: "n/a"
  })
end

get "/useragent" do
  parser = UserAgent.parse(request.env["HTTP_USER_AGENT"])
  json({
    browser: parser.browser.downcase,
    version: parser.version.to_s.split(".").first.to_s,
    os: parser.platform.downcase,
    isMobile: "n/a"
  })
end

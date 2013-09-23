require 'bundler/setup'
require File.join(File.dirname(__FILE__), "/../../frugard")
require File.join(File.dirname(__FILE__), "/../../app")
require 'rack/test'

Given(/^Spellchecker Web Service is posted "(.*?)"$/) do |input|
  @input = input
end

When(/^the user is requesting in the language "(.*?)"$/) do |language|
  @language = language
end

When(/^the user wants a response in (.*?)$/) do |format|
  @format = format
end

When(/^Spellchecker Web Service checks the word$/) do
	browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
  @result = browser.get("/spellchecker",:word => @input, :format => @format, :language => @language)
end

Then(/^the Spellchecker Web Service response should be "(.*?)"$/) do |expected_result|
	case @format
	when "json"
		JSON.parse(@result.body)["correct"].to_s.should == expected_result
	when "xml"
		@result.body.should =~ /<correct type="boolean">#{expected_result}<\/correct>/
	when "html"
		@result.body.should =~ /Correct: #{expected_result}/
	end
end
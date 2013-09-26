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
  @result = browser.post("/spellchecker",:word => @input, :format => @format, :language => @language)
end

Then(/^the Spellchecker Web Service response should be "(.*?)"$/) do |expected_result|
	@expected_result = expected_result
	case @format
	when "json"
		JSON.parse(@result.body)["spellchecker"]["correct"].to_s.should == expected_result
	when "xml"
		Hash.from_xml(@result.body)["spellchecker"]["correct"].to_s.should == expected_result
	when "html"
		@result.body.should =~ /<dd>#{expected_result}<\/dd>/
	end
end

Then(/^the Spellchecker Web Service reponse should include an array called suggestions$/) do
	case @format
	when "json"
		JSON.parse(@result.body)["spellchecker"]["suggestions"].class.should == Array
	when "xml"
		Hash.from_xml(@result.body)["spellchecker"]["suggestions"].class.should == Array
	when "html"
		@result.body.should =~ /Suggestions/
	end
end

Then(/^the Spellchecker Web Service reponse suggestions should contain "(.*?)" if false$/) do |suggestion|
	if !eval(@expected_result) # the response is false (an incorrect word)
		case @format
		when "json"
			JSON.parse(@result.body)["spellchecker"]["suggestions"].should include(suggestion)
		when "xml"
			Hash.from_xml(@result.body)["spellchecker"]["suggestions"].should include(suggestion)
		when "html"
			@result.body.should =~ /#{suggestion}/
		end
	end
end

Then(/^the Spellchecker Web Service reponse suggestions should not contain "(.*?)" if false$/) do |not_a_suggestion|
	if !eval(@expected_result) # the response is false (an incorrect word)
		case @format
		when "json"
			JSON.parse(@result.body)["spellchecker"]["suggestions"].should_not include(not_a_suggestion)
		when "xml"
			Hash.from_xml(@result.body)["spellchecker"]["suggestions"].should_not include(not_a_suggestion)
		when "html"
			@result.body.should_not =~ /#{not_a_suggestion}/
		end
	end
end

When(/^the user requests an undefined service$/) do
	browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
  @hopefully_undfined_response = browser.get("/undefined_service")
end

Then(/^the response code should be Not Found$/) do
  @hopefully_undfined_response.status.should == 404
end

Then(/^the response code should include the requested resource, even if it's bad$/) do
  @hopefully_undfined_response.body.should =~ /undefined_service/
end

Then(/^the response code should not be OK$/) do
  @hopefully_undfined_response.status.should_not == 200
end

When(/^the user makes a request to the spellchecker without a word specified$/) do
	browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
  @unprocessible_entity_response = browser.get("/spellchecker")
end

Then(/^the response code should be Unprocessible Entity$/) do
  @unprocessible_entity_response.status.should == 422
end

When(/^the user makes a request to the spellchecker without valid format$/) do
	browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
  @no_valid_format_response = browser.get("/spellchecker", :word => "cucumber", :format => "ickyicky")
end

Then(/^the response code should be Server Error without the default page$/) do
  @no_valid_format_response.status.should == 500
	@no_valid_format_response.body.should_not =~ /sinatra/i
end

When(/^the user makes a request to the spellchecker without valid language$/) do
	browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
  @unprocessible_entity_response = browser.get("/spellchecker", :word => "cucumber", :language => "ickyicky")
end


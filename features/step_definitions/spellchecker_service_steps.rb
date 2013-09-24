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
	@expected_result = expected_result
	case @format
	when "json"
		JSON.parse(@result.body)["correct"].to_s.should == expected_result
	when "xml"
		Hash.from_xml(@result.body)["hash"]["correct"].to_s.should == expected_result
	when "html"
		@result.body.should =~ /Correct: #{expected_result}/
	end
end

Then(/^the Spellchecker Web Service reponse should include an array called suggestions$/) do
	case @format
	when "json"
		JSON.parse(@result.body)["suggestions"].class.should == Array
	when "xml"
		Hash.from_xml(@result.body)["hash"]["suggestions"].class.should == Array
	when "html"
		@result.body.should =~ /Suggestions/
	end
end

Then(/^the Spellchecker Web Service reponse suggestions should contain "(.*?)" if false$/) do |suggestion|
	if !eval(@expected_result) # the response is false (an incorrect word)
		case @format
		when "json"
			JSON.parse(@result.body)["suggestions"].should include(suggestion)
		when "xml"
			Hash.from_xml(@result.body)["hash"]["suggestions"].should include(suggestion)
		when "html"
			@result.body.should =~ /#{suggestion}/
		end
	end
end

Then(/^the Spellchecker Web Service reponse suggestions should not contain "(.*?)" if false$/) do |not_a_suggestion|
	if !eval(@expected_result) # the response is false (an incorrect word)
		case @format
		when "json"
			JSON.parse(@result.body)["suggestions"].should_not include(not_a_suggestion)
		when "xml"
			Hash.from_xml(@result.body)["hash"]["suggestions"].should_not include(not_a_suggestion)
		when "html"
			@result.body.should_not =~ /#{not_a_suggestion}/
		end
	end
end

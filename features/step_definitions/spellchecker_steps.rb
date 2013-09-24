require File.join(File.dirname(__FILE__), "/../../frugard")
Given(/^the input to the Frugard::Spellchecker "(.*?)"$/) do |input|
  @input = input
end

When(/^Frugard::Spellchecker uses the language "(.*?)"$/) do |language|
  @language = language
end

When(/^Frugard::Spellchecker checks the word$/) do
  @result = Frugard::Spellchecker.check(@input,:language => @language)
end

Then(/^the Frugard::Spellchecker reponse should be "(.*?)"$/) do |expected_result|
  @result[:correct].to_s.should == expected_result
end

Then(/^the Frugard::Spellchecker reponse should include and array called suggestions$/) do
  @result[:suggestions].class.should == Array
end

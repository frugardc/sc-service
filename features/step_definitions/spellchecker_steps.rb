require File.join(File.dirname(__FILE__), "/../../frugard")
Given(/^the input "(.*?)"$/) do |input|
  @input = input
end

When(/^spellchecker checks the word$/) do
  @result = Frugard::Spellchecker.check(@input)
end

Then(/^the response should be "(.*?)"$/) do |expected_result|
  @result.to_s.should == expected_result
end

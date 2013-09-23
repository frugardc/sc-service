require File.join(File.dirname(__FILE__), "/../../frugard")
Given(/^the input to the Frugard::Spellchecker "(.*?)"$/) do |input|
  @input = input
end

When(/^Frugard::Spellchecker checks the word$/) do
  @result = Frugard::Spellchecker.check(@input)
end

Then(/^the Frugard::Spellchecker reponse should be "(.*?)"$/) do |expected_result|
	print @result
  @result[:correct].to_s.should == expected_result
end

Feature: Verifying

	Scenario Outline: Verify a word is correct
		Given the input to the Frugard::Spellchecker "<input>"
		When Frugard::Spellchecker uses the language "<language>"
		When Frugard::Spellchecker checks the word
		Then the Frugard::Spellchecker reponse should be "<output>"

		Examples:
			|input|output|language|
			|cucumber|true|en_US|
			|cuclumnber|false|en_US|
			|pepino|true|es|
			|pepinot|false|es|

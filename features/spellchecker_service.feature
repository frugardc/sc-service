Feature: Verifying Spellchecker Service

	Scenario Outline: Verify a word is correct posting to the Spellchecker Web Service
		Given Spellchecker Web Service is posted "<input>"
		When the user is requesting in the language "<language>"
		When the user wants a response in <format>
		When Spellchecker Web Service checks the word
		Then the Spellchecker Web Service response should be "<output>"

		Examples:
			|input|output|format|language|
			|cucumber|true|xml|en|
			|cucumber|true|json|en|
			|cucumber|true|html|en|
			|cuclumber|false|xml|en|
			|cuclumber|false|json|en|
			|cuclumber|false|html|en|
			|pepino|true|xml|es|
			|pepino|true|json|es|
			|pepino|true|html|es|
			|pepinot|false|xml|es|
			|pepinot|false|json|es|
			|pepinot|false|html|es|
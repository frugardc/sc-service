Feature: Verifying Spellchecker Service

	Scenario Outline: Verify a word is correct posting to the Spellchecker Web Service
		Given Spellchecker Web Service is posted "<input>"
		When the user wants a response in <format>
		When Spellchecker Web Service checks the word
		Then the Spellchecker Web Service response should be "<output>"

		Examples:
			|input|output|format|
			|cucumber|true|xml|
			|cucumber|true|json|
			|cucumber|true|html|
			|cuclumber|false|xml|
			|cuclumber|false|json|
			|cuclumber|false|html|
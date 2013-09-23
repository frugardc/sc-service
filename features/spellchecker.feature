Feature: Verifying

	Scenario Outline: Verify a word is correct
		Given the input to the Frugard::Spellchecker "<input>"
		When Frugard::Spellchecker checks the word
		Then the Frugard::Spellchecker reponse should be "<output>"

		Examples:
			|input|output|
			|cucumber|true|
			|cuclumnber|false|

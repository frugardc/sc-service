Feature: Verifying

	Scenario Outline: Verify a word is correct
		Given the input "<input>"
		When spellchecker checks the word
		Then the response should be "<output>"

		Examples:
			|input|output|
			|cucumber|true|
			|cuclumnber|false|

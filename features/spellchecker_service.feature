Feature: Spellchecker Service Checks Spelling and Returns Suggestionsin Various Formats

	Scenario Outline: Verify a word is correct posting to the Spellchecker Web Service
		Given Spellchecker Web Service is posted "<input>"
		When the user is requesting in the language "<language>"
		When the user wants a response in <format>
		When Spellchecker Web Service checks the word
		Then the Spellchecker Web Service response should be "<output>"
		Then the Spellchecker Web Service reponse should include an array called suggestions
		Then the Spellchecker Web Service reponse suggestions should contain "<suggestion>" if false
		Then the Spellchecker Web Service reponse suggestions should not contain "<not_a_suggestion>" if false

		Examples:
      | input     | output | format | language | suggestion | not_a_suggestion |
      | cucumber  | true   | xml    | en       |            |                  |
      | cucumber  | true   | json   | en       |            |                  |
      | cucumber  | true   | html   | en       |            |                  |
      | cuclumber | false  | xml    | en       | cucumber   | bundy            |
      | cuclumber | false  | json   | en       | cucumber   | bundy            |
      | cuclumber | false  | html   | en       | cucumber   | bundy            |
      | pepino    | true   | xml    | es       |            |                  |
      | pepino    | true   | json   | es       |            |                  |
      | pepino    | true   | html   | es       |            |                  |
      | pepinot   | false  | xml    | es       | pepino     | bundy            |
      | pepinot   | false  | json   | es       | pepino     | bundy            |
      | pepinot   | false  | html   | es       | pepino     | bundy            |
#Author: nam.nh@amanotes.com
Feature: SEARCH ARTISTS

Background:
* call read('classpath:karate/bcs/data/bcs-get-elements-artist.feature')

* url baseUrl + bcs_endpoint_artists
* header x-access-token = tempToken

@positive
Scenario: Get artist by absolute artist name
And param keyword = artistName
When method GET
Then status 200
* def tempArtistName = response.data[0].name
* def artistNameUpperCase = tempArtistName.toUpperCase()
* def artistNameLowerCase = tempArtistName.toLowerCase()
Given header x-access-token = tempToken
And param keyword = artistNameLowerCase
When method GET
Then status 200
And match $.data[0].name == tempArtistName
Given header x-access-token = tempToken
And param keyword = artistNameUpperCase
When method GET
Then status 200
And match $.data[0].name == tempArtistName

@positive
Scenario: Get artist by artist ids
Given param artist_ids = artistId
When method GET
Then status 200

@positive
Scenario: Get artist by genres
Given param type = 'genres'
And param keyvalue = ''
When method GET
Then status 200

@negative
Scenario: Get artist by artist name is special characters
* def randomCharacter = randomCharacters(5)
Given param keyword = randomCharacter
When method GET
Then status 200
And match $.total == 0

@negative
Scenario: Get artist by artist name is spaces
Given param keyword = ' '
When method GET
Then status 200
And match $.total == 0
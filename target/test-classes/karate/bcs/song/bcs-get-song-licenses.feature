#Author: nam.nh@amanotes.com
Feature: COUNT LICENSES INCLUDED IN SONGS

Background:
* call read('classpath:karate/bcs/data/bcs-get-elements-song.feature')
* url uri + bcs_endpoint_license
* header x-access-token = tempToken

@positive
Scenario: Get license of song
* def data = {song_ids: []}
* set data.song_ids[0] = tempFirstSongIdInAllSongs
* set data.song_ids[] = tempSecondSongIdInAllSongs
* print data
Given request data
When method POST
Then status 200

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-license.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get license with null song id
* def var = Var.getListIdFormatInvalid()
Given request {"song_ids": [""]}
When method POST
Then status 400
And match $.error.message == var

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-data-invalid.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get license with invalid song id
* def var = Var.getListIdFormatInvalid()
Given request {"song_ids": ["123456"]}
When method POST
Then status 400
And match $.error.message == var

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-data-invalid.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get license with spaces song id
* def var = Var.getListIdFormatInvalid()
Given request {"song_ids": [" "]}
When method POST
Then status 400
And match $.error.message == var
# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-data-invalid.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)
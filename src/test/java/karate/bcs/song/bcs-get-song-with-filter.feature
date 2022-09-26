#Author: nam.nh@amanotes.com
Feature: FILTER SONG WITH TAG/MOOD

Background:
* callonce read('classpath:karate/bcs/data/bcs-create-song-available-with-img-content.feature')

* url uri + bcs_endpoint_song_search
* header x-access-token = tempToken

@positive
Scenario: Get songs with tag
Given param type = 'tag'
And param keyword = 'Chasing'
When method GET
Then status 200

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-song-name.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@positive
Scenario: Get song with mood
Given param type = 'mood'
And param keyword = 'Acerbic'
When method GET
Then status 200

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-music-genres.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

# Verify when request is sent without x-access-token
* def var = Var.getTokenInvalid()
Given param type = 'instrument'
And param keyword = 'Chimes'
When method GET
Then status 401
And match $.error.message == var

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-data-invalid.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@positive
Scenario: Get songs with instrument
Given param type = 'instrument'
And param keyword = 'Chimes'
When method GET
Then status 200

@positive
Scenario: Get songs with music genres
Given param type = 'music_genres'
And param keyword = mucsicGenres
When method GET
Then status 200

@positive
Scenario: Get songs include contents
Given param include_contents = songContentSlotId
When method GET
Then status 200

@positive
Scenario: Get songs & show all hidden fields
Given param type = 'music_genres'
And param keyword = mucsicGenres
And param extra_fields = extraFields
When method GET
Then status 200
* def songParams = karate.jsonPath(response, "$.data..song_params")
* def bitRates = karate.jsonPath(response, "$.data..bitRates")
* def version = karate.jsonPath(response, "$.data..version")
* def length = karate.jsonPath(response, "$.data..length")
* def duration = karate.jsonPath(response, "$.data..duration")
* def speed = karate.jsonPath(response, "$.data..speed")
* match songParams != []
* match bitRates != []
* match version != []
* match length != []
* match duration != []
* match speed != []

@negative
Scenario: Get songs with invalid tag
* def randomNumber = randomInt(100000)
Given param type = 'tag'
And param keyword = randomNumber
When method GET
Then status 200
And match $.total == 0

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get songs with invalid mood
* def randomNumber = randomInt(100000)
Given param type = 'mood'
And param keyword = randomNumber
When method GET
Then status 200
And match $.total == 0

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get songs with invalid instrument
* def randomNumber = randomInt(100000)
Given param type = 'instrument'
And param keyword = randomNumber
When method GET
Then status 200
And match $.total == 0

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get songs with invalid music genres
* def randomNumber = randomInt(100000)
And param type = 'music_genres'
And param keyword = randomNumber
When method GET
Then status 200
And match $.total == 0

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)
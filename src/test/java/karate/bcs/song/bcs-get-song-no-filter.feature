#Author: nam.nh@amanotes.com
Feature: SEARCH SONGS

Background:
* call read('classpath:karate/bcs/data/bcs-get-elements-song.feature')

* url uri
* header x-access-token = tempToken

@positive
Scenario: Get the first song from the list and verify song details
Given path bcs_endpoint_song_details + '/' + tempFirstSongIdInAllSongs
When method GET
Then status 200
And match $.name == tempFirstSongNameInAllSongs

# Verify schema for song details
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-song-details.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

Given header x-access-token = tempToken
And path bcs_endpoint_song_search
And param id_list = tempFirstSongIdInAllSongs + ',' + tempSecondSongIdInAllSongs
When method GET
Then status 200
And match $.total == 2

Given header x-access-token = tempToken
And path bcs_endpoint_song_related + '/' + tempFirstSongIdInAllSongs
When method GET
Then status 200
* def count = response.data.length
And match $.total == count

# Verify schema for song related
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-song-related.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@positive
Scenario: Get songs & the number of songs displayed will be set random & go to the next page
* path bcs_endpoint_song_search
* def randomLimit = randomElementJson(limitJsonList)
Given param limit = randomLimit
When method GET
Then status 200
* def count = response.data.length
And match $.total == count
* def tempNextPage = response.paging.cursors.after

Given header x-access-token = tempToken
And path bcs_endpoint_song_search
And param page_token = tempNextPage
When method GET
Then status 200

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-next-page.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@positive
Scenario: Get song details with and show all hidden fields
Given path bcs_endpoint_song_details + '/' + tempSecondSongIdInAllSongs
And param extra_fields = extraFields
When method GET
Then status 200

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-extra-fields.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@positive
Scenario: Get song with song param key
Given path bcs_endpoint_song_search
Given param song_params_key = 'unlock'
And param song_params_value = 'true'
When method GET
Then status 200
And match $.total == 2

@positive
Scenario: Get songs by app playlist/artist id/mutiple artist id
Given path bcs_endpoint_song_search
And param only_playlist = 'true'
And param playlist = appId
When method GET
Then status 200
* def tempArtistIdFirst = response.data[0].artists[0].id
* def tempArtistIdSecond = response.data[0].artists[0].id

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-song-by-app-playlist.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

# Get song by artist id
Given header x-access-token = tempToken
And path bcs_endpoint_song_search
And param type = 'artist_id'
And param keyword = tempArtistIdFirst
When method GET
Then status 200
* def count = response.data.length
And match $.total == count

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-artist-id.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

# Get songs by multiple artist id
Given header x-access-token = tempToken
And path bcs_endpoint_song_search
And param artist_ids = tempArtistIdFirst + ',' + tempArtistIdSecond
When method GET
Then status 200

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-artist-ids.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@positive
Scenario: Get songs by absolute artist name
Given path bcs_endpoint_song_search
And param type = 'artist'
And param keyword = tempArtistName
When method GET
Then status 200
* def tempTotal = response.total
* def artistNameUpperCase = tempArtistName.toUpperCase()
* def artistNameLowerCase = tempArtistName.toLowerCase()
Given header x-access-token = tempToken
And path bcs_endpoint_song_search
And param type = 'artist'
And param keyword = artistNameUpperCase
When method GET
Then status 200
And match $.total == tempTotal
Given header x-access-token = tempToken
And path bcs_endpoint_song_search
And param type = 'artist'
And param keyword = artistNameLowerCase
When method GET
Then status 200
And match $.total == tempTotal

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-artist-name.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@positive
Scenario: Get songs by absolute song name
Given path bcs_endpoint_song_search
And param keyword = songNameInApp
When method GET
Then status 200
* def tempSongName = response.data[0].name
* def songNameUpperCase = tempSongName.toUpperCase()
* def songNameLowerCase = tempSongName.toLowerCase()
Given header x-access-token = tempToken
And path bcs_endpoint_song_search
And param keyword = songNameUpperCase
When method GET
Then status 200
And match $.data[0].name == tempSongName
Given header x-access-token = tempToken
And path bcs_endpoint_song_search
And param keyword = songNameLowerCase
When method GET
Then status 200
And match $.data[0].name == tempSongName

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-song-name.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get song by invalid artist id
* def randomNumber = randomInt(100000)
Given path bcs_endpoint_song_search
And param type = 'artist_id'
And param keyword = randomNumber
When method GET
Then status 200
* def count = response.data.length
And match $.total == count

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get song with invalid artist ids
* def var = Var.getArtistIdInvalid()
* def randomNumber = randomInt(100000)
Given path bcs_endpoint_song_search
And param artist_ids = randomNumber
When method GET
Then status 400
And match $.error.message == var

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-data-invalid.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get song by artist id is spaces
Given path bcs_endpoint_song_search
And param type = 'artist_id'
And param keyword = ' '
When method GET
Then status 200
* def count = response.data.length
And match $.total == count

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get songs by invalid song name
* def randomCharacter = randomCharacters(5)
Given path bcs_endpoint_song_search
And param keyword = randomCharacter
When method GET
Then status 200
And match $.total == 0

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get songs by song name is spaces
Given path bcs_endpoint_song_search
And param keyword = ' '
When method GET
Then status 200
And match $.total == 0

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get songs by artist name is special characters
* def randomCharacter = randomCharacters(5)
Given path bcs_endpoint_song_search
And param type = 'artist'
And param keyword = randomCharacter
When method GET
Then status 200
And match $.total == 0

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get songs by artist name is spaces
Given path bcs_endpoint_song_search
And param type = 'artist'
And param keyword = ' '
When method GET
Then status 200
And match $.total == 0

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get song details with spaces song id
* def var = Var.getSongIdInvalid()
Given path bcs_endpoint_song_details
And path ' '
When method GET
Then status 400

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-data-invalid.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get song details with invalid song id
* def var = Var.getSongIdInvalid()
* def randomNumber = randomInt(100000)
Given path bcs_endpoint_song_details + '/' + randomNumber
When method GET
Then status 400
And match $.error.message == var

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-data-invalid.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get song related with spaces song id
* def var = Var.getSongIdInvalid()
Given path bcs_endpoint_song_related
And path ' '
When method GET
Then status 400
And match $.error.message == var

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-data-invalid.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get song related with invalid song id
* def var = Var.getSongIdInvalid()
* def randomNumber = randomInt(100000)
Given path bcs_endpoint_song_related + '/' + randomNumber
When method GET
Then status 400
And match $.error.message == var

# Verify schema
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-data-invalid.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get songs by app playlist with invalid playlist id
* def randomNumber = randomInt(100000)
Given path bcs_endpoint_song_search
And param only_playlist = 'true'
And param playlist = randomNumber
When method GET
Then status 200
And match $.total ==  0

# Verify schema for song related
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

@negative
Scenario: Get song by app playlist with spaces playlist id
Given path bcs_endpoint_song_search
And param only_playlist = 'true'
And param playlist = ' '
When method GET
Then status 200
And match $.total ==  0

# Verify schema for song related
And match response == '#object'
* string jsonSchemaExpected = read('classpath:karate/common/files/schema/schema-resp-not-found.json')
* string jsonData = response
* assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)
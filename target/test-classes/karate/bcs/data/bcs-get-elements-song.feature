#Author: nam.nh@amanotes.com
Feature: GET ELEMENTS SONG

Background:
* call read('classpath:karate/bcs/data/bcs-create-song-available-with-img-content.feature')
* url baseUrl + bcs_endpoint_song_search
* header x-access-token = tempToken

@skip
Scenario: Get song id & song name
Given method GET
Then status 200
* def tempFirstSongIdInAllSongs = response.data[0].id
* def tempSecondSongIdInAllSongs = response.data[1].id
* def tempFirstSongNameInAllSongs = response.data[0].name
* def tempSecondSongNameInAllSongs = response.data[1].name
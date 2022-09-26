#Author: nam.nh@amanotes.com
Feature: GET ELEMENTS ARTIST

Background:
* call read('classpath:karate/bcs/data/bcs-request-builder.feature')

* url baseUrl + bcs_endpoint_artists
* header x-access-token = tempToken

@skip
Scenario: Get artist id & artist name
Given method GET
Then status 200
* def artistId = response.data[0].id
* def artistName = response.data[0].name
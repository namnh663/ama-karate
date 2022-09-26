#Author: nam.nh@amanotes.com
Feature: MOCK DATA

@skip
Scenario: Get random name that look real
Given url 'https://randomuser.me/api/'
When method GET
Then status 200
* def nameRandomUser = response.results[0].name.first
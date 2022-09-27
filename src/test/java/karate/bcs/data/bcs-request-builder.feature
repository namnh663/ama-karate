#Author: nam.nh@amanotes.com
Feature: PRE REQUEST BUILDER

Background:
* url baseUrl

@skip
Scenario: Pre builder
Given method GET
Then status 200

* def pre = karate.prevRequest
* def uri = pre.url

* def description = 'Automatically generated'
* def contentPath = 'karate/common/files/content'
* def extraFields = 'songParams,bitRates,version,length,duration,speed'

* def env = karate.properties['karate.env']
* def Var = Java.type('karate.common.utils.Var')
* def limitJsonList = [5,10,15,20,25,30,35,40,45,50,100,200]
* def SchemaUtils = Java.type('karate.common.utils.SchemaUtils')
* def randomInt = read('classpath:karate/common/func/random-int.js')
* def extraFields = 'songParams,bitRates,version,length,duration,speed'
* def randomElementJson = read('classpath:karate/common/func/random-element-json.js')
* def randomCharacters = read('classpath:karate/common/func/random-special-character.js')
* def CMSToken = Java.type('karate.common.utils.CMSToken')
* def BCSToken = Java.type('karate.common.utils.BCSToken')
* def GetFileName = Java.type('karate.common.utils.GetFileNameUtils')
* def randomGUID = read('classpath:karate/common/func/random-guid.js')
* def randomString = read('classpath:karate/common/func/random-string.js')
* def jsonMusicGenres = read('classpath:karate/bcs/file/music-genres.json')

* def token = CMSToken.Get()

* def tempToken = env == 'qc' ? BCSToken.GetTokenInQc() : env == 'stag' ? BCSToken.GetTokenInStag() : {}
* def appName = env == 'qc' ? BCSToken.GetAppNameInQc() : env == 'stag' ? BCSToken.GetAppNameInStag() : {}

* def randomGuid = randomGUID()
* def randomName = randomString(10)
* def randomCode = randomInt(10000)

#Author: nam.nh@amanotes.com
Feature: Song Services

Background:
* call read('classpath:karate/token/cms_token.feature')
* call read('classpath:karate/common/mock/mockaroo.feature')
* def randomString = read('classpath:karate/common/func/random-string.js')
* def randomInt = read('classpath:karate/common/func/random-int.js')
* def randomGUID = read('classpath:karate/common/func/random-guid.js')
* def jsonMusicGenres = read('classpath:karate/common/files/music-genres.json')
* def GetFileName = Java.type('karate.common.utils.GetFileNameUtils')
* def randomElementJson = read('classpath:karate/common/func/random-element-json.js')
* url 'https://ms.qc.amanotes.io'
* def randomName = randomString(10)
* def randomCode = randomInt(10000)
* def randomGuid = randomGUID()
* def description = 'Automatically generated'
* def contentPath = 'karate/common/files/content'

@skip
Scenario: Create artist
* def requestPayload = 
"""
{
  "artistType": null,
  "description": "",
  "artistNameList": [
    {
      "name": "sdasdas",
      "romanizedName": "",
      "locale": null,
      "display": true,
      "primaryLocale": true
    }
  ],
  "proList": [],
  "externalLinkList": []
}
"""
* requestPayload.artistNameList[0].name = tempArtistName
* requestPayload.description = description

Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/artist-service'
And request requestPayload
When method POST
Then status 200
* def tempArtistId = response.data.id
* def tempAccessKey = response.data.accessKey
# Create license
* def requestPayload = 
"""
{
  "publishLevelAllowed": "PROD",
  "allApps": true,
  "appIds": [],
  "allRegionsAllowed": true,
  "externalLinks": [],
  "copyrightCategoryIds": [],
  "regionDetails": [],
  "startDate": "2022-09-07 00:00:00",
  "endDate": "2025-12-31 00:00:00"
}
"""
* requestPayload.name = randomName + ' license karatelabs'
* requestPayload.description = description

Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/licenses'
And request requestPayload
When method POST
Then status 200
* def tempLicenseId = response.data.id
# Create app
* def requestPayload = 
"""
{
  "accessUsers": [
    "nam.nh@amanotes.com"
  ],
  "androidBundleId": "vn.amanotes.acm",
  "iosBundleId": "vn.amanotes.acm",
  "testingBundleId": "vn.amanotes.acmtest",
  "songParams": [
    {
      "key": "unlock",
      "description": "",
      "value": "true",
      "is_default": "true"
    }
  ],
  "licenseAllowed": true,
  "isAutoIngestToProduction": true
}
"""
* requestPayload.name = randomName + ' app karatelabs'
* requestPayload.description = description
* requestPayload.productCode = 'KARATE' + randomCode

Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps'
And request requestPayload
When method POST
Then status 200
* def tempAppId = response.data.id
# Get app details
Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps/' + tempAppId
When method GET
Then status 200
* print response
# Create song
* def randomGenres = randomElementJson(jsonMusicGenres.data.list)
* def requestPayload = 
"""
{
  "artistIds": [
    {
      "artistId": "",
      "index": 0
    }
  ],
  "songNameList": [
    {
      "name": "",
      "romanizedName": "",
      "locale": {
        "id": "",
        "createdAt": "2020-11-04 17:30:58",
        "createdBy": null,
        "description": null,
        "language_region": "Vietnamese (Vietnam)",
        "language_subtag": "vi-VN",
        "updatedAt": "2020-11-04 17:30:58",
        "updatedBy": null,
        "version": 0
      },
      "display": true,
      "primaryLocale": true
    }
  ],
  "description": "",
  "enumVersionLength": {
    "id": "e6d04d04-cadf-4a94-a715-c2b0329b6d1a",
    "createdAt": "2020-12-24 12:20:49",
    "createdBy": null,
    "type": "VersionLength",
    "updatedAt": "2020-12-24 12:20:49",
    "updatedBy": null,
    "value": "Full",
    "version": 0,
    "checked": false
  },
  "enumVersionType": {
    "id": "60241d7f-e3a0-49af-9adc-065f7c802c01",
    "createdAt": "2020-12-24 12:20:08",
    "createdBy": null,
    "type": "VersionType",
    "updatedAt": "2020-12-24 12:20:08",
    "updatedBy": null,
    "value": "Original",
    "version": 0,
    "checked": true
  },
  "explicit": false,
  "externalLinkList": [],
  "md5": "",
  "instruments": [],
  "moods": [],
  "musicGenres": [
    ""
  ],
  "relatedSong": null,
  "speed": 0,
  "tags": [],
  "versionNote": ""
}
"""
* requestPayload.songNameList[0].locale.id = randomGuid
* requestPayload.songNameList[0].name = randomName
* requestPayload.artistIds[0].artistId = tempArtistId
* requestPayload.musicGenres[0] = randomGenres

Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service'
And request requestPayload
When method POST
Then status 200
* def songId = response.data.id
# Upload img
* def filename = GetFileName.input(contentPath + "/album.jpg")

Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service/uploadFile'
And multipart field songId = songId
And multipart field filename = filename
And multipart file songFile = { read: 'classpath:karate/common/files/content/album.jpg', contentType: 'image/jpeg'}
When method POST
Then status 200
* json tempData = response.data
* def mp3Link = tempData.mp3_link
* def fileType = tempData.file_type
* def hash = tempData.checksum_hash
# Create content
* def requestPayload = 
"""
{
  "fileType": "",
  "contentType": "cf9f3c7c-f470-40f0-b34d-fd08df266434",
}
"""
* requestPayload.contentUrl = mp3Link
* requestPayload.checksumHash = hash
* requestPayload.songId = songId
* requestPayload.name = randomName
* requestPayload.fileType = fileType

Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service/contents'
And request requestPayload
When method POST
Then status 200
# Upload mp3
* def mp3FileName = GetFileName.input(contentPath + "/Free_All_Right_Now.mp3")

Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service/uploadFile'
And multipart field songId = songId
And multipart field filename = mp3FileName
And multipart file songFile = { read: 'classpath:karate/common/files/content/Free_All_Right_Now.mp3', contentType: 'audio/mpeg'}
When method POST
Then status 200
* print response
* json tempDataForAudioFile = response.data
* def mp3LinkForAudioFile = tempDataForAudioFile.mp3_link
* def mp3FileType = tempDataForAudioFile.file_type
* def hashForAudioFile = tempDataForAudioFile.checksum_hash
# Create content
* def requestPayload = 
"""
{
  "fileType": "",
  "contentType": "aac771f9-f155-46a2-8195-6a76981c6862",
}
"""
* requestPayload.contentUrl = mp3LinkForAudioFile
* requestPayload.checksumHash = hashForAudioFile
* requestPayload.songId = songId
* requestPayload.name = randomName
* requestPayload.fileType = mp3FileType

Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service/contents'
And request requestPayload
When method POST
Then status 200
# Add license
* def data = []
* data[0] = {id: ''} 
* set data[0].id = tempLicenseId

Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/songs/' + songId + '/licenses'
And request data
When method POST
Then status 200
# Add app
* def data = []
* data[0] = {appId: ''} 
* set data[0].appId = tempAppId

Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service/' + songId + '/apps'
And request data
When method POST
Then status 200
# Update song in app to PROD
* def data = []
* data[0] = {songId: '', status: 'PROD'} 
* set data[0].songId = songId

Given header Authorization = 'Bearer ' + tempAuthToken
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps/' + tempAppId + '/songs'
And request data
When method PUT
Then status 200
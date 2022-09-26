#Author: nam.nh@amanotes.com
Feature: CREATE SONGS AVAILABLE

Background:
* call read('classpath:karate/bcs/data/bcs-mock-data.feature')
* call read('classpath:karate/bcs/data/bcs-request-builder.feature')
* url cms

@skip
Scenario: Create songs available
# Create artist
* def requestPayload = 
"""
{
  "artistType": null,
  "description": "",
  "artistNameList": [
    {
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
* requestPayload.artistNameList[0].name = nameRandomUser
* requestPayload.description = description
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/artist-service'
And request requestPayload
When method POST
Then status 200
* def tempArtistId = response.data.id

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
Given header Authorization = 'Bearer ' + token
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
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps'
And request requestPayload
When method POST
Then status 200
* def tempAppId = response.data.id

# Get app details
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps/' + tempAppId
When method GET
Then status 200
* def tempAppName = response.data.name

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
  "instruments": [
    "Chimes"
  ],
  "moods": [
    "Acerbic"
  ],
  "musicGenres": [
    ""
  ],
  "relatedSong": null,
  "speed": 0,
  "tags": [
    "Chasing"
  ],
  "versionNote": ""
}
"""
* requestPayload.songNameList[0].locale.id = randomGuid
* requestPayload.songNameList[0].name = randomName
* requestPayload.artistIds[0].artistId = tempArtistId
* requestPayload.musicGenres[0] = randomGenres
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service'
And request requestPayload
When method POST
Then status 200
* def songId = response.data.id

# Upload img
* def filename = GetFileName.input(contentPath + "/album.jpg")
Given header Authorization = 'Bearer ' + token
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
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service/contents'
And request requestPayload
When method POST
Then status 200

# Add license
* def data = []
* data[0] = {id: ''} 
* set data[0].id = tempLicenseId
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/songs/' + songId + '/licenses'
And request data
When method POST
Then status 200

# Add app
* def data = []
* data[0] = {appId: ''} 
* set data[0].appId = tempAppId
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service/' + songId + '/apps'
And request data
When method POST
Then status 200

# Update song in app to PROD
* def data = []
* data[0] = {songId: '', status: 'PROD'} 
* set data[0].songId = songId
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps/' + tempAppId + '/songs'
And request data
When method PUT
Then status 200

# Create playlist in app
* def requestPayload = 
"""
{
  "name": ""
}
"""
* requestPayload.name = randomName + ' playlist karatelabs'
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps/' + tempAppId + '/app-playlists'
And request requestPayload
When method POST
Then status 200

# Get app playlist
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps/' + tempAppId + '/app-playlists'
When method GET
Then status 200
* def listId = response.data.list[0].id

# Add song
* def requestPayload = 
"""
{
  "playlistIds": [
    "e0c05b29-3496-43bd-a91c-9345b95dbfe2"
  ],
  "songIds": [
    "41b3dbd5-ac32-4c61-a73c-bdd5dc998351"
  ]
}
"""
* requestPayload.playlistIds[0] = listId
* requestPayload.songIds[0] = songId
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/app-playlists/songs'
And request requestPayload
When method POST
Then status 200

# Get song in app playlist
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/app-playlists/' + listId + '/songs'
When method GET
Then status 200

# Create song
* def songName = randomString(10)
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
* requestPayload.songNameList[0].name = songName
* requestPayload.artistIds[0].artistId = tempArtistId
* requestPayload.musicGenres[0] = randomGenres
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service'
And request requestPayload
When method POST
Then status 200
* def songId = response.data.id

# Upload img
* def filename = GetFileName.input(contentPath + "/album.jpg")
Given header Authorization = 'Bearer ' + token
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
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service/contents'
And request requestPayload
When method POST
Then status 200

# Add license
* def data = []
* data[0] = {id: ''} 
* set data[0].id = tempLicenseId
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/songs/' + songId + '/licenses'
And request data
When method POST
Then status 200

# Add app
* def data = []
* data[0] = {appId: ''} 
* set data[0].appId = tempAppId
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service/' + songId + '/apps'
And request data
When method POST
Then status 200

# Update song in app to PROD
* def data = []
* data[0] = {songId: '', status: 'PROD'} 
* set data[0].songId = songId
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps/' + tempAppId + '/songs'
And request data
When method PUT
Then status 200

# Add song
* def requestPayload = 
"""
{
  "playlistIds": [
    "e0c05b29-3496-43bd-a91c-9345b95dbfe2"
  ],
  "songIds": [
    "41b3dbd5-ac32-4c61-a73c-bdd5dc998351"
  ]
}
"""
* requestPayload.playlistIds[0] = listId
* requestPayload.songIds[0] = songId
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/app-playlists/songs'
And request requestPayload
When method POST
Then status 200

# Get song in app playlist
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/app-playlists/' + listId + '/songs'
When method GET
Then status 200

# Get created apps
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps'
And param name = tempAppName
When method GET
Then status 200
* def tempAccessKey = response.data.list[0].accessKey
* print tempAccessKey

# Get app details by name
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps'
And param name = appName
And param filter = 'MAIN_APP_ONLY'
When method GET
Then status 200
* def appPlaylistId = response.data.list[0].id

# Get app details by id
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps/' + appPlaylistId
When method GET
Then status 200
* def songContentSlotId = response.data.songContentSlots[0].id

# Get app playlist details
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps/' + appPlaylistId + '/app-playlists'
When method GET
Then status 200
* def appId = response.data.list[0].id

# Get songs in app
* def body =
"""
{
  "song_updated_at_from": "",
  "song_updated_at_to": "",
  "created_at_from": "",
  "created_at_to": "",
  "statuses": [
    "REVIEW",
    "PROD"
  ],
  "song_name": "",
  "artist_names": []
}
"""
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/apps/' + appPlaylistId + '/list-songs-v2'
And request body
When method POST
Then status 200
* def songNameInApp = response.data.list[0].songNameList[0].name
* def songIdInApp = response.data.list[0].id

# Get artists
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/artist-service'
And param limit = 20
When method GET
Then status 200
* def artistIdFirst = response.data.list[0].id
* def artistIdSecond = response.data.list[1].id
* def tempArtistName = response.data.list[0].name

# Get song details
Given header Authorization = 'Bearer ' + token
And header email = 'nam.nh@amanotes.com'
And path '/api/v2/song-service/' + songIdInApp
When method GET
Then status 200
* def mucsicGenres = response.data.musicGenres[0]
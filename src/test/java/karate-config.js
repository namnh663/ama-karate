function fn() {
	var env = karate.env

	var config = {
		bcs_endpoint_song_search: '/v4/search',
		bcs_endpoint_song_details: '/v4/song',
		bcs_endpoint_song_related: '/v4/related',
		bcs_endpoint_artists: '/v4/artists',
		bcs_endpoint_token_init: '/v4/init',
		bcs_endpoint_token_refresh: '/v4/refresh',
		bcs_endpoint_license: '/v4/license',

		baseUrl: 'https://env.bcs.net'
	}

	if (env == 'qc') {
		config.baseUrl = 'https://qc.bcs.net'
	}

	if (env == 'stag') {
		config.baseUrl = 'https://staging.bcs.net'
	}
	
	return config;
}

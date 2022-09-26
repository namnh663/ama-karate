// cmsTestEnvUrl: 'https://ms.qc.amanotes.io'
// bcsTestEnvUrl: 'https://qc.bcs.amanotes.net'
// var systemVar = java.lang.System.getenv(env);

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

		cms: 'https://ms.env.amanotes.io',
		baseUrl: 'https://env.bcs.amanotes.net'
	}

	if (env == 'qc') {
		config.baseUrl = 'https://qc.bcs.amanotes.net'
		config.cms = 'https://ms.qc.amanotes.io'
	}

	if (env == 'stag') {
		config.baseUrl = 'https://staging.bcs.amanotes.net'
		config.cms = 'https://ms.staging.amanotes.io'
	}
	
	return config;
}
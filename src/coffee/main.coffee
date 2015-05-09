"use strict"

require.config
	baseUrl: "/scripts"

	paths:
		"classlist": "vendor/classlist/classList"
		"gifshot": "vendor/gifshot/build/gifshot"
		"requestAnimationFrame": "vendor/requestAnimationFrame/app/requestAnimationFrame"
		
require [ "site/boot" ] , ( Site ) ->
	new Site()
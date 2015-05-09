"use strict";

module.exports = function( grunt ) {

	// Useful for showing time taken for Grunt tasks
	require("time-grunt")(grunt);

	// Automatically load libraries for Grunt tasks
	require("load-grunt-tasks")(grunt);

	grunt.initConfig({

		autoprefixer: {
			dist: {
				expand: true,
				flatten: true,
				src: "app/styles/*.css",
				dest: "dist/styles/"
			}
		},

		browserSync: {
			bsFiles: [
				"app/scripts/site/**",
				"app/styles/*.css",
				"app/*.html"
			],
			options: {
				watchTask: true,
				ghostMode: false,
				server: {
					baseDir: "app"
				}
			}
		},

		coffee: {
			dev: {
				options: {
					bare: true,
					sourceMap: true
				},
				expand: true,
				cwd: "src/coffee/",
				src: [ "**/*.coffee" ],
				dest: "app/scripts",
				ext: ".js"
			}
		},

		coffeelint: {
			app: {
				files: {
					src: [ "src/coffee/**/*.coffee" ]
				},
				options: {
					"max_line_length": {
						"level": "ignore"
					}
				}
			}
		},

		compass: {
			dev: {
				options: {
					sassDir: "src/sass",
					extensionsDir: "src/sass/extensions",
					cssDir: "app/styles",
					imagesDir: "app/images",
					relativeAssets: true,
					force: true
				}
			}
		},

		concat: {
			options: {
				stripBanners: true
			},
			home: {
				src: [ "app/scripts/site.js" ],
				dest: "app/scripts/site.js"
			}
		},

		copy: {
			dist: {
				expand: true,
				cwd: "app/",
				src: [ 
					"images/**"
				],
				dest: "dist"
			}
		},

		cssmin: {
			dist: {
				files: {
					"dist/styles/main.css": [ "dist/styles/main.css" ]
				}
			}
		},

		htmlmin: {
			dist: {
				options: {
					collapseWhitespace: true,
					minifyJS: true,
					minifyCSS: true
				},
				files: {
					"dist/index.html": "app/index.html"
				}
			}
		},

		"html-prettyprinter": {
			main: {
				src: "app/index.html",
				dest: "app/index.html"
			}
		},

		imagemin: {
			build: {
				options: {
					optimizationLevel: 4
				},
				files: [{
					expand: true,
					cwd: "src/images/",
					src: [ "**/*.{png,jpg,gif}"],
					dest: "app/images/"
				}]
			}
		},

		mustache_render: {
			options: {
				directory: "src/mustache"
			},
			build: {
				data: "src/json/main.json",
				template: "src/mustache/main.mustache",
				dest: "app/index.html"
			}
		},

		requirejs: {
			dist: {
				options: {
					baseUrl: "app/scripts",
					name: "main",
					include: "vendor/requirejs/require",
					optimize : "uglify",
					out: "dist/scripts/main.js",
					paths: {
						"classlist": "vendor/classlist/classList",
						"gifshot": "vendor/gifshot/build/gifshot",
						"requestAnimationFrame": "vendor/requestAnimationFrame/app/requestAnimationFrame"
					}
				},
				mainConfigFile: "app/scripts/site/main.js"
			}
		},

		targethtml: {
			dev: {
				files: {
					"app/index.html": "app/index.html"
				}
			},
			dist: {
				files: {
					"dist/index.html": "dist/index.html"
				}
			}
		},

		watch: {
			compass: {
				files: [ "src/sass/**" ],
				tasks: "compass",
				options: {
					debounceDelay: 200
				}
			},
			coffee: {
				files: [ "src/coffee/**" ],
				tasks: "coffee",
				options: {
					debounceDelay: 200
				}
			},
			mustache: {
				files: [ "src/mustache/**" ],
				tasks: ["mustache_render","targethtml:dev","html-prettyprinter"],
				options: {
					debounceDelay: 200
				}
			},
			json: {
				files: [ "src/json/**" ],
				tasks: ["mustache_render","targethtml:dev","html-prettyprinter"],
				options: {
					debounceDelay: 200
				}
			}
		}

	});

	// Build
	grunt.registerTask( "build", [
		"mustache_render",
		"html-prettyprinter",
		"compass",
		"autoprefixer:dist",
		"coffee:dev",
		"copy:app",
		"imagemin",
		"copy:dist",
		"cssmin",
		"htmlmin",
		"requirejs",
		"targethtml"
	]);

	// run to compress new images
	grunt.registerTask( "compress" , [ "imagemin" ]);

	// Prep the dev environment for watching, or run this directly to
	// update it a single time
	grunt.registerTask( "devupdate", [
		"copy:app",
		"imagemin",
		"compass",
		"coffee:dev",
		"mustache_render",
		"html-prettyprinter",
		"targethtml"
	]);

	// Update dev environment, and start watch
	grunt.registerTask( "start", [
		"devupdate",
		"browserSync",
		"watch"
	]);

	grunt.registerTask( "default", [ "build" ] );
};
define [

	# views
	"site/views/InterfaceView"

	# controllers
	"site/controllers/CameraController"
	"site/controllers/GifController"
	"site/controllers/GlitchController"
	"site/controllers/StageController"

	# libs
	"requestAnimationFrame"
	"gifshot"

] , (

	# views
	InterfaceView

	# controllers
	CameraController
	GifController
	GlitchController
	StageController

	# libs
	requestAnimationFrame
	gifshot

) ->

	# libs
	window.requestAnimationFrame = requestAnimationFrame
	window.gifshot = gifshot

	Site = ->

		class App

			camera: new CameraController
			gif: new GifController
			glitch: new GlitchController
			interface: new InterfaceView
			stage: new StageController

			start: ->
				i = 0
				run = [ 
					"gif"
					"interface"
					"camera"
					"stage"
				]

				for classes in run
					do site[ classes ].init

		window.site = new App
		site.start()
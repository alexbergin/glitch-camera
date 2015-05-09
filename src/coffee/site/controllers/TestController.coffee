define ->

	# mostly a test to see if gifshot could handle a dataURI
	class TestController

		init: ->
			@.getElements()
			@.makeGif()

		getElements: ->
			@.images = document.getElementsByTagName "img"

		makeGif: ->
			images = []
			w = @.images[0].offsetWidth
			h = @.images[0].offsetHeight
			for image in @.images
				images.push( image.getAttribute "src" )
			gifshot.createGIF({ images: images , gifWidth: w , gifHeight: h } , @.callback )

		callback: ( img ) ->
			console.log img
			image = document.createElement "img"
			image.setAttribute "src" , img.image
			document.body.appendChild image

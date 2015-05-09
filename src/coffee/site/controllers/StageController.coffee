define ->

	# controls the stage that is visible to the user
	class StageController

		scale: 512

		init: ->

			# get the stage & its context
			@.getElements()

			# listen for resizes
			@.addListeners()

			# decide what to render
			@.loop()

		getElements: ->

			# the actual element
			@.canvas = document.getElementsByClassName("stage")[0].getElementsByTagName("canvas")[0]

			# the canvas context
			@.c = @.canvas.getContext "2d"

		addListeners: ->

			# listen for and preform a resize
			window.addEventListener "resize" , @.onResize
			@.onResize()

		onResize: =>

			# get the scale from the parent element
			@.scale = Math.min( 512 , window.innerWidth , window.innerHeight )

			# apply it to the canvas
			@.canvas.setAttribute "width" , @.scale
			@.canvas.setAttribute "height" , @.scale
			@.canvas.style.width = "#{@.scale}px"
			@.canvas.style.height = "#{@.scale}px"

		loop: =>

			# call the render loop
			requestAnimationFrame @.loop

			# draw the glitched image
			@.drawImage()

		drawImage: ->

			# get the glitched image
			src = site.camera.image

			# draw it to the canvas, if not too corrupt
			try
				@.c.drawImage src , 0 , 0 , @.scale , @.scale

			catch err
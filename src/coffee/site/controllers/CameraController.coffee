define ->

	# opertates the camera and takes screenshots
	class CameraController

		# list of available cameras
		cameras: []
		active: 0

		# resulting image from glitching
		glitched: null

		# source frame from video
		source: null

		# assuming we always keep a square ratio
		scale: 512

		init: ->

			# get our elements + some setup
			@.getElements()
			@.addListeners()
			@.setUpCanvas()

			# test to see if we can use the camera
			if navigator.getUserMedia isnt undefined

				# get camera sources
				if MediaStreamTrack isnt undefined

					# if we have mutliple
					MediaStreamTrack.getSources( @.getCameras )

				else

					# otherwise just use the default
					# start the stream
					@.requestStream()

			else

				# cry loudly
				@.notSupported()

		getElements: ->

			# the holder for the video and canvas workers
			@.container = document.getElementsByClassName("worker")[0]
			@.stage = document.getElementsByClassName("stage")[0]

			# video + canvas + image element we store the latest glitched image in
			@.video = @.container.getElementsByTagName("video")[0]
			@.canvas = @.container.getElementsByTagName("canvas")[0]
			@.image = @.container.getElementsByTagName("img")[0]

			# error messages
			@.notAllowed = @.stage.getElementsByClassName("not-allowed")[0]
			@.noSupport = @.stage.getElementsByClassName("not-supported")[0]

			# make sure getusermedia is real/consistant
			navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia

		addListeners: ->

			# listen for a click on the stage to change video source
			@.stage.addEventListener "click" , @.cycleCameras

		setUpCanvas: ->

			# set worker canvas scale
			@.canvas.setAttribute "width" , @.scale
			@.canvas.setAttribute "height" , @.scale
			@.canvas.style.width = "#{@.scale}px"
			@.canvas.style.height = "#{@.scale}px"

			# get context
			@.c = @.canvas.getContext "2d"

			# set worker image scale
			@.image.setAttribute "width" , @.scale
			@.image.setAttribute "height" , @.scale
			@.image.style.width = "#{@.scale}px"
			@.image.style.height = "#{@.scale}px"

		getCameras: ( sources ) =>

			# error if there are no cameras
			if sources.length is 0 then @.notSupported()

			# loop through each source
			for source in sources

				# if it's a camera, add it to the array
				if source.kind is "video" then @.cameras.push source

			# use the back camera by default
			if @.cameras.length > 1

				@.cycleCameras()

			else

				@.requestStream()

		cycleCameras: =>

			# see if we changed
			original = @.active

			# increment the selected camera
			@.active++

			# loop if we go beyond the array length
			if @.active > @.cameras.length - 1 then @.active = 0

			# update the stream if needed
			if @.active isnt original
				@.requestStream()

		requestStream: ->

			# clear the old stream
			@.video.src = null
			if @.stream isnt undefined
				@.stream.stop()

			# set up the stream
			if @.cameras.length is 0

				# use default
				navigator.getUserMedia { audio: false , video: true } , @.success , @.failure

			else

				# use a custom camera
				constraints =
					audio: false,
					video:
						optional: [
							sourceId: @.cameras[ @.active ].id
						]

				# use a custom camera
				navigator.getUserMedia constraints , @.success, @.failure
		
		success: ( stream ) =>
			
			# make the new one
			@.stream = stream

			# apply our video stream
			@.video.src = window.URL.createObjectURL @.stream
			@.video.play()

			# initiate loop
			if @.initiated isnt true
				@.initiated = true
				@.loop()

		failure: ( e ) ->

			# make the not allowed message appear
			@.notAllowed.classList.add "visible"


		notSupported: ->

			# make the not supported message appear
			@.noSupport.classList.add "visible"

		loop: =>

			# repeat loop
			requestAnimationFrame @.loop

			if site.gif.isProcessing is false

				# read the source video
				@.readVideo()

				# apply the glitch effect to the imageURI
				@.glitchImage()

		readVideo: ->

			# get the video scale
			width = @.video.offsetWidth
			height = @.video.offsetHeight

			# scale the image
			if width > height

				# scale to make height fit
				width = ( width / height ) * @.scale
				height = @.scale

			else

				# scale to make width fit
				height = ( height / width ) * @.scale
				width = @.scale

			# position draw point
			x = -( width - @.scale ) / 2
			y = -( height - @.scale ) / 2

			# draw it to the canvas
			@.c.drawImage @.video , x , y , width , height

		glitchImage: ->

			# get the image URI to glich
			dataURI = @.canvas.toDataURL "image/jpeg"

			# send & save it to be glitched
			result = site.glitch.process dataURI

			# update the image source, if not corrupt
			try
				@.image.src = @.glitched
				@.glitched = result

			catch err




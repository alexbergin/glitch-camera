define ->

	# saves frames from the video when recording
	class GifController

		# use fewer frames if its a touch device
		isTouch: false
		desktopRate: 1000 / 3
		mobileRate: 1000 / 1
		
		# recording state
		isRecording: false

		# processing state
		isProcessing: false

		# saved frames to compile into gif
		frames: []

		init: ->

			# get elements we affect directly
			@.getElements()

			# listen for touch events
			@.addListeners()


		getElements: ->

			# stage container
			@.stage = document.getElementsByClassName("stage")[0]

			# interface container
			@.interface = document.getElementsByTagName("menu")[0].getElementsByClassName("buttons")[0]

			# the image to place the output into
			@.image = @.stage.getElementsByTagName("img")[0]

			# the video we read from
			@.video = document.getElementsByTagName("video")[0]

			# the download button
			@.download = document.getElementsByClassName("save")[0]

		addListeners: ->

			# if its a touch device, limit the sampling
			window.addEventListener "touchstart" , => @.isTouch = true

		loop: =>

			# only save frames when recording
			if @.isRecording

				# grab a frame from the worker
				image = site.camera.glitched

				# save it in the array
				@.frames.push image

		read: ->

			# enable the loop
			@.isRecording = true

			# use correct rate
			if @.isTouch then rate = @.mobileRate else rate = @.desktopRate

			# reset the interval loop
			clearInterval @.timer
			@.timer = setInterval =>
				@.loop()

			# frame rate to capture
			, rate

			# get the first frame
			@.loop()

		build: ->

			# disable the loop
			@.isRecording = false
				
			# get the scale
			scale = site.camera.scale

			# pause the video
			@.video.pause()

			# update the view & state
			@.isProcessing = true

			# send the images to gifshot
			gifshot.createGIF({ images: @.frames , gifWidth: scale , gifHeight: scale , progressCallback: @.onProgress } , @.render )

		clear: ->

			# discard old frames
			@.frames = []

		render: ( compiled ) =>

			# discard old image data
			@.clear()

			# update the view
			@.interface.classList.remove "processing"
			@.interface.classList.add "processed"

			# render the image
			@.image.src = compiled.image
			@.download.setAttribute "href" , compiled.image

			# make it visible
			@.stage.classList.remove "processing"
			@.stage.classList.add "rendered"

			# resume the video
			@.video.play()

		onProgress: ( e ) =>
			console.log e

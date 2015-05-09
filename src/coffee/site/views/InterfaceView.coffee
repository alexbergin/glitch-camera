define ->

	# controls the visual representation of the
	# user interface
	class InterfaceView

		# important external vars
		streamPlaying: true
		glitchLevel: 0.5

		# video player vars
		maxVidLength: 3
		recording: false

		# glitch slider var
		glitchDown: false

		init: ->

			@.getElements()
			@.addListeners()

		getElements: ->

			# sets the reference point of all of our elements
			@.container = document.getElementsByTagName("menu")[0]
			@.buttons = @.container.getElementsByClassName("buttons")[0]

			# captures a stream with the glitch effect
			@.captureButton = @.container.getElementsByClassName("capture")[0]

			# saves the build image
			@.saveButton = @.container.getElementsByClassName("save")[0]

			# removes the build image
			@.discardButton = @.container.getElementsByClassName("discard")[0]

			# the glitch level slider
			@.glitchSlider = @.container.getElementsByClassName("glitch")[0]

			# get the video progress
			@.timer = @.container.getElementsByClassName("progress")[0].getElementsByTagName("div")[0]

			# stage container
			@.stage = document.getElementsByClassName("stage")[0]

		addListeners: ->

			# these all call functions that perform actions when clicked
			@.captureButton.addEventListener "mousedown" , @.onCaptureDown
			window.addEventListener "mouseup" , @.onCaptureUp
			@.captureButton.addEventListener "touchstart" , @.onCaptureDown
			window.addEventListener "touchend" , @.onCaptureUp
			@.saveButton.addEventListener "click" , @.onSaveClick
			@.discardButton.addEventListener "click" , @.onDiscardClick

			# more complicated slider controls
			@.glitchSlider.addEventListener "mousedown" , @.onGlitchSliderDown
			@.glitchSlider.addEventListener "touchstart" , @.onGlitchSliderDown
			window.addEventListener "mousemove" , @.onGlitchSliderMove
			window.addEventListener "touchmove" , @.onGlitchSliderMove
			window.addEventListener "mouseup" , @.onGlitchSliderUp
			window.addEventListener "touchend" , @.onGlitchSliderUp

		onCaptureDown: =>
			@.buttons.classList.remove "record"
			@.buttons.classList.add "recording"
			@.startTimer()

		onCaptureUp: =>

			# check to make sure the button wasn't released falsely
			if @.buttons.classList.contains "recording"

				@.buttons.classList.remove "recording"
				@.buttons.classList.add "processing"
				@.stopTimer()

		onSaveClick: =>
			site.gif.isProcessing = false
			@.buttons.classList.remove "processed"
			@.buttons.classList.add "record"

			# todo: put controller event here
			@.stage.classList.remove "rendered"

		onDiscardClick: =>
			site.gif.isProcessing = false
			@.buttons.classList.remove "processed"
			@.buttons.classList.add "record"

			# todo: put controller event here
			@.stage.classList.remove "rendered"

		onGlitchSliderMove: ( e ) =>

			# only update if we're grabbing
			if @.glitchDown

				# get the current x and the y for touch/mouse
				if e.touches is undefined

					# mouse
					x = e.clientX
					y = e.clientY

				else

					# touch
					x = e.touches[0].clientX
					y = e.touches[0].clientY

				# get the wrapper the slider is in, the visual button, and its bounding box
				wrapper = @.glitchSlider.getElementsByTagName("div")[0]
				button = wrapper.getElementsByTagName("i")[0]
				bounds = wrapper.getBoundingClientRect()

				# get the 0 point
				x = x - bounds.left
				y = y - bounds.top

				# invert the y so we get from bottom instead
				y = bounds.height - y

				# constrain to the width & height
				x = Math.max( Math.min( x , bounds.width ) , 0 )
				y = Math.max( Math.min( y , bounds.height ) , 0 )

				# get the percentages
				x = x / bounds.width
				y = y / bounds.height

				# only listen to one, depending on screen size
				if window.innerWidth > window.innerHeight

					# when landscape
					button.style.left = "#{y*100}%"
					button.style.bottom = "#{y*100}%"
					@.glitchLevel = y

				else

					# when portrait
					button.style.left = "#{x*100}%"
					button.style.bottom = "#{x*100}%"
					@.glitchLevel = x


		onGlitchSliderDown: =>

			# set the glitch moving state to true
			@.glitchDown = true

		onGlitchSliderUp: =>

			# set the glitch moving state to false
			@.glitchDown = false

		startTimer: =>
			
			# update the view
			@.recording = new Date().getTime()
			@.loop()

			# start the recorder
			site.gif.read()

		stopTimer: =>

			# update the view
			@.recording = false
			@.stage.classList.add "processing"
			@.buttons.classList.remove "recording"
			@.buttons.classList.add "processing"

			# end the recorder
			site.gif.build()

		loop: =>

			# continue the loop if we're good
			if @.recording isnt false

				# call the loop again
				requestAnimationFrame @.loop

				# get the current time and compair it to the start time for a delta
				present = new Date().getTime()
				delta = ( present - @.recording ) / 1000

				# make sure the video doesn't go over in length
				if delta > @.maxVidLength then @.stopTimer()

				# find the percent possible and invert it for the transform
				percent = ( delta / @.maxVidLength ) * 100

				# make sure we apply the transform correctly for the viewport
				if window.innerWidth > window.innerHeight

					# when landscape
					x = 0
					y = 100 - percent

				else

					# when portrait
					x = -100 + percent
					y = 0

				# loop through each prefix and apply the style
				prefixes = [ "webkitTransform" , "mozTransform" , "msTransform" , "transform" ]
				for prefix in prefixes
					@.timer.style[prefix] = "translate( #{x}% , #{y}% )"


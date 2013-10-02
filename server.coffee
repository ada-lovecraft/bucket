
###
Module dependencies.
###
express = require("express")
routes = require("./routes")
user = require("./routes/user")
http = require("http")
path = require("path")
app = express()

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "_public"))



# development only
app.use express.errorHandler()  if "development" is app.get("env")
app.get "/", routes.index
app.get "/files", routes.files
app.get "/fileStore/:id", routes.getFile
app.post "/fileupload", routes.upload

exports.startServer = (port, path, callback) -> 
	app.get '/', (req, res) -> 
		res.sendfile './_public/index.html' 
	app.listen port 
	console.log 'Listening on port:', port 


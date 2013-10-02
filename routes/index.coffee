fs = require 'fs'
uuid = require 'node-uuid'
dirty = require 'dirty'
util = require 'util'
path = require 'path'
_ = require 'lodash'

db = dirty('fileStore.db')

#
# * GET home page.
# 
exports.index = (req, res) ->
  res.render "index",
    title: "Express"

exports.getFile = (req, res) ->
	console.log 'getting file:', req.params.id
	filePath = null

	serveRequestedFile = (file) ->
		console.log 'file exists: ' , file
		if file == false
			res.writeHead 404
			res.end()
		else
			type = require('mime').lookup(filePath)
			stream = fs.createReadStream(filePath)
			stream.on 'error', (error) ->
				res.writeHead(500)
				res.end()

			res.setHeader('Content-Type', type)
			res.writeHead(200)
			util.pump stream, res, (err) ->
				res.end()
				return


	if req.params.id
		filePath = 'fileStore/' + req.params.id
		fs.exists(filePath,serveRequestedFile)
	else
		console.log 'id not found'
		res.writeHead(400)
		res.end('No file requested', 'utf8')

	


exports.files = (req, res) ->
	console.log 'listing files:'
	response = []
	
	console.log 'db loaded'
	db.forEach (key,val) ->
		response.push {
			fileName: key
			file: val.file
			dateUploaded: val.date
		}

	_.sortBy(response,'date')
	console.log 'response:', response.reverse()
	res.send response 

#
# * POST Upload.
# 
exports.upload = (req, res) ->
	files = []
	if req.files.uploadedFiles.length > 1
		for file in req.files.uploadedFiles
			files.push file
	else
		files.push(req.files.uploadedFiles)
	for file in files
		console.log 'file.name:', file.name
		id = uuid.v4()
		matches = file.name.match(/\.(\S+)$/)
		newFileName = 'fileStore/' + file.name.replace(/\ /g,'-').replace(matches[0],'') + '-' + id + '.' + matches[1]
		fs.renameSync file.path, newFileName
		db.set file.name, {file: newFileName, date: new Date()}
	response = []
	db.forEach (key,val) ->
		response.push {
			fileName: key
			file: val.file
			dateUploaded: val.date
		}

	res.send response

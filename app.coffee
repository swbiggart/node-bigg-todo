
express = require('express')
routes = require('./routes')

app = module.exports = express.createServer();

# Configuration
app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.set 'view options', { pretty: true }
  
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use require('stylus').middleware { src: __dirname + '/public' }
  app.use app.router
  app.use express.static(__dirname + '/public')


app.configure 'development', ->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
  app.use express.errorHandler()

# Routes
app.get '/', routes.index

port = process.env.PORT || 3000
app.listen port, ->
  console.log("Listening on " + port)

console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

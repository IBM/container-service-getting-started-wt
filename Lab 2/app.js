var express = require('express')
var app = express()
var startTime = Date.now()

var delay = 10000 + Math.floor(Math.random() * 5000)

app.get('/', function(req, res) {
  res.send('Hello world! Great job getting the second stage up and running!')
})
app.get('/healthz', function(req, res) {
  if ((Date.now() - startTime) > delay) {
    res.status(500).send({
      error: 'Timeout, Health check error!'
    })
  } else {
    res.send('OK!')
  }
})
app.listen(8080, function() {
  console.log('Sample app is listening on port 8080.')
})

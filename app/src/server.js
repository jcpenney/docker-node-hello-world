/*****************************************/
/* Imports */
/*****************************************/

var Express = require('express');
var MongoJS = require('mongojs');
var ServeFavIcon = require('serve-favicon');


/*****************************************/
/* Constants */
/*****************************************/

var PORT = 8080
var MONGO_URL = "mongodb://mongo:27017/docker-node-hello-world";


/*****************************************/
/* App */
/*****************************************/

var dbVisits = MongoJS(MONGO_URL).collection('visits');

var app = Express();
app.use(ServeFavIcon(null));
app.route('*').all(function (req, res, next) {

  dbVisits.save({ dateTime: Date.now() }, function() {
    dbVisits.find().sort({ dateTime: -1 }, function(err, visits) {
      var html = "<html>";
      html += "<head><title>Hello.</title></head>";
      html += "<body>";
      html += "<h1>Hello from Node</h1>"
      html += "<h3>Visits</h3>"
      html += "<ul>"
      visits.forEach(function(visit) {
        html += "<li>" + (new Date(visit.dateTime)).toString() + "</li>";
      });
      html += "</ul>";
      html += "</body>";
      html += "</html>";
      res.send(html);
    });
  });

});

app.listen(PORT);

console.log("Node server listening on port " + PORT);

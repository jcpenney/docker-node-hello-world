/*****************************************/
/* Imports */
/*****************************************/

var Express = require('express');


/*****************************************/
/* Constants */
/*****************************************/

var PORT = 8080


/*****************************************/
/* App */
/*****************************************/

var app = Express();

app.route('*').all(function (req, res, next) {
  var html = "<html>";
  html += "<head><title>Hello.</title></head>";
  html += "<body><h1>Hello, from Node.</h1></body>";
  html += "</html>";
  res.send(html);
});

app.listen(PORT);

console.log("Node server running on port " + PORT);
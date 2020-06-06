const http = require("http");

let server = http.createServer(async (request, response) => {
  if (request.url == "/") {
    console.log(request.headers["user-agent"]);
    response.end("thank you!");
    return;
  }

  response.writeHead(404);
  response.end();
});

server.listen(8000, (err) => {
  if (err) {
    return console.error("Could not listen to port 8000. ", err);
  }

  console.log("Listening on port 8000.");
});

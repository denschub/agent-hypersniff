const http = require("http");

function jsonBuilder(browser, version, os, isMobile) {
  return {
    browser: browser.toString().toLowerCase(),
    version: version.toString().toLowerCase(),
    os: os.toString().toLowerCase(),
    isMobile: isMobile.toString().toLowerCase(),
  };
}

const Sniffers = {
  isMobile: function (userAgent) {
    let result = require("ismobilejs").default(userAgent);
    return jsonBuilder("n/a", "n/a", "n/a", result.any);
  },

  uaParserJs: function (userAgent) {
    let result = require("ua-parser-js")(userAgent);
    return jsonBuilder(
      result.browser.name,
      result.browser.major,
      result.os.name,
      "n/a"
    );
  },

  useragent: function (userAgent) {
    let result = require("useragent").parse(userAgent);
    return jsonBuilder(result.family, result.major, result.os.family, "n/a");
  },
};

let server = http.createServer(async (request, response) => {
  response.setHeader("Content-Type", "application/json");

  let userAgent = request.headers["user-agent"];
  let result = {};

  let library = request.url.substr(1);
  switch (library) {
    case "ismobile":
      result = Sniffers.isMobile(userAgent);
      break;
    case "ua-parser-js":
      result = Sniffers.uaParserJs(userAgent);
      break;
    case "useragent":
      result = Sniffers.useragent(userAgent);
      break;
    default:
      result = { error: "library not found" };
      break;
  }

  response.write(JSON.stringify(result));
  response.end();
});

server.listen(8000, (err) => {
  if (err) {
    return console.error("Could not start listening: ", err);
  }

  console.log("Listening.");
});

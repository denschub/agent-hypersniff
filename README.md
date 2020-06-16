# Agent HyperSniff

A semi-automated test suite designed to stick its nose into the world of User-Agent sniffing, so you don't have to. **Disclaimer**: This is a work in progress project. Do take the reports with a grain of salt. Do not run this on a server, this is designed to be a temporary deployment on a development machine. Also, please do not use User-Agent sniffing in your application. Ever.

## What?

This setup allows us to automatically test a series of User-Agent strings against a range of UA sniffing libraries in different programming languages.

The central concept is simple: each programming language we care about has its own module, called "Nose", which is a webserver listening to port 8000. This server provides testing results from different UA sniffing libraries, one library per URL, and returns a standardized JSON response. This JSON contains the guessed browser, browser version, operating system, and the guess if the client is a mobile device or not. These results can then evaluated by the harness and compared against the values we expect.

## How to run?

Since all noses are dockerized applications, running your own tests is not too complicated.

### Requirements

To run this, you need to have

- a recent version of [Docker](https://docs.docker.com/engine/install/)
- a recent version of [Docker Compose](https://docs.docker.com/compose/install/)

### Setup and Run

1. Clone this Git repository to a directory of your choice, then change into it's root directory.
2. Run `docker-compose build` to let Docker build the containers. This may take a while. Ignore warnings that may pop up, as long as the project finishes without showing an error, everything is fine.
3. Run `docker-compose up -d` to start up the noses and have them ready for testing.
4. Run `docker-compose exec harness ./run` to start the testing process.
5. When all tests are complete and you do not plan another round, stop the services with `docker-compose down`.

Once the tests are done, you'll see a summary in your terminal and a full JSON report in the `output` directory.

## How to extend?

This setup should be flexible enough to allow for a wide range of extensions. File a bug if you need help.

### Adding new User-Agent strings to test

User-Agent strings are stored as individual files in the `data/user-agents` folder. Each file contains the UA string, a descriptive name, and the values we expect from passing tests.

### Adding a new library to an existing programming language ("Sniffer")

Open the server implementation and see how it works (sorry, this kinda depends on each implementation). Pull the library in via the dependency manager, and add a new GET route to the webserver. You're free to implement the route how you like, but make sure the final JSON output matches the template:

```json
{
  "browser": "firefox",
  "version": "42",
  "os": "macos",
  "isMobile": "false"
}
```

If the library you're testing does not support a specific field, set its value to `n/a`. Do not omit the field. When your implementation is done, register it in `data/ua-sniffers.yml`. Make sure that the key inside the YAML matches the URL you registered.

### Adding support for a new programming language ("Nose")

Everything that can be put into a Docker container can be used. A couple of things to note:

- Make sure the server listens on `0.0.0.0`, and on port 8000.
- In `data/ua-sniffers.yml`, add a new root-level entry, using the YAML-safe name, `csharp`, for example.
- Below that, add entries for each sniffing library. Please note that the keys will be used to determine the URL, so if you add a library under `example-lib` in the YAML, make sure your server returns the data on `/example-lib`.
- In the main `docker-compose.yml`, add a new service for your nose. Copy an existing nose, and make sure the service name is `nose-[programming language]`. This is also significant as the service name determines the hostname your nose will be exposed on.

## Final words

Please, do not use User-Agent sniffing. Just don't. The web will be a better place without it. Thank you.

License: MIT

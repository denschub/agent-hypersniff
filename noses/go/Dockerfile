FROM golang:buster
COPY . /app
WORKDIR /app
EXPOSE 8000
RUN go get github.com/ua-parser/uap-go/uaparser \
  && go get github.com/mssola/user_agent
CMD ["go", "run", "server.go"]

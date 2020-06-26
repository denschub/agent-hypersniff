package main

import (
  "encoding/json"
  "net/http"
  "strings"
  "strconv"

  "github.com/ua-parser/uap-go/uaparser"
  "github.com/mssola/user_agent"
)

type UAResult struct {
  Browser string `json:"browser"`
  Version string `json:"version"`
  OS string `json:"os"`
  IsMobile string `json:"isMobile"`
}

func deliver_response(w http.ResponseWriter, result UAResult) {
  js, err := json.Marshal(result)
  if err != nil {
    http.Error(w, err.Error(), http.StatusInternalServerError)
    return
  }

  w.Header().Set("Content-Type", "application/json")
  w.Write(js)
}

func get_uap_go(w http.ResponseWriter, req *http.Request) {
  parser := uaparser.NewFromSaved()
  client := parser.Parse(req.Header.Get("User-Agent"))
  result := UAResult {
    strings.ToLower(client.UserAgent.Family),
    strings.ToLower(client.UserAgent.Major),
    strings.ToLower(client.Os.Family),
    "n/a",
  }

  deliver_response(w, result)
}

func get_user_agent(w http.ResponseWriter, req *http.Request) {
  ua := user_agent.New(req.Header.Get("User-Agent"))
  name, version := ua.Browser()
  result := UAResult {
    strings.ToLower(name),
    strings.ToLower(version),
    strings.ToLower(ua.OS()),
    strconv.FormatBool(ua.Mobile()),
  }

  deliver_response(w, result)
}

func main() {
  http.HandleFunc("/uap-go", get_uap_go)
  http.HandleFunc("/user_agent", get_user_agent)
  http.ListenAndServe(":8000", nil)
}

from flask import Flask
from flask import jsonify
from flask import request

import ua_parser
import user_agents

app = Flask(__name__)

@app.route("/python-user-agents")
def python_user_agents():
  ua = user_agents.parse(request.headers["user-agent"])
  return jsonify(
    browser = ua.browser.family.lower(),
    version = str(ua.browser.version[0]),
    os = ua.os.family.lower(),
    isMobile = str((ua.is_mobile or ua.is_tablet)).lower()
  )

@app.route("/uap-python")
def uap_python():
  ua = ua_parser.user_agent_parser.Parse(request.headers["user-agent"])
  return jsonify(
    browser = ua["user_agent"]["family"].lower(),
    version = ua["user_agent"]["major"],
    os = ua["os"]["family"].lower(),
    isMobile = "n/a"
  )

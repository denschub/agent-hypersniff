<?php
require(__DIR__ . "/vendor/autoload.php");

header("Content-Type: application/json");

switch ($_GET["path"]) {
  case "mobile-detect":
    $parser = new Mobile_Detect;
    $result = array(
      "browser" => "n/a",
      "version" => "n/a",
      "os" => "n/a",
      "isMobile" => json_encode($parser->isMobile() || $parser->isTablet())
    );
    break;

  case "parser-php":
    $parser = new WhichBrowser\Parser($_SERVER["HTTP_USER_AGENT"]);
    $result = array(
      "browser" => strtolower($parser->browser->name),
      "version" => $parser->browser->version->value,
      "os" => "n/a",
      "isMobile" => json_encode($parser->isType("mobile", "tablet"))
    );
    break;

  case "phpuseragent":
    $parser = parse_user_agent();
    $result = array(
      "browser" => strtolower($parser["browser"]),
      "version" => strtolower($parser["version"]),
      "os" => strtolower($parser["platform"]),
      "isMobile" => "n/a"
    );
    break;

  case "uap-php":
    $parser = UAParser\Parser::create()->parse($_SERVER["HTTP_USER_AGENT"]);
    $result = array(
      "browser" => strtolower($parser->ua->family),
      "version" => strtolower($parser->ua->major),
      "os" => strtolower($parser->os->family),
      "isMobile" => "n/a"
    );
    break;
}

echo(json_encode($result));
?>

using Microsoft.AspNetCore.Mvc;

namespace Nose.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SniffingController : ControllerBase
    {
        [HttpGet("/uap-csharp")]
        public UAResult UAPCsharp()
        {
            var uaParser = UAParser.Parser.GetDefault();
            UAParser.ClientInfo ci = uaParser.Parse(Request.Headers["User-Agent"]);

            return new UAResult(
                ci.UA.Family.ToLower(),
                ci.UA.Major.ToLower(),
                ci.OS.Family.ToLower(),
                "n/a"
            );
        }
    }
}

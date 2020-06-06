using System.Text.Json.Serialization;

namespace Nose
{
    public class UAResult
    {
        public UAResult(string browser, string version, string os, string isMobile)
        {
            Browser = browser;
            Version = version;
            OS = os;
            IsMobile = isMobile;
        }

        [JsonPropertyName("browser")]
        public string Browser { get; set; }

        [JsonPropertyName("version")]
        public string Version { get; set; }

        [JsonPropertyName("os")]
        public string OS { get; set; }

        [JsonPropertyName("isMobile")]
        public string IsMobile { get; set; }
    }
}

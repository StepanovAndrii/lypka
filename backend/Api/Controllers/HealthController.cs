using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [Route("/healthz")]
    [ApiController]
    public class HealthController : ControllerBase
    {
        [HttpGet]
        public ActionResult Check()
        {
            return Ok();
        }
    }
}
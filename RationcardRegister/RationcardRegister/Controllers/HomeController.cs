using BusinessObjects;
using Helper;
using HelperManagers;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using RationcardRegister.Models;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;

namespace RationcardRegister.Controllers
{
    public class HomeController : Controller
    {
        private IHttpContextAccessor _accessor;
        public HomeController(IHttpContextAccessor accessor)
        {
            _accessor = accessor;
        }

        [Route("login")]
        public IActionResult Login(string returnUrl)
        {
            return Challenge(new AuthenticationProperties { RedirectUri = "/" },
                             OpenIdConnectDefaults.AuthenticationScheme);
        }

        [HttpPost]
        [Route("logout")]
        [ValidateAntiForgeryToken]
        public async Task Logout()
        {
            if (User.Identity.IsAuthenticated)
            {
                await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
                await HttpContext.SignOutAsync(OpenIdConnectDefaults.AuthenticationScheme);
            }
        }
        public IActionResult Index()
        {
            try
            {
                ViewBag.publicIp = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                ViewBag.mac = Network.GetActiveMACAddress().ToString();
                ViewBag.gateway = Network.GetActiveGateway().ToString();

            }
            catch (Exception ex)
            {                
                LoggerHelper.LogError(ex);
            }
            return View();
        }
        
        [HttpPost]
        public List<Address> GetUserLocation(string lat, string lng, string accuracy)
        {
            string status = string.Empty;
            var addresses = new List<Address>();
            try
            {
                WebClient client = new WebClient();
                string strData = string.Empty;
                // Add a user agent header in case the 
                // requested URI contains a query.

                try
                {
                    client.Headers.Add("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)");

                    Stream data = client.OpenRead("https://maps.googleapis.com/maps/api/geocode/json?latlng=" + lat + "," + lng + "&key=AIzaSyA13qCpglQCSzEPK57P1r-C4CBU9e1pO5A");
                    StreamReader reader = new StreamReader(data);
                    strData = reader.ReadToEnd();
                    data.Close();
                    reader.Close();
                }
                catch (Exception ex)
                {
                    LoggerHelper.LogError(ex);
                }

                var mapData = JsonConvert.DeserializeObject<Rootobject>(strData);
                status = mapData.status;
                if (status.Equals("OK"))
                {
                    
                    foreach(var eachResult in mapData.results)
                    {
                        var addr = new Address
                        {
                            formatted_address = eachResult.formatted_address,
                            accuracy = accuracy,
                            lattitude = lat,
                            longitude = lng                            
                        };
                        var anyCountryFound = eachResult.address_components.FirstOrDefault(i => i.types.Contains("country"));
                        if(anyCountryFound != null)
                        {
                            addr.country = anyCountryFound.long_name;
                        }

                        var anylocalityFound = eachResult.address_components.FirstOrDefault(i => i.types.Contains("locality"));
                        if (anylocalityFound != null)
                        {
                            addr.locality = anylocalityFound.long_name;
                        }

                        var anypostal_codeFound = eachResult.address_components.FirstOrDefault(i => i.types.Contains("postal_code"));
                        if (anypostal_codeFound != null)
                        {
                            addr.postal_code = anypostal_codeFound.long_name;
                        }

                        var anystreet_numberFound = eachResult.address_components.FirstOrDefault(i => i.types.Contains("street_number"));
                        if (anystreet_numberFound != null)
                        {
                            addr.street_number = anystreet_numberFound.long_name;
                        }

                        addresses.Add(addr);
                    }
                }
                
                ViewBag.ip = Network.GetActiveIP();
                ViewBag.publicIp = Network.GetPublicIpAddress().ToString();
                ViewBag.mac = Network.GetActiveMACAddress().ToString();
                ViewBag.gateway = Network.GetActiveGateway().ToString();
            }
            catch (Exception ex)
            {
                LoggerHelper.LogError(ex);
            }
            return addresses;
        }

        [HttpPost]
        public void LogNetworkDetails(string lat, string lng, string accuracy)
        {            
            try
            {
                
            }
            catch (Exception ex)
            {
                LoggerHelper.LogError(ex);
            }
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}

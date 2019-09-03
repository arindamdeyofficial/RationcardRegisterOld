using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using DataAccessSql;
using Helpers.MasterDataManager;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using RationCardRegisterWeb.Models;

namespace RationCardRegisterWeb.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        private readonly IConfiguration _configuration;
        public HomeController(IConfiguration config)
        {
            _configuration = config;
            ConnectionManager.SetConnectionString(_configuration.GetConnectionString("AzureConnectionString"));
        }
        public IActionResult Index()
        {
            MasterDataHelper.ApplicationStartDbFetch();
            MasterDataHelper.FetchMasterData();
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [AllowAnonymous]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Helper;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;

namespace RationcardRegister
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //services.AddAuthentication(options =>
            //{
            //    options.DefaultAuthenticateScheme = OpenIdConnectDefaults.AuthenticationScheme;
            //    options.DefaultSignInScheme = CookieAuthenticationDefaults.AuthenticationScheme;
            //    options.DefaultChallengeScheme = CookieAuthenticationDefaults.AuthenticationScheme;
            //})
            //.AddOpenIdConnect(options =>
            //{
            //    options.Authority = "https://biplabhomegmail.onmicrosoft.com/a2dc4dc9-6d6a-4d1e-8520-09779830ca63"; //Tenant id / Directory Id - a2dc4dc9-6d6a-4d1e-8520-09779830ca63
            //    options.ClientId = "b50896be-b613-4120-ad17-83737431b120" ; //"YOUR_APPLICATION_ID"
            //    options.ResponseType = OpenIdConnectResponseType.IdToken;
            //    options.CallbackPath = "/auth/signin-callback";
            //    options.SignedOutRedirectUri = "https://localhost:44379/";
            //    options.TokenValidationParameters.NameClaimType = "name";
            //})
            //.AddCookie();

            services.AddDataProtection();
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1);
            // Enable Node Services
            services.AddNodeServices();

            services.AddHttpsRedirection(options =>
            {
                options.RedirectStatusCode = StatusCodes.Status307TemporaryRedirect;
                options.HttpsPort = 5001;
            });

            services.AddHsts(options =>
            {
                options.Preload = true;
                options.IncludeSubDomains = true;
                options.MaxAge = TimeSpan.FromDays(60);
                //options.ExcludedHosts.Add("rationcardregister.com");
                //options.ExcludedHosts.Add("www.rationcardregister.com");
            });

            //private IHttpContextAccessor _accessor;
            //public SomeController(IHttpContextAccessor accessor)
            //{
            //    _accessor = accessor;
            //}
            //_accessor.HttpContext.Connection.RemoteIpAddress.ToString()
            //If you want to access this information in Razor Views (cshtml). Just use @inject to DI into the view:
            //@inject Microsoft.AspNetCore.Http.IHttpContextAccessor HttpContextAccessor
            //and then use it in your razor page:
            //Client IP: @HttpContextAccessor.HttpContext.Connection.RemoteIpAddress.ToString()

            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();//To get the IP
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env
            , ILoggerFactory loggerFactory, IHttpContextAccessor accessor
            , IServiceProvider services)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }
            //MongoDbHelper.InsertUser(new User { UserName = "biplabhome", Password = "password" });
            //var d = MongoDbHelper.FindUserByUserName("biplabhome");

            ConnectionManager c = new ConnectionManager(accessor, Configuration);

            app.AppMiddleWare();
            app.UseHttpsRedirection();            
            app.UseStaticFiles();
            app.UseCookiePolicy();
            //app.UseStaticFiles(new StaticFileOptions
            //{
            //    FileProvider = new PhysicalFileProvider(
            //Path.Combine(Directory.GetCurrentDirectory(), "MyStaticFiles")),
            //    RequestPath = "/StaticFiles"
            //});

            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Home}/{action=Index}/{id?}");
            });
        }
    }
}

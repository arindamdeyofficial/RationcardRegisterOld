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
            services.AddDataProtection();
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1);
            // Enable Node Services
            services.AddNodeServices();

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

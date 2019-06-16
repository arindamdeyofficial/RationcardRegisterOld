#pragma checksum "D:\OneDrive\Websites\rationcardregister.com\RationcardRegister\RationcardRegister\RationcardRegister\Views\Home\Geolocation.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "659ca868bc2076450903b71056a04a1bf66d2b54"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Home_Geolocation), @"mvc.1.0.view", @"/Views/Home/Geolocation.cshtml")]
[assembly:global::Microsoft.AspNetCore.Mvc.Razor.Compilation.RazorViewAttribute(@"/Views/Home/Geolocation.cshtml", typeof(AspNetCore.Views_Home_Geolocation))]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#line 1 "D:\OneDrive\Websites\rationcardregister.com\RationcardRegister\RationcardRegister\RationcardRegister\Views\_ViewImports.cshtml"
using RationcardRegister;

#line default
#line hidden
#line 2 "D:\OneDrive\Websites\rationcardregister.com\RationcardRegister\RationcardRegister\RationcardRegister\Views\_ViewImports.cshtml"
using RationcardRegister.Models;

#line default
#line hidden
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"659ca868bc2076450903b71056a04a1bf66d2b54", @"/Views/Home/Geolocation.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"19b3cc1a5af0f080b7728f20038fb1d4be08e1ba", @"/Views/_ViewImports.cshtml")]
    public class Views_Home_Geolocation : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<dynamic>
    {
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
#line 1 "D:\OneDrive\Websites\rationcardregister.com\RationcardRegister\RationcardRegister\RationcardRegister\Views\Home\Geolocation.cshtml"
  
    Layout = null;

#line default
#line hidden
            BeginContext(27, 2340, true);
            WriteLiteral(@"<style>
    /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
    #map {
        height: 500px;
        width:1000px;
    }
</style>
<p id=""locationText""></p>
<div data-lat="""" data-lng="""" data-info="""" style=""display:none"" id=""divData""></div>
<div id=""content"">
    You are here!
</div>

<script async defer
        src=""https://maps.googleapis.com/maps/api/js?key=AIzaSyA13qCpglQCSzEPK57P1r-C4CBU9e1pO5A&callback=initMap"">
</script>
<script>
    function getLocation() {

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(showPosition, showError);
        } else {
            $('#locationText').html(""Geolocation is not supported by this browser."");
        }
    }

    function showError(error) {
        switch (error.code) {
            case error.PERMISSION_DENIED:
                $('#locationText').html(""Please allow Geolocation to continue.  Please try reloading the site and click");
            WriteLiteral(@" on allow."");
                break;
            case error.POSITION_UNAVAILABLE:
                $('#locationText').html(""Location information is unavailable. Please try reloading the site."");
                break;
            case error.TIMEOUT:
                $('#locationText').html(""The request to get user location timed out. Please try reloading the site."");
                break;
            case error.UNKNOWN_ERROR:
                $('#locationText').html(""An unknown error occurred. Please try reloading the site. If problem continues please contact administrator."");
                break;
        }
    }

    function showPosition(position) {
        $.ajax({
            url: '/Home/GetUserLocation',
            method: 'POST',
            data: { lat: position.coords.latitude, lng: position.coords.longitude, accuracy: position.coords.accuracy},
            success: function (data, textStatus, jqXHR) {
                //alert(data);
                //alert('You are at near ""' + d");
            WriteLiteral(@"ata + '"" with accuracy level of ' + position.coords.accuracy + ' meters');
            },
            error: function (error, status, jqXHR) {
                //alert(""error"" + error);
            }
        });
    }
    function initMap() {
        getLocation();
    }
</script>
");
            EndContext();
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<dynamic> Html { get; private set; }
    }
}
#pragma warning restore 1591

using BusinessObject;
using LogManager;
using System;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Threading;

namespace NetworkManager
{
    public static class Network
    {
        static Thread _myThread;
        static MacAddr _mac;
        static int _disconnectCount = 0;
        static int _notificationCount = 0;
        static DateTime _notificationTime = DateTime.MinValue;
        static Network()
        {
            GetActiveMacAndIpAndGateway();
            NetworkChange.NetworkAddressChanged += new NetworkAddressChangedEventHandler(AddressChangedCallback);
            IsNetworkWorking();
        }
        public delegate void ConnectedCallbackDelegate(bool isConnected);
        public static ConnectedCallbackDelegate ConnectedToInternetCallback;
        public static void CheckForInternet(ConnectedCallbackDelegate connectedToInternetCallback)
        {
            _myThread = new Thread(() => RunCallBack(connectedToInternetCallback));
            _myThread.Start();
        }
        private static void RunCallBack(ConnectedCallbackDelegate connectedToInternetCallback)
        {
            while (_myThread.IsAlive)
            {
                try
                {
                    if(!IsInternetConnected)
                    {
                        _disconnectCount++;
                    }
                    if(IsInternetConnected && (_disconnectCount > 10 ) 
                        && (DateTime.Now.Subtract(_notificationTime).Minutes > 10)
                        && (_notificationCount < 5))
                    {
                        Logger.LogError("Your Internet connection is unstable. If problem continues please contact your internet provider.", true);
                        _disconnectCount = 0;
                        _notificationTime = DateTime.Now;
                        _notificationCount++;
                    }
                    connectedToInternetCallback(IsInternetConnected);
                }
                catch (Exception ex)
                {
                    //Logger.LogError(ex);
                }
            }
        }
        public static bool IsInternetConnected
        {
            get
            {
                return IsNetworkOn && IsNetworkOnByPing();
            }
            set { }
        }
        public static bool IsNetworkOn { get; set; }
        public static bool IsNetworkOnByPing()
        {
            try
            {
                Ping myPing = new Ping();
                String host = "google.com";
                byte[] buffer = new byte[32];
                int timeout = 1000;
                PingOptions pingOptions = new PingOptions();
                PingReply reply = myPing.Send(host, timeout, buffer, pingOptions);
                return (reply.Status == IPStatus.Success);
            }
            catch (Exception)
            {
                return false;
            }
        }
        public static bool IsNetworkOnByRequest()
        {
            try
            {
                using (var client = new WebClient())
                using (var stream = client.OpenRead("http://www.google.com"))
                {
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }
        //Determines if any network is available does not tells of internet
        public static void IsNetworkWorking()
        {
            IsNetworkOn = false;
            NetworkInterface[] adapters = NetworkInterface.GetAllNetworkInterfaces();
            foreach (NetworkInterface face in adapters)
            {
                // filter so we see only Internet adapters
                if (face.OperationalStatus == OperationalStatus.Up)
                {
                    if ((face.NetworkInterfaceType != NetworkInterfaceType.Tunnel) &&
                        (face.NetworkInterfaceType != NetworkInterfaceType.Loopback) &&
                        (!face.Description.Contains("Citrix")))
                    {
                        IPv4InterfaceStatistics statistics =
                            face.GetIPv4Statistics();

                        // all testing seems to prove that once an interface
                        // comes online it has already accrued statistics for
                        // both received and sent...

                        if ((statistics.BytesReceived > 0) &&
                            (statistics.BytesSent > 0))
                        {
                            IsNetworkOn = true;
                        }
                    }
                }
            }
        }
        public static void AddressChangedCallback(object sender, EventArgs e)
        {
            IsNetworkWorking();
        }

        public static string GetPublicIpAddress()
        {
            return new System.Net.WebClient().DownloadString("https://api.ipify.org");
        }
        private static void GetActiveMacAndIpAndGateway()
        {
            _mac = new MacAddr();
            try
            {
                foreach (NetworkInterface f in NetworkInterface.GetAllNetworkInterfaces())
                {
                    if (f.OperationalStatus == OperationalStatus.Up)
                    {
                        IPInterfaceProperties ipInterface = f.GetIPProperties();
                        if (ipInterface.GatewayAddresses.Count > 0)
                        {
                            foreach (UnicastIPAddressInformation unicastAddress in ipInterface.UnicastAddresses)
                            {
                                if ((unicastAddress.Address.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork) && (unicastAddress.IPv4Mask.ToString() != "0.0.0.0"))
                                {                                    
                                    _mac.IpAddress = unicastAddress.Address.ToString();
                                    var g = ipInterface.GatewayAddresses.FirstOrDefault(i => !i.Address.ToString().Equals("fe80::1%12"));
                                    _mac.Gateway = ipInterface.GatewayAddresses.FirstOrDefault(i => !i.Address.ToString().Equals("fe80::1%12")).Address.ToString();
                                    var activeMac = (NetworkInterface.GetAllNetworkInterfaces()
                                                    .FirstOrDefault(i => i.GetIPProperties()
                                                    .UnicastAddresses.Any(c => c.Address.ToString() == _mac.IpAddress)));
                                    _mac.MacId = activeMac.GetPhysicalAddress().ToString();
                                    _mac.Desc = activeMac.Description;
                                    _mac.Name = activeMac.Name;
                                    _mac.NetworkInterfaceType = activeMac.NetworkInterfaceType.ToString();
                                    _mac.OperationalStatus = activeMac.OperationalStatus.ToString();  
                                    break;
                                }
                            }
                        }
                    }
                }                
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            if (string.IsNullOrEmpty(_mac.MacId))
            {
                Logger.LogInfo("Fixed Alternate Mac Address: " + GetMACAddress());
                _mac.MacId = GetMACAddress();                
            }
            Logger.LogInfo("_mac.IpAddress" + _mac.IpAddress ?? string.Empty
                                + "_mac.Gateway" + _mac.Gateway ?? string.Empty
                                + "_mac.MacId" + _mac.MacId ?? string.Empty
                                + "_mac.Desc" + _mac.Desc ?? string.Empty
                                + "_mac.Name" + _mac.Name ?? string.Empty
                                + "_mac.NetworkInterfaceType" + _mac.NetworkInterfaceType ?? string.Empty
                                + "_mac.OperationalStatus" + _mac.OperationalStatus ?? string.Empty);
        }

        public static string GetMACAddress()
        {
            NetworkInterface[] nics = NetworkInterface.GetAllNetworkInterfaces();
            String sMacAddress = string.Empty;
            foreach (NetworkInterface adapter in nics)
            {
                if (sMacAddress == String.Empty)// only return MAC Address from first card  
                {
                    IPInterfaceProperties properties = adapter.GetIPProperties();
                    sMacAddress = adapter.GetPhysicalAddress().ToString();
                }
            }
            return sMacAddress;
        }

        public static string GetActiveIP()
        {
            return _mac.IpAddress ?? string.Empty;
        }
        public static string GetActiveMACAddress()
        {
            return _mac.MacId ?? string.Empty;
        }
        public static string GetActiveGateway()
        {
            return _mac.Gateway ?? string.Empty;
        }
    }
}

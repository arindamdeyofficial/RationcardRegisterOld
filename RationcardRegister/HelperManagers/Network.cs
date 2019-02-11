using BusinessObjects.Common;
using Helper;
using Newtonsoft.Json;
using System;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Runtime.InteropServices;
using System.Threading;

namespace HelperManagers
{
    public static class Network
    {
        static Thread _myThread;
        static int _disconnectCount = 0;
        static int _notificationCount = 0;
        static DateTime _notificationTime = DateTime.MinValue;
        static Network()
        {

        }

        [DllImport("iphlpapi.dll", ExactSpelling = true)]
        public static extern int SendARP(int DestIP, int SrcIP, [Out] byte[] pMacAddr, ref int PhyAddrLen);

        public static string GetPublicIpAddress()
        {
            var jsonStr = new System.Net.WebClient().DownloadString("https://ipinfo.io/json?token=95f222df798ba2");
            var jsonData = JsonConvert.DeserializeObject<IpInfo>(jsonStr);
            return jsonData.ip;
        }

        public static string GetActiveIP()
        {
            return GetIP().ToString();
        }

        public static IPAddress GetIP()
        {
            IPAddress ip = null;
            try
            {             
                IPHostEntry Host = default(IPHostEntry);
                string Hostname = null;
                Hostname = System.Environment.MachineName;
                Host = Dns.GetHostEntry(Hostname);
                foreach (IPAddress IP in Host.AddressList)
                {
                    if (IP.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                    {
                        ip = IP;
                    }
                }
            }
            catch (Exception ex)
            {
                LoggerHelper.LogError(ex);
            }
            return ip;
        }
        public static string GetMACAddress(string sName)
        {
            string s = string.Empty;
            try
            {
                System.Net.IPHostEntry Tempaddr = null;
                Tempaddr = (System.Net.IPHostEntry)Dns.GetHostEntry(sName);
                System.Net.IPAddress[] ipAddrList = Tempaddr.AddressList;
                string[] Ipaddr = new string[3];
                foreach (IPAddress ipAddress in ipAddrList)
                {
                    Ipaddr[1] = ipAddress.ToString();
                    const int MacAddressLength = 6;
                    int length = MacAddressLength;
                    var macBytes = new byte[MacAddressLength];
                    SendARP(BitConverter.ToInt32(ipAddress.GetAddressBytes(), 0), 0, macBytes, ref length);
                    string sMAC = BitConverter.ToString(macBytes, 0, 6);
                    Ipaddr[2] = sMAC;
                    var a = new PhysicalAddress(macBytes);
                    s = sMAC;
                }
            }
            catch(Exception ex)
            {
                LoggerHelper.LogError(ex);
            }
            return s;
        }

        public static string GetActiveMACAddress()
        {
            return GetMACAddress(GetIP().ToString());
        }
        public static string GetActiveGateway()
        {
            var ip = GetGatewayForDestination(GetIP());
            return ip.ToString();
        }
        [DllImport("iphlpapi.dll", CharSet = CharSet.Auto)]
        private static extern int GetBestInterface(UInt32 destAddr, out UInt32 bestIfIndex);

        public static IPAddress GetGatewayForDestination(IPAddress destinationAddress)
        {
            UInt32 destaddr = BitConverter.ToUInt32(destinationAddress.GetAddressBytes(), 0);

            uint interfaceIndex;
            int result = GetBestInterface(destaddr, out interfaceIndex);
            if (result != 0)
                throw new Win32Exception(result);

            foreach (var ni in NetworkInterface.GetAllNetworkInterfaces())
            {
                var niprops = ni.GetIPProperties();
                if (niprops == null)
                    continue;

                var gateway = niprops.GatewayAddresses?.FirstOrDefault()?.Address;
                if (gateway == null)
                    continue;

                if (ni.Supports(NetworkInterfaceComponent.IPv4))
                {
                    var v4props = niprops.GetIPv4Properties();
                    if (v4props == null)
                        continue;

                    if (v4props.Index == interfaceIndex)
                        return gateway;
                }

                if (ni.Supports(NetworkInterfaceComponent.IPv6))
                {
                    var v6props = niprops.GetIPv6Properties();
                    if (v6props == null)
                        continue;

                    if (v6props.Index == interfaceIndex)
                        return gateway;
                }
            }

            return null;
        }
    }
}

using BusinessObject;
using Helpers.MasterDataManager;
using Helpers.MasterDataManager.MasterDataBo;
using System.Collections.Generic;

namespace ConfigurationManager
{
    public static class ConfigManager
    {
        private static List<Config> _configs;
        public static List<Config> GetConfig(string distId = "")
        {
            if (_configs == null)
            {
                Refresh();
            }
            return _configs;
        }
        public static void Refresh(string distId = "")
        {
            MasterDataHelper.FetchConfig(distId);
            _configs = MasterData.Configs.Data;
        }
        public static string GetConfigValue(string keyText)
        {
            string val = "";
            var config = _configs.Find(i => i.KeyText.Equals(keyText));
            if (config != null)
            {
                val = config.ValueText;
            }
            else
            {
                val = "";
            }
            return val;
        }
        public static void AddOrEditConfig(string distId, string keyText, string keyVal)
        {
            MasterDataHelper.FetchConfig(distId, keyText, keyVal, 1, "ADDOREDIT");
        }
        public static void DeleteConfig(string distId, string keyText)
        {
            MasterDataHelper.FetchConfig(distId, keyText, "", 0, "DELETE");
        }
        public static void CloneConfig(string distId, string cloneFromDistId)
        {
            MasterDataHelper.FetchConfig(distId, "", "", 1, "CLONE", cloneFromDistId);
        }
    }
}

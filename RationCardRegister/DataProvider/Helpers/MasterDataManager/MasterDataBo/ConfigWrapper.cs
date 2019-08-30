using BusinessObject;
using System.Collections.Generic;
using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public class ConfigWrapper : IMasterDataTypeWrapper
    {
        public List<Config> Data { get; set; }
        public void Refresh()
        {
            MasterDataHelper.FetchConfig();
        }
        public void Assign(DataSet ds)
        {
            MasterDataHelper.AssignConfigData(ds);
        }
    }
}

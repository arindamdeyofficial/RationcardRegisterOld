using BusinessObject;
using System.Collections.Generic;
using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public class DistMasterDataTypeWrapper : IMasterDataTypeWrapper
    {
        public List<Distributor> Data { get; set; }
        public void Refresh()
        {
            MasterDataHelper.FetchDistributorData();
        }
        public void Assign(DataSet ds)
        {
            MasterDataHelper.AssignDistributorData(ds);
        }
    }
}

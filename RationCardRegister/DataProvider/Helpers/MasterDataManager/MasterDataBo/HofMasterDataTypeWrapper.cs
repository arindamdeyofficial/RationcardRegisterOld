using BusinessObject;
using System.Collections.Generic;
using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public class HofMasterDataTypeWrapper : IMasterDataTypeWrapper
    {
        public List<Hof> Data { get; set; }
        public void Refresh()
        {
            MasterDataHelper.FetchHofData();
        }
        public void Assign(DataSet ds)
        {
            MasterDataHelper.AssignHofData(ds);
        }
    }
}

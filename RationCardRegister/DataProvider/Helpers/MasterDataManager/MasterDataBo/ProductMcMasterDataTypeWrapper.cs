using BusinessObject;
using System.Collections.Generic;
using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public class ProductMcMasterDataTypeWrapper : IMasterDataTypeWrapper
    {
        public List<ProductMcMaster> Data { get; set; }
        public void Refresh()
        {
            MasterDataHelper.FetchMcData();
        }
        public void Assign(DataSet ds)
        {
            MasterDataHelper.AssignProductMcData(ds);
        }
    }
}

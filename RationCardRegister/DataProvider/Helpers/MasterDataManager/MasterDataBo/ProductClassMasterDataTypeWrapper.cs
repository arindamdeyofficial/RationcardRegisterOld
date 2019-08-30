using BusinessObject;
using System.Collections.Generic;
using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public class ProductClassMasterDataTypeWrapper : IMasterDataTypeWrapper
    {
        public List<ProductClassMaster> Data { get; set; }
        public void Refresh()
        {
            MasterDataHelper.FetchClassData();
        }
        public void Assign(DataSet ds)
        {
            MasterDataHelper.AssignProductClassData(ds);
        }
    }
}

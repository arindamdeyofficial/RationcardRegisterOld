using BusinessObject;
using System.Collections.Generic;
using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public class ProductSubClassMasterDataTypeWrapper : IMasterDataTypeWrapper
    {
        public List<ProductSubClassMaster> Data { get; set; }
        public void Refresh()
        {
            MasterDataHelper.FetchSubClassData();
        }
        public void Assign(DataSet ds)
        {
            MasterDataHelper.AssignProductSubClassData(ds);
        }
    }
}

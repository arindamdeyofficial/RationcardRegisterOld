using BusinessObject;
using System.Collections.Generic;
using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public class ProductMasterDataTypeWrapper: IMasterDataTypeWrapper
    {
        public List<Product> Data { get; set; }
        public void Refresh()
        {
            MasterDataHelper.FetchProductData();
        }
        public void Assign(DataSet ds)
        {
            MasterDataHelper.AssignProductData(ds);
        }
    }
}

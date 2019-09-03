using BusinessObject;
using System.Collections.Generic;
using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public class CategoryMasterDataTypeWrapper : IMasterDataTypeWrapper
    {
        public List<Category> Data { get; set; }
        public void Refresh()
        {
            MasterDataHelper.FetchCategoryData();
        }
        public void Assign(DataSet ds)
        {
            MasterDataHelper.AssignCategoryData(ds);
        }
    }
}

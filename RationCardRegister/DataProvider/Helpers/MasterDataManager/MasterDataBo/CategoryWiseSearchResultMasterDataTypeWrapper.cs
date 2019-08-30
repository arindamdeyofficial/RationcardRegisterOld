using BusinessObject;
using System.Collections.Generic;
using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public class CategoryWiseSearchResultMasterDataTypeWrapper : IMasterDataTypeWrapper
    {
        public List<CategoryWiseSearchResult> Data { get; set; }
        public void Refresh()
        {
            MasterDataHelper.FetchCategoryWiseSearchResult();
        }
        public void Assign(DataSet ds)
        {
            MasterDataHelper.AssignCategoryData(ds);
        }
    }
}

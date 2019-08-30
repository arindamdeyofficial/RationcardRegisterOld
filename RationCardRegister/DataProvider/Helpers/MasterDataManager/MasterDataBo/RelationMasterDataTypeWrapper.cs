using BusinessObject;
using System.Collections.Generic;
using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public class RelationMasterDataTypeWrapper : IMasterDataTypeWrapper
    {
        public List<RelationMaster> Data { get; set; }
        public void Refresh()
        {
            MasterDataHelper.FetchRelationData();
        }
        public void Assign(DataSet ds)
        {
            MasterDataHelper.AssignRelationData(ds);
        }
    }
}

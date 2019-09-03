using System.Collections.Generic;
using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public class CardsOfThisFortnightWrapper : IMasterDataTypeWrapper
    {
        public List<string> Data { get; set; }
        public void Refresh()
        {
            MasterDataHelper.FetchCardsOfThisFortnight();
        }
        public void Assign(DataSet ds)
        {
            MasterDataHelper.AssignCardsOfThisFortnight(ds);
        }
    }
}

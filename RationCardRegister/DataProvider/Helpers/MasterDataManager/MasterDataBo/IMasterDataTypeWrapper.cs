using System.Data;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public interface IMasterDataTypeWrapper
    {
        void Refresh();
        void Assign(DataSet ds);
    }
}

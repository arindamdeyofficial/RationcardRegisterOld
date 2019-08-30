using BusinessObject;
using Businessworker;
using Helpers.MasterDataManager.MasterDataBo;
using LogManager;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Helpers.MasterDataManager
{
    public static class MasterDataHelper
    {
        private static readonly List<Task> _tasksMasterDataFetch = new List<Task>();
        public static CategoryWiseSearchResult SearchCard(string searchBy, string searchText, string searchCatId, bool fetchOnlyRecentData = false)
        {
            return MasterDataWorker.SearchCard(searchBy, searchText, searchCatId, fetchOnlyRecentData);
        }
        public static RationCardDetail FetchFamilyCount(string custId)
        {
            return MasterDataWorker.FetchFamilyCount(custId);
        }
        public static void FetchConfig(string distId = "", string keyText = "", string keyVal = "", int active = 1, string operation = "GET", string cloneFromDistId = "")
        {
            MasterDataWorker.FetchConfig();
        }
        public static void AssignConfigData(DataSet ds)
        {
            MasterDataWorker.AssignConfigData(ds);
        }

        public static void AssignHofData(DataSet ds)
        {
            MasterDataWorker.AssignHofData(ds);
        }

        public static void AssignCategoryData(DataSet ds)
        {
            MasterDataWorker.AssignCategoryData(ds);
        }

        public static void AssignRelationData(DataSet ds)
        {
            MasterDataWorker.AssignRelationData(ds);
        }

        public static List<Product> ExtractProductFromDataset(DataSet ds)
        {
            return MasterDataWorker.ExtractProductFromDataset(ds);
        }

        public static void AssignProductData(DataSet ds)
        {
            MasterDataWorker.AssignProductData(ds);
        }

        public static void AssignUomData(DataSet ds)
        {
            MasterDataWorker.AssignUomData(ds);
        }

        public static void AssignProductDeptData(DataSet ds)
        {
            MasterDataWorker.AssignProductDeptData(ds);
        }

        public static void AssignProductSubDeptData(DataSet ds)
        {
            MasterDataWorker.AssignProductSubDeptData(ds);
        }

        public static void AssignProductClassData(DataSet ds)
        {
            MasterDataWorker.AssignProductClassData(ds);
        }

        public static void AssignProductSubClassData(DataSet ds)
        {
            MasterDataWorker.AssignProductSubClassData(ds);
        }

        public static void AssignProductMcData(DataSet ds)
        {
            MasterDataWorker.AssignProductMcData(ds);
        }

        public static void AssignProductBrandData(DataSet ds)
        {
            MasterDataWorker.AssignProductBrandData(ds);
        }

        public static void AssignRoleData(DataSet ds)
        {
            MasterDataWorker.AssignRoleData(ds);
        }

        public static void AssignDistributorData(DataSet ds)
        {
            MasterDataWorker.AssignDistributorData(ds);
        }

        public static void FetchHofData()
        {
            MasterDataWorker.FetchHofData();
        }

        public static void FetchCategoryData()
        {
            MasterDataWorker.FetchCategoryData();
        }

        public static void FetchCardsOfThisFortnight()
        {
            MasterDataWorker.FetchCardsOfThisFortnight();
        }
        public static void FetchRelationData()
        {
            MasterDataWorker.FetchRelationData();
        }
        public static void FetchProductData()
        {
            MasterDataWorker.FetchProductData();
        }
        public static void FetchUomData()
        {
            MasterDataWorker.FetchUomData();
        }
        public static void FetchDeptData()
        {
            MasterDataWorker.FetchDeptData();
        }
        public static void FetchSubDeptData()
        {
            MasterDataWorker.FetchSubDeptData();
        }
        public static void FetchClassData()
        {
            MasterDataWorker.FetchClassData();
        }

        public static void FetchSubClassData()
        {
            MasterDataWorker.FetchSubClassData();
        }
        public static void FetchMcData()
        {
            MasterDataWorker.FetchMcData();
        }
        public static void FetchBrandData()
        {
            MasterDataWorker.FetchBrandData();
        }
        public static void FetchRoleData()
        {
            MasterDataWorker.FetchRoleData();
        }

        public static void FetchCategoryWiseSearchResult()
        {
            MasterData.CategoryWiseSearchResult = new CategoryWiseSearchResultMasterDataTypeWrapper();
            MasterData.CategoryWiseSearchResult.Data = new List<CategoryWiseSearchResult>();
            try
            {
                //CategoryWiseSearchResult
                if ((MasterData.Categories != null))
                {
                    foreach (Category cat in MasterData.Categories.Data)
                    {
                        Thread thread = new Thread(() => MasterDataWorker.FetchCatData(cat.Cat_Id, (cat.Cat_Id == MasterData.Categories.Data.Last().Cat_Id)));
                        thread.Start();
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }

        public static void FetchDistributorData()
        {
            MasterDataWorker.FetchDistributorData();
        }

        public static void AssignCardsOfThisFortnight(DataSet ds)
        {
            MasterDataWorker.AssignCardsOfThisFortnight(ds);
        }
    }
}

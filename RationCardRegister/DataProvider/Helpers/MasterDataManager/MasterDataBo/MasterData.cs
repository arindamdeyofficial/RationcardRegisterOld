using System;

namespace Helpers.MasterDataManager.MasterDataBo
{
    public static class MasterData
    {
        public static ProductMasterDataTypeWrapper PrdData { get; set; }
        public static HofMasterDataTypeWrapper Hofs { get; set; }
        public static UomMasterDataTypeWrapper Uoms { get; set; }
        public static UomTypeMasterDataTypeWrapper UomType { get; set; }
        public static RelationMasterDataTypeWrapper Relations { get; set; }
        public static CategoryMasterDataTypeWrapper Categories { get; set; }
        public static CategoryWiseSearchResultMasterDataTypeWrapper CategoryWiseSearchResult { get; set; }
        public static ProductDeptMasterDataTypeWrapper ProductDepts { get; set; }
        public static ProductSubDeptMasterDataTypeWrapper ProductSubDepts { get; set; }
        public static ProductClassMasterDataTypeWrapper ProductClasses { get; set; }
        public static ProductSubClassMasterDataTypeWrapper ProductSubClasses { get; set; }
        public static ProductMcMasterDataTypeWrapper ProductMcs { get; set; }
        public static ProductBrandMasterDataTypeWrapper ProductBrands { get; set; }
        public static RoleMasterDataTypeWrapper Roles { get; set; }
        public static DistMasterDataTypeWrapper Distributors { get; set; }
        public static ConfigWrapper Configs { get; set; }
        public static CardsOfThisFortnightWrapper AllCardsOfThisFortnight { get; set; }
        public static int TotalHofCount { get; set; }
        public static int ActiveHofCount { get; set; }
        public static bool MasterDataFetchComplete { get; set; }
        public static DateTime DataFetchTime { get; set; }
    }
}

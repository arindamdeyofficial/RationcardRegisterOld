using System.Collections.Generic;

namespace BusinessObject
{
    public class CategoryWiseSearchResult
    {
        public List<RationCardDetail> CardSearchResult { get; set; }
        public Category CategoryOfCard { get; set; }
        public int CardCountOfCategory { get; set; }
    }
}

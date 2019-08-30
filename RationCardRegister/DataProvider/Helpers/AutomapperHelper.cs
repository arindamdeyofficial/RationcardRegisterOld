using AutoMapper;

namespace Helpers
{
    public static class AutomapperHelper
    {
        public static Y ConvertAutoMapper<X, Y>(X source)
        {
            var config = new MapperConfiguration(cfg => {
                cfg.CreateMap<X, Y>();
            });

            IMapper mapper = config.CreateMapper();
            return mapper.Map<X, Y>(source);
        }
    }
}

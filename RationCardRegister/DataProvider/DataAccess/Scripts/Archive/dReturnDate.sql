
CREATE FUNCTION dReturnDate( @dFecha as datetime)

returns DATETIME

as

begin

     DECLARE @D AS datetimeoffset

     SET @D = CONVERT(datetimeoffset, @Dfecha) AT TIME ZONE 'India Standard Time'

     RETURN CONVERT(datetime, @D);

end
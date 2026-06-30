-- ─── FUNCTION: dday_insertgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_insertgroup(integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.dday_insertgroup(
    userno integer,
    moddate timestamp without time zone,
    tagno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    sortno integer;
    groupno bigint;
BEGIN



	SET SortNo = (SELECT COALESCE(MAX(SortNo), 0) + 1 FROM DDay_Groups WHERE UserNo = dday_insertgroup.userno)

	INSERT INTO DDay_Groups VALUES (UserNo, ModDate, TagNo, Name, SortNo)


	SET GroupNo = lastval()

	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

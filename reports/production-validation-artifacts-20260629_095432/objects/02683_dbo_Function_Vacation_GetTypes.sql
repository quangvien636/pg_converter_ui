-- ─── FUNCTION: vacation_gettypes ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_gettypes();
CREATE OR REPLACE FUNCTION public.vacation_gettypes(
) RETURNS TABLE(
    typeid text,
    userno text,
    name text,
    typei text,
    time text,
    timedis text,
    datecreate text,
    statusr text,
    note text,
    sort text,
    col11 text,
    col12 text
)
AS $function$
BEGIN

RETURN QUERY
SELECT  t.TypeId
      ,t.UserNo
      ,t.Name
      ,t.Typei
      ,t.Time
      ,t.TimeDis
      ,t.DateCreate
      ,t.statusr
	  , t.Note
	  , t.Sort
	  , COALESCE(OffType,-1) OffType
	  , COALESCE(t.special,0) Special
  FROM Vacation_Types t order by t.Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

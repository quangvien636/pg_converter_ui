-- ─── FUNCTION: worktodo_insertgroupnew ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_insertgroupnew(integer, timestamp without time zone, character varying, integer, integer, timestamp without time zone, character varying, boolean, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.worktodo_insertgroupnew(
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    parentno integer,
    repno integer,
    enddate timestamp without time zone,
    description character varying,
    enabled boolean,
    startdate timestamp without time zone
) RETURNS void
AS $function$
DECLARE
    maxsortno integer;
BEGIN
 

set maxSortNo =  COALESCE((select max(SortNo) from WorkToDo_Groups where ParentNo=worktodo_insertgroupnew.parentno),0) +1;
	insert into WorkToDo_Groups values (ModUserNo,ModDate,Name,ParentNo,RepNo,EndDate,Description, maxSortNo+1,Enabled,StartDate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

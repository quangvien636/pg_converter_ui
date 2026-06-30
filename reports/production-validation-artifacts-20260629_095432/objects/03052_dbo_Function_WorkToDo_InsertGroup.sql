-- ─── FUNCTION: worktodo_insertgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_insertgroup(integer, timestamp without time zone, character varying, integer, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.worktodo_insertgroup(
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    parentno integer,
    repno integer,
    description character varying,
    enabled boolean
) RETURNS void
AS $function$
DECLARE
    maxsortno integer;
BEGIN
 

set maxSortNo =  COALESCE((select max(SortNo) from WorkToDo_Groups where ParentNo=worktodo_insertgroup.parentno),0) +1;
	insert into WorkToDo_Groups values (ModUserNo,ModDate,Name,ParentNo,RepNo,'2999-12-31',Description, maxSortNo+1,Enabled,NULL);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

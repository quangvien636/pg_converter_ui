-- ─── PROCEDURE→FUNCTION: worktodo_insertgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.worktodo_insertgroup(integer, timestamp without time zone, character varying, integer, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.worktodo_insertgroup(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN parentno integer,
    IN repno integer,
    IN description character varying,
    IN enabled boolean
) RETURNS void
AS $function$
DECLARE
    maxsortno integer;
BEGIN
 

maxSortNo := COALESCE((select max(SortNo) from WorkToDo_Groups where ParentNo=worktodo_insertgroup.parentno),0) +1;;
	insert into WorkToDo_Groups values (ModUserNo,ModDate,Name,ParentNo,RepNo,'2999-12-31',Description, maxSortNo+1,Enabled,NULL);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

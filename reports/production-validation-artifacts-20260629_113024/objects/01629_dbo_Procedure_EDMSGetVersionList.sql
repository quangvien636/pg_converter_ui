-- ─── PROCEDURE→FUNCTION: edmsgetversionlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmsgetversionlist(integer, character varying);
CREATE OR REPLACE FUNCTION public.edmsgetversionlist(
    IN id integer,
    IN lang character varying DEFAULT '1'
) RETURNS SETOF record
AS $function$
DECLARE
    id integer;
    group integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*

--*/
	----------------------------------------------------------------------------------------
	--	기본 변수 셋팅
	----------------------------------------------------------------------------------------

	FROM	EDMSDOCUMENT
	WHERE	ID = edmsgetversionlist.id
	----------------------------------------------------------------------------------------


	--그룹 값을 이용해서 버젼리스트를 뽑는다.
	RETURN QUERY
	SELECT	ID,Title,CONVERT(char(10),RegDate,120) RegDate,	VERSION, WriterID
	FROM	EDMSDOCUMENT	--버젼
	WHERE	WGROUP	= GROUP
	AND		ID		<> edmsgetversionlist.id
	and		isdelete = ''
	ORDER BY REGDATE DESC, Version desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

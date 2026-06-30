-- ─── FUNCTION: edmsgetversionlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetversionlist(integer, character varying);
CREATE OR REPLACE FUNCTION public.edmsgetversionlist(
    id integer,
    lang character varying DEFAULT '1'
) RETURNS TABLE(
    id text,
    title text,
    col3 text,
    version text,
    writerid text
)
AS $function$
DECLARE
    id integer;
    group integer;
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

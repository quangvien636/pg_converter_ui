-- ─── FUNCTION: board_getteamlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getteamlist(integer);
CREATE OR REPLACE FUNCTION public.board_getteamlist(
    departno integer
) RETURNS TABLE(
    departno serial,
    moduserno integer,
    moddate timestamp without time zone,
    parentno integer,
    name character varying(100),
    name_en character varying(100),
    shortname character varying(100),
    sortno integer,
    enabled boolean,
    name_ch character varying(200),
    name_jp character varying(200),
    name_vn character varying(200),
    sendername character varying(100)
)
AS $function$
BEGIN

WITH TEMP AS (
	SELECT T.DepartNo,T.Name 
	FROM  Organization_Departments T Where T.ParentNo=board_getteamlist.departno AND T.Enabled = TRUE
	UNION  ALL
	SELECT  D.DepartNo,D.Name 
	FROM  Organization_Departments D
	INNER JOIN  TEMP P ON P.DepartNo=D.ParentNo  AND D.Enabled = TRUE

)
RETURN QUERY
SELECT  *
FROM  TEMP;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

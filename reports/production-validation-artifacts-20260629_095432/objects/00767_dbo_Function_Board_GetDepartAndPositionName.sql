-- ─── FUNCTION: board_getdepartandpositionname ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getdepartandpositionname(integer, integer);
CREATE OR REPLACE FUNCTION public.board_getdepartandpositionname(
    departno integer,
    positionno integer
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
 

				 DepartName nvarchar(100),
				 PositionName nvarchar(100)
				)

		Insert into tmp values ((Select case when LanguageId = 'EN' then Dep.Name_EN else Dep.Name end from Organization_Departments as Dep where DepartNo = board_getdepartandpositionname.departno),
									(Select case when LanguageId = 'EN' then Name_EN else Name end from Organization_Positions where PositionNo = board_getdepartandpositionname.positionno))

		RETURN QUERY
		select * from tmp;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

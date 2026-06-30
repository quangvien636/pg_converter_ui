-- ─── FUNCTION: vacation_requestepadd ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_requestepadd(integer, integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_requestepadd(
    p_unoi integer,
    p_type integer,
    p_from timestamp without time zone,
    p_to timestamp without time zone,
    p_date timestamp without time zone,
    p_typea integer,
    p_td double precision,
    p_uno character varying,
    p_dno character varying,
    p_note character varying DEFAULT ''
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

INSERT INTO Vacation_RequestEps
           (
            TypeId
           ,Fromd
           ,Tod
		   ,Note
           ,DateCreate,StatusUser, StatusAdmin, TypeForAll, TimeDis, UserNo, departno, UsernoI)
     VALUES
           (
				p_type ,
				p_from ,
				p_to ,
				p_Note ,
				p_date, 0, 0, p_typea, p_td, p_Uno, p_Dno, p_UnoI
			)

			RETURN QUERY
			select lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

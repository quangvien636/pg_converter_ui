-- ─── FUNCTION: vacation_addrequest ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_addrequest(integer, integer, timestamp without time zone, timestamp without time zone, double precision, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.vacation_addrequest(
    p_uno integer,
    p_type integer,
    p_from timestamp without time zone,
    p_to timestamp without time zone,
    p_vcount double precision,
    p_date timestamp without time zone,
    p_note character varying DEFAULT ''
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

INSERT INTO Vacation_Requests
           (UserNo
           ,TypeId
           ,Fromd
           ,Tod
		   ,VacationsCount
		   ,Note
           ,DateCreate,StatusUser, StatusAdmin)
     VALUES
           (
				p_Uno ,
				p_type ,
				p_from ,
				p_to ,
				p_vcount,
				p_Note ,
				p_date, 0, 0
			)

			RETURN QUERY
			select lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

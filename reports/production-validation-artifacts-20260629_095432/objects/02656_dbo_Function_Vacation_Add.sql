-- ─── FUNCTION: vacation_add ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_add(integer, double precision, timestamp without time zone, integer, double precision, character varying);
CREATE OR REPLACE FUNCTION public.vacation_add(
    p_uno integer,
    p_used double precision,
    p_date timestamp without time zone,
    p_years integer,
    p_vacations double precision DEFAULT 0,
    p_note character varying DEFAULT ''
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

INSERT INTO Vacation_Vacations
           (UserNo
           ,Vacations
           ,Used
           ,Note
           ,DateCreate,statusr, years)
     VALUES
           (p_Uno ,
			p_Vacations ,
			p_used ,
			p_Note ,
			p_date ,1, p_years )

			RETURN QUERY
			select lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

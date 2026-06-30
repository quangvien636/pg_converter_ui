-- ─── FUNCTION: vacation_updatebyexcel ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_updatebyexcel(character varying, double precision, timestamp without time zone, integer, double precision, character varying);
CREATE OR REPLACE FUNCTION public.vacation_updatebyexcel(
    p_uid character varying,
    p_used double precision,
    p_date timestamp without time zone,
    p_years integer,
    p_vacations double precision DEFAULT 0,
    p_note character varying DEFAULT ''
) RETURNS TABLE(
    uno text
)
AS $function$
BEGIN

	

	DELETE FROM Vacation_Vacations where UserNo = p_uno and years = vacation_updatebyexcel.p_years;
	if(p_uno > 0)
	begin ;
		INSERT INTO Vacation_Vacations(UserNo, Vacations, Used, Note, DateCreate,statusr, years)
		VALUES(p_uno, p_Vacations, p_used, p_Note, p_date, 1, p_years);
	end
	RETURN QUERY
	select COALESCE(p_uno,0) as uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

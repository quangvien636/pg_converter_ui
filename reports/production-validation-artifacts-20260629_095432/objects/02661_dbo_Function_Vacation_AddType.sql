-- ─── FUNCTION: vacation_addtype ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_addtype(integer, integer, integer, double precision, character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.vacation_addtype(
    p_uno integer,
    p_typei integer,
    p_time integer,
    p_timed double precision,
    p_name character varying DEFAULT '',
    p_note character varying DEFAULT '',
    p_offtype integer DEFAULT -1,
    p_special integer DEFAULT 0
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

INSERT INTO Vacation_Types
           (UserNo
		   ,Name
           ,Typei
           ,Time
           ,TimeDis
           ,DateCreate,statusr, Note, Sort, OffType, special)
     VALUES
           (p_Uno ,
			p_Name ,
			p_Typei ,
			p_Time ,
			p_Timed ,SYSDATETIME() ,1, p_Note, -99,  p_OffType, p_Special)

			RETURN QUERY
			select lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

-- ─── FUNCTION: workingtime_getcompany ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getcompany();
CREATE OR REPLACE FUNCTION public.workingtime_getcompany(
) RETURNS TABLE(
    companyno integer,
    reguserno integer,
    creationdate timestamp without time zone,
    connectionstring character varying(1000),
    name character varying(100),
    domain character varying(400),
    state integer,
    hin integer,
    hout integer,
    miin integer,
    miout integer,
    timeofset integer
)
AS $function$
BEGIN


	RETURN QUERY
	select * from WorkingTime_Companies;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

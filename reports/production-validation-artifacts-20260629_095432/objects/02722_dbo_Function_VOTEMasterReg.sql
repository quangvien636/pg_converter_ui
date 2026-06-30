-- ─── FUNCTION: votemasterreg ───────────────────────────────
DROP FUNCTION IF EXISTS public.votemasterreg(character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, smallint, smallint);
CREATE OR REPLACE FUNCTION public.votemasterreg(
    title character varying,
    type character varying,
    popup character varying,
    startdate character varying,
    enddate character varying,
    public character varying,
    itemcnt integer,
    reguserno integer,
    isstandby smallint,
    isreg smallint
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	INSERT INTO VOTEMaster
			(Title
			,Type
			,PopUp
			,StartDate
			,EndDate
			,Public
			,ItemCnt
			,IsStandBy
			,IsReg
			,RegUserNo
			,RegDate)
		 VALUES
			(Title
			,Type
			,PopUp
			,StartDate
			,EndDate
			,Public
			,ItemCnt
			,IsStandBy
			,IsReg
			,RegUserNo
			,NOW())

	RETURN QUERY
	SELECT lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

-- ─── PROCEDURE→FUNCTION: votemastermod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.votemastermod(integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, smallint, smallint);
CREATE OR REPLACE FUNCTION public.votemastermod(
    IN id integer,
    IN title character varying,
    IN type character varying,
    IN popup character varying,
    IN startdate character varying,
    IN enddate character varying,
    IN public character varying,
    IN itemcnt integer,
    IN moduserno integer,
    IN isstandby smallint,
    IN isreg smallint
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTEMaster
	SET Title = votemastermod.title
		,Type = votemastermod.type
		,PopUp = votemastermod.popup
		,StartDate = votemastermod.startdate
		,EndDate = votemastermod.enddate
		,Public = votemastermod.public
		,ItemCnt = votemastermod.itemcnt
		,IsStandBy = votemastermod.isstandby
		,IsReg = votemastermod.isreg
		,ModUserNo = votemastermod.moduserno
		,ModDate = NOW()
	 WHERE ID = votemastermod.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

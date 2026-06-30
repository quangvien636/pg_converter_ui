-- ─── FUNCTION: votemastermod ───────────────────────────────
DROP FUNCTION IF EXISTS public.votemastermod(integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, smallint, smallint);
CREATE OR REPLACE FUNCTION public.votemastermod(
    id integer,
    title character varying,
    type character varying,
    popup character varying,
    startdate character varying,
    enddate character varying,
    public character varying,
    itemcnt integer,
    moduserno integer,
    isstandby smallint,
    isreg smallint
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

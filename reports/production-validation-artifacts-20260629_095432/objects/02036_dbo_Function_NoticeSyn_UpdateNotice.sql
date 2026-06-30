-- ─── FUNCTION: noticesyn_updatenotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_updatenotice(integer, integer, timestamp without time zone, character varying, integer, character varying, date, date, boolean, boolean, boolean, integer, integer, boolean, integer, boolean);
CREATE OR REPLACE FUNCTION public.noticesyn_updatenotice(
    noticeno integer,
    moduserno integer,
    moddate timestamp without time zone,
    title character varying,
    divisionno integer,
    content character varying,
    startdate date,
    enddate date,
    important boolean,
    isshare boolean,
    isattach boolean,
    totalviews integer,
    currentviews integer,
    iscontentimg boolean,
    typeno integer,
    isimportant boolean
) RETURNS void
AS $function$
BEGIN

	
	UPDATE NoticesSyn SET
		ModUserNo = noticesyn_updatenotice.moduserno,
		ModDate = noticesyn_updatenotice.moddate,
		Title = noticesyn_updatenotice.title,
		DivisionNo = noticesyn_updatenotice.divisionno,
		Content = noticesyn_updatenotice.content,
		StartDate = noticesyn_updatenotice.startdate,
		EndDate = noticesyn_updatenotice.enddate,
		Important = noticesyn_updatenotice.important,
		IsShare = noticesyn_updatenotice.isshare,
		IsAttach = noticesyn_updatenotice.isattach,
		TotalViews = noticesyn_updatenotice.totalviews,
		CurrentViews = noticesyn_updatenotice.currentviews,
		IsContentImg = noticesyn_updatenotice.iscontentimg,
		TypeNo=noticesyn_updatenotice.typeno,
		IsImportant=noticesyn_updatenotice.isimportant
	WHERE NoticeNo = noticesyn_updatenotice.noticeno

END;


----------------------------------////////////////////////-----------------------------------

-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

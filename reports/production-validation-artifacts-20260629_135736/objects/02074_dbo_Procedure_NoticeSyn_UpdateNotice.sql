-- ─── PROCEDURE→FUNCTION: noticesyn_updatenotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_updatenotice(integer, integer, timestamp without time zone, character varying, integer, character varying, date, date, boolean, boolean, boolean, integer, integer, boolean, integer, boolean);
CREATE OR REPLACE FUNCTION public.noticesyn_updatenotice(
    IN noticeno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN title character varying,
    IN divisionno integer,
    IN content character varying,
    IN startdate date,
    IN enddate date,
    IN important boolean,
    IN isshare boolean,
    IN isattach boolean,
    IN totalviews integer,
    IN currentviews integer,
    IN iscontentimg boolean,
    IN typeno integer,
    IN isimportant boolean
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

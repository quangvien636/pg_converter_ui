-- ─── PROCEDURE→FUNCTION: notice_updatenotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_updatenotice(integer, integer, timestamp without time zone, character varying, integer, character varying, date, date, boolean, boolean, boolean, integer, integer, boolean, boolean, integer);
CREATE OR REPLACE FUNCTION public.notice_updatenotice(
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
    IN ispopup boolean,
    IN departno integer
) RETURNS void
AS $function$
BEGIN


    ---DELETE FROM NoticeReferences will show popup again;
	DELETE FROM NoticeReferences where NoticeNo = notice_updatenotice.noticeno;
	---==============================;
	UPDATE Notices SET
		--ModUserNo = ModUserNo,
		ModDate = notice_updatenotice.moddate,
		Title = notice_updatenotice.title,
		DivisionNo = notice_updatenotice.divisionno,
		Content = notice_updatenotice.content,
		StartDate = notice_updatenotice.startdate,
		EndDate = notice_updatenotice.enddate,
		Important = notice_updatenotice.important,
		IsShare = notice_updatenotice.isshare,
		IsAttach = notice_updatenotice.isattach,
		TotalViews = notice_updatenotice.totalviews,
		CurrentViews = notice_updatenotice.currentviews,
		IsContentImg = notice_updatenotice.iscontentimg,
		IsPopup = notice_updatenotice.ispopup
		--DepartNo = DepartNo
	WHERE NoticeNo = notice_updatenotice.noticeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

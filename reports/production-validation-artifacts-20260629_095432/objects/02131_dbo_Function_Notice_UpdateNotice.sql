-- ─── FUNCTION: notice_updatenotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_updatenotice(integer, integer, timestamp without time zone, character varying, integer, character varying, date, date, boolean, boolean, boolean, integer, integer, boolean, boolean, integer);
CREATE OR REPLACE FUNCTION public.notice_updatenotice(
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
    ispopup boolean,
    departno integer
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

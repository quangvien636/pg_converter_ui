-- ─── FUNCTION: notice_insertnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_insertnotice(integer, timestamp without time zone, character varying, integer, character varying, date, date, boolean, boolean, boolean, integer, integer, boolean, boolean, integer);
CREATE OR REPLACE FUNCTION public.notice_insertnotice(
    reguserno integer,
    regdate timestamp without time zone,
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
) RETURNS TABLE(
    noticeno text
)
AS $function$
DECLARE
    noticeno integer;
BEGIN


	INSERT INTO Notices (RegUserNo, RegDate, ModUserNo, ModDate,
		Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews, IsContentImg,IsPopup, DepartNo)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
		Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews,IsContentImg,IsPopup, DepartNo)
		

	SET NoticeNo = lastval()
	
	RETURN QUERY
	SELECT NoticeNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

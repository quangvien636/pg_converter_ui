-- ─── FUNCTION: notice_restorenotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_restorenotice();
CREATE OR REPLACE FUNCTION public.notice_restorenotice(
) RETURNS TABLE(
    noticeno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    title text,
    divisionno text,
    content text,
    startdate text,
    enddate text,
    important text,
    isshare text,
    isattach text,
    totalviews text,
    currentviews text,
    iscontentimg text,
    ispopup text,
    departno text,
    ppstartdate text,
    ppenddate text
)
AS $function$
BEGIN


RETURN QUERY
SELECT VALUE into #tam FROM public."UF_TEXT_SPLIT"(p_nos,';');

	SET IDENTITY_INSERT Notices ON;;
	insert into Notices(NoticeNo,RegUserNo,RegDate,ModUserNo,ModDate,Title
						,DivisionNo,Content,StartDate,EndDate,Important,IsShare,IsAttach,TotalViews
						,CurrentViews,IsContentImg,IsPopup,DepartNo,PPStartDate,PPEndDate)
	RETURN QUERY
	select 
		d.NoticeNo
		,d.RegUserNo
		,d.RegDate
		,d.ModUserNo
		,d.ModDate
		,d.Title
		,d.DivisionNo
		,d.Content
		,d.StartDate
		,d.EndDate
		,d.Important
		,d.IsShare
		,d.IsAttach
		,d.TotalViews
		,d.CurrentViews
		,d.IsContentImg
		,d.IsPopup
		,d.DepartNo
		,d.PPStartDate
		,d.PPEndDate
	from NoticesDelete d where d.NoticeNo in( select * from #tam);;
	DELETE FROM NoticesDelete  where NoticeNo in( select * from #tam);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

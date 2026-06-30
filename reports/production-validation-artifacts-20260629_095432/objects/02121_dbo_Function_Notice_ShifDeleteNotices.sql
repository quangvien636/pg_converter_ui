-- ─── FUNCTION: notice_shifdeletenotices ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_shifdeletenotices(character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_shifdeletenotices(
    p_nos character varying,
    p_uno integer
) RETURNS TABLE(
    noticeno text,
    p_uno text,
    deletedate text,
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
    ppenddate text,
    p_uno text,
    col24 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT VALUE into #tam FROM public."UF_TEXT_SPLIT"(p_nos,';');

	insert into NoticesShiftDelete(NoticeNo,UserNo,DeleteDate,RegUserNo,RegDate,ModUserNo,ModDate,Title
						,DivisionNo,Content,StartDate,EndDate,Important,IsShare,IsAttach,TotalViews
						,CurrentViews,IsContentImg,IsPopup,DepartNo,PPStartDate,PPEndDate,UserNo2, DeleteDate2)
	RETURN QUERY
	select 
		d.NoticeNo
		,p_uno
		,d.DeleteDate
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
		,p_uno
		,NOW()
	from NoticesDelete d 
	join #tam d2 on d.NoticeNo = d2.VALUE;;
	DELETE FROM NoticesDelete WHERE NoticeNo IN (SELECT * FROM #tam);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

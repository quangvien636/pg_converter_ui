-- ─── FUNCTION: notice_deletenotices ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_deletenotices(character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_deletenotices(
    p_nos character varying,
    p_uno integer
) RETURNS TABLE(
    noticeno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tbnoticenos table (
		noticeno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SET StartIndex = 1
	SET SearchIndex = 1

	WHILE (SearchIndex > 0)
	BEGIN

		SET SearchIndex = STRPOS(p_nos, StartIndex, ';')

		IF SearchIndex = 0 BEGIN

			SET TempStr = RIGHT(p_nos, LEN(p_nos) - StartIndex + 1)

		END

		ELSE BEGIN

			SET TempStr = SUBSTRING(p_nos, StartIndex, SearchIndex - StartIndex)

		END

		IF LEN(TempStr) > 0 BEGIN

			INSERT INTO tbNoticeNos VALUES(TempStr)

		END

		SET StartIndex = SearchIndex + 1 

	END

	insert into NoticesDelete(NoticeNo,UserNo,DeleteDate,RegUserNo,RegDate,ModUserNo,ModDate,Title
						,DivisionNo,Content,StartDate,EndDate,Important,IsShare,IsAttach,TotalViews
						,CurrentViews,IsContentImg,IsPopup,DepartNo,PPStartDate,PPEndDate)
	RETURN QUERY
	select 
		d.NoticeNo
		,p_uno
		,NOW()
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
	from Notices d 
	join tbNoticeNos d2 on d.NoticeNo = d2.NoticeNo;;
	DELETE FROM Notices WHERE NoticeNo IN (SELECT NoticeNo FROM tbNoticeNos);;
	DELETE FROM NoticeReference WHERE NoticeNo IN (SELECT NoticeNo FROM tbNoticeNos);
	--update Notices set isdeleted = TRUE WHERE NoticeNo IN (SELECT NoticeNo FROM tbNoticeNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

-- ─── FUNCTION: noticesyn_insertnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_insertnotice(integer, timestamp without time zone, character varying, integer, character varying, date, date, boolean, boolean, boolean, integer, integer, boolean, integer, boolean);
CREATE OR REPLACE FUNCTION public.noticesyn_insertnotice(
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
    typeno integer,
    isimportant boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    noticeno integer;
BEGIN


	INSERT INTO NoticesSyn (RegUserNo, RegDate, ModUserNo, ModDate,
		Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews, IsContentImg,TypeNo,IsDelete,IntegratedNo,IsImportant)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
		Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews,IsContentImg,TypeNo,'',0,IsImportant)
		

	SET NoticeNo = lastval()
	
	RETURN QUERY
	SELECT NoticeNo

END;

------------------------------------ ---------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

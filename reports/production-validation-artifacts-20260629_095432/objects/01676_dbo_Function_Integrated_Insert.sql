-- ─── FUNCTION: integrated_insert ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_insert(integer, timestamp without time zone, character varying, integer, character varying, date, date, boolean, boolean, boolean, integer, integer, boolean, integer, integer, integer, integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.integrated_insert(
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
    treeno integer,
    treeitem2 integer,
    treeitem3 integer,
    typeno integer,
    treeroot integer,
    options integer,
    isimportant boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    integratedno integer;
BEGIN


	INSERT INTO Integrateds(RegUserNo, RegDate, ModUserNo, ModDate,
		Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews, IsContentImg,TreeRoot,TreeNo,TreeItem2,TreeItem3,TypeNo,IsDelete,IsImportant)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
		Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews,IsContentImg,TreeRoot ,TreeNo,TreeItem2,TreeItem3,TypeNo,'',IsImportant)
		

	SET IntegratedNo = lastval()
	
	if(Options=1) BEGIN;
		INSERT INTO NoticesSyn (RegUserNo, RegDate, ModUserNo, ModDate,
			Title, DivisionNo, Content, StartDate, EndDate,
			Important, IsShare, IsAttach, TotalViews, CurrentViews, IsContentImg,TypeNo,IsDelete,IntegratedNo,TreeRoot,TreeNo,TreeItem2,TreeItem3,Options,IsImportant)
		VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
			Title, DivisionNo, Content, StartDate, EndDate,
			Important, IsShare, IsAttach, TotalViews, CurrentViews,IsContentImg,TypeNo,'',IntegratedNo,TreeRoot ,TreeNo,TreeItem2,TreeItem3,Options,IsImportant)
	END





	RETURN QUERY
	SELECT IntegratedNo

END;
---------------------////////////////////----------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

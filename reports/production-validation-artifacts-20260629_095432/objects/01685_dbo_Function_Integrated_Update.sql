-- ─── FUNCTION: integrated_update ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_update(integer, integer, timestamp without time zone, character varying, integer, character varying, date, date, boolean, boolean, boolean, integer, integer, boolean, integer, integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.integrated_update(
    integratedno integer,
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
    treeitem2 integer,
    treeitem3 integer,
    options integer,
    isimportant boolean
) RETURNS void
AS $function$
BEGIN

	
	UPDATE Integrateds SET
		ModUserNo = integrated_update.moduserno,
		ModDate = integrated_update.moddate,
		Title = integrated_update.title,
		DivisionNo = integrated_update.divisionno,
		Content = integrated_update.content,
		StartDate = integrated_update.startdate,
		EndDate = integrated_update.enddate,
		Important = integrated_update.important,
		IsShare = integrated_update.isshare,
		IsAttach = integrated_update.isattach,
		TotalViews = integrated_update.totalviews,
		CurrentViews = integrated_update.currentviews,
		IsContentImg = integrated_update.iscontentimg,
		TypeNo=integrated_update.typeno,
		TreeItem2=integrated_update.treeitem2,
		TreeItem3=integrated_update.treeitem3,
		IsImportant=integrated_update.isimportant
	WHERE IntegratedNo = integrated_update.integratedno

	if(Options = 1) BEGIN;
			UPDATE NoticesSyn SET
			ModUserNo = integrated_update.moduserno,
			ModDate = integrated_update.moddate,
			Title = integrated_update.title,
			DivisionNo = integrated_update.divisionno,
			Content = integrated_update.content,
			StartDate = integrated_update.startdate,
			EndDate = integrated_update.enddate,
			Important = integrated_update.important,
			IsShare = integrated_update.isshare,
			IsAttach = integrated_update.isattach,
			TotalViews = integrated_update.totalviews,
			CurrentViews = integrated_update.currentviews,
			IsContentImg = integrated_update.iscontentimg,
			TypeNo=integrated_update.typeno,
			TreeItem2=integrated_update.treeitem2,
		TreeItem3=integrated_update.treeitem3,
		IsImportant=integrated_update.isimportant
		WHERE IntegratedNo = integrated_update.integratedno
	END
	ELSE IF(Important = 0) BEGIN;
	 delete from NoticesSyn WHERE IntegratedNo = integrated_update.integratedno
	END 

END;



----------------------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

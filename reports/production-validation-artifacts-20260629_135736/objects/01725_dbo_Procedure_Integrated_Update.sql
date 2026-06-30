-- ─── PROCEDURE→FUNCTION: integrated_update ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.integrated_update(integer, integer, timestamp without time zone, character varying, integer, character varying, date, date, boolean, boolean, boolean, integer, integer, boolean, integer, integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.integrated_update(
    IN integratedno integer,
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
    IN treeitem2 integer,
    IN treeitem3 integer,
    IN options integer,
    IN isimportant boolean
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
	END;
	ELSE IF(Important = 0) BEGIN;
	 delete from NoticesSyn WHERE IntegratedNo = integrated_update.integratedno
	END;

END;



----------------------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

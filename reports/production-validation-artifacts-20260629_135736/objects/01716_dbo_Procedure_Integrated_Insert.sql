-- ─── PROCEDURE→FUNCTION: integrated_insert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_insert(integer, timestamp without time zone, character varying, integer, character varying, date, date, boolean, boolean, boolean, integer, integer, boolean, integer, integer, integer, integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.integrated_insert(
    IN reguserno integer,
    IN regdate timestamp without time zone,
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
    IN treeno integer,
    IN treeitem2 integer,
    IN treeitem3 integer,
    IN typeno integer,
    IN treeroot integer,
    IN options integer,
    IN isimportant boolean
) RETURNS SETOF record
AS $function$
DECLARE
    integratedno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Integrateds(RegUserNo, RegDate, ModUserNo, ModDate,
		Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews, IsContentImg,TreeRoot,TreeNo,TreeItem2,TreeItem3,TypeNo,IsDelete,IsImportant)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
		Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews,IsContentImg,TreeRoot ,TreeNo,TreeItem2,TreeItem3,TypeNo,'',IsImportant)
		

	IntegratedNo := lastval();
	if(Options=1) BEGIN;
		INSERT INTO NoticesSyn (RegUserNo, RegDate, ModUserNo, ModDate,
			Title, DivisionNo, Content, StartDate, EndDate,
			Important, IsShare, IsAttach, TotalViews, CurrentViews, IsContentImg,TypeNo,IsDelete,IntegratedNo,TreeRoot,TreeNo,TreeItem2,TreeItem3,Options,IsImportant)
		VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
			Title, DivisionNo, Content, StartDate, EndDate,
			Important, IsShare, IsAttach, TotalViews, CurrentViews,IsContentImg,TypeNo,'',IntegratedNo,TreeRoot ,TreeNo,TreeItem2,TreeItem3,Options,IsImportant)
	END;





	RETURN QUERY
	SELECT IntegratedNo

END;
---------------------////////////////////----------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

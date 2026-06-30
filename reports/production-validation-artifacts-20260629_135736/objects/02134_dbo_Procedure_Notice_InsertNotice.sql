-- ─── PROCEDURE→FUNCTION: notice_insertnotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_insertnotice(integer, timestamp without time zone, character varying, integer, character varying, date, date, boolean, boolean, boolean, integer, integer, boolean, boolean, integer);
CREATE OR REPLACE FUNCTION public.notice_insertnotice(
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
    IN ispopup boolean,
    IN departno integer
) RETURNS SETOF record
AS $function$
DECLARE
    noticeno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Notices (RegUserNo, RegDate, ModUserNo, ModDate,
		Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews, IsContentImg,IsPopup, DepartNo)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
		Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews,IsContentImg,IsPopup, DepartNo)
		

	NoticeNo := lastval();
	RETURN QUERY
	SELECT NoticeNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

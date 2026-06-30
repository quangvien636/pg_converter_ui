-- ─── PROCEDURE→FUNCTION: noticesyn_setshareupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_setshareupdate(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.noticesyn_setshareupdate(
    IN noticeno integer,
    IN departno integer,
    IN ischild character varying
) RETURNS SETOF record
AS $function$
DECLARE
    count integer;
    departname character varying;
    tdepartno integer;
    tparentno integer;
    ischeck integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN







IF Mode = 0 THEN
	count := 1;
	TDepartNo := noticesyn_setshareupdate.departno;
	WHILE count>0 LOOP
		SELECT DepartNo, ParentNo, Name INTO tdepartno, tparentno, departname from Organization_Departments where DepartNo=TDepartNo

		SELECT count(*) INTO ischeck from NoticeSyn_Sharers where NoticeNo=noticesyn_setshareupdate.noticeno and DepartNo=TDepartNo
		if(isCheck = FALSE) BEGIN;
			INSERT INTO NoticeSyn_Sharers(NoticeNo,DepartNo,DepartName,IsChild)
			VALUES(NoticeNo,TDepartNo,DepartName,IsChild)
			TDepartNo := TParentNo;
			SELECT count(*) INTO count from Organization_Departments where DepartNo=TParentNo
		END LOOP;
		ELSE BEGIN
			count := 0;
		END IF;
	END;
END;
ELSE BEGIN;
		DELETE FROM NoticeSyn_Sharers WHERE NoticeNo = noticesyn_setshareupdate.noticeno
END;
	
	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

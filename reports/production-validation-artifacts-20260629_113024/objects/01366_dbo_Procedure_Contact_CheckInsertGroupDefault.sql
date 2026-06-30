-- ─── PROCEDURE→FUNCTION: contact_checkinsertgroupdefault ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contact_checkinsertgroupdefault(integer, character varying);
CREATE OR REPLACE FUNCTION public.contact_checkinsertgroupdefault(
    IN userno integer,
    IN isdefault character varying
) RETURNS SETOF record
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	if((select count(*)	from ContactsGroup	where RegUserNo=contact_checkinsertgroupdefault.userno and IsDefault=contact_checkinsertgroupdefault.isdefault)=0) begin;
		INSERT INTO ContactsGroup (GroupName, ParentGNo, RegUserNo, Sort,RegDate,IsDefault,UseYn)
		VALUES (GroupName, 0, UserNo, 0 ,NOW(),'1','Y')
		GroupNo := lastval();
		RETURN QUERY
		SELECT GroupNo AS GroupNo
	END;
	else begin;
		update ContactsGroup set GroupName=GroupName where RegUserNo=contact_checkinsertgroupdefault.userno and IsDefault=contact_checkinsertgroupdefault.isdefault

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

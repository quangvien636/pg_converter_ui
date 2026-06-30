-- ─── PROCEDURE→FUNCTION: sourcecontrol_completesource ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sourcecontrol_completesource(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sourcecontrol_completesource(
    IN projectid integer DEFAULT 1,
    IN companyid integer DEFAULT 11,
    IN userno integer DEFAULT 70,
    IN databasetype integer DEFAULT 1
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


UPDATE public."SourceControl_CompanyHistory"
SET IsLastVersion = FALSE,UpdateUserNo=sourcecontrol_completesource.userno,UpdateDate=NOW()
WHERE CompanyId=sourcecontrol_completesource.companyid  AND IsLastVersion = TRUE;
INSERT INTO public."SourceControl_CompanyHistory"
           (CompanyId
           ,ProjectHistoryId
           ,IsLastVersion
           ,CreateUserNo
           ,CreateDate
           ,UpdateUserNo
           ,UpdateDate
           ,DatabaseHistoryId)
  RETURN QUERY
  SELECT CompanyId AS CompanyId,PH.Id AS ProjectHistoryId, TRUE AS IsLastVersion,UserNo AS CreateUserNo,NOW() AS CreateDate,UserNo AS UpdateUserNo,NOW() AS UpdateDate,DataBaseType AS DatabaseHistoryId
  FROM SourceControl_ProjectHistory PH
  LEFT JOIN SourceControl_DatabaseHistory DH ON DH.ProjectHistoryId=PH.Id AND DH.IsLastVersion = TRUE AND DH.Type=sourcecontrol_completesource.databasetype
  WHERE  PH.ProjectId = sourcecontrol_completesource.projectid AND PH.IsLastVersion = TRUE
END;
--DELETE  from SourceControl_CompanyHistory
--select * from SourceControl_CompanyHistory
--select * from SourceControl_Company

  --SELECT 11 AS CompanyId,PH.Id AS ProjectHistoryId, TRUE AS IsLastVersion,70 AS CreateUserNo,NOW() AS CreateDate,70 AS UpdateUserNo,NOW() AS UpdateDate,1 AS DatabaseHistoryId
  --FROM SourceControl_ProjectHistory PH
  --LEFT JOIN SourceControl_DatabaseHistory DH ON DH.ProjectHistoryId=PH.Id AND DH.IsLastVersion = TRUE AND DH.Type=1
  --WHERE  PH.ProjectId = 1 AND PH.IsLastVersion = TRUE
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

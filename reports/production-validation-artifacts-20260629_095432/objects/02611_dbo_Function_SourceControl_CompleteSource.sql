-- ─── FUNCTION: sourcecontrol_completesource ───────────────────────────────
DROP FUNCTION IF EXISTS public.sourcecontrol_completesource(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sourcecontrol_completesource(
    projectid integer DEFAULT 1,
    companyid integer DEFAULT 11,
    userno integer DEFAULT 70,
    databasetype integer DEFAULT 1
) RETURNS TABLE(
    id serial,
    name text,
    code text,
    website text,
    ipaddress text,
    disable boolean,
    createuserno integer,
    createdate timestamp without time zone,
    updateuserno integer,
    updatedate timestamp without time zone,
    databasetype integer
)
AS $function$
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

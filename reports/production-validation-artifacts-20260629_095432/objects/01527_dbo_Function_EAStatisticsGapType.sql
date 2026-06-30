-- ─── FUNCTION: eastatisticsgaptype ───────────────────────────────
DROP FUNCTION IF EXISTS public.eastatisticsgaptype(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.eastatisticsgaptype(
    formid character varying,
    deptid character varying,
    startdate character varying,
    enddate character varying
) RETURNS TABLE(
    orgcd text
)
AS $function$
DECLARE
    iformid integer;
BEGIN






RETURN QUERY
select '#ffffff' bgcolor, DepartID,ManagerID,formid,cast(incnt as varchar(20)) incnt,cast(outcnt as varchar(20)) outcnt,(select OrgNm1 from CMONOrgan where OrgCd=DepartID) dpnm,(select usernm1 from CMONUsers where UserId=ManagerID) usernm,
   (select name from EAPPForm  where  ID=eastatisticsgaptype.formid ) formnm,cast(incnt+outcnt as varchar(20)) totcnt ,cast(cast((outcnt*100/(incnt+outcnt) ) as int) as varchar(20)) ratio
from (
 select  DepartID,ManagerID,formid,SUM(case when  ihour <=12 then 1 else 0 end ) incnt
  ,SUM(case when  ihour > 12 then 1 else 0 end ) outcnt 
 from (
   SELECT 
       ManagerID
      ,DATEDIFF ( hour , ArriveDate, ManageDate  ) ihour
     ,case when a.DepartID is null  or a.DepartID='' then (select OrgCd1 from CMONUsers where UserId=a.ManagerID) else a.DepartID end DepartID
    ,b.FormID
   FROM EAPPProgress a join EAPPDocument b 
    on  a.DocumentID=b.id
    where a.ManageDate is not null and ArriveDate is not null
    and  b.RegDate between startdate || ' 00:00:00' and enddate || ' 23:59:59'
    and  (FormID='0' or  FormID=iFormID )
    and  ( DeptID ='%'  or a.DepartID   in (SELECT OrgCd FROM  public."COMNGetOrganChild"(DeptID)))
   ) a group by DepartID,ManagerID,formid
  ) a order by DepartID,ManagerID,formid



 RETURN QUERY
 select  SUM(case when  ihour <= 720 then 1 else 0 end ) incnt, SUM(case when  ihour <= 720 then ihour else 0 end ) intime
  ,SUM(case when  ihour > 720 then 1 else 0 end ) outcnt   ,SUM(case when  ihour > 720 then ihour else 0 end ) outtime 
 from (
   SELECT 
       ManagerID
      ,DATEDIFF ( MINUTE , ArriveDate, ManageDate  ) ihour
     ,case when a.DepartID is null  or a.DepartID='' then (select OrgCd1 from CMONUsers where UserId=a.ManagerID) else a.DepartID end DepartID
    ,b.FormID
   FROM EAPPProgress a join EAPPDocument b 
    on  a.DocumentID=b.id
    where a.ManageDate is not null  and ArriveDate is not null
    and  b.RegDate between startdate || ' 00:00:00' and enddate || ' 23:59:59'
    and  (FormID='0' or  FormID=iFormID )
    and  ( DeptID ='%'  or a.DepartID   in (SELECT OrgCd FROM  public."COMNGetOrganChild"(DeptID)))
   ) a;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

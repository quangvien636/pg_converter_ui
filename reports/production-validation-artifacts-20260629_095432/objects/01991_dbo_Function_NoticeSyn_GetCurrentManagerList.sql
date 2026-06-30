-- ─── FUNCTION: noticesyn_getcurrentmanagerlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getcurrentmanagerlist();
CREATE OR REPLACE FUNCTION public.noticesyn_getcurrentmanagerlist(
) RETURNS TABLE(
    id text,
    userno text,
    username text,
    department text,
    id text,
    userno text,
    username text,
    groupname text,
    department text,
    departmentid text,
    date text
)
AS $function$
BEGIN

	--select
	--	bg.USERGROUP_ID AS "Id", 
	--	us.UserNo,
	--	us.Name AS "UserName",
	--	'R&D' AS "Department",
	--	convert(datetime, bg.DTS_INSERT, 111) AS "Date"
	--from 
	--  Organization_Users us 
	--  inner join Notice_UserByGroup bg
	--  on us.UserNo = bg.USER_NO
	----Where bg.AUTH_GRP_ID = GROUPID


	RETURN QUERY
	select
		bg.USERGROUP_ID AS "Id", 
		bg.USER_NO AS "UserNo",
		CASE 
		  WHEN bg.USER_NO >0  THEN us.Name 
		  ELSE od.Name || ' (' || od.Name_EN || ')'
		END AS "UserName" ,
		ag.AUTH_GRP_NM AS "GroupName",
		CASE 
		  WHEN bg.USER_NO >0  THEN public."UF_DepartmentName" (bg.USER_NO)  
		  ELSE od.Name || ' (' || od.Name_EN || ')'
		END AS "Department" ,
		bg.DEPARTMENT_ID AS "DepartmentId",
		convert(datetime, bg.DTS_INSERT, 111) AS "Date"
	from 
	NoticeSyn_UserByGroup bg LEFT JOIN
	  Organization_Users us  
	  on us.UserNo = bg.USER_NO inner join NoticeSyn_AuthoGroup ag on bg.AUTH_GRP_ID=ag.AUTH_GRP_ID 

	  LEFT JOIN Organization_Departments od on od.DepartNo=bg.DEPARTMENT_ID
	  where NOT (bg.USER_NO >0 AND us.UserNo Is null)

END;
-----------------------------------///////////////////////////////////
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

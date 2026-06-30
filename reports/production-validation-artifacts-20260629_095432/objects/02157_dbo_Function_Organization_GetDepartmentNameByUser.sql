-- ─── FUNCTION: organization_getdepartmentnamebyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getdepartmentnamebyuser(integer);
CREATE OR REPLACE FUNCTION public.organization_getdepartmentnamebyuser(
    userno integer
) RETURNS TABLE(
    departno text,
    name text,
    name_en text,
    pname text,
    pnameen text
)
AS $function$
BEGIN


	with name_tree as 
	(
 		SELECT DepartNo, ParentNo, Name, Name_EN FROM Organization_Departments 
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment 
			WHERE UserNo = organization_getdepartmentnamebyuser.userno
		)
	   union all
	   select C.DepartNo, C.ParentNo, c.Name, c.Name_EN
	   from Organization_Departments c
	   join name_tree p on C.DepartNo = P.ParentNo  
		AND C.DepartNo<>C.ParentNo 
	) 
	RETURN QUERY
	select tr.DepartNo
		,(case when LangCode = 'EN' then COALESCE(tr.Name_En,tr.Name) else   tr.Name end) DepartName
		,(case when LangCode = 'EN' then COALESCE(bl.pNameEn,bl.pName) else   bl.pName end) Posision
		,(case when LangCode = 'EN' then COALESCE(bl.Name_EN,bl.Name) else   bl.Name end) Duties
	from name_tree tr
	left join (
			select b.DepartNo, d.Name, d.Name_EN,p.Name as pName, p.Name_EN   as pNameEn
			FROM Organization_BelongToDepartment  b
			left join Organization_Duties d on b.DutyNo = d.DutyNo
			left JOIN Organization_Positions P ON b.PositionNo = P.PositionNo 
			WHERE b.UserNo = organization_getdepartmentnamebyuser.userno
		
		) bl
	on tr.DepartNo = bl.DepartNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

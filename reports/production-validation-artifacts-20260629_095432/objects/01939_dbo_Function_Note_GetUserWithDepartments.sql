-- ─── FUNCTION: note_getuserwithdepartments ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getuserwithdepartments(integer);
CREATE OR REPLACE FUNCTION public.note_getuserwithdepartments(
    departno integer
) RETURNS TABLE(
    userno text,
    departno text,
    positionno text,
    name text,
    name_en text,
    cellphone text,
    userphoto text,
    photo text,
    positionsname text,
    positionsnameen text,
    moddate text
)
AS $function$
BEGIN

RETURN QUERY
SELECT        public."Organization_Users".UserNo, public."Organization_Departments".DepartNo, public."Organization_Positions".PositionNo, public."Organization_Users".Name, public."Organization_Users".Name_EN, 
                         public."Organization_Users".CellPhone, public."Organization_Users".UserPhoto, public."Organization_Users".Photo, public."Organization_Positions".Name AS PositionsName, 
                         public."Organization_Positions".Name_EN AS PositionsNameEN, public."Organization_Users".ModDate
FROM            public."Organization_Users" INNER JOIN
                         public."Organization_BelongToDepartment" ON public."Organization_Users".UserNo = public."Organization_BelongToDepartment".UserNo INNER JOIN
                         public."Organization_Positions" ON public."Organization_BelongToDepartment".PositionNo = public."Organization_Positions".PositionNo INNER JOIN
                         public."Organization_Departments" ON public."Organization_BelongToDepartment".DepartNo = public."Organization_Departments".DepartNo
	where public."Organization_Departments".DepartNo=note_getuserwithdepartments.departno AND public."Organization_Users".Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

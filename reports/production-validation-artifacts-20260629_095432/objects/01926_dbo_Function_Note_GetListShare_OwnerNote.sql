-- ─── FUNCTION: note_getlistshare_ownernote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getlistshare_ownernote(uuid);
CREATE OR REPLACE FUNCTION public.note_getlistshare_ownernote(
    listno uuid
) RETURNS TABLE(
    usersname text,
    usersnameen text,
    cellphone text,
    companyphone text,
    photo text,
    positions text,
    positionsen text,
    departno text,
    userno text,
    listno text,
    groupno text,
    daycreate text,
    dayedit text,
    readdate text,
    notetimezoneread text
)
AS $function$
BEGIN

RETURN QUERY
SELECT        public."Organization_Users".Name AS UsersName, public."Organization_Users".Name_EN AS UsersNameEN, public."Organization_Users".CellPhone, public."Organization_Users".CompanyPhone, 
                         public."Organization_Users".Photo, public."Organization_Positions".Name AS Positions, public."Organization_Positions".Name_EN AS PositionsEN, public."Organization_BelongToDepartment".DepartNo, public."Note_List".UserNo, 
                         public."Note_List".ListNo, public."Note_List".GroupNo, public."Note_List".DayCreate, public."Note_List".DayEdit, public."Note_List".ReadDate, public."Note_List".NoteTimeZoneRead
FROM            public."Organization_Users" INNER JOIN
                         public."Organization_BelongToDepartment" ON public."Organization_Users".UserNo = public."Organization_BelongToDepartment".UserNo INNER JOIN
                         public."Organization_Positions" ON public."Organization_BelongToDepartment".PositionNo = public."Organization_Positions".PositionNo INNER JOIN
                         public."Note_List" ON public."Organization_Users".UserNo = public."Note_List".UserNo
	WHERE ListNo=note_getlistshare_ownernote.listno
	ORDER BY DayCreate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

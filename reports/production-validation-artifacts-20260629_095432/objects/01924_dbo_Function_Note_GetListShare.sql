-- ─── FUNCTION: note_getlistshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getlistshare(uuid);
CREATE OR REPLACE FUNCTION public.note_getlistshare(
    listno uuid
) RETURNS TABLE(
    shareno text,
    userno text,
    listno text,
    daycreate text,
    dayedit text,
    usershare text,
    groupno text,
    isread text,
    readdate text,
    isreads text,
    favoritetype text,
    sharetype text,
    usersname text,
    usersnameen text,
    cellphone text,
    companyphone text,
    photo text,
    positions text,
    positionsen text,
    departno text,
    timeoffset text
)
AS $function$
BEGIN

RETURN QUERY
SELECT        public."Note_Share".ShareNo, public."Note_Share".UserNo, public."Note_Share".ListNo, public."Note_Share".DayCreate, public."Note_Share".DayEdit, public."Note_Share".UserShare, public."Note_Share".GroupNo, public."Note_Share".IsRead, 
                         public."Note_Share".ReadDate, public."Note_Share".IsReads, public."Note_Share".FavoriteType, public."Note_Share".ShareType, public."Organization_Users".Name AS UsersName, public."Organization_Users".Name_EN AS UsersNameEN, 
                         public."Organization_Users".CellPhone, public."Organization_Users".CompanyPhone, public."Organization_Users".Photo, public."Organization_Positions".Name AS Positions, 
                         public."Organization_Positions".Name_EN AS PositionsEN, public."Organization_BelongToDepartment".DepartNo, public."Note_Share".timeOffset
FROM            public."Organization_Users" INNER JOIN
                         public."Organization_BelongToDepartment" ON public."Organization_Users".UserNo = public."Organization_BelongToDepartment".UserNo INNER JOIN
                         public."Organization_Positions" ON public."Organization_BelongToDepartment".PositionNo = public."Organization_Positions".PositionNo RIGHT OUTER JOIN
                         public."Note_Share" ON public."Organization_Users".UserNo = public."Note_Share".UserShare AND public."Note_Share".ShareType = 2
	WHERE ListNo=note_getlistshare.listno
	ORDER BY DayCreate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

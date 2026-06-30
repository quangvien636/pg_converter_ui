-- ─── FUNCTION: board_usercollection_select ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_usercollection_select();
CREATE OR REPLACE FUNCTION public.board_usercollection_select(
) RETURNS TABLE(
    auth_grp_nm text
)
AS $function$
BEGIN

RETURN QUERY
SELECT  
   bu.USER_NO As UserNo,
   ou.ModUserNo,
   ou.UserID,
   ou.Name,
   bu.DEPARTMENT_ID,
   od.Name || ' (' || od.Name_EN || ')' As DEPARTMENT_NAME, 
   (Select MENU_TITLE FROM Board_Menu WHERE MENU_IDX =bu.MENU_ID) as MenuTitle,
   (Select AUTH_GRP_NM FROM Board_AuthoGroup WHERE AUTH_GRP_ID =bu.AUTH_GRP_ID) as Authority
  FROM Board_UserByGroup bu LEFT JOIN Organization_Users ou
  on ou.UserNo = bu.USER_NO
  LEFT JOIN Organization_Departments od on od.DepartNo=bu.DEPARTMENT_ID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

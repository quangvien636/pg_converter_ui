-- ─── FUNCTION: approval_updatedocument ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_updatedocument(bigint, integer, timestamp without time zone, character varying, bigint);
CREATE OR REPLACE FUNCTION public.approval_updatedocument(
    documentno bigint,
    moduserno integer,
    moddate timestamp without time zone,
    title character varying,
    currentappno bigint
) RETURNS void
AS $function$
DECLARE
    modusername character varying;
    modpositionname character varying;
    moddepartname character varying;
BEGIN





	SELECT ModUserName = U.Name, ModPositionName = P.Name,
		ModDepartName = D.Name
	FROM Organization_Users U
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	WHERE U.UserNo = approval_updatedocument.moduserno
	
	UPDATE Approval_Documents SET
		ModUserNo = approval_updatedocument.moduserno,
		ModDate = approval_updatedocument.moddate,
		ModUserName = ModUserName,
		ModPositionName = ModPositionName,
		ModDepartName = ModDepartName,
		Title = approval_updatedocument.title,
		CurrentAppNo = approval_updatedocument.currentappno
	WHERE DocumentNo = approval_updatedocument.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

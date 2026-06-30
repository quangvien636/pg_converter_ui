-- ─── FUNCTION: approval_insertdocument ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_insertdocument(integer, timestamp without time zone, character varying, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_insertdocument(
    reguserno integer,
    regdate timestamp without time zone,
    title character varying,
    filetype integer,
    formno integer,
    state integer,
    currentappno integer
) RETURNS TABLE(
    name text,
    name text,
    name text
)
AS $function$
DECLARE
    regusername character varying;
    regpositionname character varying;
    regdepartname character varying;
    documentno bigint;
BEGIN





	SELECT RegUserName = U.Name, RegPositionName = P.Name, RegDepartName = D.Name
	FROM Organization_Users U
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	WHERE U.UserNo = approval_insertdocument.reguserno
	
	INSERT INTO Approval_Documents (RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		ModUserNo, ModDate, ModUserName, ModPositionName, ModDepartName,
		Title, FileType, FormNo ,State, CurrentAppNo)
	VALUES(RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		RegUserNo, RegDate, RegUserName, RegPositionName, RegDepartName,
		Title, FileType, FormNo, State, CurrentAppNo)
	

	SET DocumentNo = (SELECT lastval())
	
	RETURN QUERY
	SELECT DocumentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

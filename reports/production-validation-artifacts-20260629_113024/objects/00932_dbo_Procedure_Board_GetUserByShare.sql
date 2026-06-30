-- ─── PROCEDURE→FUNCTION: board_getuserbyshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getuserbyshare(integer);
CREATE OR REPLACE FUNCTION public.board_getuserbyshare(
    IN contentno integer DEFAULT 5347
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IF(SELECT COUNT(B.BoardNo) FROM Board_Contents C
	INNER JOIN Board_Boards B ON B.BoardNo=C.BoardNo AND B.SpecType=0
	WHERE ContentNo=board_getuserbyshare.contentno AND B.SpecType=1)>0
	BEGIN
	WITH PERMISSION AS (
		Select ItemNo ,AllowValue,AllowAccessNo 
		FROM Board_AllowAccess 
		WHERE ItemType=2 AND ItemNo=board_getuserbyshare.contentno
	),
	SHARE AS(
		SELECT U.UserNo ,U.UserID,BS.ContentNo
		FROM Board_Sharers BS
		INNER JOIN (
			SELECT U.UserNo,U.UserID,OP.DepartNo 
			FROM Organization_Users U 
			INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
			WHERE U.Enabled = TRUE
			) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
		WHERE BS.ContentNo=board_getuserbyshare.contentno
		UNION ALL 
		SELECT DISTINCT U.UserNo, U.UserID,ContentNo AS ContentNo
			FROM Organization_Users U 
			WHERE U.Enabled = TRUE AND (SELECT COUNT(*) FROM Board_Contents WHERE ContentNo=board_getuserbyshare.contentno AND IsShareAll = TRUE)>0
	)
	RETURN QUERY
	SELECT DISTINCT  S.UserNo
	FROM SHARE S 
	INNER JOIN Board_Contents BC ON S.ContentNo=BC.ContentNo
	INNER JOIN PERMISSION P ON P.ItemNo=BC.BoardNo

	END;
ELSE
	WITH 
	SHARE AS(
		SELECT U.UserNo ,U.UserID,BS.ContentNo
		FROM Board_Sharers BS
		INNER JOIN (
			SELECT U.UserNo,U.UserID,OP.DepartNo 
			FROM Organization_Users U 
			INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
			WHERE U.Enabled = TRUE
			) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
		WHERE BS.ContentNo=board_getuserbyshare.contentno
		UNION ALL 
		SELECT DISTINCT U.UserNo, U.UserID,ContentNo AS ContentNo
			FROM Organization_Users U 
			WHERE U.Enabled = TRUE AND (SELECT COUNT(*) FROM Board_Contents WHERE ContentNo=board_getuserbyshare.contentno AND IsShareAll = TRUE)>0
	)
	RETURN QUERY
	SELECT DISTINCT  S.UserNo
	FROM SHARE S 
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

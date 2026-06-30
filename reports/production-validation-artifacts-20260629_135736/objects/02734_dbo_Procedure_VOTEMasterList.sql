-- ─── PROCEDURE→FUNCTION: votemasterlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.votemasterlist(integer, integer, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.votemasterlist(
    IN itemsperpage integer,
    IN currentpage integer,
    IN userno integer,
    IN authtype integer,
    IN lang character varying,
    IN mode character varying,
    IN searchtype character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- Now


	-- Total Count
	RETURN QUERY
	SELECT COUNT(*) Cnt
	FROM VOTEMaster M
	JOIN
	(
		SELECT *
		FROM 
		(
			SELECT ROW_NUMBER() OVER (PARTITION BY UserNo ORDER BY UserNo DESC) AS RowNum, UserNo, DepartNo, PositionNo
			FROM Organization_BelongToDepartment
			WHERE IsDefault = TRUE
		) R1
		WHERE RowNum = 1 -- Deduplication
	) B ON (M.RegUserNo = B.UserNo)
	JOIN Organization_Users U ON (M.RegUserNo = U.UserNo)
	JOIN Organization_Departments D ON (B.DepartNo = D.DepartNo)
	WHERE
	(
		CASE 
		WHEN SearchType = 'Title' AND Keyword = '' THEN 1
		WHEN SearchType = 'Title' AND Keyword <> '' AND Title ILIKE '%' || Keyword || '%' THEN 1
		WHEN SearchType = 'UserName' AND Keyword = '' THEN 1
		WHEN SearchType = 'UserName' AND Keyword <> '' AND U.Name ILIKE '%' || Keyword || '%' THEN 1
		WHEN SearchType = 'DepartName' AND Keyword = '' THEN 1
		WHEN SearchType = 'DepartName' AND Keyword <> '' AND D.Name ILIKE '%' || Keyword || '%' THEN 1
		ELSE 0 END
	) = 1
	AND
	(
		CASE
		WHEN Mode = 'Ongoing' AND CONVERT(VARCHAR(10), Now, 120) BETWEEN StartDate AND EndDate AND (IsReg = TRUE OR IsReg IS NULL) THEN 1
		WHEN Mode = 'Completed' AND CONVERT(VARCHAR(10), Now, 120) > EndDate  AND (IsReg = TRUE OR IsReg IS NULL) THEN 1
		WHEN Mode = 'Managed' AND (AuthType = 1 OR AuthType = 2 OR (AuthType = 3 AND RegUserNo = votemasterlist.userno)) THEN 1
		ELSE 0 END
	) = 1
	AND
	(
		CASE
		WHEN (AuthType = 1 OR AuthType = 2) THEN 1
		WHEN AuthType = 3 AND 
		(
			NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = M.ID)
			OR RegUserNo = votemasterlist.userno
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'U' AND No = votemasterlist.userno
				)
			)
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'EG' AND No IN
					(
						SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = votemasterlist.userno
					)
				)
			)
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'UG' AND No IN
					(
						SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = votemasterlist.userno
					)
				)
			)
		) THEN 1
		ELSE 0 END 
	) = 1

	-- List
	RETURN QUERY
	SELECT *,
		AuthType AS Auth,
		CASE WHEN (SELECT COUNT(*) FROM VOTEResult VR WHERE VR.MasterID = R2.ID AND VR.UserNo = votemasterlist.userno) > 0 THEN 1 ELSE 0 END AS IsJoin
	FROM
	(
		SELECT
			ROW_NUMBER() OVER
			(
				ORDER BY
				CASE WHEN Mode = 'Managed' THEN M.IsStandBy END ASC,
				CASE WHEN Mode = 'Managed' THEN M.IsReg END ASC,
				M.ID DESC
			) AS RowNum,
			ROW_NUMBER() OVER
			(
				ORDER BY
				CASE WHEN Mode = 'Managed' THEN M.IsStandBy END DESC,
				CASE WHEN Mode = 'Managed' THEN M.IsReg END DESC,
				M.ID ASC
			) AS No,
			M.ID, M.Title, M.Type, M.PopUp, M.StartDate, M.EndDate,
			M.Public, M.ItemCnt, M.RegUserNo, M.IsStandBy, M.IsReg, M.IsOuterVote, M.CompleteMessage,
			M.IsAnonyVote,
			CASE 
			WHEN Lang = 'KO' THEN U.Name 
			WHEN Lang = 'EN' THEN U.Name_EN
			WHEN Lang = 'VN' THEN U.Name_VN
			WHEN Lang = 'JP' THEN U.Name_JP
			WHEN Lang = 'CH' THEN U.Name_CH ELSE U.Name END AS UserName,
			CASE 
			WHEN Lang = 'KO' THEN D.Name 
			WHEN Lang = 'EN' THEN D.Name_EN
			WHEN Lang = 'VN' THEN D.Name_VN
			WHEN Lang = 'JP' THEN D.Name_JP
			WHEN Lang = 'CH' THEN D.Name_CH ELSE D.Name END AS DepartName
		FROM VOTEMaster M
		JOIN 
		(
			SELECT *
			FROM 
			(
				SELECT ROW_NUMBER() OVER (PARTITION BY UserNo ORDER BY UserNo DESC) AS RNum, UserNo, DepartNo, PositionNo
				FROM Organization_BelongToDepartment
				WHERE IsDefault = TRUE
			) R1
			WHERE RNum = 1 -- Deduplication
		) B ON (M.RegUserNo = B.UserNo)
		JOIN Organization_Users U ON (M.RegUserNo = U.UserNo)
		JOIN Organization_Departments D ON (B.DepartNo = D.DepartNo)
		WHERE
		(
			CASE
			WHEN SearchType = 'Title' AND Keyword = '' THEN 1
			WHEN SearchType = 'Title' AND Keyword <> '' AND Title ILIKE '%' || Keyword || '%' THEN 1
			WHEN SearchType = 'UserName' AND Keyword = '' THEN 1
			WHEN SearchType = 'UserName' AND Keyword <> '' AND U.Name ILIKE '%' || Keyword || '%' THEN 1
			WHEN SearchType = 'DepartName' AND Keyword = '' THEN 1
			WHEN SearchType = 'DepartName' AND Keyword <> '' AND D.Name ILIKE '%' || Keyword || '%' THEN 1
			ELSE 0 END
		) = 1
		AND
		(
			CASE
			WHEN Mode = 'Ongoing' AND CONVERT(VARCHAR(10), Now, 120) BETWEEN StartDate AND EndDate AND (IsReg = TRUE OR IsReg IS NULL) THEN 1
			WHEN Mode = 'Completed' AND CONVERT(VARCHAR(10), Now, 120) > EndDate  and (IsReg = TRUE or IsReg Is Null ) THEN 1
			WHEN Mode = 'Managed' AND (AuthType = 1 OR AuthType = 2 OR (AuthType = 3 AND RegUserNo = votemasterlist.userno)) THEN 1
			ELSE 0 END
		) = 1
		AND
		(
			CASE
			WHEN (AuthType = 1 OR AuthType = 2) THEN 1
		WHEN AuthType = 3 AND 
		(
			NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = M.ID)
			OR RegUserNo = votemasterlist.userno
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'U' AND No = votemasterlist.userno
				)
			)
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'EG' AND No IN
					(
						SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = votemasterlist.userno
					)
				)
			)
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'UG' AND No IN
					(
						SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = votemasterlist.userno
					)
				)
			)
		) THEN 1
			ELSE 0 END 
		) = 1
	) R2
	WHERE R2.RowNum BETWEEN ((CurrentPage - 1) * ItemsPerPage) + 1 AND CurrentPage * ItemsPerPage;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.

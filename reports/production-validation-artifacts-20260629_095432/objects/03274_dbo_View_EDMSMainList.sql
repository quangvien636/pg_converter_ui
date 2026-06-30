-- TODO: view conversion is not implemented yet: dbo.EDMSMainList
-- RAW:
CREATE  VIEW [dbo].[EDMSMainList]
AS
SELECT     d.ID, d.Title, d.WriterID, d.RegDate, d.State, d.CheckoutId, d.DepartID, d.Version, d.AuthorityLevel, d.DocLevel, d.EADocFlag, d.ModDate,isnull(d.ModDate,d.RegDate) updatedate, d.GroupCode, d.Serial, d.KeyWord, ISNULL(d.Hit, 0) AS Hit,  200 AS EAAuth, d.Summary                      
FROM dbo.EDMSDocument AS d 
WHERE     (d.Docstate = 0) AND (d.IsDelete = 'N') AND (d.VersionState = 'Y') AND (d.ValDate > GETDATE())


-- OWNER: postgres

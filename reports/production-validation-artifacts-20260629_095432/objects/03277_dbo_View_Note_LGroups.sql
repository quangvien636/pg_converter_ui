-- TODO: view conversion is not implemented yet: dbo.Note_LGroups
-- RAW:
CREATE VIEW dbo.Note_LGroups
AS
SELECT  GroupNo, Name, OrderPostion, DayCreate AS DateCreated, DayEdit AS DateChanged, UserNo, Show, Icon, CheckDelete AS IsDefault
FROM     dbo.Note_Group

-- OWNER: postgres

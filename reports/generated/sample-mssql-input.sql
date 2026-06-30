SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users] (
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [TenantId] [bigint] NOT NULL,
    [IsActive] [bit] NOT NULL CONSTRAINT [DF_Users_IsActive] DEFAULT ((1)),
    [Name] [nvarchar](100) NOT NULL,
    [Bio] [varchar](MAX) NULL,
    [CreatedAt] [datetime2](7) NOT NULL CONSTRAINT [DF_Users_CreatedAt] DEFAULT (GETDATE()),
    [Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Users_Guid] DEFAULT (NEWID()),
    [Balance] [money] NOT NULL DEFAULT ((0)),
    [Payload] [varbinary](MAX) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO
CREATE TABLE [dbo].[Orders] (
    [OrderId] [int] IDENTITY(1,1) NOT NULL,
    [UserId] [int] NOT NULL,
    [Amount] [decimal](18,2) NOT NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY ([OrderId]),
    CONSTRAINT [FK_Orders_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id])
)
GO
CREATE PROCEDURE [dbo].[usp_InsertUser]
    @Name nvarchar(100),
    @IsActive bit = 1,
    @NewId int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Users] ([Name], [IsActive]) VALUES (@Name, @IsActive);
    SET @NewId = SCOPE_IDENTITY();
    RETURN 0;
END
GO
CREATE PROCEDURE [dbo].[usp_Dynamic]
    @TableName nvarchar(100)
AS
BEGIN
    DECLARE @sql nvarchar(max);
    SET @sql = N'SELECT TOP 1 * FROM ' + @TableName;
    EXEC sp_executesql @sql;
END
GO
CREATE FUNCTION [dbo].[fn_UserLabel](@Name nvarchar(100), @IsActive bit)
RETURNS nvarchar(200)
AS
BEGIN
    RETURN ISNULL(@Name, N'') + CASE WHEN @IsActive = 1 THEN N' Active' ELSE N' Inactive' END;
END
GO
CREATE FUNCTION [dbo].[fn_UserOrders](@UserId int)
RETURNS @Result TABLE ([OrderId] int, [Amount] decimal(18,2))
AS
BEGIN
    INSERT INTO @Result SELECT [OrderId], [Amount] FROM [dbo].[Orders] WHERE [UserId] = @UserId;
    RETURN;
END
GO
CREATE INDEX [IX_Users_Name] ON [dbo].[Users] ([Name])
GO
CREATE UNIQUE INDEX [UX_Users_Guid] ON [dbo].[Users] ([Guid])
GO
CREATE NONCLUSTERED INDEX [IX_Orders_User_Amount] ON [dbo].[Orders] ([UserId], [Amount] DESC)
GO
CREATE INDEX [IX_Users_Active] ON [dbo].[Users] ([IsActive]) WHERE [IsActive] = 1
GO
CREATE NONCLUSTERED INDEX [IX_Orders_User_Include] ON [dbo].[Orders] ([UserId]) INCLUDE ([Amount])
GO
CREATE CLUSTERED INDEX [CX_Users_Tenant] ON [dbo].[Users] ([TenantId])
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Comments]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Comments](
	[CID] [int] IDENTITY(1,1) NOT NULL,
	[BugID] [int] NOT NULL,
	[Comments] [varchar](3500) NULL,
	[UserName] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_tbl_Comments_CreatedOn]  DEFAULT (getdate()),
	[Status] [char](1) NULL CONSTRAINT [DF_tbl_Comments_Status]  DEFAULT ('U'),
 CONSTRAINT [PK_tbl_Comments] PRIMARY KEY CLUSTERED 
(
	[CID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tbl_Comments', N'COLUMN',N'Status'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'U-Unread,R-Read' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbl_Comments', @level2type=N'COLUMN',@level2name=N'Status'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Projects]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Projects](
	[ProjectID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectName] [varchar](250) NULL,
	[ProjectTeam] [varchar](250) NULL,
	[ProjectStatus] [char](1) NULL CONSTRAINT [DF_tbl_Projects_ProjectStatus]  DEFAULT ('N'),
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_tbl_Projects_CreatedOn]  DEFAULT (getdate()),
 CONSTRAINT [PK_tbl_Projects] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tbl_Projects', N'COLUMN',N'ProjectStatus'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'N-New,I-Inprogress,C-Complete,R-Reject' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbl_Projects', @level2type=N'COLUMN',@level2name=N'ProjectStatus'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_UserCredentials]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_UserCredentials](
	[uid] [int] IDENTITY(1,1) NOT NULL,
	[uname] [varchar](100) NULL,
	[password] [varchar](25) NULL,
	[Role] [varchar](50) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tbl_UserCredentials', N'COLUMN',N'Role'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A-Admin,T-Tester,D-Developer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbl_UserCredentials', @level2type=N'COLUMN',@level2name=N'Role'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_showBugs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_showBugs]
@ProjectID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	Select BID,BugID,
    BugSummary,Attatchment,Case when Priority=''H'' then ''High''
               when  Priority=''L'' then ''Low''
               when Priority=''M'' then ''Medium'' End as Priority,
    CreatedOn,ModifiedOn,BugStatus
    from tbl_bugs where ProjectID=@ProjectID order
    by CreatedOn desc
END







' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_updateBugStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_updateBugStatus]
@BID int,
@BugStatus char(1),
@ModifiedOn Datetime
AS
BEGIN
	Update tbl_Bugs set BugStatus=@BugStatus,ModifiedOn=@ModifiedOn 
where BID=@BID
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Bugs]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_Bugs](
	[BID] [int] IDENTITY(1,1) NOT NULL,
	[BugID] [varchar](50) NULL,
	[ProjectID] [int] NULL,
	[BugSummary] [varchar](550) NULL,
	[BugDesc] [varchar](4000) NULL,
	[Url] [varchar](255) NULL,
	[Severity] [varchar](2) NULL,
	[Priority] [char](1) NULL,
	[Attatchment] [varchar](250) NULL,
	[BugStatus] [char](1) NULL CONSTRAINT [DF_tbl_Bugs_BugStatus]  DEFAULT ('N'),
	[AssignTo] [varchar](2000) NULL,
	[EmailTo] [varchar](2000) NULL,
	[CheckedBy] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_tbl_Bugs_CreatedOn]  DEFAULT (getdate()),
	[ModifiedOn] [datetime] NULL CONSTRAINT [DF_tbl_Bugs_ModifiedOn]  DEFAULT (getdate())
) ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Bugs_AspNet_SqlCacheNotification_Trigger]'))
EXEC dbo.sp_executesql @statement = N'CREATE TRIGGER [dbo].[tbl_Bugs_AspNet_SqlCacheNotification_Trigger] ON [dbo].[tbl_Bugs]
                       FOR INSERT, UPDATE, DELETE AS BEGIN
                       SET NOCOUNT ON
                       EXEC dbo.AspNet_SqlCacheUpdateChangeIdStoredProcedure N''tbl_Bugs''
                       END
                       ' 
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tbl_Bugs', N'COLUMN',N'Severity'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bl-Blocker,Cr-Critical,Ma-Major,Mi-Minor,Tr-Trival,En-Enhancement' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbl_Bugs', @level2type=N'COLUMN',@level2name=N'Severity'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tbl_Bugs', N'COLUMN',N'Priority'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'H-High,L-Low,M-Medium' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbl_Bugs', @level2type=N'COLUMN',@level2name=N'Priority'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tbl_Bugs', N'COLUMN',N'BugStatus'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'N-New,O-Open,R-Rejected,F-Fixed,C-Closed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbl_Bugs', @level2type=N'COLUMN',@level2name=N'BugStatus'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_LogTracker]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_LogTracker](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NULL,
	[BugID] [int] NULL,
	[ViewedBy] [varchar](100) NULL,
	[ViewTime] [datetime] NULL CONSTRAINT [DF_tbl_LogTracker_ViewTime]  DEFAULT (getdate())
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_ViewTrackFile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_ViewTrackFile]
@ProjectID int
AS
BEGIN
	Select * from viewLogFile where ProjectID=@ProjectID 
order by ViewTime desc
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_loginCheck]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,sameer>
-- Create date: <6nov08,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_loginCheck]
@username varchar(100),
@password varchar(25),
@status int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Select @status= Count(*) from tbl_UserCredentials where 
       uname=@username and password=@password
  
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_showComments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[bt_showComments]
@bid int
--@showhide char(1)
AS
BEGIN
	Select * from tbl_Comments where BugID=@bid order by CreatedOn desc
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_PostComments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_PostComments]
@CID int,
@BugID int,
@Name varchar(100),
@Comments varchar(3500)
AS
BEGIN
	Insert into tbl_Comments(BugID,UserName,Comments) 
                      values(@BugID,@Name,@Comments)
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Comments]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_Comments] 
(
	@BugID int
)
RETURNS varchar(250)
AS
BEGIN
	-- Declare the return variable here
DECLARE @CommentsID varchar(250) 
SET @CommentsID=''''
	-- Add the T-SQL statements to compute the return value here

SELECT @CommentsID=@CommentsID+'',''+ Cast(CID as varchar) from tbl_Comments 
where BugID=@BugID

SET @CommentsID=SubString(@CommentsID,2, DataLength(@CommentsID) - 1)

IF @CommentsID IS NULL
BEGIN
    SET @CommentsID=''''
END
 
return @CommentsID 
	-- Return the result of the function

END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_GetTodaysComment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_GetTodaysComment]
@BugID int,
@CreatedOn varchar(12),
@chk int
AS
BEGIN
SET @chk=0

Select @chk=Count(*) from tbl_Comments where BugID=@BugID 
            and CreatedOn=@CreatedOn
	
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_readRefinedProjects]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_readRefinedProjects] 
@Project int
AS
BEGIN
	Select ProjectID,ProjectName,ProjectTeam,ProjectStatus,
    CONVERT(VARCHAR(10), StartDate, 103) AS StartDate,
    CONVERT(VARCHAR(10), EndDate, 103) AS EndDate
    from tbl_Projects where ProjectID=@Project
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Projectname]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Samer>
-- Create date: <Create Date, 11/11/2008,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_Projectname]
(
	@ProjectID int
)
RETURNS varchar(250)
AS
BEGIN
	-- Declare the return variable here
DECLARE @ProjectName as varchar(250)

	-- Add the T-SQL statements to compute the return value here
SELECT @ProjectName=ProjectName from tbl_Projects 
where ProjectID=@ProjectID

IF @ProjectName  IS NULL
BEGIN
    SET @ProjectName=''No Name''
END
  
return @ProjectName 
	-- Return the result of the function

END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_showProjects]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_showProjects]
AS
BEGIN
	 Select * from tbl_Projects order by CreatedOn desc
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_getEmailAddresses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_getEmailAddresses] 
@ProjectID int
AS

BEGIN	  
DECLARE @NextString NVARCHAR(4000)
DECLARE @Pos INT
DECLARE @NextPos INT
DECLARE @String NVARCHAR(4000)

Select @String = ProjectTeam from tbl_Projects where 
       ProjectID=@ProjectID order by ProjectTeam asc

SET @String=@String+'',''

SET @Pos = charindex('','',@String)
--print @Pos
WHILE (@pos <> 0)
BEGIN
  SET @NextString = substring(@String,1,@Pos-1)
  SELECT @NextString as EmailAddress -- Show Results

  SET @String = substring(@String,@pos+1,len(@String))
  SET @pos = charindex('','',@String)
--print @Pos
  END 
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_AddUpdateDeleteProjects]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,sameer>
-- Create date: <Create Date,07/11/2008,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_AddUpdateDeleteProjects]
@ProjectID int,
@ProjectName varchar(250),
@ProjectTeam varchar(250),
@ProjectStatus char(1),
@StartDate datetime,
@EndDate datetime,
@ButtonType char(1),
@Counter int output
AS
SET @Counter=0
BEGIN
	  IF @ButtonType=''I''
        Begin
        Select @Counter=Count(*) from tbl_Projects 
               where ProjectName=@ProjectName
         IF @Counter=0
         Begin
          Insert into tbl_Projects(
                                  ProjectName,
                                  ProjectTeam,
                                  ProjectStatus,
                                  StartDate,
                                  EndDate 
                                  )
                          values(
                                 @ProjectName,
                                 @ProjectTeam,
								 @ProjectStatus,
								 @StartDate,
								 @EndDate
                                 )	
			SET @Counter=-1
          End
      End
     Else IF @ButtonType=''U''
          Begin
            Update tbl_Projects set ProjectName=@ProjectName,
                                    ProjectTeam=@ProjectTeam,
                                    ProjectStatus=@ProjectStatus,
									StartDate=@StartDate,
									EndDate=@EndDate
					Where ProjectID=@ProjectID
           SET @Counter=-1
          End
      Else IF @ButtonType=''D''
            Begin
               Delete from tbl_Projects where ProjectID=@ProjectID
             SET @Counter=-1
            End
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_readAllProjects]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,sameer>
-- Create date: <Create Date,,07/11/2008>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_readAllProjects]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Select ProjectID,ProjectName,ProjectTeam,
    Case When ProjectStatus=''N'' then ''New''
         When ProjectStatus=''I'' then ''In Progress''
         When ProjectStatus=''C'' then ''Complete''
         When ProjectStatus=''R'' then ''Reject'' End as ProjectStatus,
    StartDate,EndDate
    from tbl_Projects order by CreatedOn desc
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_AddUpdateDeleteBugs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,07/11/2008>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_AddUpdateDeleteBugs]
@BID int,
@BugID varchar(50),
@ProjectID int,
@BugSummary varchar(250),
@BugDesc varchar(4000),
@Url varchar(255),
@Severity varchar(2),
@Priority char(1),
@Attatchment varchar(250),
@BugStatus char(1),
@AssignTo varchar(2000),
@EmailTo varchar(2000),
@ButtonType char(1),
@Counter int output,
@OutBugID int output
AS
  Declare @bugExist as int
  Set @bugExist=0
BEGIN
	SET @Counter=0
	  IF @ButtonType=''I''
         Begin
        --first of all check if the entered bugid already exist in db
  Select @bugExist = Count(*) from tbl_Bugs where BugID=@BugID
     IF @bugExist>0
        Begin
            Set @Counter=2       --2 for alredy exost
        End
     Else
        Begin
          Insert into tbl_Bugs(
                                BugID,
                                ProjectID,
							    BugSummary,
								BugDesc,
								Url,
								Severity,
								Priority,
								Attatchment,
								BugStatus,
								AssignTo,
								EmailTo
  
                                  )
                          values(
                                @BugID,
                                @ProjectID,
							    @BugSummary,
								@BugDesc,
								@Url,
								@Severity,
								@Priority,
								@Attatchment,
								@BugStatus,
								@AssignTo,
								@EmailTo
                                 )	

            Select @OutBugID=Scope_Identity() from tbl_Bugs
			SET @Counter=1
		End
     End
  Else IF @ButtonType=''U''
          Begin
            Update tbl_Bugs set ProjectID=@ProjectID,
                   BugSummary=@BugSummary,
                   BugDesc=@BugDesc,
				   Url=@Url,
				   Severity=@Severity,
				   Priority=@Priority,
				   Attatchment=@Attatchment,
				   BugStatus=@BugStatus,
				   AssignTo=@AssignTo,
				   EmailTo=@EmailTo
               Where BugID=@BugID
           SET @Counter=1
          End
      Else IF @ButtonType=''D''
            Begin
               Delete from tbl_Bugs where BugID=@BugID
             SET @Counter=1
            End
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_readBugDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_readBugDetail]
@BID int
AS
BEGIN
	Select * from tbl_Bugs where BID=@BID
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_showBugsRefined]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[bt_showBugsRefined]
@ProjectID int,
@BugID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	Select BID,BugID,
    BugSummary,Attatchment,Case when Priority=''H'' then ''High''
               when  Priority=''L'' then ''Low''
               when Priority=''M'' then ''Medium'' End as Priority,
    CreatedOn,ModifiedOn,BugStatus
    from tbl_bugs where ProjectID=@ProjectID and BID=@BugID order
    by CreatedOn desc
END








' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viewLogFile]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[viewLogFile]
AS
SELECT     dbo.tbl_Bugs.BugID, dbo.tbl_LogTracker.ViewedBy, dbo.tbl_LogTracker.ViewTime, dbo.tbl_LogTracker.ProjectID, dbo.tbl_LogTracker.BugID AS BID, 
                      dbo.tbl_LogTracker.LogID
FROM         dbo.tbl_Bugs INNER JOIN
                      dbo.tbl_LogTracker ON dbo.tbl_Bugs.BID = dbo.tbl_LogTracker.BugID
' 
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'viewLogFile', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tbl_Bugs"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 129
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbl_LogTracker"
            Begin Extent = 
               Top = 6
               Left = 228
               Bottom = 133
               Right = 380
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 2055
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'viewLogFile'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'viewLogFile', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'viewLogFile'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_DeleteLogFiles]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_DeleteLogFiles] 
@LogID int
AS
BEGIN
	Delete from tbl_LogTracker where LogID=@LogID
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bt_TrackUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Sameer>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bt_TrackUser]
@ProjectID int,
@BugID int,
@ViewedBy varchar(100)
AS
BEGIN
	Insert into tbl_LogTracker(ProjectID,BugID,ViewedBy) 
    values(@ProjectID,@BugID,@ViewedBy)
END
' 
END

USE [master]
GO
/****** Object:  Database [s13p2_MuOnline]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE DATABASE [s13p2_MuOnline]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N's13p2_MuOnline_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\s13p2_MuOnline_Data.MDF' , SIZE = 265088KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N's13p2_MuOnline_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\s13p2_MuOnline_Log.LDF' , SIZE = 5120KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [s13p2_MuOnline] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [s13p2_MuOnline].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [s13p2_MuOnline] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET ARITHABORT OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [s13p2_MuOnline] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [s13p2_MuOnline] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [s13p2_MuOnline] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [s13p2_MuOnline] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET  ENABLE_BROKER 
GO
ALTER DATABASE [s13p2_MuOnline] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [s13p2_MuOnline] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [s13p2_MuOnline] SET  MULTI_USER 
GO
ALTER DATABASE [s13p2_MuOnline] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [s13p2_MuOnline] SET DB_CHAINING OFF 
GO
ALTER DATABASE [s13p2_MuOnline] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [s13p2_MuOnline] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [s13p2_MuOnline]
GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleAllJoinUserSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [dbo].[IGC_ArcaBattleAllJoinUserSelect]
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN
	SELECT G_Name, Number, CharName
	FROM	dbo.IGC_ARCA_BATTLE_MEMBER_JOIN_INFO
END

SET XACT_ABORT OFF  
SET NOCOUNT OFF































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleAllMarkCntSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_ArcaBattleAllMarkCntSelect]
AS     
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT G_Name, MarkCnt FROM dbo.IGC_ARCA_BATTLE_GUILDMARK_REG































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleGuildGroupNumSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_ArcaBattleGuildGroupNumSelect]  
 @CharName varchar(10)
as         
BEGIN      
    
 DECLARE @GuildName varchar(8)
 DECLARE @return int    
 SET @return = 0      
         
 Set  nocount on    

set @GuildName = (SELECT G_Name FROM IGC_ARCA_BATTLE_MEMBER_JOIN_INFO where CharName = @CharName)

 SELECT GroupNum FROM IGC_ARCA_BATTLE_GUILD_JOIN_INFO
  WHERE G_Name =  @GuildName

 SET XACT_ABORT OFF    
 Set nocount off    
      
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleGuildInsert]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE  procedure [dbo].[IGC_ArcaBattleGuildInsert]
 @GuildName varchar(8),      
 @CharName varchar(10),      
 @Number int
as     
BEGIN  

 DECLARE @return int
 DECLARE @GuildNum int
 DECLARE @GuildGroupNum tinyint
 SET @return = 0  
     
 Set  nocount on

SELECT @GuildNum = Number FROM IGC_ARCA_BATTLE_GUILD_JOIN_INFO
set @GuildGroupNum = @@ROWCOUNT
IF( @GuildGroupNum >= 6 )
BEGIN
   SET  @return = 3
   GOTO EndProc
END

IF NOT EXISTS ( SELECT Number FROM IGC_ARCA_BATTLE_GUILD_JOIN_INFO WITH ( READUNCOMMITTED )       
    WHERE Number =  @Number )  
  BEGIN 
   begin transaction      
  INSERT INTO IGC_ARCA_BATTLE_GUILD_JOIN_INFO (G_Name, G_Master, Number, JoinDate, GroupNum) VALUES      
   (  @GuildName, @CharName, @Number, GetDate(), @GuildGroupNum+1 )

  INSERT INTO IGC_ARCA_BATTLE_MEMBER_JOIN_INFO (G_Name, Number, CharName, JoinDate) VALUES      
   (  @GuildName, @Number, @CharName, GetDate() )
   goto EndProcTran
   END
ELSE
 BEGIN
   SET  @return = 4
   GOTO EndProc
 END

EndProcTran:
	IF ( @@Error  <> 0 )
	BEGIN	
		rollback transaction
		SET @return = -1
		SELECT @return
	END 
	ELSE
	BEGIN
		commit transaction
		SELECT @return
	END

EndProc:

	SET	XACT_ABORT OFF
	Set	nocount off
	
	SELECT @return
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleGuildMarkInfoAllDel]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_ArcaBattleGuildMarkInfoAllDel]

AS BEGIN
	DECLARE @ErrorCode int

	SET @ErrorCode = 0

	SET nocount on

	DELETE dbo.IGC_ARCA_BATTLE_GUILDMARK_REG

	IF ( @@Error <> 0 ) BEGIN
		SET @ErrorCode = -1
	END

	SELECT @ErrorCode

	SET nocount off
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleGuildMemberInsert]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_ArcaBattleGuildMemberInsert]
 @GuildName varchar(8),      
 @CharName varchar(10),      
 @Number int
as     
BEGIN  

 DECLARE @return int
 DECLARE @GuildNum int
 SET @return = 0  
     
 Set  nocount on

SELECT @GuildNum = Number FROM IGC_ARCA_BATTLE_GUILD_JOIN_INFO WHERE Number =  @Number
IF( @@ROWCOUNT  < 1 )
BEGIN
   SET  @return = 7
   GOTO EndProc
END

SELECT @GuildNum = Number FROM IGC_ARCA_BATTLE_MEMBER_JOIN_INFO WHERE Number =  @Number
IF( @@ROWCOUNT  >= 30 )
BEGIN
   SET  @return = 9
   GOTO EndProc
END

IF NOT EXISTS ( SELECT CharName FROM IGC_ARCA_BATTLE_MEMBER_JOIN_INFO WITH ( READUNCOMMITTED )       
    WHERE CharName =  @CharName )  
  BEGIN
   begin transaction 
  INSERT INTO IGC_ARCA_BATTLE_MEMBER_JOIN_INFO (G_Name, Number, CharName, JoinDate) VALUES      
   (  @GuildName, @Number, @CharName, GetDate() )
   goto EndProcTran
   END
ELSE
 BEGIN
   SET  @return = 8
   GOTO EndProc
 END

EndProcTran:
	IF ( @@Error  <> 0 )
	BEGIN	
		rollback transaction
		SET @return = -1
		SELECT @return
	END 
	ELSE
	BEGIN
		commit transaction
		SELECT @return
	END

EndProc:

	SET	XACT_ABORT OFF
	Set	nocount off
	
	SELECT @return
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleGuildMemberSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_ArcaBattleGuildMemberSelect]
	@G_Number int
AS BEGIN
	DECLARE @ErrorCode int

	SET @ErrorCode = 0

	SET nocount on

	SET @ErrorCode = (select count (Number)  from IGC_ARCA_BATTLE_MEMBER_JOIN_INFO where Number = @G_Number)

	IF ( @@Error <> 0 ) BEGIN
		SET @ErrorCode = -1
	END

	SELECT @ErrorCode

	SET nocount off
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleGuildNamesSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_ArcaBattleGuildNamesSelect]
as         
BEGIN      
           
 Set  nocount on    

 SELECT G_Name FROM IGC_ARCA_BATTLE_GUILD_JOIN_INFO

 SET XACT_ABORT OFF    
 Set nocount off    
      
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleGuildSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_ArcaBattleGuildSelect]
 @CharName varchar(10)

as     
BEGIN  

 DECLARE @return int
 DECLARE @GuildNum int
 DECLARE @GuildGroupNum tinyint
 SET @return = 0  
     
 Set  nocount on

SELECT @GuildNum = Number FROM IGC_ARCA_BATTLE_GUILD_JOIN_INFO
set @GuildGroupNum = @@ROWCOUNT
IF( @GuildGroupNum >= 6 )
BEGIN
   SET  @return = 3
   GOTO EndProc
END

IF NOT EXISTS ( SELECT Number FROM IGC_ARCA_BATTLE_GUILD_JOIN_INFO WITH ( READUNCOMMITTED )       
    WHERE G_Master = @CharName )  
  BEGIN    
   
   goto EndProcTran
   END
ELSE
 BEGIN
   SET  @return = 4
   GOTO EndProc
 END

EndProcTran:
	IF ( @@Error  <> 0 )
	BEGIN	
		SET @return = -1
		SELECT @return
	END 
	ELSE
	BEGIN
		SELECT @return
	END

EndProc:

	SET	XACT_ABORT OFF
	Set	nocount off
	
	SELECT @return
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleInfoDelete]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_ArcaBattleInfoDelete]
as       
BEGIN  
 DECLARE @return int
 SET @return = 0  
 Set  nocount on

 begin transaction  

delete IGC_ARCA_BATTLE_MEMBER_JOIN_INFO
delete IGC_ARCA_BATTLE_GUILD_JOIN_INFO
delete IGC_ARCA_BATTLE_WIN_GUILD_INFO


IF ( @@Error  <> 0 )
 BEGIN	
	rollback transaction
	SET @return = -1
	SELECT @return
 END 
ELSE
 BEGIN
	commit transaction
	SELECT @return
 END
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleMarkCntSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_ArcaBattleMarkCntSelect]
 @G_Number int
as     
BEGIN  

 DECLARE @return int
 DECLARE @GuildRegRank bigint

 SET @return = 0  
     
 Set  nocount on

IF NOT EXISTS ( SELECT G_Number FROM IGC_ARCA_BATTLE_GUILDMARK_REG WITH ( READUNCOMMITTED )       
    WHERE G_Number =  @G_Number)  
  BEGIN

	SET @GuildRegRank = (SELECT count (*) FROM IGC_ARCA_BATTLE_GUILDMARK_REG)
	IF( @GuildRegRank >= 250 )
	 BEGIN
	   SET  @return = -1
	   GOTO EndProc
	 END	  
   END
ELSE
  BEGIN
	set @return = (SELECT MarkCnt FROM IGC_ARCA_BATTLE_GUILDMARK_REG WHERE G_Number =  @G_Number)
  END

EndProc:
	SET	XACT_ABORT OFF
	Set	nocount off	
	select @return
	RETURN
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleMarkInsert]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_ArcaBattleMarkInsert]
 @G_Name varchar(8),      
 @G_Number int,
 @G_Master varchar(10),      
 @MarkCnt bigint
as     
BEGIN  

 DECLARE @return int
 DECLARE @GuildRegRank int
 DECLARE @CurrMarkCnt int

 SET @return = 0  
     
 Set  nocount on


IF NOT EXISTS ( SELECT G_Number FROM IGC_ARCA_BATTLE_GUILDMARK_REG WITH ( READUNCOMMITTED )       
    WHERE G_Number =  @G_Number )  
  BEGIN

	SET @GuildRegRank = (SELECT count (*) FROM IGC_ARCA_BATTLE_GUILDMARK_REG)
	IF( @GuildRegRank >= 250 )
	BEGIN
	   SET  @return = 3
	   GOTO EndProc
	END

   begin transaction      
  INSERT INTO IGC_ARCA_BATTLE_GUILDMARK_REG (G_Name, G_Number, G_Master, RegDate, GuildRegRank, MarkCnt ) VALUES      
   (  @G_Name, @G_Number, @G_Master, GetDate(), (@GuildRegRank+1), @MarkCnt )
   goto EndProcTran

   END
ELSE
 BEGIN
	SET @CurrMarkCnt  = (SELECT MarkCnt from IGC_ARCA_BATTLE_GUILDMARK_REG WHERE G_Number = @G_Number AND G_Name = @G_Name)
	 begin transaction
	 UPDATE IGC_ARCA_BATTLE_GUILDMARK_REG SET MarkCnt = (@MarkCnt + @CurrMarkCnt)  WHERE G_Number = @G_Number AND G_Name = @G_Name
	 SET @return = 1
	goto EndProcTran
 END

EndProcTran:
	IF ( @@Error  <> 0 )
	BEGIN	
		rollback transaction
		SET @return = -1
		select @return
	END 
	ELSE
	BEGIN
		commit transaction
		select @return
	END
	RETURN

EndProc:
	SET	XACT_ABORT OFF
	Set	nocount off	
	select @return
	RETURN
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleMarkRankSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_ArcaBattleMarkRankSelect]
	@G_Number		INT
AS
    SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @return int
	DECLARE @GuildRegRank int

	SET @return = 0  
	SET @GuildRegRank = 0
	 
	IF NOT EXISTS ( SELECT G_Number FROM dbo.IGC_ARCA_BATTLE_GUILDMARK_REG WHERE G_Number =  @G_Number)  
	BEGIN
		SELECT @return, @GuildRegRank
		RETURN
	END

	DECLARE @Tbl_Rank TABLE 
	(
		mRank		INT IDENTITY(1,1) primary key,
		G_Number	INT,
		mMarkCnt	BIGINT
	)
	
	INSERT INTO @Tbl_Rank (G_Number, mMarkCnt) 
	SELECT G_Number, MarkCnt FROM dbo.IGC_ARCA_BATTLE_GUILDMARK_REG ORDER BY MarkCnt DESC, GuildRegRank ASC
	
	SELECT mRank, mMarkCnt  FROM @Tbl_Rank WHERE G_Number = @G_Number
	
	
	RETURN































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleMarkRegDel]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure  [dbo].[IGC_ArcaBattleMarkRegDel]
 @G_Number int
as       
BEGIN  
 DECLARE @return int
 SET @return = 0  
 Set  nocount on

 begin transaction  

 delete dbo.IGC_ARCA_BATTLE_GUILDMARK_REG WHERE G_Number =  @G_Number

IF ( @@Error  <> 0 )
 BEGIN	
	rollback transaction
	SET @return = -1
	SELECT @return
 END 
ELSE
 BEGIN
	commit transaction
	SELECT @return
 END
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleMemberSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE  procedure [dbo].[IGC_ArcaBattleMemberSelect]  
 @CharName varchar(10)  
as         
BEGIN      
    
 DECLARE @return int    
 SET @return = 0      
         
 Set  nocount on    
      
IF NOT EXISTS ( SELECT CharName FROM IGC_ARCA_BATTLE_MEMBER_JOIN_INFO WITH ( READUNCOMMITTED )           
    WHERE CharName =  @CharName )      
  BEGIN 
 SET  @return = 11    
   END    
    
 SET XACT_ABORT OFF    
 Set nocount off    
     
 SELECT @return    
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleMemberUnderSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_ArcaBattleMemberUnderSelect]
 @GuildName varchar(8)
as         
BEGIN      
 
 Set  nocount on    

 SELECT count (*) FROM IGC_ARCA_BATTLE_MEMBER_JOIN_INFO WHERE G_Name = @GuildName

 SET XACT_ABORT OFF    
 Set nocount off    
      
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleMinGuildDelete]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_ArcaBattleMinGuildDelete]
  @G_Name varchar(8)
as     
BEGIN

 DECLARE @return int
 SET @return = 0

 Set  nocount on
 begin transaction  

 delete IGC_ARCA_BATTLE_GUILD_JOIN_INFO WHERE G_Name = @G_Name
 delete IGC_ARCA_BATTLE_MEMBER_JOIN_INFO WHERE G_Name = @G_Name

IF ( @@Error  <> 0 )
 BEGIN	
	rollback transaction
	SET @return = -1
	SELECT @return
 END 
ELSE
 BEGIN
	commit transaction
	SELECT @return
 END
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleMinGuildSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_ArcaBattleMinGuildSelect]
 @G_Name varchar(8),
 @nMinGuildMemCnt int
as     
BEGIN

 DECLARE @return int
 DECLARE @GuildNum int
 DECLARE @GuildMemCnt int
 SET @return = -1       

 Set  nocount on

 SELECT @GuildNum = Number FROM IGC_ARCA_BATTLE_MEMBER_JOIN_INFO WHERE G_Name = @G_Name
 SET @GuildMemCnt = @@ROWCOUNT
 IF( @GuildMemCnt < @nMinGuildMemCnt )
 BEGIN
   SELECT @return
 END
ELSE
 BEGIN
   SELECT @GuildNum
 END
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleProcInsert]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_ArcaBattleProcInsert]
 @nProcState tinyint
as     
BEGIN  

 DECLARE @return int
 SET @return = 0  
 Set  nocount on

IF NOT EXISTS ( SELECT Proc_State FROM IGC_ARCA_BATTLE_PROC_STATE WITH ( READUNCOMMITTED ) )  
  BEGIN
   begin transaction      
  INSERT INTO IGC_ARCA_BATTLE_PROC_STATE (Proc_State) VALUES  ( @nProcState )
   END
ELSE
 begin transaction      
  UPDATE IGC_ARCA_BATTLE_PROC_STATE SET  Proc_State = @nProcState

IF ( @@Error  <> 0 )
 BEGIN	
	rollback transaction
	SET @return = -1
	SELECT @return
 END 
ELSE
 BEGIN
	commit transaction
	SELECT @return
 END
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleProcSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_ArcaBattleProcSelect]    

as         
BEGIN      
      
 SELECT Proc_State FROM IGC_ARCA_BATTLE_PROC_STATE
    
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleTopRankSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[IGC_ArcaBattleTopRankSelect]
AS
	SELECT top 6 G_Name, MarkCnt FROM dbo.IGC_ARCA_BATTLE_GUILDMARK_REG ORDER BY MarkCnt DESC, GuildRegRank ASC































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleWinGuildInsert]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE  procedure [dbo].[IGC_ArcaBattleWinGuildInsert]    
 @GuildName varchar(8),        
 @Number int,    
 @nOuccupyObelisk tinyint,    
 @nObeliskGroup tinyint,    
 @nLeftTime bigint    
    
as         
BEGIN      
         
 Set  nocount on    
    
 INSERT INTO IGC_ARCA_BATTLE_WIN_GUILD_INFO (G_Name, G_Number, WinDate, OuccupyObelisk, ObeliskGroup, LeftTime) VALUES         
   (@GuildName, @Number, GetDate(), @nOuccupyObelisk,@nObeliskGroup,  @nLeftTime)    
      
 Set nocount off      
    
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_ArcaBattleWinGuildSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_ArcaBattleWinGuildSelect]    
as         
BEGIN      
      
 SELECT G_Name, OuccupyObelisk, ObeliskGroup FROM IGC_ARCA_BATTLE_WIN_GUILD_INFO
    
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_BattleCore_CancelUser]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_BattleCore_CancelUser]
	@AccountID varchar(10),
	@Name varchar(10),
	@ServerCode int
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT * FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @Name AND ServerCode = @ServerCode)
	BEGIN
		SELECT 0 AS Result
		RETURN
	END

	DECLARE @KeyName varchar(10)
	SELECT @KeyName = Name FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @Name AND ServerCode = @ServerCode

	DECLARE @Slot1 varchar(10), @Slot2 varchar(10), @CurSlot varchar(10)
	SELECT @Slot1 = GameID1, @Slot2 = GameID2 FROM [BattleCore].[dbo].AccountCharacter WHERE Id = @AccountID

	IF (@Slot1 = @KeyName)
	BEGIN
		UPDATE [BattleCore].[dbo].AccountCharacter SET GameID1 = NULL WHERE Id = @AccountID
		PRINT 'Slot1 clear'
	END
	ELSE IF (@Slot2 = @KeyName)
	BEGIN
		UPDATE [BattleCore].[dbo].AccountCharacter SET GameID2 = NULL WHERE Id = @AccountID
		PRINT 'Slot2 clear'
	END

	UPDATE [BattleCore].[dbo].BattleCoreInfo SET RegisterState = 0, RegisterDay = 0, RegisterMonth = 0, LeftTime = GETDATE() WHERE
		AccountID = @AccountID AND UBFName = @Name AND ServerCode = @ServerCode

	SELECT 1 AS Result
END


















GO
/****** Object:  StoredProcedure [dbo].[IGC_BattleCore_CopyCharacter_Normal]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_BattleCore_CopyCharacter_Normal]
	@AccountID varchar(10),
	@Name varchar(10),
	@ServerCode int
AS
BEGIN
	SET NOCOUNT ON;

	-- prepare data

	IF NOT EXISTS (SELECT * FROM Character WHERE AccountID = @AccountID AND Name = @Name)
	BEGIN
		SELECT 2 AS Result
		RETURN
	END

	DECLARE @Slot1 varchar (10), @Slot2 varchar (10)
	DECLARE @SlotNumber int

	SET @SlotNumber = 0

	SELECT @Slot1 = GameID1, @Slot2 = GameID2 FROM [BattleCore].[dbo].AccountCharacter WHERE Id = @AccountID

	IF (@Slot1 IS NULL)
	BEGIN
		SET @SlotNumber = 1
	END
	ELSE IF (@Slot2 IS NULL)
	BEGIN
		SET @SlotNumber = 2
	END
	ELSE
	BEGIN
		SELECT 3 AS Result
		RETURN
	END
	
	DECLARE @KeyName varchar(10)
	SELECT @KeyName = Name FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @Name AND ServerCode = @ServerCode

	-- step 1
	-- copy character data

	DECLARE @cLevel int
	DECLARE @LevelUpPoint int
	DECLARE @Class tinyint
	DECLARE @Experience bigint
	DECLARE @Strength int
	DECLARE @Dexterity int
	DECLARE @Vitality int
	DECLARE @Energy int
	DECLARE @MagicList varbinary(1850)
	DECLARE @Money int
	DECLARE @Life real
	DECLARE @MaxLife real
	DECLARE @Mana real
	DECLARE @MaxMana real
	DECLARE @MapNumber smallint
	DECLARE @MapPosX smallint
	DECLARE @MapPosY smallint
	DECLARE @MapDir tinyint
	DECLARE @PkCount int
	DECLARE @PkLevel int
	DECLARE @PkTime int
	DECLARE @MDate smalldatetime
	DECLARE @LDate smalldatetime
	DECLARE @CtlCode tinyint
	DECLARE @Quest varbinary(100)
	DECLARE @Leadership int
	DECLARE @ChatLimitTime smallint
	DECLARE @FruitPoint int
	DECLARE @RESETS int
	DECLARE @Inventory varbinary(7648)
	DECLARE @Married int
	DECLARE @MarryName varchar(10)
	DECLARE @mLevel int
	DECLARE @mlPoint int
	DECLARE @mlExperience bigint
	DECLARE @mlNextExp bigint
	DECLARE @InventoryExpansion tinyint
	DECLARE @WinDuels int
	DECLARE @LoseDuels int
	DECLARE @PenaltyMask int
	DECLARE @BlockChatTime bigint
	DECLARE @Ruud int
	DECLARE @OpenHuntingLog tinyint
	DECLARE @MuHelperData varbinary(512)
	DECLARE @StatCoin int
	DECLARE @StatGP int
	DECLARE @i4thSkillPoint int
	DECLARE @AddStrength int
	DECLARE @AddDexterity int
	DECLARE @AddVitality int
	DECLARE @AddEnergy int

	DECLARE CUR CURSOR FOR SELECT [cLevel], [LevelUpPoint], [Class], [Experience], [Strength], [Dexterity], [Vitality], [Energy], [MagicList], 
		[Money], [Life], [MaxLife], [Mana], [MaxMana], [MapNumber], [MapPosX], [MapPosY], [MapDir], [PkCount], [PkLevel], [PkTime], 
		[MDate], [LDate], [CtlCode], [Quest], [Leadership], [ChatLimitTime], [FruitPoint], [RESETS], [Inventory], [Married],
		[MarryName], [mLevel], [mlPoint], [mlExperience], [mlNextExp], [InventoryExpansion], [WinDuels], [LoseDuels], 
		[PenaltyMask], [BlockChatTime], [Ruud], [OpenHuntingLog], [MuHelperData], [StatCoin], [StatGP], [i4thSkillPoint], [AddStrength], [AddDexterity], [AddVitality], [AddEnergy] FROM Character WHERE AccountID = @AccountID AND Name = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @cLevel, @LevelUpPoint, @Class, @Experience, @Strength, @Dexterity, @Vitality, @Energy, @MagicList,
		@Money, @Life, @MaxLife, @Mana, @MaxMana, @MapNumber, @MapPosX, @MapPosY, @MapDir, @PkCount, @PkLevel, @PkTime,
		@MDate, @LDate, @CtlCode, @Quest, @Leadership, @ChatLimitTime, @FruitPoint, @RESETS, @Inventory, @Married,
		@MarryName, @mLevel, @mlPoint, @mlExperience, @mlNextExp, @InventoryExpansion, @WinDuels, @LoseDuels,
		@PenaltyMask, @BlockChatTime, @Ruud, @OpenHuntingLog, @MuHelperData, @StatCoin, @StatGP, @i4thSkillPoint, @AddStrength, @AddDexterity, @AddVitality, @AddEnergy

	INSERT INTO [BattleCore].[dbo].Character (AccountID, Name, cLevel, LevelUpPoint, Class, Experience, Strength, Dexterity, Vitality, Energy, MagicList,
		Money, Life, MaxLife, Mana, MaxMana, MapNumber, MapPosX, MapPosY, MapDir, PkCount, PkLevel, PkTime, MDate, LDate, CtlCode, Quest,
		Leadership, ChatLimitTime, FruitPoint, RESETS, Inventory, Married, MarryName, mLevel, mlPoint, mlExperience, mlNextExp,
		InventoryExpansion, WinDuels, LoseDuels, PenaltyMask, BlockChatTime, Ruud, OpenHuntingLog, MuHelperData, StatCoin, StatGP, i4thSkillPoint, AddStrength, AddDexterity, AddVitality, AddEnergy) 
		VALUES (@AccountID, @KeyName, @cLevel, @LevelUpPoint, @Class, @Experience, @Strength, @Dexterity, @Vitality, @Energy, @MagicList,
		100000000, @Life, @MaxLife, @Mana, @MaxMana, @MapNumber, @MapPosX, @MapPosY, @MapDir, @PkCount, @PkLevel, @PkTime, @MDate, @LDate, @CtlCode, @Quest,
		@Leadership, @ChatLimitTime, @FruitPoint, @RESETS, @Inventory, @Married, @MarryName, @mLevel, @mlPoint, @mlExperience, @mlNextExp,
		@InventoryExpansion, @WinDuels, @LoseDuels, @PenaltyMask, @BlockChatTime, @Ruud, @OpenHuntingLog, @MuHelperData, @StatCoin, @StatGP, @i4thSkillPoint, @AddStrength, @AddDexterity, @AddVitality, @AddEnergy)

	CLOSE CUR
	DEALLOCATE CUR

	-- step 2
	-- copy event inventory

	DECLARE @EventInventory varbinary(1024)
	SELECT @EventInventory = Inventory FROM T_Event_Inventory WHERE AccountID = @AccountID AND Name = @Name

	INSERT INTO [BattleCore].[dbo].T_Event_Inventory (AccountID, Name, Inventory) VALUES (@AccountID, @KeyName, @EventInventory)

	-- step 3.1
	-- copy muun inventory

	DECLARE @MuunInventory varbinary(3296)

	DECLARE CUR CURSOR FOR SELECT [Items] FROM IGC_Muun_Inventory WHERE Name = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @MuunInventory

	INSERT INTO [BattleCore].[dbo].IGC_Muun_Inventory (Name, Items) VALUES (@KeyName, @MuunInventory)

	CLOSE CUR
	DEALLOCATE CUR

	-- step 3.2
	-- copy muun period info

	DECLARE @ItemType int
	DECLARE @UsedInfo tinyint
	DECLARE @Serial bigint
	DECLARE @GetItemDate smalldatetime
	DECLARE @ExpireDate smalldatetime
	DECLARE @ExpireDateConvert bigint

	DECLARE CUR CURSOR FOR SELECT [ItemType], [UsedInfo], [Serial], [GetItemDate],
		[ExpireDate], [ExpireDateConvert] FROM IGC_Muun_Period WHERE Name = @Name

	OPEN CUR
	FETCH NEXT FROM CUR INTO @ItemType, @UsedInfo, @Serial, @GetItemDate, @ExpireDate, @ExpireDateConvert

	WHILE( @@fetch_status <> -1 )
	BEGIN
		IF( @@fetch_status <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].[IGC_Muun_Period] (Name, ItemType, UsedInfo, Serial, GetItemDate, ExpireDate, ExpireDateConvert)
				VALUES (@KeyName, @ItemType, @UsedInfo, @Serial, @GetItemDate, @ExpireDate, @ExpireDateConvert)
		END
		FETCH NEXT FROM CUR INTO @ItemType, @UsedInfo, @Serial, @GetItemDate, @ExpireDate, @ExpireDateConvert
	END

	CLOSE CUR
	DEALLOCATE CUR
	
	-- step 3.3
	-- copy muun info condition info

	DECLARE @SlotIndex tinyint
	DECLARE @ConditionType tinyint
	DECLARE @Value int

	DECLARE CUR CURSOR FOR SELECT [SlotIndex], [ConditionType], [Value] FROM IGC_Muun_ConditionInfo WHERE Name = @Name

	OPEN CUR
	FETCH NEXT FROM CUR INTO @SlotIndex, @ConditionType, @Value

	WHILE( @@fetch_status <> -1 )
	BEGIN
		IF( @@fetch_status <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].[IGC_Muun_ConditionInfo] (Name, SlotIndex, ConditionType, Value)
				VALUES (@KeyName, @SlotIndex, @ConditionType, @Value)
		END
		FETCH NEXT FROM CUR INTO @SlotIndex, @ConditionType, @Value
	END

	CLOSE CUR
	DEALLOCATE CUR

	-- step 4
	-- copy pentagram item data

	DECLARE @UserGuid int
	DECLARE @JewelPos tinyint
	DECLARE @PentagramInfo varbinary(4250)

	DECLARE CUR CURSOR FOR SELECT [UserGuid], [JewelPos], [PentagramInfo] FROM IGC_PentagramInfo WHERE
		AccountID = @AccountID AND Name = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @UserGuid, @JewelPos, @PentagramInfo

	WHILE( @@fetch_status <> -1 )
	BEGIN
		IF( @@fetch_status <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].IGC_PentagramInfo (UserGuid, AccountID, Name, JewelPos, PentagramInfo)
			VALUES (@UserGuid, @AccountID, @KeyName, @JewelPos, @PentagramInfo)
		END
		FETCH NEXT FROM CUR INTO @UserGuid, @JewelPos, @PentagramInfo
	END

	CLOSE CUR
	DEALLOCATE CUR

	-- step 5
	-- copy character option data (q,w,e,r etc.)

	DECLARE @SkillKey binary(20)
	DECLARE @GameOption tinyint
	DECLARE @QKey tinyint
	DECLARE @WKey tinyint
	DECLARE @EKey tinyint
	DECLARE @ChatWindow tinyint
	DECLARE @RKey tinyint
	DECLARE @QWERLevel int
	DECLARE @EnableChangeMode tinyint
	DECLARE @PlayGuideLv smallint
	DECLARE @PlayGuideCK tinyint

	DECLARE CUR CURSOR FOR SELECT [SkillKey], [GameOption], [QKey], [WKey], [EKey], [ChatWindow], [RKey], [QWERLevel], [EnableChangeMode], [PlayGuideLv], [PlayGuideCK] FROM OptionData WHERE Name = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @SkillKey, @GameOption, @QKey, @WKey, @EKey, @ChatWindow, @RKey, @QWERLevel, @EnableChangeMode, @PlayGuideLv, @PlayGuideCK

	INSERT INTO [BattleCore].[dbo].OptionData (Name, SkillKey, GameOption, Qkey, Wkey, Ekey, ChatWindow, Rkey, QWERLevel, EnableChangeMode, PlayGuideLv, PlayGuideCK) VALUES
		(@KeyName, @SkillKey, @GameOption, @QKey, @WKey, @EKey, @ChatWindow, @RKey, @QWERLevel, @EnableChangeMode, @PlayGuideLv, @PlayGuideCK)

	CLOSE CUR
	DEALLOCATE CUR

	-- step 6.1
	-- copy period item data (cash-shop)
	DECLARE @PeriodUserGuid int
	DECLARE @PeriodItemCode int
	DECLARE @PeriodEffectType1 tinyint
	DECLARE @PeriodEffectType2 tinyint
	DECLARE @PeriodUsedTime int
	DECLARE @PeriodLeftTime int
	DECLARE @PeriodBuyDate smalldatetime
	DECLARE @PeriodExpireDate smalldatetime
	DECLARE @PeriodUsedInfo tinyint
	DECLARE @PeriodOptionType tinyint
	DECLARE @PeriodItemType tinyint
	DECLARE @PeriodSerialCode bigint
	DECLARE @PeriodBuyDateConvert bigint
	DECLARE @PeriodExpireDateConvert bigint
	DECLARE @PeriodSetExpire tinyint

	DECLARE CUR CURSOR FOR SELECT [UserGuid], [ItemCode], [EffectType1], [EffectType2], [UsedTime], [LeftTime], [BuyDate], [ExpireDate], [UsedInfo], [OptionType], [ItemType], [SerialCode], [BuyDateConvert], [ExpireDateConvert], [SetExpire]
	FROM IGC_PeriodItemInfo WHERE CharacterName = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @PeriodUserGuid, @PeriodItemCode, @PeriodEffectType1, @PeriodEffectType2, @PeriodUsedTime, @PeriodLeftTime, @PeriodBuyDate, @PeriodExpireDate,
	@PeriodUsedInfo, @PeriodOptionType, @PeriodItemType, @PeriodSerialCode, @PeriodBuyDateConvert, @PeriodExpireDateConvert, @PeriodSetExpire

	WHILE( @@fetch_status  <> -1 )
	BEGIN
		IF( @@fetch_status  <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].IGC_PeriodItemInfo (UserGuid, CharacterName, ItemCode, EffectType1, EffectType2, UsedTime, LeftTime, BuyDate, ExpireDate, UsedInfo, OptionType, ItemType, SerialCode, BuyDateConvert, ExpireDateConvert, SetExpire)
			VALUES (@PeriodUserGuid, @KeyName, @PeriodItemCode, @PeriodEffectType1, @PeriodEffectType2, @PeriodUsedTime, @PeriodLeftTime, @PeriodBuyDate, @PeriodExpireDate, @PeriodUsedInfo, @PeriodOptionType, @PeriodItemType, @PeriodSerialCode, @PeriodBuyDateConvert, @PeriodExpireDateConvert, @PeriodSetExpire)
		END

		FETCH NEXT FROM CUR INTO @PeriodUserGuid, @PeriodItemCode, @PeriodEffectType1, @PeriodEffectType2, @PeriodUsedTime, @PeriodLeftTime, @PeriodBuyDate, @PeriodExpireDate,
		@PeriodUsedInfo, @PeriodOptionType, @PeriodItemType, @PeriodSerialCode, @PeriodBuyDateConvert, @PeriodExpireDateConvert, @PeriodSetExpire
	END

	CLOSE CUR
	DEALLOCATE CUR

	-- step 6.2
	-- copy period item data (arca buffs)
	DECLARE @PeriodBuffIndex smallint
	DECLARE @PeriodDuration int

	SET @PeriodEffectType1 = 0
	SET @PeriodEffectType2 = 0
	SET @PeriodExpireDateConvert = 0

	DECLARE CUR CURSOR FOR SELECT [BuffIndex], [EffectType1], [EffectType2], [ExpireDate], [Duration] FROM IGC_PeriodBuffInfo WHERE CharacterName = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @PeriodBuffIndex, @PeriodEffectType1, @PeriodEffectType2, @PeriodExpireDateConvert, @PeriodDuration

	WHILE( @@fetch_status <> -1 )
	BEGIN
		IF( @@fetch_status <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].IGC_PeriodBuffInfo (CharacterName, BuffIndex, EffectType1, EffectType2, ExpireDate, Duration) VALUES
			(@KeyName, @PeriodBuffIndex, @PeriodEffectType1, @PeriodEffectType2, @PeriodExpireDateConvert, @PeriodDuration)
		END

		FETCH NEXT FROM CUR INTO @PeriodBuffIndex, @PeriodEffectType1, @PeriodEffectType2, @PeriodExpireDateConvert, @PeriodDuration
	END

	CLOSE CUR
	DEALLOCATE CUR

	-- step 7
	-- copy lucky item data

	DECLARE @LuckyUserGuid int
	DECLARE @LuckyItemCode int
	DECLARE @LuckyItemSerial bigint
	DECLARE @LuckyDurabilitySmall smallint

	DECLARE CUR CURSOR FOR SELECT [UserGuid], [ItemCode], [ItemSerial], [DurabilitySmall] FROM T_LUCKY_ITEM_INFO WHERE CharName = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @LuckyUserGuid, @LuckyItemCode, @LuckyItemSerial, @LuckyDurabilitySmall

	WHILE( @@fetch_status <> -1 )
	BEGIN
		IF( @@fetch_status <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].T_LUCKY_ITEM_INFO (UserGuid, CharName, ItemCode, ItemSerial, DurabilitySmall) VALUES
			(@LuckyUserGuid, @KeyName, @LuckyItemCode, @LuckyItemSerial, @LuckyDurabilitySmall)
		END

		FETCH NEXT FROM CUR INTO @LuckyUserGuid, @LuckyItemCode, @LuckyItemSerial, @LuckyDurabilitySmall
	END

	CLOSE CUR
	DEALLOCATE CUR

	-- step 8
	-- copy gm data

	DECLARE @AuthorityMask int
	DECLARE @Expiry smalldatetime

	SELECT @AuthorityMask = AuthorityMask, @Expiry = Expiry FROM T_GMSystem WHERE Name = @Name

	INSERT INTO [BattleCore].[dbo].T_GMSystem (Name, AuthorityMask, Expiry) VALUES (@KeyName, @AuthorityMask, @Expiry)


	-- step 9
	-- set character in AccountCharacter

	IF (@SlotNumber = 1)
	BEGIN
		UPDATE [BattleCore].[dbo].AccountCharacter SET GameID1 = @KeyName WHERE Id = @AccountID
	END
	ELSE IF (@SlotNumber = 2)
	BEGIN
		UPDATE [BattleCore].[dbo].AccountCharacter SET GameID2 = @KeyName WHERE Id = @AccountID
	END

	SELECT 1 AS Result
END







GO
/****** Object:  StoredProcedure [dbo].[IGC_BattleCore_CopyCharacter_Promotion]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_BattleCore_CopyCharacter_Promotion]
	@AccountID varchar(10),
	@Name varchar(10),
	@ServerCode int
AS
BEGIN
	SET NOCOUNT ON;

	-- prepare data

	IF NOT EXISTS (SELECT * FROM Character WHERE AccountID = @AccountID AND Name = @Name)
	BEGIN
		SELECT 2 AS Result
		RETURN
	END

	DECLARE @Slot1 varchar (10), @Slot2 varchar (10)
	DECLARE @SlotNumber int

	SET @SlotNumber = 0

	SELECT @Slot1 = GameID1, @Slot2 = GameID2 FROM [BattleCore].[dbo].AccountCharacter WHERE Id = @AccountID

	IF (@Slot1 IS NULL)
	BEGIN
		SET @SlotNumber = 1
	END
	ELSE IF (@Slot2 IS NULL)
	BEGIN
		SET @SlotNumber = 2
	END
	ELSE
	BEGIN
		SELECT 3 AS Result
		RETURN
	END
	
	DECLARE @KeyName varchar(10)
	SELECT @KeyName = Name FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @Name AND ServerCode = @ServerCode

	-- step 1
	-- copy character data

	DECLARE @cLevel int
	DECLARE @LevelUpPoint int
	DECLARE @Class tinyint
	DECLARE @Experience bigint
	DECLARE @Strength int
	DECLARE @Dexterity int
	DECLARE @Vitality int
	DECLARE @Energy int
	DECLARE @MagicList varbinary(2250)
	DECLARE @Money int
	DECLARE @Life real
	DECLARE @MaxLife real
	DECLARE @Mana real
	DECLARE @MaxMana real
	DECLARE @MapNumber smallint
	DECLARE @MapPosX smallint
	DECLARE @MapPosY smallint
	DECLARE @MapDir tinyint
	DECLARE @PkCount int
	DECLARE @PkLevel int
	DECLARE @PkTime int
	DECLARE @MDate smalldatetime
	DECLARE @LDate smalldatetime
	DECLARE @CtlCode tinyint
	DECLARE @Quest varbinary(100)
	DECLARE @Leadership int
	DECLARE @ChatLimitTime smallint
	DECLARE @FruitPoint int
	DECLARE @RESETS int
	DECLARE @Inventory varbinary(7648)
	DECLARE @Married int
	DECLARE @MarryName varchar(10)
	DECLARE @mLevel int
	DECLARE @mlPoint int
	DECLARE @mlExperience bigint
	DECLARE @mlNextExp bigint
	DECLARE @InventoryExpansion tinyint
	DECLARE @WinDuels int
	DECLARE @LoseDuels int
	DECLARE @PenaltyMask int
	DECLARE @BlockChatTime bigint
	DECLARE @Ruud int
	DECLARE @OpenHuntingLog tinyint
	DECLARE @MuHelperData varbinary(512)
	DECLARE @StatCoin int
	DECLARE @StatGP int
	DECLARE @i4thSkillPoint int
	DECLARE @AddStrength int
	DECLARE @AddDexterity int
	DECLARE @AddVitality int
	DECLARE @AddEnergy int

	DECLARE CUR CURSOR FOR SELECT [cLevel], [LevelUpPoint], [Class], [Experience], [Strength], [Dexterity], [Vitality], [Energy], [MagicList], 
		[Money], [Life], [MaxLife], [Mana], [MaxMana], [MapNumber], [MapPosX], [MapPosY], [MapDir], [PkCount], [PkLevel], [PkTime], 
		[MDate], [LDate], [CtlCode], [Quest], [Leadership], [ChatLimitTime], [FruitPoint], [RESETS], [Inventory], [Married],
		[MarryName], [mLevel], [mlPoint], [mlExperience], [mlNextExp], [InventoryExpansion], [WinDuels], [LoseDuels], 
		[PenaltyMask], [BlockChatTime], [Ruud], [OpenHuntingLog], [MuHelperData], [StatCoin], [StatGP], [i4thSkillPoint], [AddStrength], [AddDexterity], [AddVitality], [AddEnergy] FROM Character WHERE AccountID = @AccountID AND Name = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @cLevel, @LevelUpPoint, @Class, @Experience, @Strength, @Dexterity, @Vitality, @Energy, @MagicList,
		@Money, @Life, @MaxLife, @Mana, @MaxMana, @MapNumber, @MapPosX, @MapPosY, @MapDir, @PkCount, @PkLevel, @PkTime,
		@MDate, @LDate, @CtlCode, @Quest, @Leadership, @ChatLimitTime, @FruitPoint, @RESETS, @Inventory, @Married,
		@MarryName, @mLevel, @mlPoint, @mlExperience, @mlNextExp, @InventoryExpansion, @WinDuels, @LoseDuels,
		@PenaltyMask, @BlockChatTime, @Ruud, @OpenHuntingLog, @MuHelperData, @StatCoin, @StatGP, @i4thSkillPoint, @AddStrength, @AddDexterity, @AddVitality, @AddEnergy

	INSERT INTO [BattleCore].[dbo].Character (AccountID, Name, cLevel, LevelUpPoint, Class, Experience, Strength, Dexterity, Vitality, Energy, MagicList,
		Money, Life, MaxLife, Mana, MaxMana, MapNumber, MapPosX, MapPosY, MapDir, PkCount, PkLevel, PkTime, MDate, LDate, CtlCode, Quest,
		Leadership, ChatLimitTime, FruitPoint, RESETS, Inventory, Married, MarryName, mLevel, mlPoint, mlExperience, mlNextExp,
		InventoryExpansion, WinDuels, LoseDuels, PenaltyMask, BlockChatTime, Ruud, OpenHuntingLog, MuHelperData, StatCoin, StatGP, i4thSkillPoint, AddStrength, AddDexterity, AddVitality, AddEnergy) 
		VALUES (@AccountID, @KeyName, @cLevel, @LevelUpPoint, @Class, @Experience, @Strength, @Dexterity, @Vitality, @Energy, @MagicList,
		100000000, @Life, @MaxLife, @Mana, @MaxMana, @MapNumber, @MapPosX, @MapPosY, @MapDir, @PkCount, @PkLevel, @PkTime, @MDate, @LDate, @CtlCode, @Quest,
		@Leadership, @ChatLimitTime, @FruitPoint, @RESETS, @Inventory, @Married, @MarryName, @mLevel, @mlPoint, @mlExperience, @mlNextExp,
		@InventoryExpansion, @WinDuels, @LoseDuels, @PenaltyMask, @BlockChatTime, @Ruud, @OpenHuntingLog, @MuHelperData, @StatCoin, @StatGP, @i4thSkillPoint, @AddStrength, @AddDexterity, @AddVitality, @AddEnergy)

	CLOSE CUR
	DEALLOCATE CUR

	-- step 2
	-- copy event inventory

	DECLARE @EventInventory varbinary(1024)
	SELECT @EventInventory = Inventory FROM T_Event_Inventory WHERE AccountID = @AccountID AND Name = @Name

	INSERT INTO [BattleCore].[dbo].T_Event_Inventory (AccountID, Name, Inventory) VALUES (@AccountID, @KeyName, @EventInventory)

	-- step 3.1
	-- copy muun inventory

	DECLARE @MuunInventory varbinary(3296)

	DECLARE CUR CURSOR FOR SELECT [Items] FROM IGC_Muun_Inventory WHERE Name = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @MuunInventory

	INSERT INTO [BattleCore].[dbo].IGC_Muun_Inventory (Name, Items) VALUES (@KeyName, @MuunInventory)

	CLOSE CUR
	DEALLOCATE CUR

	-- step 3.2
	-- copy muun info

	DECLARE @ItemType int
	DECLARE @UsedInfo tinyint
	DECLARE @Serial bigint
	DECLARE @GetItemDate smalldatetime
	DECLARE @ExpireDate smalldatetime
	DECLARE @ExpireDateConvert bigint

	DECLARE CUR CURSOR FOR SELECT [ItemType], [UsedInfo], [Serial], [GetItemDate],
		[ExpireDate], [ExpireDateConvert] FROM IGC_Muun_Period WHERE Name = @Name

	OPEN CUR
	FETCH NEXT FROM CUR INTO @ItemType, @UsedInfo, @Serial, @GetItemDate, @ExpireDate, @ExpireDateConvert

	WHILE( @@fetch_status <> -1 )
	BEGIN
		IF( @@fetch_status <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].[IGC_Muun_Period] (Name, ItemType, UsedInfo, Serial, GetItemDate, ExpireDate, ExpireDateConvert)
				VALUES (@KeyName, @ItemType, @UsedInfo, @Serial, @GetItemDate, @ExpireDate, @ExpireDateConvert)
		END
		FETCH NEXT FROM CUR INTO @ItemType, @UsedInfo, @Serial, @GetItemDate, @ExpireDate, @ExpireDateConvert
	END

	CLOSE CUR
	DEALLOCATE CUR
	
	-- step 3.3
	-- copy muun info condition info

	DECLARE @SlotIndex tinyint
	DECLARE @ConditionType tinyint
	DECLARE @Value int

	DECLARE CUR CURSOR FOR SELECT [SlotIndex], [ConditionType], [Value] FROM IGC_Muun_ConditionInfo WHERE Name = @Name

	OPEN CUR
	FETCH NEXT FROM CUR INTO @SlotIndex, @ConditionType, @Value

	WHILE( @@fetch_status <> -1 )
	BEGIN
		IF( @@fetch_status <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].[IGC_Muun_ConditionInfo] (Name, SlotIndex, ConditionType, Value)
				VALUES (@KeyName, @SlotIndex, @ConditionType, @Value)
		END
		FETCH NEXT FROM CUR INTO @SlotIndex, @ConditionType, @Value
	END

	CLOSE CUR
	DEALLOCATE CUR

	-- step 4
	-- copy pentagram item data

	DECLARE @UserGuid int
	DECLARE @JewelPos tinyint
	DECLARE @PentagramInfo varbinary(4250)

	DECLARE CUR CURSOR FOR SELECT [UserGuid], [JewelPos], [PentagramInfo] FROM IGC_PentagramInfo WHERE
		AccountID = @AccountID AND Name = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @UserGuid, @JewelPos, @PentagramInfo

	WHILE( @@fetch_status <> -1 )
	BEGIN
		IF( @@fetch_status <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].IGC_PentagramInfo (UserGuid, AccountID, Name, JewelPos, PentagramInfo)
			VALUES (@UserGuid, @AccountID, @KeyName, @JewelPos, @PentagramInfo)
		END
		FETCH NEXT FROM CUR INTO @UserGuid, @JewelPos, @PentagramInfo
	END

	CLOSE CUR
	DEALLOCATE CUR

	-- step 5
	-- copy character option data (q,w,e,r etc.)

	DECLARE @SkillKey binary(20)
	DECLARE @GameOption tinyint
	DECLARE @QKey tinyint
	DECLARE @WKey tinyint
	DECLARE @EKey tinyint
	DECLARE @ChatWindow tinyint
	DECLARE @RKey tinyint
	DECLARE @QWERLevel int
	DECLARE @EnableChangeMode tinyint
	DECLARE @PlayGuideLv smallint
	DECLARE @PlayGuideCK tinyint

	DECLARE CUR CURSOR FOR SELECT [SkillKey], [GameOption], [QKey], [WKey], [EKey], [ChatWindow], [RKey], [QWERLevel], [EnableChangeMode], [PlayGuideLv], [PlayGuideCK] FROM OptionData WHERE Name = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @SkillKey, @GameOption, @QKey, @WKey, @EKey, @ChatWindow, @RKey, @QWERLevel, @EnableChangeMode, @PlayGuideLv, @PlayGuideCK

	INSERT INTO [BattleCore].[dbo].OptionData (Name, SkillKey, GameOption, Qkey, Wkey, Ekey, ChatWindow, Rkey, QWERLevel, EnableChangeMode, PlayGuideLv, PlayGuideCK) VALUES
		(@KeyName, @SkillKey, @GameOption, @QKey, @WKey, @EKey, @ChatWindow, @RKey, @QWERLevel, @EnableChangeMode, @PlayGuideLv, @PlayGuideCK)

	CLOSE CUR
	DEALLOCATE CUR

	-- step 6.1
	-- copy period item data (cash-shop)
	DECLARE @PeriodUserGuid int
	DECLARE @PeriodItemCode int
	DECLARE @PeriodEffectType1 tinyint
	DECLARE @PeriodEffectType2 tinyint
	DECLARE @PeriodUsedTime int
	DECLARE @PeriodLeftTime int
	DECLARE @PeriodBuyDate smalldatetime
	DECLARE @PeriodExpireDate smalldatetime
	DECLARE @PeriodUsedInfo tinyint
	DECLARE @PeriodOptionType tinyint
	DECLARE @PeriodItemType tinyint
	DECLARE @PeriodSerialCode bigint
	DECLARE @PeriodBuyDateConvert bigint
	DECLARE @PeriodExpireDateConvert bigint
	DECLARE @PeriodSetExpire tinyint

	DECLARE CUR CURSOR FOR SELECT [UserGuid], [ItemCode], [EffectType1], [EffectType2], [UsedTime], [LeftTime], [BuyDate], [ExpireDate], [UsedInfo], [OptionType], [ItemType], [SerialCode], [BuyDateConvert], [ExpireDateConvert], [SetExpire]
	FROM IGC_PeriodItemInfo WHERE CharacterName = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @PeriodUserGuid, @PeriodItemCode, @PeriodEffectType1, @PeriodEffectType2, @PeriodUsedTime, @PeriodLeftTime, @PeriodBuyDate, @PeriodExpireDate,
	@PeriodUsedInfo, @PeriodOptionType, @PeriodItemType, @PeriodSerialCode, @PeriodBuyDateConvert, @PeriodExpireDateConvert, @PeriodSetExpire

	WHILE( @@fetch_status  <> -1 )
	BEGIN
		IF( @@fetch_status  <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].IGC_PeriodItemInfo (UserGuid, CharacterName, ItemCode, EffectType1, EffectType2, UsedTime, LeftTime, BuyDate, ExpireDate, UsedInfo, OptionType, ItemType, SerialCode, BuyDateConvert, ExpireDateConvert, SetExpire)
			VALUES (@PeriodUserGuid, @KeyName, @PeriodItemCode, @PeriodEffectType1, @PeriodEffectType2, @PeriodUsedTime, @PeriodLeftTime, @PeriodBuyDate, @PeriodExpireDate, @PeriodUsedInfo, @PeriodOptionType, @PeriodItemType, @PeriodSerialCode, @PeriodBuyDateConvert, @PeriodExpireDateConvert, @PeriodSetExpire)
		END

		FETCH NEXT FROM CUR INTO @PeriodUserGuid, @PeriodItemCode, @PeriodEffectType1, @PeriodEffectType2, @PeriodUsedTime, @PeriodLeftTime, @PeriodBuyDate, @PeriodExpireDate,
		@PeriodUsedInfo, @PeriodOptionType, @PeriodItemType, @PeriodSerialCode, @PeriodBuyDateConvert, @PeriodExpireDateConvert, @PeriodSetExpire
	END

	CLOSE CUR
	DEALLOCATE CUR

	-- step 6.2
	-- copy period item data (arca buffs)
	DECLARE @PeriodBuffIndex smallint
	DECLARE @PeriodDuration int

	SET @PeriodEffectType1 = 0
	SET @PeriodEffectType2 = 0
	SET @PeriodExpireDateConvert = 0

	DECLARE CUR CURSOR FOR SELECT [BuffIndex], [EffectType1], [EffectType2], [ExpireDate], [Duration] FROM IGC_PeriodBuffInfo WHERE CharacterName = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @PeriodBuffIndex, @PeriodEffectType1, @PeriodEffectType2, @PeriodExpireDateConvert, @PeriodDuration

	WHILE( @@fetch_status <> -1 )
	BEGIN
		IF( @@fetch_status <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].IGC_PeriodBuffInfo (CharacterName, BuffIndex, EffectType1, EffectType2, ExpireDate, Duration) VALUES
			(@KeyName, @PeriodBuffIndex, @PeriodEffectType1, @PeriodEffectType2, @PeriodExpireDateConvert, @PeriodDuration)
		END

		FETCH NEXT FROM CUR INTO @PeriodBuffIndex, @PeriodEffectType1, @PeriodEffectType2, @PeriodExpireDateConvert, @PeriodDuration
	END

	CLOSE CUR
	DEALLOCATE CUR

	-- step 7
	-- copy lucky item data

	DECLARE @LuckyUserGuid int
	DECLARE @LuckyItemCode int
	DECLARE @LuckyItemSerial bigint
	DECLARE @LuckyDurabilitySmall smallint

	DECLARE CUR CURSOR FOR SELECT [UserGuid], [ItemCode], [ItemSerial], [DurabilitySmall] FROM T_LUCKY_ITEM_INFO WHERE CharName = @Name
	OPEN CUR
	FETCH NEXT FROM CUR INTO @LuckyUserGuid, @LuckyItemCode, @LuckyItemSerial, @LuckyDurabilitySmall

	WHILE( @@fetch_status <> -1 )
	BEGIN
		IF( @@fetch_status <> -2 )
		BEGIN
			INSERT INTO [BattleCore].[dbo].T_LUCKY_ITEM_INFO (UserGuid, CharName, ItemCode, ItemSerial, DurabilitySmall) VALUES
			(@LuckyUserGuid, @KeyName, @LuckyItemCode, @LuckyItemSerial, @LuckyDurabilitySmall)
		END

		FETCH NEXT FROM CUR INTO @LuckyUserGuid, @LuckyItemCode, @LuckyItemSerial, @LuckyDurabilitySmall
	END

	CLOSE CUR
	DEALLOCATE CUR

	-- step 8
	-- copy gm data

	DECLARE @AuthorityMask int
	DECLARE @Expiry smalldatetime

	SELECT @AuthorityMask = AuthorityMask, @Expiry = Expiry FROM T_GMSystem WHERE Name = @Name

	INSERT INTO [BattleCore].[dbo].T_GMSystem (Name, AuthorityMask, Expiry) VALUES (@KeyName, @AuthorityMask, @Expiry)


	-- step 9
	-- set character in AccountCharacter

	IF (@SlotNumber = 1)
	BEGIN
		UPDATE [BattleCore].[dbo].AccountCharacter SET GameID1 = @KeyName WHERE Id = @AccountID
	END
	ELSE IF (@SlotNumber = 2)
	BEGIN
		UPDATE [BattleCore].[dbo].AccountCharacter SET GameID2 = @KeyName WHERE Id = @AccountID
	END

	SELECT 1 AS Result
END







GO
/****** Object:  StoredProcedure [dbo].[IGC_BattleCore_CopyPetItemInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_BattleCore_CopyPetItemInfo]
	@PetItemSerial bigint,
	@ServerCode int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ItemSerial bigint, @Pet_Level smallint, @Pet_Exp bigint
	SELECT @ItemSerial = ItemSerial, @Pet_Level = Pet_Level, @Pet_Exp = Pet_Exp FROM T_PetItem_Info WHERE ItemSerial = @PetItemSerial

	IF EXISTS (SELECT * FROM [BattleCore].[dbo].BattleCore_PetItem_Info WHERE ItemSerial = @ItemSerial AND ServerCode = @ServerCode)
	BEGIN
		DELETE FROM [BattleCore].[dbo].BattleCore_PetItem_Info WHERE ItemSerial = @ItemSerial AND ServerCode = @ServerCode
	END

	INSERT INTO [BattleCore].[dbo].BattleCore_PetItem_Info (ItemSerial, ServerCode, Pet_Level, Pet_Exp) VALUES (@PetItemSerial, @ServerCode, @Pet_Level, @Pet_Exp)
END



















GO
/****** Object:  StoredProcedure [dbo].[IGC_BattleCore_DeleteCharacter]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_BattleCore_DeleteCharacter]
	@AccountID varchar(10),
	@Name varchar(10),
	@ServerCode int
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT * FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @Name AND ServerCode = @ServerCode)
	BEGIN
		SELECT 0 AS Result
		RETURN
	END

	DECLARE @KeyName varchar(10)
	SELECT @KeyName = Name FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @Name AND ServerCode = @ServerCode

	DELETE FROM [BattleCore].[dbo].Character WHERE AccountID = @AccountID AND Name = @KeyName
	DELETE FROM [BattleCore].[dbo].IGC_BlockChat WHERE Name = @KeyName
	DELETE FROM [BattleCore].[dbo].IGC_Muun_ConditionInfo WHERE Name = @KeyName
	DELETE FROM [BattleCore].[dbo].IGC_Muun_Inventory WHERE Name = @KeyName
	DELETE FROM [BattleCore].[dbo].IGC_Muun_Period WHERE Name = @KeyName
	DELETE FROM [BattleCore].[dbo].IGC_PentagramInfo WHERE Name = @KeyName
	DELETE FROM [BattleCore].[dbo].IGC_PeriodBuffInfo WHERE CharacterName = @KeyName
	DELETE FROM [BattleCore].[dbo].IGC_PeriodItemInfo WHERE CharacterName = @KeyName
	DELETE FROM [BattleCore].[dbo].OptionData WHERE Name = @KeyName
	DELETE FROM [BattleCore].[dbo].T_Event_Inventory WHERE Name = @KeyName
	DELETE FROM [BattleCore].[dbo].T_LUCKY_ITEM_INFO WHERE CharName = @KeyName
	DELETE FROM [BattleCore].[dbo].T_MuRummy WHERE Name = @KeyName
	DELETE FROM [BattleCore].[dbo].T_MuRummyInfo WHERE Name = @KeyName
	DELETE FROM [BattleCore].[dbo].T_MuRummyLog WHERE Name = @KeyName
	
	
	
	DECLARE @g1 varchar(10), @g2 varchar(10)						
	SELECT @g1=GameID1, @g2=GameID2 FROM [BattleCore].[dbo].AccountCharacter Where Id = @AccountID

	IF (@g1 = @KeyName)
	BEGIN
		UPDATE [BattleCore].[dbo].AccountCharacter SET GameID1 = NULL WHERE Id = @AccountID
	END
	ELSE IF (@g2 = @KeyName)
	BEGIN
		UPDATE [BattleCore].[dbo].AccountCharacter SET GameID2 = NULL WHERE Id = @AccountID
	END



	SELECT 1 AS Result
END


















GO
/****** Object:  StoredProcedure [dbo].[IGC_BattleCore_GetRealName]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_BattleCore_GetRealName]
	@KeyName varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT UBFName AS RealName, ServerCode FROM [BattleCore].[dbo].BattleCoreInfo WHERE Name = @KeyName
END


















GO
/****** Object:  StoredProcedure [dbo].[IGC_BattleCore_GetReward]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_BattleCore_GetReward]
	@AccountID varchar(10),
	@Name varchar(10),
	@ServerCode int
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT * FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @Name AND ServerCode = @ServerCode)
	BEGIN
		RETURN
	END

	DECLARE @KeyName varchar(10)
	SELECT @KeyName = Name FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @Name AND ServerCode = @ServerCode

	SELECT * FROM [BattleCore].[dbo].BattleCore_Reward WHERE CharName = @KeyName AND Status = 0 AND ServerCode = @ServerCode
END

















GO
/****** Object:  StoredProcedure [dbo].[IGC_BattleCore_GetUserInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_BattleCore_GetUserInfo]
	@AccountID varchar(10),
	@Name varchar(10),
	@ServerCode int,
	@IsUBFServer int
AS
BEGIN
	SET NOCOUNT ON;

	IF (@IsUBFServer = 1) -- Battle Core GS
	BEGIN
		IF EXISTS (SELECT * FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND Name = @Name)
		BEGIN
			SELECT 1 AS Result, RegisterState, RegisterMonth, RegisterDay FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND Name = @Name
			RETURN
		END
		ELSE
		BEGIN
			SELECT 0 AS Result
			RETURN
		END
	END
	ELSE IF (@IsUBFServer = 0) -- Normal GS
	BEGIN
		IF EXISTS (SELECT * FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @Name AND ServerCode = @ServerCode)
		BEGIN
			SELECT 1 AS Result, RegisterState, RegisterMonth, RegisterDay FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @Name AND ServerCode = @ServerCode
			RETURN
		END
		ELSE
		BEGIN
			SELECT 0 AS Result
			RETURN
		END
	END
	ELSE
	BEGIN
		SELECT 0 AS Result
		RETURN
	END			
END



GO
/****** Object:  StoredProcedure [dbo].[IGC_BattleCore_JoinUser]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[IGC_BattleCore_JoinUser]
	@AccountID varchar(10),
	@Name varchar(10),
	@UBFName varchar(10),
	@ServerCode int,
	@RegisterState int,
	@RegisterMonth int,
	@RegisterDay int
AS
BEGIN
	SET NOCOUNT ON;

	IF ((SELECT COUNT (*) FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND RegisterState = 1) >= 2)
	BEGIN
		SELECT 4 AS Result
		RETURN
	END

	IF EXISTS (SELECT * FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @UBFName AND ServerCode = @ServerCode AND RegisterState = 1)
	BEGIN
		SELECT 2 AS Result
		RETURN
	END

	IF EXISTS (SELECT * FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @UBFName AND ServerCode = @ServerCode AND RegisterState = 0)
	BEGIN
		DECLARE @LeftTime smalldatetime
		SELECT @LeftTime = LeftTime FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @AccountID AND UBFName = @UBFName AND ServerCode = @ServerCode AND RegisterState = 0

		IF (DATEDIFF(SECOND, @LeftTime, GETDATE()) < 180)
		BEGIN
			SELECT 3 AS Result, (180 - DATEDIFF(SECOND, @LeftTime, GETDATE())) AS LeftSecond
			RETURN
		END
		ELSE
		BEGIN
			UPDATE [BattleCore].[dbo].BattleCoreInfo SET RegisterState = 1, RegisterMonth = @RegisterMonth, RegisterDay = @RegisterDay WHERE AccountID = @AccountID AND UBFName = @UBFName AND ServerCode = @ServerCode
			SELECT 1 AS Result
			RETURN
		END
	END
	ELSE
	BEGIN

		DECLARE @FreeKeyName int
		SET @FreeKeyName = 0

		WHILE (1 = 1)
		BEGIN
			SET @FreeKeyName = ROUND(((2000000000 - 1 -1) * RAND() + 1), 0)
			IF NOT EXISTS (SELECT * FROM [BattleCore].[dbo].BattleCoreInfo WHERE Name = @FreeKeyName)
			BEGIN
				BREAK
			END
		END

		INSERT INTO [BattleCore].[dbo].BattleCoreInfo (AccountID, Name, UBFName, ServerCode, RegisterState, RegisterMonth, RegisterDay, LeftTime) VALUES
		(@AccountID, @FreeKeyName, @UBFName, @ServerCode, 1, @RegisterMonth, @RegisterDay, NULL)

		INSERT INTO [BattleCore].[dbo].AccountCharacter (Id, GameID1, GameID2, GameID3, GameID4, GameID5, GameID6, GameID7, GameID8, GameIDC, MoveCnt, Summoner, WarehouseExpansion, RageFighter, GrowLancer, MagicGladiator, DarkLord, SecCode) VALUES
		(@AccountID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, 1, 1, 1, 0)

		SELECT 0 AS Result
	END
		RETURN


END


GO
/****** Object:  StoredProcedure [dbo].[IGC_BattleCore_SetRewardStatus]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_BattleCore_SetRewardStatus]
	@szAccountID varchar(10),
	@szName varchar(10),
	@ServerCode int,
	@ItemType int,
	@EventType int,
	@Status int,
	@GUID int
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT * FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @szAccountID AND UBFName = @szName AND ServerCode = @ServerCode)
	BEGIN
		SELECT 0 AS Result
		RETURN
	END

	DECLARE @KeyName varchar(10)
	SELECT @KeyName = Name FROM [BattleCore].[dbo].BattleCoreInfo WHERE AccountID = @szAccountID AND UBFName = @szName AND ServerCode = @ServerCode

	UPDATE [BattleCore].[dbo].[BattleCore_Reward] SET Status = @Status WHERE AccountName = @szAccountID AND CharName = @KeyName AND ServerCode = @ServerCode AND ItemType = @ItemType AND EventType = @EventType AND GUID = @GUID
	SELECT 1 AS Result
END


GO
/****** Object:  StoredProcedure [dbo].[IGC_ClassQuest_MonsterKillLoad]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IGC_ClassQuest_MonsterKillLoad]
    @szCharName     varchar(10)
As
Begin
    BEGIN TRANSACTION
   
    SET NOCOUNT ON
    IF EXISTS ( SELECT CharacterName FROM IGC_ClassQuest_MonsterKill  WITH ( READUNCOMMITTED )
                WHERE CharacterName = @szCharName )
    BEGIN
        SELECT QuestIndex, MonsterIndex_1, MonsterKillCount_1, MonsterIndex_2, MonsterKillCount_2, MonsterIndex_3, MonsterKillCount_3, MonsterIndex_4, MonsterKillCount_4, MonsterIndex_5, MonsterKillCount_5
            FROM IGC_ClassQuest_MonsterKill  WHERE CharacterName = @szCharName
    END
    ELSE
    BEGIN
        INSERT IGC_ClassQuest_MonsterKill VALUES ( @szCharName, -1, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0 )
        SELECT QuestIndex, MonsterIndex_1, MonsterKillCount_1, MonsterIndex_2, MonsterKillCount_2, MonsterIndex_3, MonsterKillCount_3, MonsterIndex_4, MonsterKillCount_4, MonsterIndex_5, MonsterKillCount_5
            FROM IGC_ClassQuest_MonsterKill  WHERE CharacterName = @szCharName
    END
   
    IF(@@Error <> 0 )
        ROLLBACK TRANSACTION
    ELSE   
        COMMIT TRANSACTION
    SET NOCOUNT OFF
End




GO
/****** Object:  StoredProcedure [dbo].[IGC_ClassQuest_MonsterKillSave]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IGC_ClassQuest_MonsterKillSave]
    @szCharName     varchar(10)
,   @iQuestIndex        smallint
,   @iMonsterIndex1     smallint
,   @iKillCount1        smallint
,   @iMonsterIndex2     smallint
,   @iKillCount2        smallint
,   @iMonsterIndex3     smallint
,   @iKillCount3        smallint
,   @iMonsterIndex4     smallint
,   @iKillCount4        smallint
,   @iMonsterIndex5     smallint
,   @iKillCount5        smallint
As
Begin
    BEGIN TRANSACTION
   
    SET NOCOUNT ON
    IF EXISTS ( SELECT CharacterName FROM IGC_ClassQuest_MonsterKill  WITH (READUNCOMMITTED)
                WHERE CharacterName = @szCharName )
    BEGIN
        UPDATE IGC_ClassQuest_MonsterKill
        SET QuestIndex = @iQuestIndex
            , MonsterIndex_1    = @iMonsterIndex1
            , MonsterKillCount_1    = @iKillCount1
            , MonsterIndex_2    = @iMonsterIndex2
            , MonsterKillCount_2    = @iKillCount2
            , MonsterIndex_3    = @iMonsterIndex3
            , MonsterKillCount_3    = @iKillCount3
            , MonsterIndex_4    = @iMonsterIndex4
            , MonsterKillCount_4    = @iKillCount4
            , MonsterIndex_5    = @iMonsterIndex5
            , MonsterKillCount_5    = @iKillCount5
        WHERE CharacterName = @szCharName
    END
    ELSE
    BEGIN
        INSERT IGC_ClassQuest_MonsterKill VALUES ( @szCharName, -1, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0 )
 
        UPDATE IGC_ClassQuest_MonsterKill
        SET QuestIndex = @iQuestIndex
            , MonsterIndex_1    = @iMonsterIndex1
            , MonsterKillCount_1    = @iKillCount1
            , MonsterIndex_2    = @iMonsterIndex2
            , MonsterKillCount_2    = @iKillCount2
            , MonsterIndex_3    = @iMonsterIndex3
            , MonsterKillCount_3    = @iKillCount3
            , MonsterIndex_4    = @iMonsterIndex4
            , MonsterKillCount_4    = @iKillCount4
            , MonsterIndex_5    = @iMonsterIndex5
            , MonsterKillCount_5    = @iKillCount5
        WHERE CharacterName = @szCharName
    END
   
    IF(@@Error <> 0 )
        ROLLBACK TRANSACTION
    ELSE   
        COMMIT TRANSACTION
    SET NOCOUNT OFF
End




GO
/****** Object:  StoredProcedure [dbo].[IGC_DeleteAllPartyMatchingList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_DeleteAllPartyMatchingList]
as 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

       delete from dbo.IGC_PartyMatching
       delete from dbo.IGC_WaitPartyMatching
END






























GO
/****** Object:  StoredProcedure [dbo].[IGC_DeleteCharacter]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IGC_DeleteCharacter]
    @szCharName varchar(10)
AS
BEGIN
    SET NOCOUNT ON;
 
    IF EXISTS (SELECT [Name] FROM [dbo].[Character] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[Character] WHERE [Name] = @szCharName
    END
    ELSE
    BEGIN
        SELECT 0 AS QueryResult
        RETURN
    END

    IF EXISTS (SELECT [Name] FROM [dbo].[OptionData] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[OptionData] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [CHAR_NAME] FROM [dbo].[T_QUEST_EXP_INFO] WHERE [CHAR_NAME] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_QUEST_EXP_INFO] WHERE [CHAR_NAME] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[IGC_Gens] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_Gens] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[IGC_GensAbuse] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_GensAbuse] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [CharacterName] FROM [dbo].[IGC_PeriodItemInfo] WHERE [CharacterName] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_PeriodItemInfo] WHERE [CharacterName] = @szCharName
    END
 
    IF EXISTS (SELECT [CharName] FROM [dbo].[T_LUCKY_ITEM_INFO] WHERE [CharName] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_LUCKY_ITEM_INFO] WHERE [CharName] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[IGC_PentagramInfo] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_PentagramInfo] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [CharacterName] FROM [dbo].[IGC_PeriodBuffInfo] WHERE [CharacterName] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_PeriodBuffInfo] WHERE [CharacterName] = @szCharName
    END
	
	IF EXISTS (SELECT [Name] FROM [dbo].[IGC_EvolutionMonster] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_EvolutionMonster] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[T_Event_Inventory] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_Event_Inventory] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[IGC_Muun_Inventory] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_Muun_Inventory] WHERE [Name] = @szCharName
    END
	
	IF EXISTS (SELECT [Name] FROM [dbo].[IGC_Muun_Period] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_Muun_Period] WHERE [Name] = @szCharName
    END
	
	IF EXISTS (SELECT [Name] FROM [dbo].[IGC_Muun_ConditionInfo] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_Muun_ConditionInfo] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[IGC_RestoreItem_Inventory] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_RestoreItem_Inventory] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[IGC_GremoryCase] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_GremoryCase] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [CharacterName] FROM [dbo].[T_MineSystem] WHERE [CharacterName] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_MineSystem] WHERE [CharacterName] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[T_PSHOP_ITEMVALUE_INFO] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_PSHOP_ITEMVALUE_INFO] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[T_MuRummy] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_MuRummy] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[T_MuRummyInfo] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_MuRummyInfo] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[T_MuRummyLog] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_MuRummyLog] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[T_GMSystem] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_GMSystem] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [name] FROM [dbo].[C_Monster_KillCount] WHERE [name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[C_Monster_KillCount] WHERE [name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[IGC_BlockChat] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_BlockChat] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[IGC_HuntingRecord] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_HuntingRecord] WHERE [Name] = @szCharName
    END
	
	IF EXISTS (SELECT [Name] FROM [dbo].[IGC_HuntingRecordOption] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_HuntingRecordOption] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[T_BombGameScore] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_BombGameScore] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[T_GUIDE_QUEST_INFO] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_GUIDE_QUEST_INFO] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [Name] FROM [dbo].[T_CGuid] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[T_CGuid] WHERE [Name] = @szCharName
    END
 
    IF EXISTS (SELECT [CharacterName] FROM [dbo].[IGC_ClassQuest_MonsterKill] WHERE [CharacterName] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_ClassQuest_MonsterKill] WHERE [CharacterName] = @szCharName
    END

	IF EXISTS (SELECT [CharacterName] FROM [dbo].[IGC_EventMapEnterLimit] WHERE [CharacterName] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_EventMapEnterLimit] WHERE [CharacterName] = @szCharName
    END
	
	IF EXISTS (SELECT [Name] FROM [dbo].[IGC_FavouriteWarpData] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_FavouriteWarpData] WHERE [Name] = @szCharName
    END

	IF EXISTS (SELECT [Name] FROM [dbo].[IGC_LabyrinthClearLog] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_LabyrinthClearLog] WHERE [Name] = @szCharName
    END
	
	IF EXISTS (SELECT [Name] FROM [dbo].[IGC_LabyrinthInfo] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_LabyrinthInfo] WHERE [Name] = @szCharName
    END
	
	IF EXISTS (SELECT [Name] FROM [dbo].[IGC_LabyrinthMissionInfo] WHERE [Name] = @szCharName)
    BEGIN
        DELETE FROM [dbo].[IGC_LabyrinthMissionInfo] WHERE [Name] = @szCharName
    END
 
    SELECT 1 AS QueryResult
 
END




GO
/****** Object:  StoredProcedure [dbo].[IGC_DeleteGuildMatchingData]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_DeleteGuildMatchingData]
   @GuildNum varchar(8)
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF EXISTS (SELECT TOP 1 * FROM dbo.IGC_GuildMatching  WITH (READUNCOMMITTED)
		where GuildNum = @GuildNum)
	              BEGIN
	                   delete dbo.IGC_GuildMatching where GuildNum = @GuildNum 
			     select 0 as Result
	              END
       ELSE
	              BEGIN
	       	     select -3 as Result
	              END
	       
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_DeletePartyMatchingList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_DeletePartyMatchingList]
   @PartyLeaderName varchar(10)
as 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

      	delete dbo.IGC_PartyMatching where PartyLeaderName = @PartyLeaderName
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_DeleteWaitPartyMatchingList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_DeleteWaitPartyMatchingList]
   @MemberName varchar(10)
as 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

      	delete dbo.IGC_WaitPartyMatching where MemberName = @MemberName
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_DelGuildMatchingWaitState]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_DelGuildMatchingWaitState]
   @Name varchar(10)
as 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    delete  dbo.IGC_WaitGuildMatching where ApplicantName = @Name 
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_EventMapEnterCount_Get]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_EventMapEnterCount_Get]
	@szCharacterName	VARCHAR(10)	
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @LastDate SMALLDATETIME

IF NOT EXISTS ( SELECT * FROM dbo.IGC_EventMapEnterLimit
				WHERE CharacterName = @szCharacterName )
BEGIN
	INSERT INTO dbo.IGC_EventMapEnterLimit (CharacterName)
	VALUES (@szCharacterName)
END

SELECT @LastDate = LastDate
FROM dbo.IGC_EventMapEnterLimit
WHERE CharacterName = @szCharacterName

IF (CONVERT(INT,CONVERT(CHAR(8),@LastDate,112)) < CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112)))
BEGIN
	SELECT 0 AS BloodCastle, 0 AS ChaosCastle, 0 AS DevilSquare, 0 AS DoppelGanger, 0 AS ImperialGuardian, 0 AS IllusionTempleRenewal
END
ELSE
	SELECT
		BloodCastle
		,ChaosCastle	
		,DevilSquare
		,DoppelGanger	
		,ImperialGuardian
		,IllusionTempleRenewal
	FROM dbo.IGC_EventMapEnterLimit
	WHERE CharacterName = @szCharacterName


GO
/****** Object:  StoredProcedure [dbo].[IGC_EventMapEnterCount_Set]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_EventMapEnterCount_Set]
	@CharacterName			VARCHAR(10)
	,@BloodCastle			TINYINT
	,@ChaosCastle			TINYINT
	,@DevilSquare			TINYINT
	,@DoppelGanger			TINYINT
	,@ImperialGuardian		TINYINT
	,@IllusionTempleRenewal	TINYINT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

UPDATE dbo.IGC_EventMapEnterLimit 
SET 
	BloodCastle = @BloodCastle
	,ChaosCastle = @ChaosCastle
	,DevilSquare = @DevilSquare
	,DoppelGanger = @DoppelGanger
	,ImperialGuardian= @ImperialGuardian
	,IllusionTempleRenewal = @IllusionTempleRenewal
	,LastDate = GETDATE()
WHERE CharacterName = @CharacterName

IF (@@ROWCOUNT = 0)
BEGIN
	INSERT INTO dbo.IGC_EventMapEnterLimit
		(CharacterName,BloodCastle,ChaosCastle, DevilSquare,DoppelGanger
			,ImperialGuardian,IllusionTempleRenewal, LastDate)
	VALUES
		(@CharacterName,@BloodCastle,@ChaosCastle,@DevilSquare,@DoppelGanger
			,@ImperialGuardian,@IllusionTempleRenewal, GETDATE())
END



GO
/****** Object:  StoredProcedure [dbo].[IGC_EvolutionMonsterInfoLoad]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_EvolutionMonsterInfoLoad]
	@AccountID	VARCHAR(10)
	,@CharName	VARCHAR(10)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
SELECT	AccountID, [Name], MonsterIndex1, MonsterLevel1, KillCount1
		,MonsterIndex2, MonsterLevel2, KillCount2
		,MonsterIndex3, MonsterLevel3, KillCount3
		,MonsterIndex4, MonsterLevel4, KillCount4
		,MonsterIndex5, MonsterLevel5, KillCount5, AccumDmg
FROM dbo.IGC_EvolutionMonster
WHERE AccountID = @AccountID
	AND Name = @CharName

IF (@@ROWCOUNT = 0)
BEGIN
	INSERT INTO dbo.IGC_EvolutionMonster 
	VALUES( @AccountID, @CharName, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
		, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT )

	SELECT	AccountID, [Name], MonsterIndex1, MonsterLevel1, KillCount1
			,MonsterIndex2, MonsterLevel2, KillCount2
			,MonsterIndex3, MonsterLevel3, KillCount3
			,MonsterIndex4, MonsterLevel4, KillCount4
			,MonsterIndex5, MonsterLevel5, KillCount5, AccumDmg
	FROM dbo.IGC_EvolutionMonster
	WHERE AccountID = @AccountID
		AND Name = @CharName
END



GO
/****** Object:  StoredProcedure [dbo].[IGC_EvolutionMonsterInfoSave]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_EvolutionMonsterInfoSave]
	@AccountID		VARCHAR(10)
	,@CharName		VARCHAR(10)
	,@MonsterIndex1	SMALLINT
	,@MonsterLevel1	SMALLINT
	,@KillCount1	INT
	,@MonsterIndex2	SMALLINT
	,@MonsterLevel2	SMALLINT
	,@KillCount2	INT
	,@MonsterIndex3	SMALLINT
	,@MonsterLevel3	SMALLINT
	,@KillCount3	INT
	,@MonsterIndex4	SMALLINT
	,@MonsterLevel4	SMALLINT
	,@KillCount4	INT
	,@MonsterIndex5	SMALLINT
	,@MonsterLevel5	SMALLINT
	,@KillCount5	INT
	,@AccumDmg		BIGINT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

UPDATE dbo.IGC_EvolutionMonster
SET	
	MonsterIndex1	=	@MonsterIndex1
	,MonsterLevel1	=	@MonsterLevel1
	,KillCount1		=	@KillCount1
	,MonsterIndex2	=	@MonsterIndex2
	,MonsterLevel2	=	@MonsterLevel2
	,KillCount2		=	@KillCount2
	,MonsterIndex3	=	@MonsterIndex3
	,MonsterLevel3	=	@MonsterLevel3
	,KillCount3		=	@KillCount3
	,MonsterIndex4	=	@MonsterIndex4
	,MonsterLevel4	=	@MonsterLevel4
	,KillCount4		=	@KillCount4
	,MonsterIndex5	=	@MonsterIndex5
	,MonsterLevel5	=	@MonsterLevel5
	,KillCount5		=	@KillCount5
	,AccumDmg		=	@AccumDmg
WHERE AccountID = @AccountID AND Name = @CharName

IF (@@ROWCOUNT = 0)

BEGIN
	INSERT INTO dbo.IGC_EvolutionMonster 
	(AccountID, [Name], MonsterIndex1, MonsterLevel1, KillCount1
	,MonsterIndex2, MonsterLevel2, KillCount2, MonsterIndex3, MonsterLevel3, KillCount3
	,MonsterIndex4, MonsterLevel4, KillCount4, MonsterIndex5, MonsterLevel5, KillCount5, AccumDmg)
	VALUES 
	(@AccountID, @CharName, @MonsterIndex1, @MonsterLevel1, @KillCount1
	,@MonsterIndex2, @MonsterLevel2, @KillCount2, @MonsterIndex3, @MonsterLevel3, @KillCount3
	,@MonsterIndex4, @MonsterLevel4, @KillCount4, @MonsterIndex5, @MonsterLevel5, @KillCount5, @AccumDmg)
END



GO
/****** Object:  StoredProcedure [dbo].[IGC_GensAbuseLoad]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Andrzej Erenc @ awHost.pl>
-- Create date: <28.02.2013>
-- Description: <Gens Abuse Load SP>
-- =============================================
CREATE PROCEDURE [dbo].[IGC_GensAbuseLoad]
 @szCharName varchar(10)
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
 BEGIN TRANSACTION

SELECT TOP 10 [Name]
      ,[KillName]
      ,[KillCount]
  FROM [dbo].[IGC_GensAbuse]
  WHERE Name = @szCharName
 
 IF(@@Error <> 0 )
  ROLLBACK TRANSACTION
 ELSE 
  COMMIT TRANSACTION
 SET NOCOUNT OFF 
END
































GO
/****** Object:  StoredProcedure [dbo].[IGC_GensAbuseSave]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Andrzej Erenc>
-- Create date: <28.02.2013>
-- Description: <Gens Abuse Save SP>
-- =============================================
CREATE PROCEDURE [dbo].[IGC_GensAbuseSave]
 @szCharName varchar(10),
 @szKillName varchar(10),
 @iKillCount smallint
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
 BEGIN TRANSACTION

    IF NOT EXISTS ( SELECT Name FROM IGC_GensAbuse  WITH ( READUNCOMMITTED ) 
    WHERE Name = @szCharName AND KillName = @szKillName )
 BEGIN
  INSERT INTO [dbo].[IGC_GensAbuse]
           ([Name]
           ,[KillName]
           ,[KillCount])
     VALUES
           (@szCharName,
           @szKillName,
           @iKillCount)
 END
 ELSE
 BEGIN
  UPDATE [dbo].[IGC_GensAbuse]
   SET [Name] = @szCharName,
      [KillName] = @szKillName,
      [KillCount] = @iKillCount
   WHERE Name = @szCharName
 END
 
 IF(@@Error <> 0 )
  ROLLBACK TRANSACTION
 ELSE 
  COMMIT TRANSACTION
 SET NOCOUNT OFF 
END




































GO
/****** Object:  StoredProcedure [dbo].[IGC_GensAdd]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:  <Andrzej Erenc, Dudas (IGC)>
-- Create date: <28.02.2013>
-- Update date: <02.06.2015>
-- Description: <Gens Add SP>
-- =============================================
CREATE PROCEDURE [dbo].[IGC_GensAdd]
	@szCharName varchar(10),
	@Influence tinyint,
	@LeaveDayDifference smallint
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRANSACTION;

	IF NOT EXISTS ( SELECT Name FROM IGC_Gens  WITH ( READUNCOMMITTED ) WHERE Name = @szCharName )
	BEGIN
		INSERT INTO IGC_Gens (Name, Influence, Rank, LeaveDate)  VALUES (@szCharName, @Influence, 0, NULL)
		SELECT 0x00
	END
	ELSE
	BEGIN
		DECLARE @CurInfluence tinyint
		SELECT @CurInfluence = Influence FROM IGC_Gens WHERE Name = @szCharName

		IF (@CurInfluence > 0)
		BEGIN
			SELECT 0x01
		END
		ELSE
		BEGIN
			DECLARE @GensLeaveDate smalldatetime
			SELECT @GensLeaveDate = LeaveDate FROM IGC_Gens WHERE Name = @szCharName
			IF (DATEDIFF(DAY, @GensLeaveDate, GETDATE()) < @LeaveDayDifference AND @LeaveDayDifference != 0)
			BEGIN
				SELECT 0x02
			END
			ELSE
			BEGIN
				UPDATE IGC_Gens SET Influence = @Influence, Rank = 0, Reward = 0, Points = 0, LeaveDate = NULL WHERE Name = @szCharName
				SELECT 0x00
			END
		END
	END
 
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE 
		COMMIT TRANSACTION
	SET NOCOUNT OFF 
END



































GO
/****** Object:  StoredProcedure [dbo].[IGC_GensDelete]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:  <Andrzej Erenc, Dudas (IGC)>
-- Create date: <28.02.2013>
-- Update date: <02.06.2015>
-- Description: <Gens Delete SP>
-- =============================================

CREATE PROCEDURE [dbo].[IGC_GensDelete]
	@szCharName varchar(10)
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRANSACTION;

    IF NOT EXISTS ( SELECT Name FROM IGC_Gens  WITH ( READUNCOMMITTED ) WHERE Name = @szCharName )
	BEGIN
		SELECT 0x01
	END
	ELSE IF EXISTS ( SELECT G_Name FROM Guild WHERE G_Master = @szCharName)
	BEGIN
		SELECT 0x02
	END
	ELSE
	BEGIN
		UPDATE IGC_Gens SET Influence = 0, Points = 0, Rank = 0, Reward = 0, LeaveDate = GETDATE() WHERE Name = @szCharName
		IF EXISTS (SELECT Name from IGC_GensAbuse WHERE Name = @szCharName)
		BEGIN
			DELETE FROM IGC_GensAbuse WHERE Name = @szCharName
		END
		SELECT 0x00
	END
 
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE 
		COMMIT TRANSACTION
	SET NOCOUNT OFF 
END



































GO
/****** Object:  StoredProcedure [dbo].[IGC_GensLoad]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Andrzej Erenc awHost.pl>
-- Create date: <28.02.2013>
-- Description: <Gens Load SP>
-- =============================================
CREATE PROCEDURE [dbo].[IGC_GensLoad]
 @szCharName varchar(10)
AS
BEGIN
 SET NOCOUNT ON;
 BEGIN TRANSACTION

 SELECT [Name]
      ,[Points]
      ,[Class]
	  ,[Influence]
  FROM [dbo].[IGC_Gens]
  WHERE Name = @szCharName
 
 IF(@@Error <> 0 )
  ROLLBACK TRANSACTION
 ELSE 
  COMMIT TRANSACTION
 SET NOCOUNT OFF 
END




































GO
/****** Object:  StoredProcedure [dbo].[IGC_GensReward]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Create date: <28.02.2013>
-- Description: <Gens Reward SP>
-- =============================================
CREATE PROCEDURE [dbo].[IGC_GensReward]
 @szCharName varchar(10)
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
 BEGIN TRANSACTION

    IF NOT EXISTS ( SELECT Name FROM IGC_Gens  WITH ( READUNCOMMITTED ) 
    WHERE Name = @szCharName )
 BEGIN
  SELECT 0x00
 END
 ELSE
 BEGIN
  UPDATE IGC_Gens SET Reward = 2 WHERE Name = @szCharName
  SELECT 0x01
 END
 
 IF(@@Error <> 0 )
  ROLLBACK TRANSACTION
 ELSE 
  COMMIT TRANSACTION
 SET NOCOUNT OFF 
END




















GO
/****** Object:  StoredProcedure [dbo].[IGC_GensRewardCheck]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Create date: <28.02.2013>
-- Description: <Gens Check Reward SP>
-- =============================================

CREATE PROCEDURE [dbo].[IGC_GensRewardCheck]
 @szCharName varchar(10)
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
 BEGIN TRANSACTION

    IF NOT EXISTS ( SELECT Name FROM IGC_Gens  WITH ( READUNCOMMITTED ) 
    WHERE Name = @szCharName )
 BEGIN
  SELECT 0 AS Reward, 0 as Class
 END
 ELSE
 BEGIN
  SELECT Reward, Class FROM IGC_Gens WHERE Name = @szCharName
 END
 
 IF(@@Error <> 0 )
  ROLLBACK TRANSACTION
 ELSE 
  COMMIT TRANSACTION
 SET NOCOUNT OFF 
END




















GO
/****** Object:  StoredProcedure [dbo].[IGC_GensSave]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Andrzej Erenc>
-- Create date: <28.02.2013>
-- Description: <Gens Save SP>
-- =============================================
CREATE PROCEDURE [dbo].[IGC_GensSave]
 @szCharName varchar(10),
 @Points int,
 @Class tinyint
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
 BEGIN TRANSACTION;

    IF NOT EXISTS ( SELECT Name FROM IGC_Gens  WITH ( READUNCOMMITTED ) 
    WHERE Name = @szCharName )
 BEGIN
  SELECT 0x00;
 END
 ELSE
 BEGIN
  UPDATE IGC_Gens SET Points = @Points, Class = @Class WHERE Name = @szCharName
  SELECT 0x01
 END
 
 IF(@@Error <> 0 )
  ROLLBACK TRANSACTION
 ELSE 
  COMMIT TRANSACTION
 SET NOCOUNT OFF 
END




































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetGremoryCaseSerial]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_GetGremoryCaseSerial]

	@iAddSerialCount	INT
AS
BEGIN
	DECLARE @ItemSerial	BIGINT

	SET XACT_ABORT ON
	SET NOCOUNT ON
	BEGIN TRANSACTION

	UPDATE dbo.GameServerInfo
	SET @ItemSerial = GCItemCount = GCItemCount + @iAddSerialCount
	
	IF ( @@ERROR  <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION	
	END

	SELECT @ItemSerial - @iAddSerialCount + 1 AS ItemSerial

	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END



GO
/****** Object:  StoredProcedure [dbo].[IGC_GetGuildMatchingAcceptNRejectInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_GetGuildMatchingAcceptNRejectInfo]
   @Name varchar(10)
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	select top 1 State  from dbo.IGC_WaitGuildMatching where ApplicantName = @Name and ( State = 1 or State = 2 )
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetGuildMatchingList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_GetGuildMatchingList]
   @page int,
   @pageSize int
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @nTemp int, @nPageSize int
       DECLARE @lastIdentNo int

       set @nTemp = (((@page - 1) * @pageSize) + 1) 
       set @nPageSize = @pageSize

       set ROWCOUNT @nTemp

       select @lastIdentNo = identNo from dbo.IGC_GuildMatching order by identNo desc

       set ROWCOUNT @nPageSize
  
       select  
	   identNo, GuildName, GuildNum, GuildMasterName, GuildMasterLevel, GuildMasterClass, GuildMemberCnt, Memo, InterestType, LevelRange, ClassType, GensType, RegDate
	   from dbo.IGC_GuildMatching where identNo <= @lastIdentNo 
       order by identNo desc  
    
 end































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetGuildMatchingListCount]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[IGC_GetGuildMatchingListCount]
AS
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

       select count(*) as Count  from dbo.IGC_GuildMatching






























GO
/****** Object:  StoredProcedure [dbo].[IGC_GetGuildMatchingListKeyword]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_GetGuildMatchingListKeyword]
   @page int,
   @pageSize int,
   @keyword varchar(10)
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @nTemp int, @nPageSize int
       DECLARE @lastIdentNo int


       set @nTemp = (((@page - 1) * @pageSize) + 1) 
       set @nPageSize = @pageSize

       set ROWCOUNT @nTemp

       set @keyword = rtrim(replace(@keyword,' ',''))
       set @keyword = '%' + @keyword + '%'

       select @lastIdentNo = identNo from dbo.IGC_GuildMatching  where replace(Memo,' ','')  like @keyword order by identNo desc

       set ROWCOUNT @nPageSize
  
       select  
	   identNo, GuildName, GuildNum, GuildMasterName, GuildMasterLevel, GuildMasterClass, GuildMemberCnt, Memo, InterestType, LevelRange, ClassType, GensType, RegDate
	   from dbo.IGC_GuildMatching where identNo <= @lastIdentNo and replace(Memo,' ','') like @keyword
       order by identNo desc  
    
 end






























GO
/****** Object:  StoredProcedure [dbo].[IGC_GetGuildMatchingRegCheck]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_GetGuildMatchingRegCheck]
   @GuildNum int
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

       select count(*) as count from IGC_GuildMatching where GuildNum = @GuildNum
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetGuildMatchingWaitState]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_GetGuildMatchingWaitState]
   @Name varchar(10),
   @State tinyint
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    select top 1 State  from dbo.IGC_WaitGuildMatching where ApplicantName = @Name and State = @State
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetGuildMatchingWaitStateList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_GetGuildMatchingWaitStateList]
   @Name	 varchar(10)
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

       select top 1 GuildName, GuildMasterName  from dbo.IGC_WaitGuildMatching where ApplicantName = @Name and State = 0
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetLoadEventInventory]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_GetLoadEventInventory] (
	@AccountID	VARCHAR(10)
,	@Name		VARCHAR(10)
)
AS  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @Inventory VARBINARY(1024)    
	DECLARE @OldAccountID VARCHAR(10)
	
	SELECT @OldAccountID = AccountID FROM dbo.T_Event_Inventory WHERE Name = @Name
	IF @OldAccountID <> @AccountID 
	BEGIN
		DELETE FROM T_Event_Inventory WHERE AccountID = @OldAccountID and Name = @Name
	END
	
	
	SELECT @Inventory = Inventory FROM dbo.T_Event_Inventory WHERE AccountID = @AccountID AND Name = @Name
	IF @@ROWCOUNT = 0
	BEGIN
		SET @Inventory = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
		
		INSERT INTO dbo.T_Event_Inventory ( AccountID, Name, Inventory)
		VALUES (@AccountID,@Name,@Inventory);
	END

	SELECT @Inventory































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetLoadRestoreInventory]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_GetLoadRestoreInventory]
	@AccountID	VARCHAR(10)
	,@Name		VARCHAR(10)
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @RestoreInven VARBINARY(230)

SELECT @RestoreInven = RestoreInven 
FROM dbo.IGC_RestoreItem_Inventory 
WHERE AccountID = @AccountID 
	AND [Name] = @Name

IF @@ROWCOUNT = 0

BEGIN
	SET @RestoreInven = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
		
	INSERT INTO dbo.IGC_RestoreItem_Inventory 
		( AccountID, [Name], RestoreInven)
	VALUES 
		( @AccountID, @Name, @RestoreInven )
END

SELECT @RestoreInven



GO
/****** Object:  StoredProcedure [dbo].[IGC_GetPartyMatchingList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_GetPartyMatchingList]
   @page int,
   @pageSize int
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @nTemp int, @nPageSize int
       DECLARE @lastIdentNo int

       set @nTemp = (((@page - 1) * @pageSize) + 1) 
       set @nPageSize = @pageSize

       set ROWCOUNT @nTemp

       select @lastIdentNo = IdentNo from dbo.IGC_PartyMatching order by IdentNo desc

       set ROWCOUNT @nPageSize
  
       select  
	   IdentNo, PartyLeaderName, Title, MinLevel, MaxLevel, HuntingGround, WantedClass, CurMemberCount, AcceptType, UsePassWord, 
	   PassWord, WantedClassDetailInfo1, WantedClassDetailInfo2, WantedClassDetailInfo3, WantedClassDetailInfo4, WantedClassDetailInfo5, 
	   WantedClassDetailInfo6, WantedClassDetailInfo7, LeaderChannel, GensType, LeaderLevel, LeaderClass, RegDate
	   from dbo.IGC_PartyMatching where IdentNo <= @lastIdentNo 
       order by IdentNo desc  
    
 end































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetPartyMatchingListCount]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_GetPartyMatchingListCount]
AS
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

       select count(*) as Count  from dbo.IGC_PartyMatching































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetPartyMatchingListJoinAble]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE procedure [dbo].[IGC_GetPartyMatchingListJoinAble]
   @UserLevel smallint,
   @Class tinyint,
   @GensType tinyint,
   @page int,
   @pageSize int
as 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

       DECLARE @nTemp int, @nPageSize int
       DECLARE @lastIdentNo int

       set @nTemp = (((@page - 1) * @pageSize) + 1) 
       set @nPageSize = @pageSize

       set ROWCOUNT @nTemp

       select @lastIdentNo = IdentNo from dbo.IGC_PartyMatching order by IdentNo desc

       set ROWCOUNT @nPageSize
  
       select  
	   IdentNo, PartyLeaderName, Title, MinLevel, MaxLevel, HuntingGround, WantedClass, CurMemberCount, AcceptType, UsePassWord, 
	   PassWord, WantedClassDetailInfo1, WantedClassDetailInfo2, WantedClassDetailInfo3, WantedClassDetailInfo4, WantedClassDetailInfo5, 
	   WantedClassDetailInfo6, WantedClassDetailInfo7, LeaderChannel, GensType, LeaderLevel, LeaderClass, RegDate
	   from dbo.IGC_PartyMatching where  MinLevel <= @UserLevel and (MaxLevel >= @UserLevel  or MaxLevel = 0)
       and  (WantedClass = WantedClass |  @Class or WantedClass = 0 )  and CurMemberCount < 5 and IdentNo <= @lastIdentNo 
       and UsePassWord = 0 and GensType = @GensType
       order by IdentNo desc  
SET NOCOUNT OFF
    
 end































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetPartyMatchingListJoinAbleTotalCount]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_GetPartyMatchingListJoinAbleTotalCount]
   @UserLevel smallint,
   @Class tinyint,
   @Gens tinyint
as 
  BEGIN
SET NOCOUNT ON
       select count(*) as nCount  from IGC_PartyMatching where  MinLevel <= @UserLevel and (MaxLevel >= @UserLevel  or MaxLevel = 0)
       and  (WantedClass = WantedClass |  @Class or WantedClass = 0 )  and CurMemberCount < 5 and UsePassWord = 0 
       and GensType = @Gens 
SET NOCOUNT OFF
    
 end


































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetPartyMatchingListKeyword]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE procedure [dbo].[IGC_GetPartyMatchingListKeyword]
   @page int,
   @pageSize int,
   @keyword varchar(10)
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @nTemp int, @nPageSize int
       DECLARE @lastIdentNo int


       set @nTemp = (((@page - 1) * @pageSize) + 1) 
       set @nPageSize = @pageSize

       set ROWCOUNT @nTemp

       set @keyword = rtrim(replace(@keyword,' ',''))
       set @keyword = '%' + @keyword + '%'

       select @lastIdentNo = IdentNo from dbo.IGC_PartyMatching  where replace(Title,' ','')  like @keyword order by IdentNo desc

       set ROWCOUNT @nPageSize
  
       select  
	   IdentNo, PartyLeaderName, Title, MinLevel, MaxLevel, HuntingGround, WantedClass, CurMemberCount, AcceptType, UsePassWord, 
	   PassWord, WantedClassDetailInfo1, WantedClassDetailInfo2, WantedClassDetailInfo3, WantedClassDetailInfo4, WantedClassDetailInfo5,
	   WantedClassDetailInfo6, WantedClassDetailInfo7, LeaderChannel, GensType, LeaderLevel, LeaderClass, RegDate
	   from dbo.IGC_PartyMatching where IdentNo <= @lastIdentNo and replace(Title,' ','') like @keyword
       order by IdentNo desc  
    
 end































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetPartyMatchingPassWordInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_GetPartyMatchingPassWordInfo]
   @Name	 varchar(10)
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

       select top 1 PassWord,UsePassWord,AcceptType  from IGC_PartyMatching where PartyLeaderName = @Name

END































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetPartyMatchingRandom]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_GetPartyMatchingRandom]
   @UserLevel smallint,
   @Class         tinyint,
   @GensType    tinyint
as 
BEGIN

           SET NOCOUNT ON
           SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

           select top 1 
           PartyLeaderName
           from dbo.IGC_PartyMatching where MinLevel <= @UserLevel and (MaxLevel >= @UserLevel  or MaxLevel = 0)
       and  (WantedClass = WantedClass |  @Class  or WantedClass = 0)   and CurMemberCount < 5   and UsePassWord = 0 and GensType = @GensType
           order by newid()
  END






























GO
/****** Object:  StoredProcedure [dbo].[IGC_GetPartyMatchingWaitList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE    PROCEDURE [dbo].[IGC_GetPartyMatchingWaitList]
   @Name	 varchar(10)
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	select top 1 LeaderName from dbo.IGC_WaitPartyMatching where MemberName = @Name
   
END

































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetPartyMatchingWaitListForLeader]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_GetPartyMatchingWaitListForLeader]
   @Name	 varchar(10)
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	select top 80 MemberName, Class, MemberLevel from dbo.IGC_WaitPartyMatching where LeaderName = @Name
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_GetPartyMatchingWaitMemberInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_GetPartyMatchingWaitMemberInfo]
	@Name	VARCHAR(10)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Class, MemberLevel 
FROM dbo.IGC_WaitPartyMatching 
WHERE MemberName = @Name


GO
/****** Object:  StoredProcedure [dbo].[IGC_GetTotalOnline]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_GetTotalOnline]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Server1 int
	DECLARE @Server2 int

	SET @Server1 = 0
	SET @Server2 = 0

	SELECT @Server1 = COUNT(ConnectStat) FROM [MuOnline].[dbo].[MEMB_STAT] WHERE ConnectStat = 1
	SELECT @Server2 = COUNT(ConnectStat) FROM [MuOnline2].[dbo].[MEMB_STAT] WHERE ConnectStat = 1

	SELECT (@Server1 + @Server2) AS TotalOnline
END























GO
/****** Object:  StoredProcedure [dbo].[IGC_GetWaitGuildMatching]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE    PROCEDURE [dbo].[IGC_GetWaitGuildMatching] 
   @GuildNumber int, 
   @State tinyint
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    select top 80   
	identNo, GuildNumber, GuildName, GuildMasterName, ApplicantName, ApplicantClass, ApplicantLevel, State, RegDate
	from dbo.IGC_WaitGuildMatching where GuildNumber = @GuildNumber and State = @State
    order by identNo desc
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_GremoryCaseChkLimitedCnt]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_GremoryCaseChkLimitedCnt]
	@AccountID	VARCHAR(10)
	,@Name		VARCHAR(10)
	,@GCType	TINYINT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE 
	@ErrorCode			INT
	,@ItemCnt			INT
	,@MAX_GC_ACCOUNT	INT
	,@MAX_GC_CHAR		INT
	,@aRowCnt			INT
	,@GCIndex			INT
SELECT 
	@ErrorCode			=	0
	,@ItemCnt			=	0
	,@MAX_GC_ACCOUNT	=	50
	,@MAX_GC_CHAR		=	50
	,@aRowCnt			=	0
	,@GCIndex			=	0

IF ( @GCType = 1 ) 
BEGIN
	SELECT GremoryCaseIndex FROM dbo.IGC_GremoryCase WHERE AccountID = @AccountID AND GCType = 1 AND UsedInfo = 0

	SET @aRowCnt = @@ROWCOUNT

	IF( @aRowCnt > @MAX_GC_ACCOUNT ) 
	BEGIN
		SET @ItemCnt = @aRowCnt - @MAX_GC_ACCOUNT

		WHILE ( @ItemCnt > 0 )
		BEGIN
			SELECT TOP 1 @GCIndex = GremoryCaseIndex 
			FROM dbo.IGC_GremoryCase 
			WHERE AccountID = @AccountID 
				AND GCType = 1 
				AND UsedInfo = 0 
			ORDER BY RecvDateConvert ASC

			UPDATE dbo.IGC_GremoryCase 
			SET UsedInfo = 4 
			WHERE GremoryCaseIndex = @GCIndex

			SET @ItemCnt = @ItemCnt - 1
		END
	END
END
ELSE IF ( @GCType = 2 ) 
BEGIN
	SELECT GremoryCaseIndex FROM dbo.IGC_GremoryCase WHERE AccountID = @AccountID  AND Name = @Name AND GCType = 2 AND UsedInfo = 0

	SET @aRowCnt = @@ROWCOUNT

	IF( @aRowCnt > @MAX_GC_CHAR ) 
	BEGIN
		SET @ItemCnt = @aRowCnt - @MAX_GC_CHAR

		WHILE ( @ItemCnt > 0 ) 
		BEGIN
			SELECT TOP 1 @GCIndex = GremoryCaseIndex 
			FROM dbo.IGC_GremoryCase 
			WHERE AccountID = @AccountID 
				AND Name = @Name 
				AND GCType = 2 
				AND UsedInfo = 0 
			ORDER BY RecvDateConvert ASC

			UPDATE dbo.IGC_GremoryCase
			SET UsedInfo = 4 
			WHERE GremoryCaseIndex = @GCIndex
			
			SET @ItemCnt = @ItemCnt - 1
		END
	END
END

IF( @@ERROR <> 0 )
BEGIN
	SET @ErrorCode = -1
END



GO
/****** Object:  StoredProcedure [dbo].[IGC_GremoryCaseDelete]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_GremoryCaseDelete]
	@GCType			TINYINT
	,@AccountID		VARCHAR(10)
	,@Name			VARCHAR(10)
	,@ItemType		TINYINT        
	,@ItemIndex		INT            
	,@Level			TINYINT
	,@ItemSerial	BIGINT
	,@RecvDate		BIGINT
	,@UsedInfo		TINYINT
AS 

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @ErrorCode INT
SET @ErrorCode = 0

IF ( @GCType = 1 ) 
BEGIN
	UPDATE dbo.IGC_GremoryCase 
	SET UsedInfo = @UsedInfo 
	WHERE AccountID = @AccountID 
		AND GCType = 1 
		AND ItemType = @ItemType 
		AND ItemIndex = @ItemIndex 
		AND Level = @Level 
		AND Serial = @ItemSerial 
		AND RecvDateConvert = @RecvDate

	IF ( @@ROWCOUNT = 0 )
	BEGIN
		SET @ErrorCode = 1
	END
END
ELSE IF ( @GCType = 2 )
BEGIN
	UPDATE dbo.IGC_GremoryCase 
	SET UsedInfo = @UsedInfo
	WHERE AccountID = @AccountID 
		AND Name = @Name 
		AND GCType = 2 
		AND ItemType = @ItemType 
		AND ItemIndex = @ItemIndex 
		AND Level = @Level 
		AND Serial = @ItemSerial 
		AND RecvDateConvert = @RecvDate

	IF ( @@ROWCOUNT = 0 )
	BEGIN
		SET @ErrorCode = 1
	END
END

SELECT @ErrorCode












GO
/****** Object:  StoredProcedure [dbo].[IGC_GremoryCaseInsert]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_GremoryCaseInsert]
	@GCType				TINYINT	
	,@GiveType			TINYINT
	,@AccountID			VARCHAR(10)
	,@Name				VARCHAR(10)
	,@ItemType			TINYINT        
	,@ItemIndex			INT 
	,@Level				TINYINT
	,@ItemDur			TINYINT
	,@Skill				TINYINT
	,@Luck				TINYINT
	,@Opt				TINYINT
	,@SetOpt			TINYINT
	,@NewOpt			INT
	,@BonusSocketOpt	TINYINT
	,@SocketOpt1		TINYINT
	,@SocketOpt2		TINYINT
	,@SocketOpt3		TINYINT
	,@SocketOpt4		TINYINT
	,@SocketOpt5		TINYINT
	,@Serial			BIGINT
	,@RecvDuration		BIGINT	
	,@ItemDuration		BIGINT	
	,@RecvDate			BIGINT	
	,@RecvExpireDate	BIGINT	
	,@ExpireDate		BIGINT	
AS

SET NOCOUNT ON

DECLARE @ErrorCode int, @PeriodItemIndex int
SELECT @ErrorCode = 0, @PeriodItemIndex = 0

DECLARE @CalcRecvExpireDate SMALLDATETIME
	,@CalcExpireDate SMALLDATETIME

SELECT @CalcRecvExpireDate = DATEADD( SECOND, @RecvDuration, GETDATE() )
	,@CalcExpireDate = DATEADD( SECOND, @ItemDuration, GETDATE() )

INSERT INTO dbo.IGC_GremoryCase
	( GCType, GiveType, AccountID, Name, ItemType, ItemIndex, Level,ItemDur, Skill, Luck, Opt, SetOpt, NewOpt
	, BonusSocketOpt,  SocketOpt1, SocketOpt2, SocketOpt3, SocketOpt4,SocketOpt5
	, Serial,RecvDate, RecvExpireDate,  ItemExpireDate, RecvDateConvert, RecvExpireDateConvert, ItemExpireDateConvert )
VALUES
	( @GCType, @GiveType, @AccountID, @Name, @ItemType, @ItemIndex, @Level, @ItemDur,@Skill, @Luck, @Opt, @SetOpt , @NewOpt
	,@BonusSocketOpt, @SocketOpt1, @SocketOpt2, @SocketOpt3, @SocketOpt4,@SocketOpt5
	,@Serial,GETDATE(), @CalcRecvExpireDate, @CalcExpireDate, @RecvDate, @RecvExpireDate, @ExpireDate )

IF ( @@ERROR <> 0 ) 
BEGIN
	SET @ErrorCode = 2
END

SELECT @ErrorCode




GO
/****** Object:  StoredProcedure [dbo].[IGC_GremoryCaseItemRecv]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_GremoryCaseItemRecv]
	@GCType			TINYINT
	,@AccountID		VARCHAR(10)
	,@Name			VARCHAR(10)
	,@ItemType		TINYINT      
	,@ItemIndex		INT         
	,@Level			TINYINT
	,@ItemSerial	BIGINT
	,@RecvDate		BIGINT
	,@UsedInfo		TINYINT
AS 
	 
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @ErrorCode INT
SET @ErrorCode = 0

IF ( @GCType = 1 ) 
BEGIN
	UPDATE dbo.IGC_GremoryCase 
	SET UsedInfo = @UsedInfo
		,ReceiptDate = GETDATE() 
	WHERE AccountID = @AccountID 
		AND GCType = 1 
		AND ItemType = @ItemType 
		AND ItemIndex = @ItemIndex 
		AND Level = @Level 
		AND Serial = @ItemSerial 
		AND RecvDateConvert = @RecvDate 
		AND UsedInfo = 0

	IF ( @@ROWCOUNT = 0 )
	BEGIN
		SET @ErrorCode = 1
	END
END
ELSE IF ( @GCType = 2 ) 
BEGIN
	UPDATE dbo.IGC_GremoryCase 
	SET UsedInfo = @UsedInfo
		,ReceiptDate = GETDATE()
	WHERE AccountID = @AccountID 
		AND Name = @Name 
		AND GCType = 2 
		AND ItemType = @ItemType 
		AND ItemIndex = @ItemIndex 
		AND Level = @Level 
		AND Serial = @ItemSerial 
		AND RecvDateConvert = @RecvDate 
		AND UsedInfo = 0

	IF ( @@ROWCOUNT = 0 )
	BEGIN
		SET @ErrorCode = 1
	END
END


SELECT @ErrorCode




GO
/****** Object:  StoredProcedure [dbo].[IGC_GremoryCaseSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_GremoryCaseSelect]
	@AccountID	VARCHAR(10)
	,@Name		VARCHAR(10)
	,@GCType	TINYINT
AS 
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @ErrorCode INT
SET @ErrorCode = 0

IF ( @GCType = 1 ) 
BEGIN
	UPDATE dbo.IGC_GremoryCase 
	SET UsedInfo = 1 
	WHERE AccountID = @AccountID 
			AND UsedInfo = 0 
			AND GCType = 1 
			AND RecvExpireDate < GETDATE()
		
	SELECT 
		GremoryCaseIndex, AccountID, Name, GCType, GiveType, ItemType, ItemIndex, Level, ItemDur, Skill
		,Luck, Opt, SetOpt, NewOpt, BonusSocketOpt, SocketOpt1, SocketOpt2, SocketOpt3, SocketOpt4, SocketOpt5
		,UsedInfo, Serial, RecvDate, ReceiptDate, RecvExpireDate, ItemExpireDate, RecvDateConvert, RecvExpireDateConvert, ItemExpireDateConvert  
	FROM dbo.IGC_GremoryCase 
	WHERE AccountID = @AccountID AND UsedInfo = 0 AND GCType = 1
END
ELSE IF(@GCType = 2) 
BEGIN
	UPDATE dbo.IGC_GremoryCase 
	SET UsedInfo = 1 
	WHERE AccountID = @AccountID 
		AND Name = @Name 
		AND UsedInfo = 0 
		AND GCType = 2  
		AND RecvExpireDate < GETDATE()
		
	SELECT
		GremoryCaseIndex, AccountID, Name, GCType, GiveType, ItemType, ItemIndex, Level, ItemDur, Skill
		,Luck, Opt, SetOpt, NewOpt, BonusSocketOpt, SocketOpt1, SocketOpt2, SocketOpt3, SocketOpt4, SocketOpt5
		,UsedInfo, Serial, RecvDate, ReceiptDate, RecvExpireDate, ItemExpireDate, RecvDateConvert, RecvExpireDateConvert, ItemExpireDateConvert  
	FROM dbo.IGC_GremoryCase 
	WHERE AccountID = @AccountID AND Name = @Name AND UsedInfo = 0 AND GCType = 2
END

IF( @@ERROR <> 0 )
BEGIN
	SET @ErrorCode = -1
END





GO
/****** Object:  StoredProcedure [dbo].[IGC_GuildMemberBuffDelete]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  StoredProcedure [dbo].[IGC_GuildMemberBuffDelete]    Script Date: 30.08.2018 13:43:40 ******/
CREATE PROCEDURE [dbo].[IGC_GuildMemberBuffDelete]
	@BuffIndex	int
AS BEGIN
	DECLARE @ErrorCode int

	SET @ErrorCode = 0

	SET nocount on

	DELETE IGC_PeriodBuffInfo WHERE BuffIndex = @BuffIndex

	IF ( @@Error <> 0 ) BEGIN
		SET @ErrorCode = -1
	END

	SELECT @ErrorCode

	SET NOCOUNT OFF
END


GO
/****** Object:  StoredProcedure [dbo].[IGC_HuntingLog_SaveCurrent]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_HuntingLog_SaveCurrent]
	@szName varchar(10),
	@iMapNumber tinyint,
	@iYear int,
	@iMonth int,
	@iDay int,
	@iUserLevel smallint,
	@iHuntingTime int,
	@iDealDamage bigint,
	@iDealElementalDamage bigint,
	@iHealAmount bigint,
	@iMonsterKillCount bigint,
	@iGainExp bigint
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT Name FROM IGC_HuntingLog WHERE Name = @szName AND MapNumber =  @iMapNumber AND Date = DATEFROMPARTS(@iYear, @iMonth, @iDay))
	BEGIN
		INSERT INTO IGC_HuntingLog (Name, Date, MapNumber, UserLevel, HuntingTime, DamageDeal, ElementalDamageDeal, HealAmount, MonsterKillCount, GainExp) VALUES (@szName, DATEFROMPARTS(@iYear, @iMonth, @iDay), @iMapNumber, @iUserLevel, @iHuntingTime, @iDealDamage, @iDealElementalDamage, @iHealAmount, @iMonsterKillCount, @iGainExp)
	END
	ELSE
	BEGIN
		UPDATE IGC_HuntingLog SET HuntingTime = @iHuntingTime, DamageDeal = @iDealDamage, ElementalDamageDeal = @iDealElementalDamage, HealAmount = @iHealAmount, MonsterKillCount = @iMonsterKillCount, GainExp = @iGainExp WHERE Name = @szName AND MapNumber =  @iMapNumber AND Date = DATEFROMPARTS(@iYear, @iMonth, @iDay)
	END
END














GO
/****** Object:  StoredProcedure [dbo].[IGC_HuntingRecordDelete]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[IGC_HuntingRecordDelete]
	@AccountID	VARCHAR(10)
	,@Name		VARCHAR(10)
	,@MapIndex	INT
	,@mYear		INT
	,@mMonth	INT
	,@mDay		INT
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DELETE FROM dbo.IGC_HuntingRecord 
WHERE AccountID		= @AccountID	
	AND	Name		= @Name		
	AND	MapIndex	= @MapIndex
	AND	mYear		= @mYear
	AND	mMonth		= @mMonth
	AND	mDay		= @mDay


GO
/****** Object:  StoredProcedure [dbo].[IGC_HuntingRecordDeleteMapAll]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_HuntingRecordDeleteMapAll]
	@AccountID	VARCHAR(10)
	,@Name		VARCHAR(10)
	,@MapIndex	INT
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DELETE FROM dbo.IGC_HuntingRecord 
WHERE AccountID		= @AccountID	
	AND	Name		= @Name		
	AND	MapIndex	= @MapIndex


GO
/****** Object:  StoredProcedure [dbo].[IGC_HuntingRecordInfoSave]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_HuntingRecordInfoSave]
	@AccountID					VARCHAR(10)
	,@Name						VARCHAR(10)
	,@MapIndex					INT
	,@mYear						INT
	,@mMonth					INT
	,@mDay						INT
	,@CurrentLevel				INT
	,@HuntingAccrueSecond		INT
	,@NormalAccrueDamage		BIGINT
	,@PentagramAccrueDamage		BIGINT
	,@HealAccrueValue			INT
	,@MonsterKillCount			INT
	,@AccrueExp					BIGINT
	,@Class						INT
	,@MaxNormalDamage			INT
	,@MinNormalDamage			INT
	,@MaxPentagramDamage		INT
	,@MinPentagramDamage		INT
	,@GetNormalAccrueDamage		INT
	,@GetPentagramAccrueDamage	INT
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

UPDATE dbo.IGC_HuntingRecord
SET 
		CurrentLevel				= @CurrentLevel
	,	HuntingAccrueSecond			= @HuntingAccrueSecond
	,	NormalAccrueDamage 			= @NormalAccrueDamage
	,	PentagramAccrueDamage 		= @PentagramAccrueDamage
	,	HealAccrueValue	 			= @HealAccrueValue
	,	MonsterKillCount 			= @MonsterKillCount
	,	AccrueExp					= @AccrueExp
	,	Class 						= @Class
	,	MaxNormalDamage 			= @MaxNormalDamage
	,	MinNormalDamage 			= @MinNormalDamage
	,	MaxPentagramDamage 			= @MaxPentagramDamage
	,	MinPentagramDamage 			= @MinPentagramDamage
	,	GetNormalAccrueDamage 		= @GetNormalAccrueDamage
	,	GetPentagramAccrueDamage 	= @GetPentagramAccrueDamage
	,	mDate						= GETDATE()
WHERE AccountID = @AccountID 
	AND Name = @Name 
	AND MapIndex = @MapIndex 
	AND mYear = @mYear  
	AND mMonth = @mMonth  
	AND mDay = @mDay

IF @@ROWCOUNT = 0 
BEGIN
	INSERT INTO dbo.IGC_HuntingRecord 
		(AccountID, Name, MapIndex, mYear, mMonth, mDay, CurrentLevel
		, HuntingAccrueSecond, NormalAccrueDamage, PentagramAccrueDamage
		, HealAccrueValue, MonsterKillCount, AccrueExp, Class, MaxNormalDamage
		, MinNormalDamage, MaxPentagramDamage, MinPentagramDamage
		, GetNormalAccrueDamage, GetPentagramAccrueDamage, mDate)
	VALUES 
		(@AccountID,@Name,@MapIndex,@mYear,@mMonth,@mDay,@CurrentLevel
		,@HuntingAccrueSecond,@NormalAccrueDamage,@PentagramAccrueDamage
		,@HealAccrueValue,@MonsterKillCount,@AccrueExp, @Class, @MaxNormalDamage
		, @MinNormalDamage, @MaxPentagramDamage, @MinPentagramDamage
		, @GetNormalAccrueDamage, @GetPentagramAccrueDamage, GETDATE())
END




GO
/****** Object:  StoredProcedure [dbo].[IGC_HuntingRecordInfoUserOpenLoad]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_HuntingRecordInfoUserOpenLoad]
	@AccountID	VARCHAR(10)
	,@Name		VARCHAR(10)
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UserOpen
FROM dbo.IGC_HuntingRecordOption
WHERE AccountID	= @AccountID	
	AND	Name = @Name


GO
/****** Object:  StoredProcedure [dbo].[IGC_HuntingRecordInfoUserOpenSave]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_HuntingRecordInfoUserOpenSave]
	@AccountID	VARCHAR(10)
	,@Name		VARCHAR(10)
	,@UserOpen	TINYINT
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

UPDATE dbo.IGC_HuntingRecordOption
SET UserOpen = @UserOpen
WHERE AccountID = @AccountID
	AND Name = @Name

IF @@ROWCOUNT = 0 
BEGIN
	INSERT INTO dbo.IGC_HuntingRecordOption 
		(AccountID, Name, UserOpen)
	VALUES
		(@AccountID,@Name,@UserOpen)
END


GO
/****** Object:  StoredProcedure [dbo].[IGC_HuntingRecordLoad]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_HuntingRecordLoad]
	@AccountID	VARCHAR(10)
	,@Name		VARCHAR(10)
	,@MapIndex	INT
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT TOP 60 MapIndex, mYear, mMonth, mDay, CurrentLevel
	, HuntingAccrueSecond, NormalAccrueDamage, PentagramAccrueDamage
	, HealAccrueValue, MonsterKillCount, AccrueExp, Class, MaxNormalDamage
	, MinNormalDamage, MaxPentagramDamage, MinPentagramDamage
	, GetNormalAccrueDamage, GetPentagramAccrueDamage
FROM dbo.IGC_HuntingRecord
WHERE AccountID = @AccountID	
	AND	Name = @Name		
	AND	MapIndex = @MapIndex
ORDER BY mDate desc


GO
/****** Object:  StoredProcedure [dbo].[IGC_HuntingRecordLoad_Current]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_HuntingRecordLoad_Current]
	@AccountID	VARCHAR(10)
	,@Name		VARCHAR(10)
	,@MapIndex	INT
	,@mYear		INT
	,@mMonth	INT
	,@mDay		INT
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT MapIndex, mYear, mMonth, mDay, CurrentLevel
	, HuntingAccrueSecond, NormalAccrueDamage, PentagramAccrueDamage
	, HealAccrueValue, MonsterKillCount, AccrueExp, Class, MaxNormalDamage
	, MinNormalDamage, MaxPentagramDamage, MinPentagramDamage
	, GetNormalAccrueDamage, GetPentagramAccrueDamage
FROM dbo.IGC_HuntingRecord
WHERE AccountID		= @AccountID	
	AND	Name		= @Name		
	AND	MapIndex	= @MapIndex
	AND	mYear		= @mYear
	AND	mMonth		= @mMonth
	AND	mDay		= @mDay


GO
/****** Object:  StoredProcedure [dbo].[IGC_IBS_CheckGiftTarget]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_IBS_CheckGiftTarget]
	@Target					varchar(10)	
AS
BEGIN
	SET NOCOUNT ON;

    IF NOT EXISTS(SELECT AccountID FROM Character WHERE Name = @Target) 
	BEGIN
		SELECT 3 AS Result
	END
	ELSE
	BEGIN
		SELECT 0 AS Result
	END
	
	SET NOCOUNT OFF;
END























GO
/****** Object:  StoredProcedure [dbo].[IGC_InsertGuildMatchingList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[IGC_InsertGuildMatchingList]
   @GuildName varchar(8),
   @GuildMasterName varchar(10),
   @GuildNum	int,
   @GuildMasterLevel smallint,
   @GuildMasterClass tinyint,
   @GuildMemberCnt smallint,
   @Memo varchar(40),
   @InterestType tinyint,
   @LevelRange tinyint,
   @ClassType tinyint,
   @GensType tinyint
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @aErrNo INT, 
			@aRowCnt INT

	SELECT @aErrNo = 0, @aRowCnt = 0

	IF EXISTS (SELECT TOP 1 * FROM dbo.IGC_GuildMatching where GuildNum = @GuildNum)
    BEGIN
		BEGIN TRANSACTION
		BEGIN
			delete dbo.IGC_GuildMatching where GuildNum= @GuildNum
			SELECT @aErrNo = @@ERROR,  @aRowCnt = @@ROWCOUNT
			IF  @aErrNo <> 0 OR @aRowCnt = 0
			BEGIN
				ROLLBACK TRAN
				RETURN
			END		

			insert into dbo.IGC_GuildMatching(GuildName,GuildNum,GuildMasterName,GuildMasterLevel,GuildMasterClass,
			GuildMemberCnt,Memo,InterestType,LevelRange,ClassType,GensType,RegDate)
			values(@GuildName,@GuildNum,@GuildMasterName,@GuildMasterLevel, @GuildMasterClass, @GuildMemberCnt,
			@Memo,@InterestType,@LevelRange,@ClassType,@GensType,GetDate())
			SELECT @aErrNo = @@ERROR,  @aRowCnt = @@ROWCOUNT
			IF  @aErrNo <> 0 OR @aRowCnt = 0
			BEGIN
				ROLLBACK TRAN
				RETURN
			END		

		END
		COMMIT TRANSACTION

    END
    ELSE
    BEGIN
		insert into dbo.IGC_GuildMatching(GuildName,GuildNum,GuildMasterName,GuildMasterLevel,GuildMasterClass,
		GuildMemberCnt,Memo,InterestType,LevelRange,ClassType,GensType,RegDate)
		values(@GuildName,@GuildNum,@GuildMasterName,@GuildMasterLevel, @GuildMasterClass, @GuildMemberCnt,
		@Memo,@InterestType,@LevelRange,@ClassType,@GensType,GetDate())

    END
       
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_InsertGuildMatchingWaitList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[IGC_InsertGuildMatchingWaitList]

   @GuildNumber	int,
   @ApplicantName varchar(10),
   @ApplicantClass tinyint,
   @ApplicantLevel smallint,
   @State tinyint
as 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @aErrNo INT, 
			@aRowCnt INT

	SELECT @aErrNo = 0, @aRowCnt = 0

       declare @GuildName varchar(8)
       declare  @GuildMasterName varchar(10)

       set  @GuildName = (select top 1  GuildName from dbo.IGC_GuildMatching where GuildNum = @GuildNumber)
       set  @GuildMasterName = (select top 1  GuildMasterName from dbo.IGC_GuildMatching where GuildNum = @GuildNumber)

	IF EXISTS (SELECT TOP 1 * FROM dbo.IGC_WaitGuildMatching where ApplicantName = @ApplicantName)
    BEGIN
		BEGIN TRANSACTION
		BEGIN

				delete dbo.IGC_WaitGuildMatching where ApplicantName = @ApplicantName
				SELECT @aErrNo = @@ERROR,  @aRowCnt = @@ROWCOUNT
				IF  @aErrNo <> 0 OR @aRowCnt = 0
				BEGIN
					ROLLBACK TRAN
					RETURN
				END		

				insert into dbo.IGC_WaitGuildMatching (GuildName, GuildMasterName, GuildNumber, ApplicantName, ApplicantClass,
				ApplicantLevel,State,RegDate) values(@GuildName, @GuildMasterName,@GuildNumber,@ApplicantName,@ApplicantClass,
				@ApplicantLevel,@State,GetDate())
				SELECT @aErrNo = @@ERROR,  @aRowCnt = @@ROWCOUNT
				IF  @aErrNo <> 0 OR @aRowCnt = 0
				BEGIN
					ROLLBACK TRAN
					RETURN
				END		

		END
		COMMIT TRANSACTION

    END
    ELSE
    BEGIN
            insert into dbo.IGC_WaitGuildMatching (GuildName, GuildMasterName, GuildNumber, ApplicantName, ApplicantClass,
            ApplicantLevel,State,RegDate) values(@GuildName, @GuildMasterName,@GuildNumber,@ApplicantName,@ApplicantClass,
			@ApplicantLevel,@State,GetDate())

    END
       
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_InsertPartyMatchingList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_InsertPartyMatchingList]
   @PartyLeaderName varchar(10),
   @Title varchar(40),
   @PassWord varchar(4),
   @MinLevel	smallint,
   @MaxLevel smallint,
   @HuntingGround smallint,
   @WantedClass tinyint,
   @CurMemberCount tinyint,
   @UsePassWord tinyint,
   @AcceptType tinyint,
   @WantedClassDetailInfo1 tinyint,
   @WantedClassDetailInfo2 tinyint,
   @WantedClassDetailInfo3 tinyint,
   @WantedClassDetailInfo4 tinyint,
   @WantedClassDetailInfo5 tinyint,
   @WantedClassDetailInfo6 tinyint,
   @WantedClassDetailInfo7 tinyint,
   @LeaderChannel tinyint,
   @GensType tinyint,
   @LeaderLevel smallint,
   @LeaderClass tinyint
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @aErrNo INT, 
			@aRowCnt INT

	SELECT @aErrNo = 0, @aRowCnt = 0


	IF EXISTS (SELECT TOP 1 * FROM dbo.IGC_PartyMatching where PartyLeaderName = @PartyLeaderName)
    BEGIN

		BEGIN TRANSACTION
		BEGIN

			delete IGC_PartyMatching where PartyLeaderName= @PartyLeaderName
			SELECT @aErrNo = @@ERROR,  @aRowCnt = @@ROWCOUNT
			IF  @aErrNo <> 0 OR @aRowCnt = 0
			BEGIN
				ROLLBACK TRAN
				RETURN
			END		

			insert into dbo.IGC_PartyMatching(PartyLeaderName,Title,MinLevel,MaxLevel,HuntingGround,WantedClass,CurMemberCount,PassWord,UsePassWord,AcceptType,WantedClassDetailInfo1,
			WantedClassDetailInfo2,WantedClassDetailInfo3,WantedClassDetailInfo4,WantedClassDetailInfo5,WantedClassDetailInfo6,WantedClassDetailInfo7
			,LeaderChannel,GensType,  LeaderLevel ,LeaderClass,RegDate)
			values(@PartyLeaderName,@Title,@MinLevel,@MaxLevel,@HuntingGround,@WantedClass,@CurMemberCount,@PassWord,@UsePassWord,@AcceptType,@WantedClassDetailInfo1
			,@WantedClassDetailInfo2,@WantedClassDetailInfo3,@WantedClassDetailInfo4,@WantedClassDetailInfo5,@WantedClassDetailInfo6,@WantedClassDetailInfo7
				,@LeaderChannel,@GensType, @LeaderLevel ,   @LeaderClass,GetDate())
			SELECT @aErrNo = @@ERROR,  @aRowCnt = @@ROWCOUNT
			IF  @aErrNo <> 0 OR @aRowCnt = 0
			BEGIN
				ROLLBACK TRAN
				RETURN
			END		

		END
		COMMIT TRANSACTION

		select 1 as result

    END
    ELSE
    BEGIN

	insert into dbo.IGC_PartyMatching(PartyLeaderName,Title,MinLevel,MaxLevel,HuntingGround,WantedClass,CurMemberCount,PassWord,UsePassWord,AcceptType,WantedClassDetailInfo1,
	WantedClassDetailInfo2,WantedClassDetailInfo3,WantedClassDetailInfo4,WantedClassDetailInfo5,WantedClassDetailInfo6,WantedClassDetailInfo7
	,LeaderChannel,GensType,  LeaderLevel ,LeaderClass,RegDate)

	values(@PartyLeaderName,@Title,@MinLevel,@MaxLevel,@HuntingGround,@WantedClass,@CurMemberCount,@PassWord,@UsePassWord,@AcceptType,@WantedClassDetailInfo1
	,@WantedClassDetailInfo2,@WantedClassDetailInfo3,@WantedClassDetailInfo4,@WantedClassDetailInfo5,@WantedClassDetailInfo6,@WantedClassDetailInfo7
		,@LeaderChannel,@GensType,   @LeaderLevel , @LeaderClass,GetDate())
	select 0 as result

    END
       
   
END



GO
/****** Object:  StoredProcedure [dbo].[IGC_InsertWaitPartyMatching]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[IGC_InsertWaitPartyMatching]
   @PartyLeaderName varchar(10),
   @MemberName varchar(10),
   @Class tinyint,
   @MemberLevel smallint,
   @MemberDBNumber int
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF EXISTS (SELECT TOP 1 * FROM IGC_WaitPartyMatching where MemberName = @MemberName)
    BEGIN
            select -1 as result

    END
    ELSE
    BEGIN
	insert into dbo.IGC_WaitPartyMatching(LeaderName,MemberName,Class,MemberLevel,MemberDBNumber,RegDate)
	values(@PartyLeaderName,@MemberName,@Class,@MemberLevel,@MemberDBNumber,GetDate())
        select 0 as result
    END
       
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_IsApplicantListGuildMatching]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_IsApplicantListGuildMatching]
   @GuildNumber	int
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF EXISTS (SELECT TOP 1 * FROM IGC_WaitGuildMatching where GuildNumber = @GuildNumber and State = 0)
    BEGIN
        select 1 as result

    END
    ELSE
    BEGIN
        select 0 as result
    END
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_Labyrinth_End_Update]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Labyrinth_End_Update]
	@AccountID		VARCHAR(10)
	,@Name			VARCHAR(10)
	,@ClearCnt		INT
	,@ClearState	TINYINT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

UPDATE dbo.IGC_LabyrinthInfo
SET ClearCnt = @ClearCnt
	,ClearState = @ClearState
	,EndTime = GETDATE()
WHERE AccountID = @AccountID AND Name = @Name



GO
/****** Object:  StoredProcedure [dbo].[IGC_Labyrinth_Info_Load]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Labyrinth_Info_Load]
	@AccountID	VARCHAR(10)
	,@Name		VARCHAR(10)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
SELECT DimensionLevel, ConfigNum, CurrentZone, VisitedCnt, EntireExp, EntireMonKillCnt, ClearCnt, ClearState
FROM dbo.IGC_LabyrinthInfo
WHERE AccountID = @AccountID AND Name = @Name





GO
/****** Object:  StoredProcedure [dbo].[IGC_Labyrinth_Info_Save]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Labyrinth_Info_Save]
	@AccountID	VARCHAR(10)
	,@Name	VARCHAR(10)
	,@DimensionLevel	TINYINT
	,@ConfigNum		SMALLINT
	,@CurrentZone	TINYINT
	,@VisitedCnt	TINYINT
	,@VisitedList	BINARY(200)
	,@EntireExp	BIGINT
	,@EntireMonKillCnt BIGINT
	,@ClearCnt	INT
	,@ClearState	TINYINT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
UPDATE IGC_LabyrinthInfo 
SET DimensionLevel = @DimensionLevel
	,ConfigNum = @ConfigNum
	,CurrentZone = @CurrentZone
	,VisitedCnt = @VisitedCnt
	,VisitedList = @VisitedList
	,EntireExp = @EntireExp
	,EntireMonKillCnt = @EntireMonKillCnt
	,ClearCnt = @ClearCnt
	,ClearState = @ClearState
WHERE AccountID = @AccountID AND Name = @Name
	
IF @@ROWCOUNT = 0
BEGIN
	INSERT INTO IGC_LabyrinthInfo (AccountID, Name, DimensionLevel, ConfigNum
		, CurrentZone, VisitedCnt, VisitedList, EntireExp, EntireMonKillCnt, ClearCnt, ClearState)
	VALUES (@AccountID, @Name, @DimensionLevel, @ConfigNum
		, @CurrentZone, @VisitedCnt, @VisitedList, @EntireExp, @EntireMonKillCnt, @ClearCnt, @ClearState)
END



GO
/****** Object:  StoredProcedure [dbo].[IGC_Labyrinth_Info_Update]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Labyrinth_Info_Update]
	@AccountID			VARCHAR(10)
	,@Name				VARCHAR(10)
	,@DimensionLevel	TINYINT
	,@ConfigNum			TINYINT
	,@CurrentZone		TINYINT
	,@VisitedCnt		TINYINT
	,@VisitedList		BINARY(200)
	,@EntireExp			BIGINT
	,@EntireMonKillCnt 	BIGINT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
UPDATE dbo.IGC_LabyrinthInfo
SET DimensionLevel = @DimensionLevel,
	ConfigNum = @ConfigNum,
	CurrentZone = @CurrentZone,
	VisitedCnt = @VisitedCnt,
	VisitedList = @VisitedList,
	EntireExp = @EntireExp,
	EntireMonKillCnt = @EntireMonKillCnt
WHERE AccountID = @AccountID AND Name = @Name





GO
/****** Object:  StoredProcedure [dbo].[IGC_Labyrinth_Mission_Delete]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Labyrinth_Mission_Delete]
	@AccountID	VARCHAR(10)
	,@Name	VARCHAR(10)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
DELETE FROM dbo.IGC_LabyrinthMissionInfo
WHERE AccountID = @AccountID AND Name = @Name




GO
/****** Object:  StoredProcedure [dbo].[IGC_Labyrinth_Mission_Insert]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Labyrinth_Mission_Insert] 
	@AccountID		VARCHAR(10)
	, @Name			VARCHAR(10)
	, @ZoneNumber		TINYINT
	, @MissionType		TINYINT
	, @MissionValue		INT
	, @IsMainMission	TINYINT
	, @MainMissionOrder	TINYINT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
INSERT INTO dbo.IGC_LabyrinthMissionInfo 
	(AccountID, Name, ZoneNumber, MissionType
	, MissionValue, IsMainMission, MainMissionOrder)
VALUES (@AccountID, @Name, @ZoneNumber, @MissionType
	, @MissionValue, @IsMainMission, @MainMissionOrder)





GO
/****** Object:  StoredProcedure [dbo].[IGC_Labyrinth_Mission_Load]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Labyrinth_Mission_Load]
	@AccountID	VARCHAR(10)
	,@Name	VARCHAR(10)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
SELECT ZoneNumber, MissionType, MissionValue, AcquisitionValue
	,MissionState, IsMainMission, MainMissionOrder, RewardItemType
	, RewardItemIndex, RewardValue, RewardCheckState
FROM dbo.IGC_LabyrinthMissionInfo
WHERE AccountID = @AccountID AND Name = @Name




GO
/****** Object:  StoredProcedure [dbo].[IGC_Labyrinth_Mission_Update]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Labyrinth_Mission_Update]
	@AccountID			VARCHAR(10)
	,@Name				VARCHAR(10)
	,@ZoneNumber		TINYINT
	,@MissionType		TINYINT
	,@AcquisitionValue	INT
	,@MissionState		TINYINT
	,@IsMainMission		TINYINT
	,@MainMissionOrder	TINYINT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
UPDATE dbo.IGC_LabyrinthMissionInfo
SET AcquisitionValue = @AcquisitionValue, MissionState = @MissionState
WHERE AccountID = @AccountID 
	AND Name = @Name 
	AND ZoneNumber = @ZoneNumber 
	AND IsMainMission = @IsMainMission 
	AND MainMissionOrder = @MainMissionOrder





GO
/****** Object:  StoredProcedure [dbo].[IGC_Labyrinth_Path_Load]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Labyrinth_Path_Load]
	@AccountID	VARCHAR(10)
	,@Name		VARCHAR(10)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
SELECT VisitedList 
FROM dbo.IGC_LabyrinthInfo 
WHERE AccountID = @AccountID 
	AND Name = @Name




GO
/****** Object:  StoredProcedure [dbo].[IGC_Labyrinth_Reward_Complete_Update]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Labyrinth_Reward_Complete_Update]
	@AccountID			VARCHAR(10)
	,@Name				VARCHAR(10)
	,@IsMainMission		TINYINT
	,@RewardCheckState	TINYINT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
UPDATE IGC_LabyrinthMissionInfo
SET RewardCheckState = @RewardCheckState
WHERE AccountID = @AccountID 
	AND Name = @Name 
	AND IsMainMission = @IsMainMission 

RETURN




GO
/****** Object:  StoredProcedure [dbo].[IGC_Labyrinth_Reward_Update]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Labyrinth_Reward_Update]
	@AccountID			VARCHAR(10)
	,@Name				VARCHAR(10)
	,@ZoneNumber		TINYINT
	,@IsMainMission		TINYINT
	,@MainMissionOrder	TINYINT
	,@RewardItemType	SMALLINT
	,@RewardItemIndex	SMALLINT
	,@RewardValue		INT
	,@RewardCheckState	TINYINT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
UPDATE dbo.IGC_LabyrinthMissionInfo
SET RewardItemType = @RewardItemType
	,RewardItemIndex = @RewardItemIndex
	,RewardValue = @RewardValue
	,RewardCheckState = @RewardCheckState
WHERE AccountID = @AccountID 
	AND Name = @Name 
	AND ZoneNumber = @ZoneNumber 
	AND IsMainMission = @IsMainMission 
	AND MainMissionOrder = @MainMissionOrder




GO
/****** Object:  StoredProcedure [dbo].[IGC_LabyrinthClearLogSetSave]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_LabyrinthClearLogSetSave]
	@AccountID			VARCHAR(10)    
	,@Name				VARCHAR(10)    
	,@DimensionLevel	INT
AS      
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
INSERT INTO dbo.[IGC_LabyrinthClearLog] ( mDate, AccountID, Name, mDimensionLevel)
VALUES (GETDATE(), @AccountID, @Name, @DimensionLevel)




GO
/****** Object:  StoredProcedure [dbo].[IGC_LuckyItemDelete]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC  [dbo].[IGC_LuckyItemDelete]
	@CharacterName varchar(10)
	,@ItemCode	int
	,@ItemSerial	bigint
	AS  
	DELETE	T_LUCKY_ITEM_INFO 
	WHERE	CharName = @CharacterName AND ItemCode = @ItemCode AND ItemSerial = @ItemSerial






























GO
/****** Object:  StoredProcedure [dbo].[IGC_LuckyItemInsert]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC  [dbo].[IGC_LuckyItemInsert]  
	@UserGuid 			int
	,@CharName			varchar(10)
	,@ItemCode			int
	,@ItemSerial		bigint
	,@DurabilitySmall	smallint
	AS         
	DECLARE @ErrorCode int        
	SET	@ErrorCode = 0        
	
	SET NOCOUNT ON    
	SET	XACT_ABORT ON
	        
	BEGIN TRAN
	
	IF NOT EXISTS (SELECT ItemCode FROM T_LUCKY_ITEM_INFO  WITH ( READUNCOMMITTED )         
	WHERE CharName = @CharName AND ItemCode = @ItemCode AND ItemSerial  = @ItemSerial)
	BEGIN            
		INSERT INTO T_LUCKY_ITEM_INFO (UserGuid, CharName, ItemCode, ItemSerial, DurabilitySmall) 
		VALUES  (@UserGuid, @CharName, @ItemCode, @ItemSerial, @DurabilitySmall)    
	END       
	
	ELSE        
	BEGIN    
		UPDATE T_LUCKY_ITEM_INFO 
		SET	DurabilitySmall = @DurabilitySmall
		WHERE CharName = @CharName AND ItemCode = @ItemCode AND ItemSerial  = @ItemSerial
	END        
	
	IF( @@Error <> 0 )        
	BEGIN        
	SET @ErrorCode = 2        
	END        
	
	IF ( @ErrorCode  <> 0 ) 
	ROLLBACK TRAN       
	ELSE        
	COMMIT TRAN
	
	SELECT @ErrorCode        
	
	SET	XACT_ABORT OFF        
	SET NOCOUNT OFF









GO
/****** Object:  StoredProcedure [dbo].[IGC_LuckyItemSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[IGC_LuckyItemSelect]
	@CharacterName varchar(10)  
	AS  
	SELECT	ItemCode, ItemSerial, DurabilitySmall 
	FROM	T_LUCKY_ITEM_INFO 
	WHERE	CharName = @CharacterName






























GO
/****** Object:  StoredProcedure [dbo].[IGC_MineSystem_Delete_UPTUserInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_MineSystem_Delete_UPTUserInfo]
	@CharacterName	varchar(10)	
AS
    SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DELETE dbo.T_MineSystem WHERE CharacterName = @CharacterName

































GO
/****** Object:  StoredProcedure [dbo].[IGC_MineSystem_Insert_UPTUserInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_MineSystem_Insert_UPTUserInfo]
	@CharacterName	varchar(10),
	@QuestionType	int,
	@CurrentType	int
AS
    SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	INSERT dbo.T_MineSystem ( CharacterName, TwinkleType, CurrentStage )
	VALUES(@CharacterName, @QuestionType, @CurrentType)

































GO
/****** Object:  StoredProcedure [dbo].[IGC_MineSystem_Select_UPTUserInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
CREATE PROCEDURE [dbo].[IGC_MineSystem_Select_UPTUserInfo]
	@CharacterName	varchar(10)	
AS
    SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT CharacterName, TwinkleType, CurrentStage FROM dbo.T_MineSystem WHERE CharacterName = @CharacterName
































GO
/****** Object:  StoredProcedure [dbo].[IGC_Monster_KillCount_Save]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_Monster_KillCount_Save]
	@szCharName VARCHAR(10), --Name of character who kill the monster
	@iMonsterID INT --Monster ID that was killed
AS
	BEGIN
		SET NOCOUNT ON

		IF EXISTS (SELECT 0 FROM dbo.C_Monster_KillCount WHERE Name = @szCharName AND MonsterID = @iMonsterID)
			BEGIN
				UPDATE dbo.C_Monster_KillCount SET Count = Count +1 WHERE Name = @szCharName AND MonsterID = @iMonsterID
			END
		ELSE
			BEGIN
				INSERT INTO dbo.C_Monster_KillCount (Name, MonsterID, Count) VALUES (@szCharName, @iMonsterID, 1)
			END


		IF (@@ERROR <> 0)
			SELECT 0 as ResultCode --No error, return success.
		ELSE
			SELECT 1 as ResultCode --We got an error error, return fail.
	END
































GO
/****** Object:  StoredProcedure [dbo].[IGC_MuunConditionInfoDel]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_MuunConditionInfoDel]
	@Name	VARCHAR(10)
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DELETE FROM dbo.IGC_Muun_ConditionInfo 
WHERE Name = @Name




GO
/****** Object:  StoredProcedure [dbo].[IGC_MuunConditionInfoGetLoad]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_MuunConditionInfoGetLoad]
	@Name	VARCHAR(10)
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SlotIndex, ConditionType, Value 
FROM dbo.IGC_Muun_ConditionInfo 
WHERE Name = @Name




GO
/****** Object:  StoredProcedure [dbo].[IGC_MuunConditionInfoSetSave]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_MuunConditionInfoSetSave]
	@Name			VARCHAR(10)
	,@SlotIndex		TINYINT
	,@ConditionType	TINYINT
	,@Value			INT 
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

UPDATE dbo.IGC_Muun_ConditionInfo 
SET Value = @Value
	,ConditionType = @ConditionType
WHERE Name = @Name 
	AND SlotIndex = @SlotIndex

IF @@ROWCOUNT = 0
BEGIN		
	INSERT INTO IGC_Muun_ConditionInfo ( Name, ConditionType, Value, SlotIndex )
	VALUES (@Name, @ConditionType, @Value, @SlotIndex)
END




GO
/****** Object:  StoredProcedure [dbo].[IGC_MuunPeriodInsert]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_MuunPeriodInsert]
	@Name				VARCHAR(10)
	,@ItemType			INT 
	,@Serial			BIGINT
	,@ItemDuration		BIGINT
	,@ExpireDateConvert	BIGINT
AS
SET NOCOUNT ON

DECLARE @ErrorCode int
SELECT @ErrorCode = 0

DECLARE @CalcExpireDate SMALLDATETIME

SELECT @CalcExpireDate = DATEADD( SECOND, @ItemDuration, GETDATE() )

INSERT INTO dbo.IGC_Muun_Period
	( Name, ItemType, Serial, GetItemDate, ExpireDate, ExpireDateConvert )
VALUES
	( @Name, @ItemType, @Serial, GETDATE(), @CalcExpireDate, @ExpireDateConvert )

IF ( @@ERROR <> 0 ) 
BEGIN
	SET @ErrorCode = 1
END

SELECT @ErrorCode




GO
/****** Object:  StoredProcedure [dbo].[IGC_MuunPeriodSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_MuunPeriodSelect]
	@Name	VARCHAR(10)
AS 
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @ErrorCode INT
SET @ErrorCode = 0

BEGIN
	UPDATE dbo.IGC_Muun_Period 
	SET UsedInfo = 1 
	WHERE Name = @Name
			AND UsedInfo = 0 
			AND ExpireDate < GETDATE()
	SELECT 
		Name, ItemType, Serial, ExpireDateConvert
	FROM dbo.IGC_Muun_Period 
	WHERE Name = @Name 
		AND UsedInfo = 0
END

IF( @@ERROR <> 0 )
BEGIN
	SET @ErrorCode = 1
END




GO
/****** Object:  StoredProcedure [dbo].[IGC_MuunPeriodUpdate]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_MuunPeriodUpdate]
	@Name			VARCHAR(10)
	,@ItemType		INT
	,@ItemSerial	BIGINT
	,@UsedInfo		TINYINT
AS 
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @ErrorCode INT
SET @ErrorCode = 0

BEGIN	
	UPDATE dbo.IGC_Muun_Period 
	SET UsedInfo = @UsedInfo 
	WHERE Name = @Name
		AND ItemType = @ItemType 
		AND Serial = @ItemSerial 

	IF ( @@ROWCOUNT = 0 )
	BEGIN
		SET @ErrorCode = 1
	END
END

SELECT @ErrorCode




GO
/****** Object:  StoredProcedure [dbo].[IGC_PeriodBuffDelete]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Dudas [IGCN Team]>
-- Create date: <28.02.2014>
-- Description:	<PeriodBuffSystem delete procedure>
-- =============================================
CREATE PROCEDURE [dbo].[IGC_PeriodBuffDelete]
	-- Add the parameters for the stored procedure here
	@CharacterName varchar(10),
	@BuffIndex int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM IGC_PeriodBuffInfo WHERE [CharacterName] = @CharacterName AND [BuffIndex] = @BuffIndex

	SELECT 0 AS QueryResult

END



































GO
/****** Object:  StoredProcedure [dbo].[IGC_PeriodBuffDeleteGuild]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Dudas [IGCN Team]>
-- Create date: <28.02.2014>
-- Description:	<PeriodBuffSystem delete procedure for guilds>
-- =============================================
CREATE PROCEDURE [dbo].[IGC_PeriodBuffDeleteGuild]
	-- Add the parameters for the stored procedure here
	@BuffIndex int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM IGC_PeriodBuffInfo WHERE [BuffIndex] = @BuffIndex

	SELECT 0 AS QueryResult

END



































GO
/****** Object:  StoredProcedure [dbo].[IGC_PeriodBuffInsert]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:  <Dudas>
-- Create date: <28.02.2014>
-- Description: <PeriodBuffSystem insert procedure>
-- =============================================
CREATE PROCEDURE [dbo].[IGC_PeriodBuffInsert]
 -- Add the parameters for the stored procedure here
 @CharacterName varchar(10),
 @BuffIndex smallint,
 @EffectType1 smallint,
 @EffectType2 smallint,
 @Duration int,
 @ExpireDate bigint
 
AS
BEGIN
 SET NOCOUNT ON;

    INSERT INTO [dbo].[IGC_PeriodBuffInfo]
           ([CharacterName], [BuffIndex], [EffectType1], [EffectType2], [Duration], [ExpireDate])
     VALUES (@CharacterName, @BuffIndex, @EffectType1, @EffectType2, @Duration, @ExpireDate)

	 SELECT 0 AS QueryResult
END



































GO
/****** Object:  StoredProcedure [dbo].[IGC_PeriodBuffSelect]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Dudas [IGCN Team]>
-- Create date: <28.02.2014>
-- Description:	<PeriodBuffSystem select procedure>
-- =============================================
CREATE PROCEDURE [dbo].[IGC_PeriodBuffSelect]
	-- Add the parameters for the stored procedure here
	@CharacterName varchar(10)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT * FROM IGC_PeriodBuffInfo WHERE [CharacterName] = @CharacterName


END



































GO
/****** Object:  StoredProcedure [dbo].[IGC_PeriodItemDeleteEx]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[IGC_PeriodItemDeleteEx]
	@UserGuid	int,
	@CharacterName	varchar(10),
	@ItemCode	int,
	@ItemType	tinyint,
	@ItemSerial	bigint
AS BEGIN
	DECLARE @ErrorCode int
	DECLARE @ItemInfoCount int

	SET @ErrorCode = 0
	SET @ItemInfoCount = 0

	SET nocount on

	IF ( @ItemType = 1 ) BEGIN
		SELECT @ItemInfoCount = COUNT(*) FROM IGC_PeriodItemInfo WHERE UserGuid = @UserGuid AND ItemCode = @ItemCode
		IF ( @ItemInfoCount < 1 ) BEGIN
			SET @ErrorCode = 1
		END
		ELSE BEGIN
			UPDATE IGC_PeriodItemInfo SET UsedInfo = 0 WHERE UserGuid = @UserGuid AND CharacterName = @CharacterName AND ItemCode = @ItemCode
		END
	END
	ELSE IF ( @ItemType = 2 ) BEGIN
		SELECT @ItemInfoCount = COUNT(*) FROM IGC_PeriodItemInfo WHERE UserGuid = @UserGuid AND CharacterName = @CharacterName AND ItemCode = @ItemCode AND SerialCode = @ItemSerial
		IF ( @ItemInfoCount < 1 ) BEGIN
			SET @ErrorCode = 1
		END
		ELSE BEGIN
			UPDATE IGC_PeriodItemInfo SET UsedInfo = 0 WHERE UserGuid = @UserGuid AND ItemCode = @ItemCode AND SerialCode = @ItemSerial
		END
	END

	SELECT @ErrorCode

	SET nocount off
END




GO
/****** Object:  StoredProcedure [dbo].[IGC_PeriodItemExpiredItemSelectEx]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_PeriodItemExpiredItemSelectEx]
	@UserGuid	int,
	@CharacterName	varchar(10)
as 
BEGIN
	DECLARE @ErrorCode int

	SET @ErrorCode = 0

	SET NOCOUNT ON

	UPDATE IGC_PeriodItemInfo SET SetExpire = 2 WHERE UserGuid = @UserGuid AND CharacterName = @CharacterName AND ItemType = 2 AND [ExpireDate] < GETDATE() AND SetExpire = 1

	UPDATE IGC_PeriodItemInfo SET SetExpire = 1 WHERE UserGuid = @UserGuid AND CharacterName = @CharacterName AND ItemType = 2 AND [ExpireDate] < GETDATE() AND SetExpire = 0

	SELECT * FROM IGC_PeriodItemInfo WHERE UserGuid = @UserGuid AND CharacterName = @CharacterName AND ItemType = 2 AND SetExpire = 1
	IF ( @@Error <> 0 ) BEGIN
		SET @ErrorCode = -1
	END

	SET NOCOUNT OFF
END




GO
/****** Object:  StoredProcedure [dbo].[IGC_PeriodItemInsertEx]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_PeriodItemInsertEx]
	@UserGuid	int,
	@CharacterName	varchar(10),
	@ItemType	tinyint,
	@ItemCode	int,
	@OptionType	tinyint,
	@EffectType1	tinyint,
	@EffectType2	tinyint,
	@ItemSerial	bigint,
	@Duration	int,
	@BuyDate	bigint,
	@ExpireDate	bigint
AS
BEGIN
	DECLARE @ErrorCode int
	DECLARE @PeriodItemIndex int

	SET @ErrorCode = 0
	SET @PeriodItemIndex = 0

	SET XACT_ABORT ON
	Set nocount on 		
	begin transaction

	DECLARE @CalcExpireDate smalldatetime
	SELECT @CalcExpireDate = DATEADD( second, @Duration, GETDATE() )

	IF ( @ItemType = 1 ) BEGIN
		SELECT @PeriodItemIndex = PeriodIndex FROM IGC_PeriodItemInfo WHERE UserGuid = @UserGuid AND CharacterName = @CharacterName AND UsedInfo = 1 AND OptionType = @OptionType
		IF( @PeriodItemIndex <> 0 ) BEGIN
			UPDATE IGC_PeriodItemInfo SET UsedInfo = 0 WHERE PeriodIndex = @PeriodItemIndex
		END

		INSERT INTO IGC_PeriodItemInfo ( UserGuid, CharacterName, ItemCode, ItemType, EffectType1, EffectType2, UsedTime, LeftTime, BuyDate, ExpireDate, UsedInfo, OptionType, SerialCode, BuyDateConvert, ExpireDateConvert )
		VALUES
		( @UserGuid, @CharacterName, @ItemCode, @ItemType, @EffectType1, @EffectType2, 0, @Duration, GETDATE(), @CalcExpireDate, 1, @OptionType, 0, @BuyDate, @ExpireDate )
		iF ( @@Error <> 0 ) BEGIN
			SET @ErrorCode = 2
		END
	END
	ELSE IF ( @ItemType = 2 ) BEGIN
		INSERT INTO IGC_PeriodItemInfo ( UserGuid, CharacterName, ItemCode, ItemType, EffectType1, EffectType2, UsedTime, LeftTime, BuyDate, ExpireDate, UsedInfo, OptionType, SerialCode, BuyDateConvert, ExpireDateConvert )
		VALUES
		( @UserGuid, @CharacterName, @ItemCode, @ItemType, 0, 0, 0, @Duration, GETDATE(), @CalcExpireDate, 1, 0, @ItemSerial, @BuyDate, @ExpireDate )
		iF ( @@Error <> 0 ) BEGIN
			SET @ErrorCode = 2
		END
	END

	IF ( @ErrorCode <> 0 )
		rollback transaction
	ELSE
		commit transaction

	SELECT @ErrorCode

	Set 	nocount off 
	SET XACT_ABORT OFF
END


GO
/****** Object:  StoredProcedure [dbo].[IGC_PeriodItemSelectEx]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[IGC_PeriodItemSelectEx]
	@UserGuid	int,
	@CharacterName	varchar(10)
as 
BEGIN
	DECLARE @ErrorCode int

	SET @ErrorCode = 0

	SET NOCOUNT ON

	UPDATE IGC_PeriodItemInfo SET UsedInfo = 0 WHERE UserGuid = @UserGuid AND CharacterName = @CharacterName AND UsedInfo = 1 AND ExpireDate < GetDate()

	SELECT * FROM IGC_PeriodItemInfo WHERE UserGuid = @UserGuid AND CharacterName = @CharacterName AND UsedInfo = 1
	IF ( @@Error <> 0 ) BEGIN
		SET @ErrorCode = -1
	END

	SET NOCOUNT OFF
END


GO
/****** Object:  StoredProcedure [dbo].[IGC_PShopItemMove]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_PShopItemMove] (
	@AccountID	VARCHAR(10)
,	@Name		VARCHAR(10)

,	@OldInvenNum		int
,	@NewInvenNum		int
)
AS  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF EXISTS ( SELECT * FROM T_PSHOP_ITEMVALUE_INFO WHERE AccountID = @AccountID AND Name = @Name AND ItemInvenNum = @NewInvenNum )
	BEGIN
		DELETE FROM T_PSHOP_ITEMVALUE_INFO WHERE AccountID = @AccountID AND Name = @Name AND ItemInvenNum = @NewInvenNum
	END

	UPDATE dbo.T_PSHOP_ITEMVALUE_INFO
	SET 
			ItemInvenNum = @NewInvenNum
	WHERE AccountID = @AccountID AND Name = @Name AND ItemInvenNum = @OldInvenNum
































GO
/****** Object:  StoredProcedure [dbo].[IGC_PShopItemValueInfoDel]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_PShopItemValueInfoDel] (
	@AccountID	VARCHAR(10)
,	@Name		VARCHAR(10)

,	@ItemInvenNum		int
)
AS  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DELETE FROM dbo.T_PSHOP_ITEMVALUE_INFO WHERE AccountID = @AccountID AND Name = @Name AND ItemInvenNum = @ItemInvenNum
































GO
/****** Object:  StoredProcedure [dbo].[IGC_PShopItemValueInfoLoad]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_PShopItemValueInfoLoad] (
	@AccountID varchar(10)
,	@Name		VARCHAR(10)
)
AS  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT 
		ItemInvenNum, ItemSerial, Money, BlessJewelValue, SoulJewelValue, ChaosJewelValue
	FROM dbo.T_PSHOP_ITEMVALUE_INFO WHERE AccountID = @AccountID AND Name = @Name
































GO
/****** Object:  StoredProcedure [dbo].[IGC_PShopItemValueInfoSave]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_PShopItemValueInfoSave] (
	@AccountID	VARCHAR(10)
,	@Name		VARCHAR(10)

,	@ItemInvenNum		int
,	@ItemSerial			bigint
,	@Money				int
,	@BlessJewelValue	int
,	@SoulJewelValue		int
,	@ChaosJewelValue	int
)
AS  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	UPDATE dbo.T_PSHOP_ITEMVALUE_INFO
	SET 
			ItemInvenNum = @ItemInvenNum
		,	ItemSerial = @ItemSerial
		,	Money = @Money
		,	BlessJewelValue = @BlessJewelValue
		,	SoulJewelValue = @SoulJewelValue
		,	ChaosJewelValue = @ChaosJewelValue
	WHERE AccountID = @AccountID AND Name = @Name AND ItemInvenNum = @ItemInvenNum
	IF @@ROWCOUNT = 0 
	BEGIN
		INSERT INTO dbo.T_PSHOP_ITEMVALUE_INFO 
		( AccountID, Name, ItemInvenNum, ItemSerial, Money, BlessJewelValue, SoulJewelValue, ChaosJewelValue )
		VALUES ( @AccountID,@Name, @ItemInvenNum,@ItemSerial,@Money,@BlessJewelValue,@SoulJewelValue,@ChaosJewelValue );
	END
	
































GO
/****** Object:  StoredProcedure [dbo].[IGC_QuestExpUserInfoLoad]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE  proc [dbo].[IGC_QuestExpUserInfoLoad]
 @CharacterName varchar(10)
AS
SELECT EPISODE, QUEST_SWITCH, PROG_STATE, ASK_INDEX, ASK_VALUE, ASK_STATE 
FROM T_QUEST_EXP_INFO WHERE CHAR_NAME = @CharacterName
































GO
/****** Object:  StoredProcedure [dbo].[IGC_QuestExpUserInfoLoad_Fir]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[IGC_QuestExpUserInfoLoad_Fir]
@CharacterName VARCHAR(10)  
AS  
SELECT  CHAR_NAME, EPISODE, QUEST_SWITCH, PROG_STATE
,StartDateConvert,EndDateConvert  
FROM T_QUEST_EXP_INFO
WHERE CHAR_NAME = @CharacterName
































GO
/****** Object:  StoredProcedure [dbo].[IGC_QuestExpUserInfoLoad_Sec]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[IGC_QuestExpUserInfoLoad_Sec]
 @CharacterName varchar(10),
 @Episode	int,
 @Ask_Index	varbinary(5)		OUTPUT,
 @Ask_Value	varbinary(5)		OUTPUT,
 @Ask_State	varbinary(5)		OUTPUT
AS

SELECT @Ask_Index = ASK_INDEX, @Ask_Value = ASK_VALUE, @Ask_State = ASK_STATE  FROM T_QUEST_EXP_INFO  WHERE CHAR_NAME =  @CharacterName AND EPISODE = @Episode
































GO
/****** Object:  StoredProcedure [dbo].[IGC_QuestExpUserInfoSave]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROC [dbo].[IGC_QuestExpUserInfoSave]
@CharacterName	varchar(10)
,@Episode		smallint      
,@Quest_Switch	smallint     
,@ProgState		smallint
,@StartDate		bigint	--StartDateConvert
,@EndDate 		bigint	--EndDateConvert  
,@AskIndex		varbinary(5)  
,@AskValue		varbinary(5)  
,@AskState		varbinary(5)  
AS       
SET NOCOUNT ON

DECLARE	@ErrorCode	int      
SET	@ErrorCode = 0      
      
BEGIN TRANSACTION

IF NOT EXISTS ( SELECT EPISODE FROM T_QUEST_EXP_INFO  WITH ( READUNCOMMITTED )       
WHERE EPISODE = @Episode AND CHAR_NAME = @CharacterName )  
BEGIN        
INSERT T_QUEST_EXP_INFO 
(CHAR_NAME,EPISODE,QUEST_SWITCH,PROG_STATE
,StartDateConvert,EndDateConvert 
,ASK_INDEX,ASK_VALUE,ASK_STATE) 
SELECT	
@CharacterName,@Episode,@Quest_Switch,@ProgState
,@StartDate,@EndDate
,@AskIndex,@AskValue,@AskState  
END      

ELSE      
BEGIN 
UPDATE	T_QUEST_EXP_INFO 
SET	QUEST_SWITCH = @Quest_Switch,PROG_STATE = @ProgState
,StartDateConvert = @StartDate
,EndDateConvert = @EndDate
,ASK_INDEX = @AskIndex,ASK_VALUE = @AskValue,ASK_STATE = @AskState
WHERE	EPISODE = @Episode AND CHAR_NAME = @CharacterName  
END      

IF(@@Error <> 0)      
BEGIN      
SET @ErrorCode = 2      
END      

IF(@@Error <> 0)
ROLLBACK TRANSACTION
ELSE
COMMIT TRANSACTION
   
SELECT @ErrorCode      

SET NOCOUNT OFF
































GO
/****** Object:  StoredProcedure [dbo].[IGC_SetDeleteMuRummy]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_SetDeleteMuRummy] (
	@AccountID	VARCHAR(10)
,	@Name		VARCHAR(10)
)
AS  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DELETE FROM dbo.T_MuRummyInfo WHERE AccountID = @AccountID AND Name = @Name
	DELETE FROM dbo.T_MuRummy WHERE AccountID = @AccountID AND Name = @Name
































GO
/****** Object:  StoredProcedure [dbo].[IGC_SetGuildMatchingWaitState]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_SetGuildMatchingWaitState]
   @Name varchar(10),
   @State	  tinyint
as 
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    IF EXISTS ( select Name from dbo.Character where Name = @Name)
     BEGIN
	 update  dbo.IGC_WaitGuildMatching set State = @State where ApplicantName = @Name 
	 select  0 as result
     END
     ELSE
     BEGIN
	 delete  dbo.IGC_WaitGuildMatching  where ApplicantName = @Name 
	 select -1 as result
     END
    SET NOCOUNT OFF
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_SetInsertMuRummy]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_SetInsertMuRummy] (
	@AccountID	VARCHAR(10)
,	@Name		VARCHAR(10)
,	@Number		INT
,	@Color		INT
,	@Position	INT
,	@Status		INT
,	@Sequence	INT
)
AS  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	INSERT INTO dbo.T_MuRummy ( AccountID, Name, mNumber, mColor, mPosition, mStatus, mSequence)
	VALUES (@AccountID,@Name,@Number,@Color,@Position,@Status,@Sequence);


GO
/****** Object:  StoredProcedure [dbo].[IGC_SetSaveMuRummyInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_SetSaveMuRummyInfo] (
	@AccountID	VARCHAR(10)
,	@Name		VARCHAR(10)
,	@TotalScore	INT
,	@GameType	INT
,	@SPCDeckCnt	INT
)
AS  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	UPDATE dbo.T_MuRummyInfo SET mTotalScore = @TotalScore, mGameType = @GameType, mSPUseCnt = @SPCDeckCnt WHERE AccountID = @AccountID AND Name = @Name
	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO dbo.T_MuRummyInfo ( AccountID, Name, mTotalScore, mGameType, mSPUseCnt)
		VALUES (@AccountID,@Name,0,@GameType,@SPCDeckCnt);
	END


GO
/****** Object:  StoredProcedure [dbo].[IGC_SetSaveMuRummyLog]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_SetSaveMuRummyLog] (
	@AccountID	VARCHAR(10)
,	@Name		VARCHAR(10)
,	@Score	INT
)
AS  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	INSERT INTO dbo.T_MuRummyLog ( mDate, AccountID, Name, mScore)	VALUES (GETDATE(), @AccountID,@Name,@Score);


GO
/****** Object:  StoredProcedure [dbo].[IGC_SetSaveRestoreInventory]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_SetSaveRestoreInventory]
	@AccountID	VARCHAR(10)
	,@Name	VARCHAR(10)
	,@RestoreInven	VARBINARY(230)	
AS  
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

UPDATE dbo.IGC_RestoreItem_Inventory 
SET RestoreInven = @RestoreInven
WHERE AccountID = @AccountID 
	AND [Name] = @Name

IF @@ROWCOUNT = 0

BEGIN
	SET @RestoreInven =0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
		
	INSERT INTO dbo.IGC_RestoreItem_Inventory 
		( AccountID, [Name], RestoreInven)
	VALUES 
		( @AccountID, @Name, @RestoreInven)
END


GO
/****** Object:  StoredProcedure [dbo].[IGC_SetSelectMuRummy]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_SetSelectMuRummy] (
	@AccountID	VARCHAR(10)
,	@Name		VARCHAR(10)
)
AS  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT a.AccountID,a.Name,a.mTotalScore,a.mGameType,a.mSPUseCnt,b.mColor,b.mNumber,b.mPosition,b.mStatus,b.mSequence
	FROM dbo.T_MuRummyInfo a INNER JOIN dbo.T_MuRummy b ON a.Name = b.Name
	WHERE a.AccountID = @AccountID AND a.Name = @Name


GO
/****** Object:  StoredProcedure [dbo].[IGC_SetUpdateMuRummy]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[IGC_SetUpdateMuRummy] (
	@AccountID	VARCHAR(10)
,	@Name		VARCHAR(10)
,	@Position	INT
,	@Status		INT
,	@Sequence	INT
)
AS  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	UPDATE dbo.T_MuRummy SET mPosition = @Position, mStatus = @Status 
	WHERE AccountID = @AccountID AND Name = @Name AND mSequence = @Sequence


GO
/****** Object:  StoredProcedure [dbo].[IGC_UpdateGuildMatchingMemberCount]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE    PROCEDURE [dbo].[IGC_UpdateGuildMatchingMemberCount]
   @GuildName	 varchar(8),
   @MemberCount tinyint
as 
BEGIN

       SET NOCOUNT ON
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
       UPDATE IGC_GuildMatching SET GuildMemberCnt = @MemberCount where GuildName = @GuildName
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_UpdatePartyMatchingLeader]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE    PROCEDURE [dbo].[IGC_UpdatePartyMatchingLeader]
   @OldLeaderName    varchar(10),
   @NewLeaderName    varchar(10),
   @NewLeaderChannel    tinyint,
   @NewLeaderLevel      smallint,
   @NewLeaderClass      tinyint
as
BEGIN
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
     UPDATE dbo.IGC_PartyMatching SET PartyLeaderName = @NewLeaderName, LeaderChannel = @NewLeaderChannel,
        LeaderLevel = @NewLeaderLevel, LeaderClass = @NewLeaderClass WHERE PartyLeaderName = @OldLeaderName
 
    DELETE FROM IGC_WaitPartyMatching WHERE LeaderName = @OldLeaderName
END












GO
/****** Object:  StoredProcedure [dbo].[IGC_UpdatePartyMatchingList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IGC_UpdatePartyMatchingList]
   @OldLeaderName varchar(10)
   ,@NewLeaderName varchar(10)
   ,@LeaderChannel tinyint
   ,@LeaderLevel smallint
   ,@LeaderClass tinyint
AS 
SET NOCOUNT ON

UPDATE IGC_PartyMatching 
SET 
	PartyLeaderName = @NewLeaderName
	,UsePassWord = 0
	,PassWord = ''
	,LeaderChannel = @LeaderChannel
	,LeaderLevel = @LeaderLevel
	,LeaderClass = @LeaderClass
WHERE PartyLeaderName = @OldLeaderName


GO
/****** Object:  StoredProcedure [dbo].[IGC_UpdatePartyMatchingMemberCount]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[IGC_UpdatePartyMatchingMemberCount]
   @LeaderName	 varchar(10),
   @MemberCount tinyint
as 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

     UPDATE dbo.IGC_PartyMatching SET CurMemberCount = @MemberCount where PartyLeaderName = @LeaderName
   
END































GO
/****** Object:  StoredProcedure [dbo].[IGC_VipAdd]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



						  
								 
												
CREATE PROCEDURE [dbo].[IGC_VipAdd]
													
	@szCharName varchar(10),
	@DayAdd int,
	@VipType smallint
AS
BEGIN

									   
	SET NOCOUNT ON;
	BEGIN TRANSACTION;

	DECLARE @CurVipType smallint

	IF NOT EXISTS (SELECT * FROM T_VIPList WITH (READUNCOMMITTED) WHERE AccountID = @szCharName) -- no vip in DB
		INSERT INTO T_VIPList (AccountID, Date, Type) VALUES (@szCharName, DATEADD(dd, @DayAdd, GETDATE()), @VipType)
	ELSE IF EXISTS (SELECT * FROM T_VIPList WITH (READUNCOMMITTED) WHERE AccountID = @szCharName AND Date > GETDATE()) -- already ACTIVE vip
	BEGIN
		SELECT @CurVipType = Type FROM T_VIPList WITH (READUNCOMMITTED) WHERE AccountID = @szCharName

		IF (@CurVipType < @VipType) -- new vip has higher level
		BEGIN
			UPDATE T_VIPList SET [Date] = DATEADD(dd, @DayAdd, GETDATE()), Type = @VipType WHERE AccountID = @szCharName
		END
		ELSE IF (@CurVipType = @VipType) -- same vip level
		BEGIN
			UPDATE T_VIPList SET [Date] = DATEADD(dd, @DayAdd, [Date]) WHERE AccountID = @szCharName
		END
	END
	ELSE -- there is vip info, but expired
	BEGIN
		UPDATE T_VIPList SET [Date] = DATEADD(dd, @DayAdd, GETDATE()), Type = @VipType WHERE AccountID = @szCharName
	END
 
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE 
		COMMIT TRANSACTION
	SET NOCOUNT OFF 
END

















GO
/****** Object:  StoredProcedure [dbo].[VIPSystem_CheckAccount]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[VIPSystem_CheckAccount]
 -- Add the parameters for the stored procedure here
 @Account varchar(10)
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

    -- Insert statements for procedure here
 DECLARE @DateInfo smalldatetime
 DECLARE @VipType tinyint
 
 
 SELECT @DateInfo = Date, @VipType = Type FROM T_VIPList WHERE AccountID = @Account
 
 IF (DATEDIFF(MINUTE, GETDATE(), @DateInfo) > 0)
 BEGIN
  SELECT 1 AS Result, @DateInfo AS DateTime, @VipType AS Type
 END
 ELSE
 BEGIN
  SELECT 0 AS Result
 END
END


































GO
/****** Object:  StoredProcedure [dbo].[WZ_CharMoveReset]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CharMoveReset] 

	@AccountID		varchar(10),
	@Name			varchar(10)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON	
	
	DECLARE	@Result tinyint	
	DECLARE	@ResultLowCount int
	DECLARE	@Class tinyint
	DECLARE	@Ctl1_Code tinyint
	DECLARE	@SQLEXEC varchar(1000)
	DECLARE	@ErrorCheck INT
	DECLARE @g1 varchar(10)
	DECLARE @g2 varchar(10)
	DECLARE @g3 varchar(10)
	DECLARE @g4 varchar(10)
	DECLARE @g5 varchar(10)
	DECLARE @g6 varchar(10)
	DECLARE @g7 varchar(10)
	DECLARE @g8 varchar(10)
	DECLARE @MoveCnt tinyint		
	DECLARE @ChangeMoveCnt tinyint		
	DECLARE	@SqlStmt VARCHAR(700)		
	DECLARE	@SqlStmt2 VARCHAR(700)		

	SET LOCK_TIMEOUT	1000
	SET @Result = 0x00	
	SET @ErrorCheck = 0x00

	SELECT @Class = Class, @Ctl1_Code = CtlCode FROM Character WHERE Name = @Name
	
	SELECT @ResultLowCount = @@rowcount, @ErrorCheck = @@error
					
	IF @ResultLowCount = 0 
	BEGIN
		SET @Result	= 0x02			
		GOTO ON_ERROR						
	END

	IF @ErrorCheck  <> 0 GOTO ON_ERROR

	IF  ( (@Ctl1_Code & 127 ) > 0 )
	BEGIN
		SET @Result	= 0x03			
		GOTO ON_ERROR						
	END 

	SELECT  @g1=GameID1, @g2=GameID2, @g3=GameID3, @g4=GameID4, @g5=GameID5, @g6=GameID6, @g7=GameID7, @g8=GameID8, @MoveCnt = MoveCnt 
	FROM dbo.AccountCharacter WHERE Id = @AccountID 		
	
	SELECT @ResultLowCount = @@rowcount, @ErrorCheck = @@error

	IF @ResultLowCount = 0 
	BEGIN
		SET @Result	= 0x02			
		GOTO ON_ERROR						
	END

	IF @ErrorCheck  <> 0 GOTO ON_ERROR

	SET @MoveCnt =  0

	SET @SqlStmt = 'UPDATE AccountCharacter  '

	IF ( @g1 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  '
	ELSE IF ( @g2 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  '
	ELSE IF ( @g3 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  '
	ELSE IF ( @g4 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  '
	ELSE IF ( @g5 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  '
	ELSE IF ( @g6 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  '
	ELSE IF ( @g7 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  '
	ELSE IF ( @g8 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  '
	ELSE 				
		SET @Result	= 0x05

	IF ( @Result <> 0 )
		GOTO ON_ERROR

	SET @SqlStmt = @SqlStmt + ' MoveCnt =  ' + CONVERT(VARCHAR, @MoveCnt )					
	SET @SqlStmt = @SqlStmt + ' WHERE Id =  ''' + @AccountID	 + ''''				
	SET @SqlStmt2 = 'UPDATE Character '
	SET @SqlStmt2 = @SqlStmt2 + 'SET  '
	SET @SqlStmt2 = @SqlStmt2 + 'CtlCode = ' + CONVERT(VARCHAR, @Ctl1_Code & 127)
	SET @SqlStmt2 = @SqlStmt2 + ' WHERE Name = ''' +  @Name + ''''

	BEGIN TRANSACTION 

	EXEC(@SqlStmt)
	SELECT @ResultLowCount = @@rowcount,  @ErrorCheck = @@error
	IF  @ResultLowCount = 0  GOTO ON_TRN_ERROR
	IF  @ErrorCheck  <> 0 GOTO ON_TRN_ERROR

	EXEC(@SqlStmt2)
	SELECT @ResultLowCount = @@rowcount,  @ErrorCheck = @@error
	IF  @ResultLowCount = 0  GOTO ON_TRN_ERROR
	IF  @ErrorCheck  <> 0 GOTO ON_TRN_ERROR


ON_TRN_ERROR:
	IF ( @Result  <> 0 ) OR (@ErrorCheck <> 0)
	BEGIN
		IF @Result = 0 
			SET @Result = 0x09

		ROLLBACK TRAN
	END
	ELSE
		COMMIT TRAN

ON_ERROR:
	IF @ErrorCheck <> 0
	BEGIN
		SET @Result = 0x09
	END 

	SELECT @Result	

	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END






GO
/****** Object:  StoredProcedure [dbo].[WZ_CONNECT_MEMB]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CONNECT_MEMB]

	@memb___id 	varchar(10),
	@ServerName  	varchar(20),
	@IP 		varchar(15)	
AS
BEGIN

SET NOCOUNT ON
	DECLARE @find_id 		varchar(10)	
	DECLARE @ConnectStat	 tinyint
	SET @find_id = 'NOT'
	SET @ConnectStat = 1

	SELECT @find_id = S.memb___id FROM MEMB_STAT S INNER JOIN MEMB_INFO I ON S.memb___id = I.memb___id 
	      WHERE I.memb___id = @memb___id

	IF( @find_id = 'NOT' )
	BEGIN
		INSERT INTO MEMB_STAT (memb___id,ConnectStat,ServerName,IP,ConnectTM)
		values(@memb___id,  @ConnectStat, @ServerName, @IP, getdate())
	END
	ELSE	
		UPDATE MEMB_STAT SET ConnectStat = @ConnectStat,
					 ServerName = @ServerName,IP = @IP,
					 ConnectTM = getdate()
       	WHERE memb___id = @memb___id
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CreateCharacter]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE Procedure [dbo].[WZ_CreateCharacter] 

	@AccountID varchar(10),
	@Name varchar(10),
	@Class tinyint
AS
BEGIN

	SET NOCOUNT ON
	SET	XACT_ABORT ON
	DECLARE @Result tinyint
	SET @Result = 0x00

	IF EXISTS (SELECT Name FROM Character WHERE Name = @Name)
	BEGIN
		SET @Result	= 0x01
		GOTO ProcEnd						
	END

	BEGIN TRAN

	IF NOT EXISTS (SELECT Id FROM  AccountCharacter WHERE Id = @AccountID)
		BEGIN
			INSERT INTO dbo.AccountCharacter(Id, GameID1, GameID2, GameID3, GameID4, GameID5, GameID6, GameID7, GameID8, GameIDC) 
			VALUES(@AccountID, @Name, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)

			SET @Result = @@Error
		END
	ELSE
		BEGIN
			DECLARE @g1 varchar(10), @g2 varchar(10), @g3 varchar(10), @g4 varchar(10), @g5 varchar(10), @g6 varchar(10), @g7 varchar(10), @g8 varchar(10)
			SELECT @g1=GameID1, @g2=GameID2, @g3=GameID3, @g4=GameID4, @g5=GameID5, @g6=GameID6, @g7=GameID7, @g8=GameID8 FROM dbo.AccountCharacter WHERE Id = @AccountID 			

			IF((@g1 is NULL) OR (Len(@g1) = 0))
				BEGIN
					UPDATE AccountCharacter SET GameID1 = @Name
					WHERE Id = @AccountID
										
					SET @Result = @@Error
				END
			ELSE IF(@g2 is NULL OR Len(@g2) = 0)
				BEGIN
					UPDATE AccountCharacter SET GameID2 = @Name
					WHERE Id = @AccountID

					SET @Result = @@Error
				END
			ELSE IF(@g3 is NULL OR Len(@g3) = 0)
				BEGIN	
					UPDATE AccountCharacter SET GameID3 = @Name
					WHERE Id = @AccountID

					SET @Result = @@Error
				END
			ELSE IF(@g4 is NULL OR Len(@g4) = 0)
				BEGIN
					UPDATE AccountCharacter SET GameID4 = @Name
					WHERE Id = @AccountID

					SET @Result = @@Error
				END
			ELSE IF(@g5 is NULL OR Len(@g5) = 0)
				BEGIN
					UPDATE AccountCharacter SET GameID5 = @Name
					WHERE Id = @AccountID

					SET @Result = @@Error
				END
			ELSE IF(@g6 is NULL OR Len(@g6) = 0)
				BEGIN
					UPDATE AccountCharacter SET GameID6 = @Name
					WHERE Id = @AccountID

					SET @Result = @@Error
				END
			ELSE IF(@g7 is NULL OR Len(@g7) = 0)
				BEGIN
					UPDATE AccountCharacter SET GameID7 = @Name
					WHERE Id = @AccountID

					SET @Result = @@Error
				END
			ELSE IF(@g8 is NULL OR Len(@g8) = 0)
				BEGIN
					UPDATE AccountCharacter SET GameID8 = @Name
					WHERE Id = @AccountID

					SET @Result = @@Error
				END
			ELSE
				BEGIN		
					SET @Result	= 0x03							
					GOTO TranProcEnd								
				END	 
		END

	IF(@Result <> 0)
		BEGIN
			GOTO TranProcEnd		
		END
	ELSE
		BEGIN
			INSERT INTO dbo.Character(AccountID, Name, cLevel, LevelUpPoint, Class, Strength, Dexterity, Vitality, Energy, Inventory, MagicList,
					Life, MaxLife, Mana, MaxMana, MapNumber, MapPosX, MapPosY,  MDate, LDate, Quest, Leadership )
				
			SELECT @AccountID AS AccountID, @Name AS Name, Level, LevelUpPoint, @Class AS Class, Strength, Dexterity, Vitality, Energy, Inventory,
				MagicList, Life, MaxLife, Mana, MaxMana, MapNumber, MapPosX, MapPosY, getdate() AS MDate, getdate() AS LDate, Quest, Leadership
			FROM  DefaultClassType WHERE Class = @Class

			SET @Result = @@Error
		END

TranProcEnd:
	IF (@Result  <> 0)
		ROLLBACK TRAN
	ELSE
		COMMIT TRAN

ProcEnd:
	SET NOCOUNT OFF
	SET XACT_ABORT OFF

	SELECT
	   CASE @Result
	      WHEN 0x00 THEN 0x01
	      WHEN 0x01 THEN 0x00
	      WHEN 0x03 THEN 0x03
	      ELSE 0x02
	   END AS Result 
END






GO
/****** Object:  StoredProcedure [dbo].[WZ_CreateCharacter_GetVersion]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CreateCharacter_GetVersion]
AS
BEGIN
	SELECT 1
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_CheckSiegeGuildList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_CheckSiegeGuildList]

	@szGuildName		varchar(8)
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	DECLARE @iEnd INT

	SELECT @iEnd = SIEGE_ENDED FROM MuCastle_DATA

	IF @iEnd = 1
	BEGIN
		SELECT 0 As QueryResult
	END
	ELSE IF EXISTS ( SELECT GUILD_NAME FROM MuCastle_SIEGE_GUILDLIST  WITH (READUNCOMMITTED) 
				WHERE GUILD_NAME = @szGuildName)
	BEGIN
		SELECT 1 As QueryResult	
	END
	ELSE
	BEGIN
		IF EXISTS ( SELECT REG_SIEGE_GUILD FROM MuCastle_REG_SIEGE WITH (READUNCOMMITTED) 
				WHERE REG_SIEGE_GUILD = @szGuildName AND IS_GIVEUP = 0)
		BEGIN
			SELECT 1 As QueryResult
		END
		ELSE
		BEGIN
			SELECT 0 As QueryResult	
		END
	END


	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_GetAllGuildMarkRegInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_GetAllGuildMarkRegInfo]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	SELECT TOP 100 * FROM MuCastle_REG_SIEGE WITH (READUNCOMMITTED)
	WHERE MAP_SVR_GROUP = @iMapSvrGroup
	ORDER BY SEQ_NUM DESC

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_GetCalcRegGuildList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CS_GetCalcRegGuildList]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	DECLARE T_CURSOR CURSOR FAST_FORWARD
	FOR SELECT TOP 100 * FROM MuCastle_REG_SIEGE	WHERE MAP_SVR_GROUP = @iMapSvrGroup AND IS_GIVEUP = 0 ORDER BY SEQ_NUM DESC
	
	OPEN T_CURSOR
	
	DECLARE	@iMapSvrNum			INT
	DECLARE	@szRegGuild			VARCHAR(8)
	DECLARE	@iRegMarks			INT
	DECLARE	@iIsGiveUp			INT
	DECLARE	@iSeqNum			INT
	DECLARE	@iGuildMemberCount		INT
	DECLARE	@iGuildMasterLevel		INT

	CREATE TABLE #T_REG_GUILDLIST  (
		[REG_SIEGE_GUILD] [varchar] (8) NOT NULL ,
		[REG_MARKS] [int] NOT NULL ,
		[GUILD_MEMBER] [int] NOT NULL ,
		[GM_LEVEL] [int] NOT NULL ,
		[SEQ_NUM] [int] NOT NULL 
	) ON [PRIMARY]
	
	FETCH FROM T_CURSOR INTO @iMapSvrNum, @szRegGuild, @iRegMarks, @iIsGiveUp, @iSeqNum
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF EXISTS ( SELECT G_Name FROM Guild  WITH (READUNCOMMITTED) WHERE G_Name = @szRegGuild)
		BEGIN
			DECLARE @szGuildMaster	VARCHAR(10)
			SELECT @szGuildMaster = G_Master FROM Guild  WHERE G_Name = @szRegGuild

			IF EXISTS ( SELECT Name FROM Character WITH (READUNCOMMITTED) WHERE Name = @szGuildMaster)
			BEGIN
				SELECT @iGuildMemberCount = COUNT(*) FROM GuildMember WHERE G_Name = @szRegGuild
				SELECT @iGuildMasterLevel = cLevel FROM Character WHERE Name = @szGuildMaster

				INSERT INTO #T_REG_GUILDLIST VALUES (@szRegGuild, @iRegMarks, @iGuildMemberCount, @iGuildMasterLevel, @iSeqNum)
			END
		END
		
		FETCH FROM T_CURSOR INTO @iMapSvrGroup, @szRegGuild, @iRegMarks, @iIsGiveUp, @iSeqNum
	END
	
	CLOSE T_CURSOR
	
	DEALLOCATE T_CURSOR

	SELECT * FROM #T_REG_GUILDLIST

	DROP TABLE #T_REG_GUILDLIST

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_GetCastleMoneySts]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_GetCastleMoneySts]

	@iMapSvrGroup		SMALLINT,
	@iTaxDate		DATETIME
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON
	
	DECLARE	@iTaxInc		MONEY
	DECLARE	@iTaxDec		MONEY
	DECLARE	@iYEAR		INT
	DECLARE	@iMONTH		INT
	DECLARE	@iDAY			INT
	DECLARE	@dtLogDateStart	DATETIME
	DECLARE	@dtLogDateEnd	DATETIME
	SELECT	@iYEAR		= DATEPART(YY, @iTaxDate)
	SELECT	@iMONTH		= DATEPART(MM, @iTaxDate)
	SELECT	@iDAY			= DATEPART(DD, @iTaxDate)
	SET		@dtLogDateStart	= CAST(@iYEAR AS VARCHAR(4)) + '-' + CAST(@iMONTH AS VARCHAR(2))  + '-' + CAST(@iDAY AS VARCHAR(4)) + ' 00:00:00'
	SET		@dtLogDateEnd	= CAST(@iYEAR AS VARCHAR(4)) + '-' + CAST(@iMONTH AS VARCHAR(2))  + '-' + CAST(@iDAY AS VARCHAR(4)) + ' 23:59:59'
	
	SELECT @iTaxInc = SUM(MONEY_CHANGE) FROM MuCastle_MONEY_STATISTICS  WITH (READUNCOMMITTED) 
	WHERE MAP_SVR_GROUP = 0 and LOG_DATE BETWEEN @dtLogDateStart AND @dtLogDateEnd and MONEY_CHANGE >= 0
	
	SELECT @iTaxDec = SUM(MONEY_CHANGE) FROM MuCastle_MONEY_STATISTICS  WITH (READUNCOMMITTED) 
	WHERE MAP_SVR_GROUP = 0 and LOG_DATE BETWEEN @dtLogDateStart AND @dtLogDateEnd and MONEY_CHANGE < 0
	
	IF @iTaxInc IS NULL
		SET @iTaxInc = 0
	IF @iTaxDec IS NULL
		SET @iTaxDec = 0

	SELECT @dtLogDateStart As TaxDate, @iTaxInc As TaxInc, @iTaxDec As TaxDec

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_GetCastleMoneyStsRange]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_GetCastleMoneyStsRange]

	@iMapSvrGroup		SMALLINT,
	@iTaxDateStart		DATETIME,
	@iTaxDateEnd		DATETIME
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	CREATE TABLE #T_REG_TAXSTT  (
		[TaxDate] [datetime] NOT NULL ,
		[TaxInc] [money] NOT NULL ,
		[TaxDec] [money] NOT NULL 
	) ON [PRIMARY]
	
	IF (@iTaxDateStart <= @iTaxDateEnd)
	BEGIN
		DECLARE	@iTaxDate		DATETIME
		SET		@iTaxDate		= @iTaxDateStart

		WHILE(@iTaxDate <= @iTaxDateEnd)
		BEGIN
			DECLARE	@dtLogDateStart	DATETIME
			DECLARE	@dtLogDateEnd	DATETIME
			DECLARE	@iTaxInc		MONEY
			DECLARE	@iTaxDec		MONEY
			DECLARE	@iYEAR		INT
			DECLARE	@iMONTH		INT
			DECLARE	@iDAY			INT
			SELECT	@iYEAR		= DATEPART(YY, @iTaxDate)
			SELECT	@iMONTH		= DATEPART(MM, @iTaxDate)
			SELECT	@iDAY			= DATEPART(DD, @iTaxDate)
			SET		@dtLogDateStart	= CAST(@iYEAR AS VARCHAR(4)) + '-' + CAST(@iMONTH AS VARCHAR(2))  + '-' + CAST(@iDAY AS VARCHAR(4)) + ' 00:00:00'
			SET		@dtLogDateEnd	= CAST(@iYEAR AS VARCHAR(4)) + '-' + CAST(@iMONTH AS VARCHAR(2))  + '-' + CAST(@iDAY AS VARCHAR(4)) + ' 23:59:59'
					
			SELECT @iTaxInc = SUM(MONEY_CHANGE) FROM MuCastle_MONEY_STATISTICS  WITH (READUNCOMMITTED) 
			WHERE MAP_SVR_GROUP = 0 and LOG_DATE BETWEEN @dtLogDateStart AND @dtLogDateEnd and MONEY_CHANGE >= 0
			
			SELECT @iTaxDec = SUM(MONEY_CHANGE) FROM MuCastle_MONEY_STATISTICS  WITH (READUNCOMMITTED) 
			WHERE MAP_SVR_GROUP = 0 and LOG_DATE BETWEEN @dtLogDateStart AND @dtLogDateEnd and MONEY_CHANGE < 0

			IF @iTaxInc IS NULL
				SET @iTaxInc = 0
			IF @iTaxDec IS NULL
				SET @iTaxDec = 0
						
			INSERT INTO #T_REG_TAXSTT VALUES (@dtLogDateStart, @iTaxInc, @iTaxDec)

			SET @iTaxDate				= DATEADD(DD, 1, @iTaxDate)
		END
	END
	
	SELECT * FROM #T_REG_TAXSTT

	DROP TABLE #T_REG_TAXSTT

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_GetCastleNpcInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_GetCastleNpcInfo]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	SELECT * FROM MuCastle_NPC WITH (READUNCOMMITTED)
	WHERE MAP_SVR_GROUP = @iMapSvrGroup

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_GetCastleTaxInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_GetCastleTaxInfo]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	SELECT MONEY, TAX_RATE_CHAOS, TAX_RATE_STORE, TAX_HUNT_ZONE FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
	WHERE MAP_SVR_GROUP = @iMapSvrGroup

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_GetCastleTotalInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CS_GetCastleTotalInfo]

	@iMapSvrGroup		SMALLINT,
	@iCastleEventCycle	INT
AS
BEGIN
	DECLARE	@iCastleSiegeTerm			INT
	SET		@iCastleSiegeTerm			= @iCastleEventCycle
	DECLARE	@iFirstCreate				INT
	SET		@iFirstCreate				= 0
	
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	IF NOT EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		DECLARE	@dtStartDate			datetime
		DECLARE	@dtEndDate			datetime
		DECLARE	@dtStartDateString		varchar(32)
		DECLARE	@dtEndDateString		varchar(32)

		SET		@dtStartDate			= GetDate()
		SET		@dtEndDate			= DATEADD(dd, @iCastleSiegeTerm, GetDate())
		SET		@dtStartDateString		= CAST(DATEPART(YY, @dtStartDate) AS char(4)) + '-' + CAST(DATEPART(MM, @dtStartDate) AS char(2)) + '-' + CAST(DATEPART(DD, @dtStartDate) AS char(2)) + ' 00:00:00'
		SET		@dtEndDateString		= CAST(DATEPART(YY, @dtEndDate) AS char(4)) + '-' + CAST(DATEPART(MM, @dtEndDate) AS char(2)) + '-' + CAST(DATEPART(DD, @dtEndDate) AS char(2)) + ' 00:00:00'


		INSERT INTO MuCastle_DATA  VALUES (
			@iMapSvrGroup,
			@dtStartDateString,
			@dtEndDateString,
			0,
			0,
			0,
			'',
			0,
			0,
			0,
			0
		)

		SET @iFirstCreate				= 1
	END

	SELECT	 MAP_SVR_GROUP, 
			DATEPART(YY,SIEGE_START_DATE)	As SYEAR, 
			DATEPART(MM,SIEGE_START_DATE)	As SMONTH, 
			DATEPART(DD,SIEGE_START_DATE)	As SDAY, 
			DATEPART(YY,SIEGE_END_DATE)	As EYEAR, 
			DATEPART(MM,SIEGE_END_DATE)	As EMONTH, 
			DATEPART(DD,SIEGE_END_DATE)	As EDAY, 
			SIEGE_GUILDLIST_SETTED, 
			SIEGE_ENDED, 
			CASTLE_OCCUPY, 
			OWNER_GUILD, 
			MONEY, 
			TAX_RATE_CHAOS,
			TAX_RATE_STORE,
			TAX_HUNT_ZONE,
			@iFirstCreate As FIRST_CREATE
	FROM MuCastle_DATA  WITH (READUNCOMMITTED)
	WHERE MAP_SVR_GROUP = @iMapSvrGroup

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_GetCsGuildUnionInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CS_GetCsGuildUnionInfo]

	@szGuildName		VARCHAR(8)
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	DECLARE	@iG_Union	INT
	SET		@iG_Union	= -1
	
	IF EXISTS ( SELECT G_Name FROM Guild  WITH (READUNCOMMITTED) 
				WHERE G_Name = @szGuildName)
	BEGIN
		SELECT @iG_Union = G_Union
		FROM Guild WITH (READUNCOMMITTED) 
		WHERE G_Name = @szGuildName
	END

	IF (@iG_Union = 0)
	BEGIN
		SELECT @szGuildName As GUILD_NAME
	END
	ELSE
	BEGIN
		SELECT G_Name As GUILD_NAME
		FROM Guild WITH (READUNCOMMITTED) 
		WHERE G_Union = @iG_Union
	END
	
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_GetGuildMarkRegInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CS_GetGuildMarkRegInfo]

	@iMapSvrGroup		SMALLINT,
	@szGuildName		VARCHAR(8)
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	SELECT * FROM MuCastle_REG_SIEGE WITH (READUNCOMMITTED)
	WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName
	ORDER BY SEQ_NUM ASC

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_GetOwnerGuildMaster]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_GetOwnerGuildMaster]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON	

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		DECLARE	@iIsCastleOccupied	TINYINT
		DECLARE	@szGuildName		VARCHAR(8)

		SELECT @iIsCastleOccupied = CASTLE_OCCUPY, @szGuildName = OWNER_GUILD FROM MuCastle_DATA WHERE MAP_SVR_GROUP = @iMapSvrGroup

		IF (@iIsCastleOccupied = 1)
		BEGIN
			IF (@szGuildName <> '')			
			BEGIN
				IF EXISTS ( SELECT G_Master FROM Guild  WITH (READUNCOMMITTED)
							WHERE G_Name = @szGuildName)
				BEGIN
					SELECT 1 As QueryResult, @szGuildName As OwnerGuild, G_Master As OwnerGuildMaster FROM Guild  WITH (READUNCOMMITTED) WHERE G_Name = @szGuildName
				END
				ELSE
				BEGIN
					SELECT 4 As QueryResult, '' As OwnerGuild, '' As OwnerGuildMaster
				END
			END
			ELSE
			BEGIN
				SELECT 3 As QueryResult, '' As OwnerGuild, '' As OwnerGuildMaster
			END
		END
		ELSE
		BEGIN
			SELECT 2 As QueryResult, '' As OwnerGuild, '' As OwnerGuildMaster
		END
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult, '' As OwnerGuild, '' As OwnerGuildMaster
	END


	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_GetSiegeGuildInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CS_GetSiegeGuildInfo]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	SELECT * 
	FROM MuCastle_SIEGE_GUILDLIST  WITH (READUNCOMMITTED) 
	WHERE MAP_SVR_GROUP = @iMapSvrGroup

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ModifyCastleOwnerInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ModifyCastleOwnerInfo]

	@iMapSvrGroup		SMALLINT,
	@iCastleOccupied	INT,
	@szOwnGuildName	VARCHAR(8)
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		UPDATE MuCastle_DATA 
		SET CASTLE_OCCUPY = @iCastleOccupied, OWNER_GUILD = @szOwnGuildName
		WHERE MAP_SVR_GROUP = @iMapSvrGroup

		SELECT 1 As QueryResult
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ModifyCastleSchedule]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ModifyCastleSchedule]

	@iMapSvrGroup		SMALLINT,
	@dtStartDate		DATETIME,
	@dtEndDate		DATETIME
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		UPDATE MuCastle_DATA 
		SET SIEGE_START_DATE = @dtStartDate, SIEGE_END_DATE = @dtEndDate
		WHERE MAP_SVR_GROUP = @iMapSvrGroup

		SELECT 1 As QueryResult
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ModifyGuildGiveUp]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ModifyGuildGiveUp]

	@iMapSvrGroup		SMALLINT,
	@szGuildName		VARCHAR(8),
	@iIsGiveUp		INT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_REG_SIEGE  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName)
	BEGIN
		DECLARE	@iMarkCount	INT
		SELECT @iMarkCount = REG_MARKS FROM MuCastle_REG_SIEGE  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName

		UPDATE MuCastle_REG_SIEGE 
		SET IS_GIVEUP = @iIsGiveUp, REG_MARKS = 0
		WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName

		SELECT 1 As QueryResult, @iMarkCount As DEL_MARKS
	END
	ELSE
	BEGIN
		SELECT 2 As QueryResult, 0 As DEL_MARKS
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ModifyGuildMarkRegCount]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ModifyGuildMarkRegCount]

	@iMapSvrGroup		SMALLINT,
	@szGuildName		VARCHAR(8),
	@iMarkCount		INT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_REG_SIEGE  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName)
	BEGIN
		UPDATE MuCastle_REG_SIEGE 
		SET REG_MARKS = @iMarkCount
		WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName

		SELECT 1 As QueryResult
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ModifyGuildMarkReset]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ModifyGuildMarkReset]

	@iMapSvrGroup		SMALLINT,
	@szGuildName		VARCHAR(8)
AS
BEGIN
	BEGIN TRANSACTION

	DECLARE		@iMarkCount	INT
	DECLARE		@bIsGiveUp	INT

	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_REG_SIEGE  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName)
	BEGIN
		SELECT @iMarkCount = REG_MARKS, @bIsGiveUp = IS_GIVEUP
		FROM MuCastle_REG_SIEGE
		WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName

		IF (@iMarkCount > 0)
		BEGIN
			IF (@bIsGiveUp = 0)
			BEGIN
				UPDATE MuCastle_REG_SIEGE 
				SET REG_MARKS = 0
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName
		
				SELECT 1 As QueryResult, @iMarkCount As DEL_MARKS
			END
			ELSE
			BEGIN
				SELECT 2 As QueryResult, 0 As DEL_MARKS
			END
		END
		ELSE
		BEGIN
			SELECT 1 As QueryResult, 0 As DEL_MARKS
		END
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult, 0 As DEL_MARKS
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ModifyMoney]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CS_ModifyMoney]

	@iMapSvrGroup		SMALLINT,
	@iMoneyChange	MONEY	
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		DECLARE	@iTotMoney	MONEY
		SELECT @iTotMoney = MONEY FROM MuCastle_DATA
		WHERE MAP_SVR_GROUP = @iMapSvrGroup

		IF (@iTotMoney + @iMoneyChange < 0)
		BEGIN
			SELECT 2 As QueryResult, MONEY
			FROM MuCastle_DATA
			WHERE MAP_SVR_GROUP = @iMapSvrGroup		
		END
		ELSE
		BEGIN
			UPDATE MuCastle_DATA 
			SET MONEY = @iTotMoney + @iMoneyChange
			WHERE MAP_SVR_GROUP = @iMapSvrGroup
	
			SELECT 1 As QueryResult, MONEY
			FROM MuCastle_DATA
			WHERE MAP_SVR_GROUP = @iMapSvrGroup		
		END

		INSERT MuCastle_MONEY_STATISTICS VALUES (@iMapSvrGroup, GetDate(), @iMoneyChange)
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult, 0 As MONEY
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ModifySiegeEnd]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ModifySiegeEnd]

	@iMapSvrGroup		SMALLINT,
	@iSiegeEnded		INT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		UPDATE MuCastle_DATA 
		SET SIEGE_ENDED = @iSiegeEnded
		WHERE MAP_SVR_GROUP = @iMapSvrGroup

		SELECT 1 As QueryResult
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ModifyTaxRate]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ModifyTaxRate]

	@iMapSvrGroup		SMALLINT,
	@iTaxKind		INT,
	@iTaxRate		INT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF (@iTaxKind = 1)
	BEGIN
		IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
					WHERE MAP_SVR_GROUP = @iMapSvrGroup)
		BEGIN
			UPDATE MuCastle_DATA 
			SET TAX_RATE_CHAOS = @iTaxRate
			WHERE MAP_SVR_GROUP = @iMapSvrGroup
	
			SELECT @iTaxKind As TaxKind, 1 As QueryResult, TAX_RATE_CHAOS As TaxRate
			FROM MuCastle_DATA
			WHERE MAP_SVR_GROUP = @iMapSvrGroup
		END
		ELSE
		BEGIN
			SELECT @iTaxKind As TaxKind, 0 As QueryResult, 0 As TaxRate
		END
	END
	ELSE IF (@iTaxKind = 2)
	BEGIN
		IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
					WHERE MAP_SVR_GROUP = @iMapSvrGroup)
		BEGIN
			UPDATE MuCastle_DATA 
			SET TAX_RATE_STORE = @iTaxRate
			WHERE MAP_SVR_GROUP = @iMapSvrGroup
	
			SELECT @iTaxKind As TaxKind, 1 As QueryResult, TAX_RATE_STORE As TaxRate
			FROM MuCastle_DATA
			WHERE MAP_SVR_GROUP = @iMapSvrGroup
		END
		ELSE
		BEGIN
			SELECT @iTaxKind As TaxKind, 0 As QueryResult, 0 As TaxRate
		END
	END
	ELSE IF (@iTaxKind = 3)	
	BEGIN
		IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
					WHERE MAP_SVR_GROUP = @iMapSvrGroup)
		BEGIN
			UPDATE MuCastle_DATA 
			SET TAX_HUNT_ZONE = @iTaxRate
			WHERE MAP_SVR_GROUP = @iMapSvrGroup
	
			SELECT @iTaxKind As TaxKind, 1 As QueryResult, TAX_HUNT_ZONE As TaxRate
			FROM MuCastle_DATA
			WHERE MAP_SVR_GROUP = @iMapSvrGroup
		END
		ELSE
		BEGIN
			SELECT @iTaxKind As TaxKind, 0 As QueryResult, 0 As TaxRate
		END
	END
	ELSE
	BEGIN
		SELECT @iTaxKind As TaxKind, 0 As QueryResult, 0 As TaxRate
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ReqNpcBuy]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ReqNpcBuy]

	@iMapSvrGroup		SMALLINT,
	@iNpcNumber		INT,
	@iNpcIndex		INT,
	@iNpcDfLevel		INT,
	@iNpcRgLevel		INT,
	@iNpcMaxHp		INT,
	@iNpcHp		INT,
	@btNpcX		TINYINT,
	@btNpcY		TINYINT,
	@btNpcDIR		TINYINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_NPC  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex)
	BEGIN
		SELECT 4 As QueryResult
	END
	ELSE
	BEGIN
		INSERT INTO MuCastle_NPC VALUES (
			@iMapSvrGroup	,
			@iNpcNumber,
			@iNpcIndex,
			@iNpcDfLevel,
			@iNpcRgLevel,
			@iNpcMaxHp,
			@iNpcHp,
			@btNpcX,
			@btNpcY,
			@btNpcDIR,
			GetDate()
		)
		
		SELECT 1 As QueryResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ReqNpcRemove]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ReqNpcRemove]

	@iMapSvrGroup		SMALLINT,
	@iNpcNumber		INT,
	@iNpcIndex		INT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_NPC  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex)
	BEGIN
		DELETE MuCastle_NPC
		WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex

		SELECT 1 As QueryResult
	END
	ELSE
	BEGIN
		SELECT 2 As QueryResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ReqNpcRepair]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ReqNpcRepair]

	@iMapSvrGroup		SMALLINT,
	@iNpcNumber		INT,
	@iNpcIndex		INT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_NPC  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex)
	BEGIN
		UPDATE MuCastle_NPC 
		SET  NPC_HP = NPC_MAXHP
		WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex

		SELECT 1 As QueryResult, NPC_HP, NPC_MAXHP
		FROM MuCastle_NPC  WITH (READUNCOMMITTED) 
		WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex
	END
	ELSE
	BEGIN
		SELECT 2 As QueryResult, 0 As NPC_HP, 0 As NPC_MAXHP
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ReqNpcUpdate]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ReqNpcUpdate]

	@iMapSvrGroup		SMALLINT,
	@iNpcNumber		INT,
	@iNpcIndex		INT,
	@iNpcDfLevel		INT,
	@iNpcRgLevel		INT,
	@iNpcMaxHp		INT,
	@iNpcHp		INT,
	@btNpcX		TINYINT,
	@btNpcY		TINYINT,
	@btNpcDIR		TINYINT
As
Begin
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_NPC  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex)
	BEGIN
		
		UPDATE MuCastle_NPC
		SET	NPC_NUMBER		= @iNpcNumber, 
			NPC_INDEX		= @iNpcIndex, 
			NPC_DF_LEVEL	= @iNpcDfLevel, 
			NPC_RG_LEVEL	= @iNpcRgLevel, 
			NPC_MAXHP		= @iNpcMaxHp, 
			NPC_HP		= @iNpcHp,
			NPC_X			= @btNpcX,
			NPC_Y			= @btNpcY, 
			NPC_DIR		= @btNpcDIR
		WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex
	END
	ELSE
	BEGIN

		INSERT INTO MuCastle_NPC VALUES (
			@iMapSvrGroup	,
			@iNpcNumber,
			@iNpcIndex,
			@iNpcDfLevel,
			@iNpcRgLevel,
			@iNpcMaxHp,
			@iNpcHp,
			@btNpcX,
			@btNpcY,
			@btNpcDIR,
			GetDate()
		)
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ReqNpcUpgrade]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CS_ReqNpcUpgrade]

	@iMapSvrGroup		SMALLINT,
	@iNpcNumber		INT,
	@iNpcIndex		INT,
	@iNpcUpType		INT,
	@iNpcUpValue		INT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_NPC  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex)
	BEGIN
		IF (@iNpcUpType = 1)
		BEGIN
			UPDATE MuCastle_NPC 
			SET NPC_DF_LEVEL = @iNpcUpValue
			WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex
	
			SELECT 1 As QueryResult
		END
		ELSE IF (@iNpcUpType = 2)
		BEGIN
			UPDATE MuCastle_NPC 
			SET NPC_RG_LEVEL = @iNpcUpValue
			WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex
	
			SELECT 1 As QueryResult
		END
		ELSE IF (@iNpcUpType = 3)
		BEGIN
			UPDATE MuCastle_NPC 
			SET NPC_MAXHP = @iNpcUpValue, NPC_HP = @iNpcUpValue
			WHERE MAP_SVR_GROUP = @iMapSvrGroup and NPC_NUMBER = @iNpcNumber and NPC_INDEX = @iNpcIndex
	
			SELECT 1 As QueryResult
		END
		ELSE
		BEGIN
			SELECT 2 As QueryResult
		END
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ReqRegAttackGuild]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ReqRegAttackGuild]

	@iMapSvrGroup		SMALLINT,
	@szGuildName		VARCHAR(8)
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	DECLARE	@iMaxRegGuildCount	INT
	DECLARE	@iCurRegGuildCount	INT
	SET 		@iMaxRegGuildCount	= 100

	SELECT @iCurRegGuildCount = COUNT(*) FROM MuCastle_REG_SIEGE  WITH (READUNCOMMITTED)  WHERE MAP_SVR_GROUP = @iMapSvrGroup
	IF (@iCurRegGuildCount >= @iMaxRegGuildCount)
	BEGIN
			SELECT 6 As QueryResult
	END
	ELSE
	BEGIN
		IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_REG_SIEGE  WITH (READUNCOMMITTED) 
					WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName)
		BEGIN
			SELECT 2 As QueryResult
		END
		ELSE
		BEGIN
			DECLARE @szOwnGuildName		VARCHAR(8)
			SELECT @szOwnGuildName = OWNER_GUILD FROM MuCastle_DATA WHERE MAP_SVR_GROUP = @iMapSvrGroup
	
			IF (@szOwnGuildName = @szGuildName)
			BEGIN
				SELECT 3 As QueryResult
			END
			ELSE
			BEGIN
				IF NOT EXISTS ( SELECT G_Name FROM Guild  WITH (READUNCOMMITTED) WHERE G_Name = @szGuildName)
				BEGIN
					SELECT 4 As QueryResult
				END
				ELSE
				BEGIN
					DECLARE @szGuildMaster			VARCHAR(10)
					DECLARE @iGuildMasterLevel			INT
					DECLARE @iGuildMemberCount			INT
					
					SELECT @szGuildMaster = G_Master FROM Guild WHERE G_Name = @szGuildName
					SELECT @iGuildMasterLevel = cLevel FROM Character WHERE Name = @szGuildMaster
					SELECT @iGuildMemberCount = COUNT(*) FROM GuildMember WHERE G_Name = @szGuildName
					
					IF (@iGuildMasterLevel < 1)
					BEGIN
						SELECT 5 As QueryResult
					END
					ELSE
					BEGIN
						IF (@iGuildMemberCount < 0)
						BEGIN
							SELECT 8 As QueryResult
						END
						ELSE
						BEGIN
							DECLARE @iMAX_SEQNUM	INT
							DECLARE @iNXT_SEQNUM	INT
							SELECT @iMAX_SEQNUM = MAX(SEQ_NUM) FROM MuCastle_REG_SIEGE  WITH (READUNCOMMITTED)  WHERE MAP_SVR_GROUP = @iMapSvrGroup
							
							IF (@iMAX_SEQNUM IS NULL)
								SET @iNXT_SEQNUM	= 1
							ELSE
								SET @iNXT_SEQNUM	= @iMAX_SEQNUM + 1

							INSERT INTO MuCastle_REG_SIEGE 
							VALUES (@iMapSvrGroup, @szGuildName, 0, 0, @iNXT_SEQNUM)
					
							SELECT 1 As QueryResult
						END
					END
				END
			END
		END
	END

	
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ReqRegGuildMark]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CS_ReqRegGuildMark]

	@iMapSvrGroup		SMALLINT,
	@szGuildName		VARCHAR(8)
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_REG_SIEGE  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName)
	BEGIN
		DECLARE	@bIS_GIVEUP	INT
		SELECT @bIS_GIVEUP = IS_GIVEUP FROM MuCastle_REG_SIEGE  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName

		IF (@bIS_GIVEUP = 0)
		BEGIN
			UPDATE MuCastle_REG_SIEGE 
			SET REG_MARKS = REG_MARKS + 1
			WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName
	
			SELECT 1 As QueryResult, REG_MARKS
			FROM MuCastle_REG_SIEGE  WITH (READUNCOMMITTED)
			WHERE MAP_SVR_GROUP = @iMapSvrGroup and REG_SIEGE_GUILD = @szGuildName
		END
		ELSE
		BEGIN
			SELECT 0 As QueryResult, 0 As REG_MARKS
		END
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult, 0 As REG_MARKS
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ResetCastleSiege]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ResetCastleSiege]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		UPDATE MuCastle_DATA 
		SET 	SIEGE_GUILDLIST_SETTED = 0,
			SIEGE_ENDED = 0
		WHERE MAP_SVR_GROUP = @iMapSvrGroup

		DELETE MuCastle_SIEGE_GUILDLIST
		WHERE MAP_SVR_GROUP = @iMapSvrGroup

		SELECT 1 As QueryResult
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ResetCastleTaxInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ResetCastleTaxInfo]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		UPDATE MuCastle_DATA 
		SET MONEY = 0, TAX_RATE_CHAOS = 0, TAX_RATE_STORE = 0, TAX_HUNT_ZONE = 0
		WHERE MAP_SVR_GROUP = @iMapSvrGroup

		SELECT 1 As QueryResult
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ResetRegSiegeInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ResetRegSiegeInfo]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		DELETE MuCastle_REG_SIEGE
		WHERE MAP_SVR_GROUP = @iMapSvrGroup

		SELECT 1 As QueryResult
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_ResetSiegeGuildInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CS_ResetSiegeGuildInfo]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		DELETE MuCastle_SIEGE_GUILDLIST
		WHERE MAP_SVR_GROUP = @iMapSvrGroup

		SELECT 1 As QueryResult
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult
	END

	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_SetSiegeGuildInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE	[dbo].[WZ_CS_SetSiegeGuildInfo]
	@iMapSvrGroup		SMALLINT,
	@szGuildName		VARCHAR(8),
	@iGuildID		INT,
	@iGuildInvolved		INT,
	@iGuildScore		INT
As
Begin
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	INSERT INTO MuCastle_SIEGE_GUILDLIST
	VALUES (@iMapSvrGroup, @szGuildName, @iGuildID, @iGuildInvolved, @iGuildScore)
	
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
End



































GO
/****** Object:  StoredProcedure [dbo].[WZ_CS_SetSiegeGuildOK]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_CS_SetSiegeGuildOK]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON

	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		UPDATE MuCastle_DATA
		SET SIEGE_GUILDLIST_SETTED = 1
		WHERE MAP_SVR_GROUP = @iMapSvrGroup

		SELECT 1 As QueryResult
	END
	ELSE
	BEGIN
		SELECT 0 As QueryResult
	END
	
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CW_InfoLoad]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CW_InfoLoad]

	@iMapSvrGroup		SMALLINT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON
	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCrywolf_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		SELECT CRYWOLF_OCCUFY, CRYWOLF_STATE  FROM MuCrywolf_DATA  WHERE MAP_SVR_GROUP = @iMapSvrGroup
	END
	ELSE
	BEGIN
		INSERT MuCrywolf_DATA VALUES ( @iMapSvrGroup, DEFAULT, DEFAULT, DEFAULT, DEFAULT )
		SELECT CRYWOLF_OCCUFY, CRYWOLF_STATE  FROM MuCrywolf_DATA WHERE  MAP_SVR_GROUP = @iMapSvrGroup
	END
	
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION
	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_CW_InfoSave]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_CW_InfoSave]

	@iMapSvrGroup		SMALLINT,
	@iCrywolfState		INT,
	@iOccupationState	INT
AS
BEGIN
	BEGIN TRANSACTION
	
	SET NOCOUNT ON
	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCrywolf_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN
		UPDATE MuCrywolf_DATA
		SET CRYWOLF_OCCUFY = @iOccupationState, CRYWOLF_STATE = @iCrywolfState
		WHERE MAP_SVR_GROUP = @iMapSvrGroup
	END
	ELSE
	BEGIN
		INSERT MuCrywolf_DATA VALUES ( @iMapSvrGroup, DEFAULT, DEFAULT, DEFAULT, DEFAULT )

		UPDATE MuCrywolf_DATA
		SET CRYWOLF_OCCUFY = @iOccupationState, CRYWOLF_STATE = @iCrywolfState
		WHERE MAP_SVR_GROUP = @iMapSvrGroup
	END
	
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION
	SET NOCOUNT OFF	
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_DelMail]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_DelMail]

	@Name 	varchar(10),
	@MemoIndex 	int
AS
BEGIN
	DECLARE @ErrorCode int
	DECLARE @UserGuid  int

	SET XACT_ABORT ON
	SET NOCOUNT ON

	SET @ErrorCode = 0

	IF NOT EXISTS ( SELECT GUID FROM T_FriendMain WHERE Name=@Name)
	  BEGIN
		SET @ErrorCode = 2
		GOTO EndProc

	  END
	ELSE
	  BEGIN
		SELECT @UserGuid = GUID FROM T_FriendMain WHERE Name=@Name
	
		IF ( @@Error  <> 0   )
		BEGIN
			SET @ErrorCode = 3
			GOTO EndProc
		END
	
	  END

	IF NOT EXISTS ( select MemoIndex FROM T_FriendMail  WHERE  MemoIndex=@MemoIndex AND GUID=@UserGuid)
	  BEGIN
		SET @ErrorCode = 4
		GOTO EndProc
	  END

	BEGIN TRAN

	DELETE FROM T_FriendMail WHERE MemoIndex=@MemoIndex AND GUID=@UserGuid
	IF ( @@Error  <> 0 )
		SET @ErrorCode = 5
	ELSE
	  BEGIN
		UPDATE T_FriendMain SET MemoTotal=MemoTotal-1 WHERE GUID = @UserGuid
		IF ( @@Error  <> 0 )
		BEGIN
			SET @ErrorCode = 6
		END
	  END

	IF ( @ErrorCode  <> 0 )
	  BEGIN
		ROLLBACK TRAN
	  END
	ELSE
	  BEGIN
		COMMIT TRAN
		SET @ErrorCode = 1
	  END
	
EndProc:

	SET XACT_ABORT OFF
	SET NOCOUNT OFF
	SELECT @ErrorCode
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_DISCONNECT_MEMB]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_DISCONNECT_MEMB]

	@memb___id 	varchar(10)
AS
BEGIN

SET NOCOUNT ON
	DECLARE @find_id		 varchar(10)	
	DECLARE @ConnectStat	 tinyint
	SET @ConnectStat = 0
	SET @find_id = 'NOT'
	SELECT @find_id = S.memb___id FROM MEMB_STAT S INNER JOIN MEMB_INFO I ON S.memb___id = I.memb___id 
	     WHERE I.memb___id = @memb___id

	IF( @find_id <> 'NOT' )
	BEGIN
		UPDATE MEMB_STAT set ConnectStat = @ConnectStat, DisConnectTM = getdate()
		 WHERE memb___id = @memb___id
	END
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_FriendAdd]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_FriendAdd]

	@Name		varchar(10),
	@FriendName 	varchar(10)

AS
BEGIN
	DECLARE @ErrorCode int
	DECLARE @UserGuid  int
	DECLARE @FriendGuid  int

	SET NOCOUNT ON
	SET XACT_ABORT ON


	SET @ErrorCode = 0

	IF NOT EXISTS ( SELECT GUID FROM T_FriendMain WHERE Name=@FriendName )
	  BEGIN
		SET @ErrorCode = 5
		GOTO EndProc
	  END
 	ELSE
	  BEGIN
		SELECT @FriendGuid = GUID FROM T_FriendMain WHERE Name=@FriendName

		IF ( @@Error  <> 0 )
		BEGIN
			SET @ErrorCode = 6
			GOTO EndProc
		END

	END

	IF NOT EXISTS ( SELECT GUID FROM T_FriendMain WHERE Name=@Name)
	  BEGIN
		SET @ErrorCode = 3
		GOTO EndProc

	  END
	ELSE
	  BEGIN
		SELECT @UserGuid = GUID FROM T_FriendMain WHERE Name=@Name
	
		IF ( @@Error  <> 0   )
		BEGIN
			SET @ErrorCode = 4
			GOTO EndProc
		END
	
	  END

	IF EXISTS (SELECT GUID FROM T_FriendList WHERE GUID = @UserGuid AND FriendGuid = @FriendGuid  )
	BEGIN
		SET @ErrorCode = 2
		GOTO EndProc
	END

	BEGIN TRAN

	INSERT INTO T_FriendList (GUID, FriendGuid, FriendName ) 
		VALUES ( @UserGuid, @FriendGuid, @FriendName)
	
	IF ( @@Error  <> 0 )
		SET @ErrorCode = @@Error
	ELSE
	  BEGIN
		DELETE FROM T_WaitFriend where GUID = @UserGuid AND FriendGuid = @FriendGuid
		IF ( @@Error  <> 0 )
		BEGIN
			SET @ErrorCode = @@Error
		END
	  END

	IF ( @ErrorCode  <> 0 )
	  BEGIN
		ROLLBACK TRAN
	  END
	ELSE
	  BEGIN
		COMMIT TRAN
		SET @ErrorCode = 1
	  END
	
EndProc:

	SET XACT_ABORT OFF
	SET NOCOUNT OFF
	SELECT @ErrorCode
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_FriendDel]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_FriendDel]

	@Name		varchar(10),
	@FriendName 	varchar(10)
AS
BEGIN
	DECLARE @ErrorCode int
	DECLARE @UserGuid  int
	DECLARE @FriendGuid  int

	SET NOCOUNT ON

	SET @ErrorCode = 0

	IF NOT EXISTS ( SELECT GUID FROM T_FriendMain WHERE Name=@Name)
	  BEGIN
		SET @ErrorCode = 3
		GOTO EndProc

	  END
	ELSE
	  BEGIN
		SELECT @UserGuid = GUID FROM T_FriendMain WHERE Name=@Name
	
		IF ( @@Error  <> 0   )
		BEGIN
			SET @ErrorCode = 4
		END

	  END

	IF NOT EXISTS ( SELECT GUID FROM T_FriendMain WHERE Name=@FriendName )
	  BEGIN
		SET @ErrorCode = 5
		GOTO EndProc
	  END
 	ELSE
	  BEGIN
		SELECT @FriendGuid = GUID FROM T_FriendMain WHERE Name=@FriendName

		IF ( @@Error  <> 0 )
		BEGIN
			SET @ErrorCode = 6
		END
	END

	IF NOT EXISTS (SELECT GUID FROM T_FriendList WHERE GUID = @UserGuid AND FriendGuid = @FriendGuid  )
	BEGIN
		SET @ErrorCode = 2
		GOTO EndProc
	END
	
	DELETE FROM T_FriendList where GUID = @UserGuid AND FriendGuid = @FriendGuid  
	
	IF ( @@Error  <> 0 )
		SET @ErrorCode	= @@Error
	ELSE SET @ErrorCode	= 1

	IF( @ErrorCode = 1 )
	BEGIN
		UPDATE T_FriendList SET Del=1 WHERE GUID=@FriendGuid AND FriendGuid=@UserGuid
	END

EndProc:

	SET NOCOUNT OFF
	SELECT @ErrorCode
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_Get_DBID]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_Get_DBID]

AS
BEGIN	
	SET NOCOUNT ON

	SELECT [DESC] FROM Mu_DBID

	SET NOCOUNT OFF

END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_GetItemSerial]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_GetItemSerial]

AS
BEGIN	
	DECLARE @ItemSerial	bigint
	SET XACT_ABORT ON
	SET NOCOUNT ON
	BEGIN TRANSACTION

	UPDATE GameServerInfo SET @ItemSerial = ItemCount = ItemCount+1
			
	IF ( @@error  <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION			
	END

	SELECT @ItemSerial
	
	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END
















GO
/****** Object:  StoredProcedure [dbo].[WZ_GetItemSerial2]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[WZ_GetItemSerial2]

	@iAddSerialCount	int
AS
BEGIN	
	DECLARE @ItemSerial	bigint

	SET XACT_ABORT ON
	SET NOCOUNT ON
	BEGIN TRANSACTION

	UPDATE GameServerInfo 
	SET @ItemSerial = ItemCount = ItemCount+@iAddSerialCount
		
	IF ( @@error  <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION	
	END

	SELECT @ItemSerial-@iAddSerialCount+1 AS ItemSerial

	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END















GO
/****** Object:  StoredProcedure [dbo].[WZ_GuildCreate]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_GuildCreate]

	@GuildName	varchar(8),
	@MasterName 	varchar(10)
AS
BEGIN
	DECLARE @ErrorCode int

	SET @ErrorCode = 0
	SET XACT_ABORT ON

	SET NOCOUNT ON
	BEGIN TRANSACTION

	INSERT INTO Guild (G_Name, G_Master, G_Score) VALUES (@GuildName, @MasterName, 0)
	IF ( @@Error  <> 0 )
	BEGIN
		SET @ErrorCode = 1
	END

	IF ( @ErrorCode  =  0 )
	BEGIN
		INSERT GuildMember (Name, G_Name, G_Level) VALUES (@MasterName, @GuildName, 1)
		IF ( @@Error  <> 0 )
		BEGIN
			SET @ErrorCode = 2
		END
	END

	IF ( @ErrorCode  <> 0 )
		ROLLBACK TRANSACTION
	ELSE
		COMMIT TRANSACTION

	SELECT @ErrorCode

	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_IBS_AddCoin]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WZ_IBS_AddCoin]
	-- Add the parameters for the stored procedure here
	@AccountID		varchar(10),
	@Type			int,
	@Coin			float
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@Type = 0)
	BEGIN
		UPDATE T_InGameShop_Point SET WCoin = WCoin+@Coin WHERE AccountID = @AccountID
	END
	IF(@Type = 1)
	BEGIN
		UPDATE T_InGameShop_Point SET GoblinPoint = GoblinPoint+@Coin WHERE AccountID = @AccountID
	END
END


















GO
/****** Object:  StoredProcedure [dbo].[WZ_IBS_AddGift]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Dudas, WOG Team>
-- Create date: <15 July 2011>
-- Description:	<IBS Shop Add Item procedure>
-- =============================================
CREATE PROCEDURE [dbo].[WZ_IBS_AddGift]
	-- Add the parameters for the stored procedure here
	@Target					varchar(10),
	@ID1					int,
	@ID2					int,
	@ID3					int,
	@Type					int,
	@Sender					varchar(10),
	@Message				varchar(200)
	
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRANSACTION

	DECLARE @FreeAuthCode int
	SET @FreeAuthCode = 0

	WHILE (1 = 1)
	BEGIN
		SET @FreeAuthCode = ROUND(((2000000000 - 1 -1) * RAND() + 1), 0)
		IF NOT EXISTS (SELECT * FROM T_InGameShop_Items WHERE AuthCode = @FreeAuthCode)
		BEGIN
			BREAK
		END
	END
    
	DECLARE @GiftAccount varchar(10)
	SELECT @GiftAccount = AccountID from Character Where Name = @Target
	INSERT INTO T_InGameShop_Items (AccountID, AuthCode, UniqueID1, UniqueID2, UniqueID3, InventoryType, GiftName, Message, UsedItem) VALUES
	(@GiftAccount, @FreeAuthCode, @ID1, @ID2, @ID3, @Type, @Sender, @Message, 0)
    
	SELECT 1 AS Result
	
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION
	
	SET NOCOUNT OFF		
END






















GO
/****** Object:  StoredProcedure [dbo].[WZ_IBS_AddItem]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Dudas, WOG Team>
-- Create date: <15 July 2011>
-- Description:	<IBS Shop Add Item procedure>
-- =============================================
CREATE PROCEDURE [dbo].[WZ_IBS_AddItem]
	-- Add the parameters for the stored procedure here
	@AccountID				varchar(10),
	@ID1					int,
	@ID2					int,
	@ID3					int,
	@Type					int
	
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION

	DECLARE @FreeAuthCode int
	SET @FreeAuthCode = 0

	WHILE (1 = 1)
	BEGIN
		SET @FreeAuthCode = ROUND(((2000000000 - 1 -1) * RAND() + 1), 0)
		IF NOT EXISTS (SELECT * FROM T_InGameShop_Items WHERE AuthCode = @FreeAuthCode)
		BEGIN
			BREAK
		END
	END
    
    INSERT INTO T_InGameShop_Items (AccountID, AuthCode, UniqueID1, UniqueID2, UniqueID3, InventoryType, UsedItem) VALUES
    (@AccountID, @FreeAuthCode, @ID1, @ID2, @ID3, @Type, 0)
    
    SELECT 1 AS Result
    
    IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION

	SET NOCOUNT OFF		
END






















GO
/****** Object:  StoredProcedure [dbo].[WZ_IBS_DeleteItem]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[WZ_IBS_DeleteItem]
	@AccountID			varchar(10),
	@UniqueCode			int,
	@AuthCode			int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Acc	varchar(10)
	IF EXISTS ( SELECT AccountID, UniqueID1, UniqueID2, UniqueID3 FROM T_InGameShop_Items WHERE UniqueCode = @UniqueCode AND AuthCode = @AuthCode )
	BEGIN
		DELETE FROM T_InGameShop_Items WHERE UniqueCode = @UniqueCode AND AuthCode = @AuthCode AND AccountID = @AccountID
		SELECT 1 AS Result
	END
	ELSE
	BEGIN
		SELECT 0 AS Result
	END
END






















GO
/****** Object:  StoredProcedure [dbo].[WZ_IBS_GetItemsList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WZ_IBS_GetItemsList]
	-- Add the parameters for the stored procedure here
	@AccountID				varchar(10),
	@Type					int																					
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT * FROM T_InGameShop_Items WHERE AccountID = @AccountID AND InventoryType = @Type AND UsedItem = 0
END






















GO
/****** Object:  StoredProcedure [dbo].[WZ_IBS_GetItemToUse]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[WZ_IBS_GetItemToUse]
	@AccountID			varchar(10),
	@UniqueCode			int,
	@AuthCode			int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Acc	varchar(10)
	DECLARE @UsedFlag int

	SET @UsedFlag = 0
	IF EXISTS ( SELECT AccountID, UniqueID1, UniqueID2, UniqueID3 FROM T_InGameShop_Items WHERE UniqueCode = @UniqueCode AND AuthCode = @AuthCode )
	BEGIN
		SELECT @UsedFlag = UsedItem FROM T_InGameShop_Items WHERE UniqueCode = @UniqueCode AND AuthCode = @AuthCode AND AccountID = @AccountID

		IF (@UsedFlag = 1)
		BEGIN
			SELECT 0 AS Result
		END
		ELSE
		BEGIN
			UPDATE T_InGameShop_Items SET UsedItem = 1 WHERE UniqueCode = @UniqueCode AND AuthCode = @AuthCode AND AccountID = @AccountID
			SELECT 1 AS Result, AccountID, UniqueID1, UniqueID2, UniqueID3 FROM T_InGameShop_Items WHERE UniqueCode = @UniqueCode AND AuthCode = @AuthCode AND AccountID = @AccountID
		END
	END
	ELSE
	BEGIN
		SELECT 0 AS Result
	END
END






















GO
/****** Object:  StoredProcedure [dbo].[WZ_MoveCharacter]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_MoveCharacter] 

	@AccountID varchar(10),
	@Name varchar(10),
	@ChangeAccountID varchar(10),
	@IsOriginalAccountID bit
AS
BEGIN

	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	DECLARE	@Result tinyint	
	DECLARE	@ResultLowCount int
	DECLARE	@Class tinyint
	DECLARE	@Ctl1_Code tinyint
	DECLARE	@SQLEXEC varchar(1000)
	DECLARE	@ErrorCheck INT
	DECLARE @g1 varchar(10), @g2 varchar(10), @g3 varchar(10), @g4 varchar(10), @g5 varchar(10), @g6 varchar(10), @g7 varchar(10), @g8 varchar(10)
	DECLARE @MoveCnt tinyint		
	DECLARE @ChangeMoveCnt tinyint		
	DECLARE	@SqlStmt VARCHAR(700)		
	DECLARE	@SqlStmt2 VARCHAR(700)		
	DECLARE	@SqlStmt3 VARCHAR(700)		

	SET LOCK_TIMEOUT	1000
	SET @Result = 0x00	
	SET @ErrorCheck = 0x00

	IF EXISTS( SELECT Name FROM GuildMember WHERE Name = @Name )
	BEGIN
		SET @Result	= 0x10
		GOTO ON_ERROR
	END

	SELECT @Class = Class, @Ctl1_Code = CtlCode FROM Character WHERE Name = @Name
	
	SELECT @ResultLowCount = @@rowcount, @ErrorCheck = @@error
  						
	IF @ResultLowCount = 0 
	BEGIN
		SET @Result	= 0x02			
		GOTO ON_ERROR						
	END

	IF @ErrorCheck  <> 0 GOTO ON_ERROR

	IF ( (@Ctl1_Code & 127 ) > 0 )
	BEGIN
		SET @Result	= 0x03			
		GOTO ON_ERROR						
	END 

	SELECT  @g1=GameID1, @g2=GameID2, @g3=GameID3, @g4=GameID4, @g5=GameID5, @g6=GameID6, @g7=GameID7, @g8=GameID8, @MoveCnt = MoveCnt 
	FROM dbo.AccountCharacter WHERE Id = @AccountID 		
	
	SELECT @ResultLowCount = @@rowcount, @ErrorCheck = @@error

	IF @ResultLowCount = 0 
	BEGIN
		SET @Result	= 0x02			
		GOTO ON_ERROR						
	END

	IF @ErrorCheck  <> 0 GOTO ON_ERROR

	IF @MoveCnt IS NULL 
	BEGIN
		SET @MoveCnt = 0 
	END

	IF  @Class = 48 
		BEGIN
			IF ((@MoveCnt&240) > 0) 
				BEGIN	
					SET @Result	= 0x04
					GOTO ON_ERROR				
				END 
			ELSE
				BEGIN
					SET @MoveCnt =  @MoveCnt | 16	
				END 
		END
	ELSE
		BEGIN
			IF @Class = 64
				BEGIN
					IF ((@MoveCnt&240) > 0) 
						BEGIN	
							SET @Result	= 0x04
						GOTO ON_ERROR				
						END 
					ELSE
						BEGIN
							SET @MoveCnt =  @MoveCnt | 16	
						END 
				END
			ELSE
				BEGIN
					IF  ((@MoveCnt&15) > 0)
						BEGIN	
							SET @Result	= 0x04
							GOTO ON_ERROR				
						END 
					ELSE
						BEGIN
							SET @MoveCnt =  @MoveCnt | 1	
						END 
				END 
		END

	SET @SqlStmt = 'UPDATE AccountCharacter  '

	IF ( @g1 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  GameID1 = NULL,'
	ELSE IF ( @g2 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  GameID2 = NULL,'
	ELSE IF ( @g3 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  GameID3 = NULL,'
	ELSE IF ( @g4 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  GameID4 = NULL,'
	ELSE IF ( @g5 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  GameID5 = NULL,'
	ELSE IF ( @g6 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  GameID6 = NULL,'
	ELSE IF ( @g7 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  GameID7 = NULL,'
	ELSE IF ( @g8 = @Name )
		SET @SqlStmt = @SqlStmt + ' SET  GameID8 = NULL,'
	ELSE 				
		SET @Result	= 0x05

	IF ( @Result <> 0 )
		GOTO ON_ERROR

	SET @SqlStmt = @SqlStmt + ' MoveCnt =  ' + CONVERT(VARCHAR, @MoveCnt )					
	SET @SqlStmt = @SqlStmt + ' WHERE Id =  ''' + @AccountID	 + ''''				

	SELECT  @g1=GameID1, @g2=GameID2, @g3=GameID3, @g4=GameID4, @g5=GameID5, @g6=GameID6, @g7=GameID7, @g8=GameID8, @ChangeMoveCnt = MoveCnt  
	FROM dbo.AccountCharacter  Where Id = @ChangeAccountID 			

	SELECT @ResultLowCount = @@rowcount, @ErrorCheck = @@error

	IF @ErrorCheck  <> 0 GOTO ON_ERROR

	IF @ResultLowCount = 0 
	BEGIN
		SET @SqlStmt2 ='INSERT INTO dbo.AccountCharacter(Id, GameID1, GameID2, GameID3, GameID4, GameID5, GameID6, GameID7, GameID8, GameIDC) '
		SET @SqlStmt2 = @SqlStmt2 + ' VALUES( ''' +  @ChangeAccountID + ''', '
		SET @SqlStmt2 = @SqlStmt2 + '''' + @Name + ''', '
		SET @SqlStmt2 = @SqlStmt2 +  ' NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) '

		PRINT @SqlStmt2
	END
	ELSE
	BEGIN
		SET @SqlStmt2 = 'UPDATE AccountCharacter SET '
	
		IF( ( @g1 Is NULL) OR (Len(@g1) = 0))
			SET @SqlStmt2 = @SqlStmt2 + '  GameID1 = '
		ELSE IF ( @g2  Is NULL OR Len(@g2) = 0)
			SET @SqlStmt2 = @SqlStmt2 + '  GameID2 = '
		ELSE IF ( @g3 Is NULL OR Len(@g3) = 0)
			SET @SqlStmt2 = @SqlStmt2 + '  GameID3 = ' 
		ELSE IF ( @g4 Is NULL OR Len(@g4) = 0)
			SET @SqlStmt2 = @SqlStmt2 + '  GameID4 = '
		ELSE IF ( @g5 Is NULL OR Len(@g5) = 0)
			SET @SqlStmt2 = @SqlStmt2 + '  GameID5 = '
		ELSE IF ( @g6 Is NULL OR Len(@g6) = 0)
			SET @SqlStmt2 = @SqlStmt2 + '  GameID6 = ' 
		ELSE IF ( @g7 Is NULL OR Len(@g7) = 0)
			SET @SqlStmt2 = @SqlStmt2 + '  GameID7 = '
		ELSE IF ( @g8 Is NULL OR Len(@g8) = 0)
			SET @SqlStmt2 = @SqlStmt2 + '  GameID8 = '
		ELSE 		
			SET @Result	= 0x06			
	
		if( @Result <> 0 )
			GOTO ON_ERROR
		
		SET @SqlStmt2 = @SqlStmt2 +  '''' + @Name + ''''
		SET @SqlStmt2 = @SqlStmt2 + ' WHERE Id =  ''' + @ChangeAccountID + ''''
	END

	SET @SqlStmt3 = 'UPDATE Character '
	SET @SqlStmt3 = @SqlStmt3 + 'SET  AccountID = ''' + @ChangeAccountID + ''''
	
	IF @IsOriginalAccountID = 1
		SET @SqlStmt3 = @SqlStmt3 + ', CtlCode = ' + CONVERT(VARCHAR, @Ctl1_Code & 127	)
	ELSE
		SET @SqlStmt3 = @SqlStmt3 + ', CtlCode = ' + CONVERT(VARCHAR,  @Ctl1_Code | 128	)
	
	SET @SqlStmt3 = @SqlStmt3 + ' WHERE Name = ''' +  @Name + ''''


	BEGIN TRANSACTION 

	EXEC(@SqlStmt)
	SELECT @ResultLowCount = @@rowcount,  @ErrorCheck = @@error
	IF  @ResultLowCount = 0  GOTO ON_TRN_ERROR
	IF  @ErrorCheck  <> 0 GOTO ON_TRN_ERROR

	EXEC(@SqlStmt2)
	SELECT @ResultLowCount = @@rowcount,  @ErrorCheck = @@error
	IF  @ResultLowCount = 0  GOTO ON_TRN_ERROR
	IF  @ErrorCheck  <> 0 GOTO ON_TRN_ERROR
	
	EXEC(@SqlStmt3)
	SELECT @ResultLowCount = @@rowcount,  @ErrorCheck = @@error
	IF  @ResultLowCount = 0  GOTO ON_TRN_ERROR
	IF  @ErrorCheck  <> 0 GOTO ON_TRN_ERROR

ON_TRN_ERROR:
	IF ( @Result  <> 0 ) OR (@ErrorCheck <> 0)
	BEGIN
		IF @Result = 0 
			SET @Result = 0x09

		ROLLBACK TRAN
	END
	ELSE
		COMMIT	TRAN

ON_ERROR:
	IF @ErrorCheck <> 0
	BEGIN
		SET @Result = 0x09
	END 

	SELECT @Result	

	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END






GO
/****** Object:  StoredProcedure [dbo].[WZ_RenameCharacter]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_RenameCharacter] 

	@ServerCode smallint,
	@AccountID varchar(10),
	@Name varchar(10),
	@ChangeName varchar(10)
AS
BEGIN

	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Result	tinyint, 	@GUID int,	@CGUID	int

	SET LOCK_TIMEOUT	5000
	SET @Result = 0x00	

	IF NOT EXISTS ( SELECT Name FROM Character (READUNCOMMITTED) WHERE Name = @Name )
	BEGIN
		SET @Result	= 0x01		
		GOTO ProcEnd						
	END

	IF NOT EXISTS ( SELECT Name FROM Character (READUNCOMMITTED) WHERE Name = @ChangeName )
	BEGIN
		SET @Result	= 0x02					
		GOTO ProcEnd						
	END

	IF EXISTS( SELECT Name FROM GuildMember (READUNCOMMITTED)  WHERE Name = @Name )
	BEGIN
		SET @Result	= 0x03
		GOTO ProcEnd
	END	
	
	SELECT @GUID=GUID FROM T_CGuid WHERE Name=@Name

	DECLARE @cLevel int,@LevelUpPoint int,@Class tinyint  ,@Experience int ,@Strength smallint  ,@Dexterity smallint  ,@Vitality smallint  ,@Energy smallint  ,@Inventory varbinary (1080)  ,@MagicList varbinary (60)  ,@Money int  ,@Life real  ,@MaxLife real  ,@Mana real  ,@MaxMana real  ,@MapNumber smallint  ,@MapPosX smallint  ,@MapPosY smallint  ,@MapDir tinyint,@PkCount int ,@PkLevel int ,@PkTime int ,@MDate smalldatetime  ,@LDate smalldatetime  ,@CtlCode tinyint ,@DbVersion tinyint,@Quest varbinary (50)  ,@Leadership smallint,@ChatLimitTime smallint
	DECLARE @O_Name varchar(10),@O_SkillKey binary(10),@O_GameOption tinyint,@O_Qkey tinyint,@O_Wkey tinyint,@O_Ekey tinyint,@O_ChatWindow tinyint
	DECLARE @F_Name varchar(10),@F_FriendCount tinyint,@F_MemoCount int,@F_MemoTotal int

	SELECT @cLevel=cLevel ,@LevelUpPoint=LevelUpPoint ,@Class=Class,@Experience=Experience  ,@Strength=Strength,@Dexterity=Dexterity,@Vitality=Vitality,@Energy=Energy,
		 @Inventory=Inventory  ,@MagicList=MagicList  ,@Money=Money   ,@Life=Life   ,
		 @MaxLife=MaxLife   ,@Mana=Mana   ,@MaxMana=MaxMana   ,@MapNumber=MapNumber,
		 @MapPosX=MapPosX   ,@MapPosY=MapPosY   ,@MapDir=MapDir ,@PkCount=PkCount  ,
		 @PkLevel=PkLevel  ,@PkTime=PkTime  ,@MDate=MDate   ,@LDate=LDate   ,@CtlCode=CtlCode,
		 @Quest=Quest  ,@Leadership=Leadership ,@ChatLimitTime=ChatLimitTime 
		 FROM Character WHERE Name=@Name

	SELECT @O_Name=Name, @O_SkillKey=SkillKey, @O_GameOption=GameOption,  @O_Qkey=Qkey, @O_Wkey=Wkey, @O_Ekey=Ekey ,@O_ChatWindow=ChatWindow 
		 FROM OptionData WHERE Name=@Name

	BEGIN DISTRIBUTED TRAN

	IF NOT EXISTS ( SELECT  Id  FROM  AccountCharacter  WHERE Id = @AccountID )
		BEGIN					
			SET @Result  = 0x04
			GOTO ProcTrnEnd
		END
	ELSE
		BEGIN
			DECLARE @g1 varchar(10), @g2 varchar(10), @g3 varchar(10), @g4 varchar(10), @g5 varchar(10), @g6 varchar(10), @g7 varchar(10), @g8 varchar(10)						
			SELECT @g1=GameID1, @g2=GameID2, @g3=GameID3, @g4=GameID4, @g5=GameID5, @g6=GameID6, @g7=GameID7, @g8=GameID8 FROM dbo.AccountCharacter Where Id = @AccountID 			

			IF( @g1 = @Name )
				BEGIN
					UPDATE AccountCharacter SET  GameID1 = @ChangeName
					WHERE Id = @AccountID
		
					SET @Result  = @@Error
				END
			ELSE IF( @g2 = @Name )
				BEGIN
					UPDATE AccountCharacter SET  GameID2 = @ChangeName
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END
			ELSE IF( @g3 = @Name )
				BEGIN		
					UPDATE AccountCharacter SET  GameID3 = @ChangeName
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END
			ELSE IF( @g4 = @Name )
				BEGIN
					UPDATE AccountCharacter SET  GameID4 = @ChangeName
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END
			ELSE IF( @g5 = @Name )
				BEGIN
					UPDATE AccountCharacter SET  GameID5 = @ChangeName
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END
			ELSE IF( @g6 = @Name )
				BEGIN
					UPDATE AccountCharacter SET  GameID6 = @ChangeName
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END
			ELSE IF( @g7 = @Name )
				BEGIN
					UPDATE AccountCharacter SET  GameID7 = @ChangeName
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END
			ELSE IF( @g8 = @Name )
				BEGIN
					UPDATE AccountCharacter SET  GameID8 = @ChangeName
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END
			ELSE	
				BEGIN			
					SET @Result	= 0x05				
					GOTO ProcTrnEnd								
				END

			IF( @g1 = @ChangeName )
				BEGIN
					UPDATE AccountCharacter SET  GameID1 = ''
					WHERE Id = @AccountID
		
					SET @Result  = @@Error
				END
			ELSE IF( @g2 = @ChangeName )
				BEGIN
					UPDATE AccountCharacter SET  GameID2 = ''
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END
			ELSE IF( @g3 = @ChangeName )
				BEGIN	
					UPDATE AccountCharacter SET  GameID3 = ''
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END
			ELSE IF( @g4 = @ChangeName )
				BEGIN
					UPDATE AccountCharacter SET  GameID4 = ''
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END
			ELSE IF( @g5 = @ChangeName )
				BEGIN
					UPDATE AccountCharacter SET  GameID5 = ''
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END
			ELSE IF( @g6 = @ChangeName )
				BEGIN
					UPDATE AccountCharacter SET  GameID6 = ''
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END	
			ELSE IF( @g7 = @ChangeName )
				BEGIN
					UPDATE AccountCharacter SET  GameID7 = ''
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END	
			ELSE IF( @g8 = @ChangeName )
				BEGIN
					UPDATE AccountCharacter SET  GameID8 = ''
					WHERE Id = @AccountID

					SET @Result  = @@Error
				END	
			ELSE	
				BEGIN		
					SET @Result	= 0x05			
					GOTO ProcTrnEnd								
				END	
	 		END

	IF ( @Result <> 0 )
	BEGIN
		GOTO ProcTrnEnd	
	END

	IF ( @Result = 0 )
	BEGIN
		
		UPDATE Character	
		SET
		cLevel=@cLevel ,LevelUpPoint=@LevelUpPoint ,Class=@Class,Experience=@Experience  ,
		Strength=@Strength,Dexterity=@Dexterity,Vitality=@Vitality,Energy=@Energy,
		Inventory=@Inventory  ,MagicList=@MagicList  ,Money=@Money   ,Life=@Life   ,
		MaxLife=@MaxLife   ,Mana=@Mana   ,MaxMana=@MaxMana   ,MapNumber=@MapNumber,
		MapPosX=@MapPosX   ,MapPosY=@MapPosY   ,MapDir=@MapDir ,PkCount=@PkCount  ,
		PkLevel=@PkLevel  ,PkTime=@PkTime  ,MDate=@MDate   ,LDate=@LDate   ,CtlCode=@CtlCode,
		Quest=@Quest  ,Leadership=@Leadership ,ChatLimitTime=@ChatLimitTime 
		FROM Character WHERE Name=@ChangeName


		UPDATE OptionData SET SkillKey=@O_SkillKey,GameOption= @O_GameOption, Qkey= @O_Qkey, Wkey=@O_Wkey, Ekey=@O_Ekey ,ChatWindow=@O_ChatWindow 
		WHERE Name=@ChangeName
		
		SET @Result =  @@Error
		IF @Result <> 0 
			GOTO ProcTrnEnd	
	END 

ProcTrnEnd:
	IF ( @Result  <> 0 )
		ROLLBACK TRAN
	ELSE
		COMMIT TRAN


ProcEnd:
	SELECT @Result	

	SET NOCOUNT OFF
	SET XACT_ABORT OFF
END






GO
/****** Object:  StoredProcedure [dbo].[WZ_SetGuildDelete]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_SetGuildDelete]

	@GuildName	varchar(10)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Result	int
	SET @Result = 1 

	BEGIN TRANSACTION
		DELETE GuildMember WHERE G_Name = @GuildName		
		IF @@Error <> 0 
		BEGIN	
			SET @Result = 0
			GOTO PROBLEM	
		END

		DELETE Guild WHERE G_Name = @GuildName		
		IF @@Error <> 0 
			BEGIN
				SET @Result = 0
				GOTO PROBLEM	
			END
		ELSE GOTO SUCESS

	PROBLEM:
		ROLLBACK TRANSACTION
 
	SUCESS:
   		COMMIT TRANSACTION
				
	SELECT @Result AS Result
	SET NOCOUNT OFF
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_UserGuidCreate]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_UserGuidCreate]

	@Name 	varchar(10)
AS
BEGIN
	DECLARE @ErrorCode int
	DECLARE @UserGuid  int

	SET @ErrorCode = 1
	SET @UserGuid = -1

	SET XACT_ABORT ON
	SET NOCOUNT ON

	IF EXISTS ( SELECT GUID FROM T_CGuid WHERE Name=@Name ) 
	  BEGIN
		SET @ErrorCode = 0
		GOTO EndProc
	  END

	BEGIN TRAN

	INSERT INTO T_CGuid (Name) VALUES(@Name)

	IF ( @@Error  <> 0 )
	  BEGIN
		SET @ErrorCode = 2
	  END
	ELSE 
	  BEGIN
		select @UserGuid = GUID FROM T_CGuid where Name=@Name
		IF ( @@Error  <> 0 )
		  BEGIN
			SET @ErrorCode = 3
		  END
		ELSE 
		  BEGIN
			INSERT INTO T_FriendMain ( GUID, Name, FriendCount, MemoCount) VALUES(@UserGuid, @Name,1,10)
			IF ( @@Error  <> 0 )
				SET @ErrorCode = 4
		  END
	  END

EndTranProc:
	IF ( @@Error  <> 0 )
		ROLLBACK TRAN
	ELSE COMMIT TRAN

EndProc:
	SELECT @ErrorCode
	SET XACT_ABORT OFF
	SET NOCOUNT OFF
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_WaitFriendAdd]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_WaitFriendAdd]

	@Name 	varchar(10),
	@FriendName 	varchar(10)
AS
BEGIN
	DECLARE @ErrorCode int
	DECLARE @UserGuid  int
	DECLARE @FriendGuid  int
	DECLARE @FriendLevel  int

	SET NOCOUNT ON
	SET XACT_ABORT ON
	

	SET @ErrorCode = 0

	IF EXISTS (SELECT GUID FROM T_FriendMain WHERE Name=@Name)
  	  BEGIN
		select @UserGuid = GUID FROM T_FriendMain WHERE Name=@Name
		IF ( @@Error  <> 0 )
		BEGIN
			SET @ErrorCode = 2
			GOTO EndProc
		END
	  END
	ELSE
	  BEGIN
		SET @ErrorCode = 3
		GOTO EndProc
	  END

	IF EXISTS (SELECT GUID FROM T_FriendMain WHERE Name=@FriendName)
	  BEGIN
		SELECT @FriendGuid = GUID FROM T_FriendMain WHERE Name=@FriendName
		IF ( @@Error  <> 0 )
		BEGIN
			SET @ErrorCode	= 4
			GOTO EndProc
		END
  	  END
	ELSE
	  BEGIN
		SET @ErrorCode	= 5
		GOTO EndProc
  	  END

	SELECT @FriendLevel=cLevel FROM Character WHERE Name=@FriendName
	IF( @@Error <> 0 )
	  BEGIN
		SET @ErrorCode = 5		
		GOTO EndProc
	  END
	ELSE 
	  BEGIN
		IF( @FriendLevel < 6 )
		  BEGIN
			SET @ErrorCode = 6
			GOTO EndProc
		 END
	  END

	BEGIN TRAN

	INSERT INTO T_FriendList (GUID, FriendGuid, FriendName ) 
		VALUES ( @UserGuid, @FriendGuid, @FriendName)
	
	IF ( @@Error  <> 0 )
	BEGIN
		SET @ErrorCode = 7
		GOTO EndTranProc
	END

	IF EXISTS (SELECT GUID FROM T_FriendList WHERE GUID = @FriendGuid AND FriendGuid =  @UserGuid )
	 BEGIN
		UPDATE T_FriendList SET Del=0 WHERE GUID=@FriendGuid AND FriendGuid=@UserGuid
		SET @ErrorCode = 8
		GOTO EndTranProc
	END

	INSERT INTO T_WaitFriend (GUID, FriendName, FriendGuid ) 
				VALUES ( @FriendGuid, @Name, @UserGuid)
	
	IF ( @@Error  <> 0 )
	BEGIN
		SET @ErrorCode = 6
		GOTO EndTranProc
	END

EndTranProc:
	IF ( (@ErrorCode  = 0) OR (@ErrorCode  = 8) )
	  BEGIN
		COMMIT TRAN
	  END
	ELSE
	  BEGIN
		ROLLBACK TRAN
	  END
	
EndProc:

	SET	XACT_ABORT OFF

	SET NOCOUNT OFF

	SELECT @ErrorCode
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_WaitFriendDel]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WZ_WaitFriendDel]

	@Name		 varchar(10), 
	@FriendName 	 varchar(10)
AS
BEGIN
	DECLARE @ErrorCode int
	DECLARE @UserGuid  int
	DECLARE @FriendGuid  int

	SET NOCOUNT ON

	SET @ErrorCode = 0

	IF NOT EXISTS ( select GUID FROM T_FriendMain where Name=@Name)
	  BEGIN
		SET @ErrorCode = 3
		GOTO EndProc

	  END
	ELSE
	  BEGIN
		SELECT @UserGuid = GUID FROM T_FriendMain where Name=@Name
	
		IF ( @@Error  <> 0   )
		BEGIN
			SET @ErrorCode = 4
		END
	  END

	IF NOT EXISTS ( select GUID FROM T_FriendMain where Name=@FriendName )
	  BEGIN
		SET @ErrorCode = 5
		GOTO EndProc
	  END
 	ELSE
	  BEGIN
		SELECT @FriendGuid = GUID FROM T_FriendMain where Name=@FriendName

		IF ( @@Error  <> 0 )
		BEGIN
			SET @ErrorCode = 6
		END

	END

	IF NOT EXISTS (SELECT GUID FROM T_WaitFriend where GUID = @UserGuid AND FriendGuid = @FriendGuid  )
	BEGIN
		SET @ErrorCode = 2
		GOTO EndProc
	END
	
	DELETE FROM T_WaitFriend where GUID = @UserGuid AND FriendGuid = @FriendGuid  
	
	IF ( @@Error  <> 0 )
		SET @ErrorCode	= @@Error

	IF( @ErrorCode = 0 )
	BEGIN
		UPDATE T_FriendList SET Del=1 where GUID=@FriendGuid AND FriendGuid=@UserGuid
	END

EndProc:

	SET NOCOUNT OFF
	SELECT @ErrorCode
END




































GO
/****** Object:  StoredProcedure [dbo].[WZ_WriteMail]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[WZ_WriteMail]

	@SendName 	varchar(10), 
	@RecvName 	varchar(10),
	@Subject	varchar(32),
	@Dir		tinyint,
	@Act		tinyint
AS
BEGIN
	SET NOCOUNT ON

	DECLARE 	@userguid	int
	DECLARE 	@memocount	int
	DECLARE	@return		int
	DECLARE	@MemoTotal	int
	DECLARE 	@FriendLevel  	int

	SET	XACT_ABORT ON

	SET @return	= 0

	SELECT @userguid=GUID, @MemoTotal=MemoTotal FROM T_FriendMain where Name= @RecvName
	IF( @@ROWCOUNT < 1 )
	BEGIN
		SET @return = 2
		GOTO EndProc
	END

	IF( @MemoTotal > 49 )
	BEGIN
		SET @return = 5
		GOTO EndProc
	END

	SELECT @FriendLevel=cLevel FROM Character WHERE Name=@RecvName
	IF( @@Error <> 0 )
	 BEGIN
		SET @return = 2		
		GOTO EndProc
	 END
	ELSE 
	  BEGIN
		IF( @FriendLevel < 6 )
		 BEGIN
			SET @return = 6
			GOTO EndProc
		END
	  END

	BEGIN TRANSACTION

	UPDATE T_FriendMain set @memocount = MemoCount = MemoCount+1, MemoTotal=MemoTotal+1 WHERE Name = @RecvName
	IF( @@error <> 0 )
	BEGIN
		SET @return = 3
		GOTO EndProcTran
	END	

	INSERT INTO T_FriendMail (MemoIndex, GUID, FriendName, wDate, Subject,bRead,  Dir,  Act) VALUES(@memocount,@userguid, @SendName, getdate(), @Subject, 0,  @Dir, @Act)
	IF( @@error <> 0 )
	BEGIN
		SET @return = 4
		GOTO EndProcTran
	END

EndProcTran:
	IF ( @return  <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION
		SET @return = @memocount
	END
	
EndProc:
	SET XACT_ABORT OFF
	SET NOCOUNT OFF
	
	SELECT @return, @userguid
END













GO
/****** Object:  UserDefinedFunction [dbo].[fn_md5]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_md5] (@data VARCHAR(20), @data2 VARCHAR(10))
RETURNS BINARY(16) AS
BEGIN
DECLARE @hash BINARY(16)
EXEC master.dbo.XP_MD5_EncodeKeyVal @data, @data2, @hash OUT
RETURN @hash
END


















GO
/****** Object:  UserDefinedFunction [dbo].[IGC_FriendChat_GetMessageLogs]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[IGC_FriendChat_GetMessageLogs] (@Name varchar(10), @FriendName varchar(10), @RecordCount	int)
RETURNS @OrderShipperTab TABLE
   (
    Name   nvarchar(10),
    [Text]       nvarchar(135)
   )
AS
BEGIN
DECLARE @LastID int;
SET @LastID = (SELECT TOP 1 ID FROM IGC_FriendChat_MessageLog  WHERE (Name = @Name AND FriendName = @FriendName) OR (Name = @FriendName AND FriendName = @Name) ORDER BY ID DESC);
INSERT INTO @OrderShipperTab SELECT Name, [Text] FROM IGC_FriendChat_MessageLog WHERE (Name = @Name AND FriendName = @FriendName) OR (Name = @FriendName AND FriendName = @Name) AND ID <= @LastID AND ID > (@LastID - @RecordCount);
RETURN
END




































GO
/****** Object:  Table [dbo].[AccountCharacter]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccountCharacter](
	[Number] [int] IDENTITY(1,1) NOT NULL,
	[Id] [varchar](10) NOT NULL,
	[GameID1] [varchar](10) NULL,
	[GameID2] [varchar](10) NULL,
	[GameID3] [varchar](10) NULL,
	[GameID4] [varchar](10) NULL,
	[GameID5] [varchar](10) NULL,
	[GameIDC] [varchar](10) NULL,
	[MoveCnt] [tinyint] NULL,
	[Summoner] [tinyint] NOT NULL,
	[WarehouseExpansion] [tinyint] NOT NULL,
	[RageFighter] [tinyint] NOT NULL,
	[SecCode] [int] NOT NULL,
	[GrowLancer] [tinyint] NOT NULL,
	[MagicGladiator] [tinyint] NOT NULL,
	[DarkLord] [tinyint] NOT NULL,
	[GameID6] [varchar](10) NULL,
	[GameID7] [varchar](10) NULL,
	[GameID8] [varchar](10) NULL,
 CONSTRAINT [PK_AccountCharacter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[C_Monster_KillCount]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[C_Monster_KillCount](
	[name] [varchar](10) NOT NULL,
	[MonsterId] [int] NOT NULL,
	[count] [int] NOT NULL,
 CONSTRAINT [IX_C_Monster_KillCount] UNIQUE NONCLUSTERED 
(
	[name] ASC,
	[MonsterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[C_PlayerKiller_Info]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[C_PlayerKiller_Info](
	[Victim] [varchar](20) NOT NULL,
	[Killer] [varchar](20) NOT NULL,
	[KillDate] [datetime] NOT NULL,
	[id] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_C_PlayerKiller_Info] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Character]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Character](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[cLevel] [int] NULL,
	[LevelUpPoint] [int] NULL,
	[Class] [tinyint] NULL,
	[Experience] [bigint] NULL,
	[Strength] [int] NULL,
	[Dexterity] [int] NULL,
	[Vitality] [int] NULL,
	[Energy] [int] NULL,
	[MagicList] [varbinary](1850) NULL,
	[Money] [int] NULL,
	[Life] [real] NULL,
	[MaxLife] [real] NULL,
	[Mana] [real] NULL,
	[MaxMana] [real] NULL,
	[MapNumber] [smallint] NULL,
	[MapPosX] [smallint] NULL,
	[MapPosY] [smallint] NULL,
	[MapDir] [tinyint] NULL,
	[PkCount] [int] NULL,
	[PkLevel] [int] NULL,
	[PkTime] [int] NULL,
	[MDate] [smalldatetime] NULL,
	[LDate] [smalldatetime] NULL,
	[CtlCode] [tinyint] NULL,
	[Quest] [varbinary](100) NULL,
	[Leadership] [int] NULL,
	[ChatLimitTime] [smallint] NOT NULL,
	[FruitPoint] [int] NOT NULL,
	[RESETS] [int] NOT NULL,
	[Inventory] [varbinary](7648) NULL,
	[Married] [int] NULL,
	[MarryName] [varchar](10) NULL,
	[mLevel] [int] NOT NULL,
	[mlPoint] [int] NOT NULL,
	[mlExperience] [bigint] NOT NULL,
	[mlNextExp] [bigint] NOT NULL,
	[InventoryExpansion] [tinyint] NOT NULL,
	[WinDuels] [int] NOT NULL,
	[LoseDuels] [int] NOT NULL,
	[PenaltyMask] [int] NOT NULL,
	[BlockChatTime] [bigint] NULL,
	[Ruud] [int] NOT NULL,
	[OpenHuntingLog] [tinyint] NOT NULL,
	[MuHelperData] [varbinary](512) NULL,
	[StatCoin] [int] NOT NULL,
	[StatGP] [int] NOT NULL,
	[i4thSkillPoint] [int] NOT NULL,
	[AddStrength] [int] NOT NULL,
	[AddDexterity] [int] NOT NULL,
	[AddVitality] [int] NOT NULL,
	[AddEnergy] [int] NOT NULL,
 CONSTRAINT [PK_Character] PRIMARY KEY NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ConnectionHistory]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ConnectionHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [varchar](10) NULL,
	[ServerName] [varchar](40) NULL,
	[IP] [varchar](16) NULL,
	[Date] [datetime] NULL,
	[State] [varchar](12) NULL,
	[HWID] [varchar](100) NULL,
 CONSTRAINT [PK__Connecti__3214EC27FA8B4F22] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DefaultClassType]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DefaultClassType](
	[Class] [tinyint] NOT NULL,
	[Strength] [smallint] NULL,
	[Dexterity] [smallint] NULL,
	[Vitality] [smallint] NULL,
	[Energy] [smallint] NULL,
	[MagicList] [varbinary](1850) NULL,
	[Life] [real] NULL,
	[MaxLife] [real] NULL,
	[Mana] [real] NULL,
	[MaxMana] [real] NULL,
	[MapNumber] [smallint] NULL,
	[MapPosX] [smallint] NULL,
	[MapPosY] [smallint] NULL,
	[Quest] [varbinary](100) NULL,
	[DbVersion] [tinyint] NULL,
	[Leadership] [smallint] NULL,
	[Level] [smallint] NULL,
	[LevelUpPoint] [smallint] NULL,
	[Inventory] [varbinary](7648) NULL,
	[LevelLife] [real] NULL,
	[LevelMana] [real] NULL,
	[VitalityToLife] [real] NULL,
	[EnergyToMana] [real] NULL,
 CONSTRAINT [PK_DefaultClassType] PRIMARY KEY CLUSTERED 
(
	[Class] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GameServerInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameServerInfo](
	[Number] [int] NOT NULL,
	[ItemCount] [bigint] NULL,
	[ZenCount] [int] NULL,
	[GmItemCount] [int] NULL,
	[AceItemCount] [int] NULL,
	[GensRankingMonth] [int] NULL,
	[GCItemCount] [bigint] NULL,
 CONSTRAINT [PK_GameServerInfo] PRIMARY KEY NONCLUSTERED 
(
	[Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Guild]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Guild](
	[G_Name] [varchar](8) NOT NULL,
	[G_Mark] [varbinary](32) NULL,
	[G_Score] [int] NOT NULL,
	[G_Master] [varchar](10) NULL,
	[G_Count] [int] NULL,
	[G_Notice] [varchar](60) NULL,
	[Number] [int] IDENTITY(1,1) NOT NULL,
	[G_Type] [int] NOT NULL,
	[G_Rival] [int] NOT NULL,
	[G_Union] [int] NOT NULL,
	[G_Warehouse] [varbinary](3840) NULL,
	[G_WHPassword] [int] NULL,
	[G_WHMoney] [int] NULL,
 CONSTRAINT [PK_Guild] PRIMARY KEY CLUSTERED 
(
	[G_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GuildMember]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GuildMember](
	[Name] [varchar](10) NOT NULL,
	[G_Name] [varchar](8) NOT NULL,
	[G_Level] [tinyint] NULL,
	[G_Status] [tinyint] NOT NULL,
 CONSTRAINT [PK_GuildMember] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_ARCA_BATTLE_GUILD_JOIN_INFO]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_ARCA_BATTLE_GUILD_JOIN_INFO](
	[G_Name] [varchar](8) NOT NULL,
	[G_Master] [varchar](10) NOT NULL,
	[Number] [int] NOT NULL,
	[JoinDate] [smalldatetime] NULL,
	[GroupNum] [tinyint] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_ARCA_BATTLE_GUILDMARK_REG]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_ARCA_BATTLE_GUILDMARK_REG](
	[Index] [int] IDENTITY(1,1) NOT NULL,
	[G_Number] [int] NOT NULL,
	[G_Name] [varchar](8) NOT NULL,
	[G_Master] [varchar](10) NOT NULL,
	[RegDate] [smalldatetime] NULL,
	[GuildRegRank] [int] NULL,
	[MarkCnt] [bigint] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_ARCA_BATTLE_MEMBER_JOIN_INFO]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_ARCA_BATTLE_MEMBER_JOIN_INFO](
	[G_Name] [varchar](8) NULL,
	[Number] [int] NOT NULL,
	[CharName] [varchar](10) NOT NULL,
	[JoinDate] [smalldatetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_ARCA_BATTLE_PROC_STATE]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IGC_ARCA_BATTLE_PROC_STATE](
	[Proc_State] [tinyint] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IGC_ARCA_BATTLE_WIN_GUILD_INFO]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_ARCA_BATTLE_WIN_GUILD_INFO](
	[G_Name] [varchar](8) NOT NULL,
	[G_Number] [int] NOT NULL,
	[WinDate] [smalldatetime] NOT NULL,
	[OuccupyObelisk] [tinyint] NOT NULL,
	[ObeliskGroup] [tinyint] NOT NULL,
	[LeftTime] [bigint] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_BlockChat]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_BlockChat](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[BlockedName] [varchar](10) NOT NULL,
 CONSTRAINT [PK_IGC_BlockChat] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_ClassQuest_MonsterKill]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_ClassQuest_MonsterKill](
	[CharacterName] [varchar](10) NOT NULL,
	[QuestIndex] [smallint] NOT NULL,
	[MonsterIndex_1] [smallint] NOT NULL,
	[MonsterKillCount_1] [smallint] NOT NULL,
	[MonsterIndex_2] [smallint] NOT NULL,
	[MonsterKillCount_2] [smallint] NOT NULL,
	[MonsterIndex_3] [smallint] NOT NULL,
	[MonsterKillCount_3] [smallint] NOT NULL,
	[MonsterIndex_4] [smallint] NOT NULL,
	[MonsterKillCount_4] [smallint] NOT NULL,
	[MonsterIndex_5] [smallint] NOT NULL,
	[MonsterKillCount_5] [smallint] NOT NULL,
 CONSTRAINT [PK_IGC_ClassQuest_MonsterKill] PRIMARY KEY CLUSTERED 
(
	[CharacterName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_DuelLog]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_DuelLog](
	[Player1] [varchar](10) NOT NULL,
	[Player2] [varchar](10) NOT NULL,
	[Score1] [smallint] NOT NULL,
	[Score2] [smallint] NOT NULL,
	[Winner] [smallint] NOT NULL,
	[Date] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_EventMapEnterLimit]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_EventMapEnterLimit](
	[CharacterName] [varchar](10) NOT NULL,
	[BloodCastle] [tinyint] NOT NULL,
	[ChaosCastle] [tinyint] NOT NULL,
	[DevilSquare] [tinyint] NOT NULL,
	[DoppelGanger] [tinyint] NOT NULL,
	[ImperialGuardian] [tinyint] NOT NULL,
	[IllusionTempleRenewal] [tinyint] NOT NULL,
	[LastDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_IGC_EventMapEnterLimit] PRIMARY KEY CLUSTERED 
(
	[CharacterName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_EvolutionMonster]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_EvolutionMonster](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[MonsterIndex1] [smallint] NOT NULL,
	[MonsterLevel1] [smallint] NOT NULL,
	[KillCount1] [int] NULL,
	[MonsterIndex2] [smallint] NOT NULL,
	[MonsterLevel2] [smallint] NOT NULL,
	[KillCount2] [int] NULL,
	[MonsterIndex3] [smallint] NOT NULL,
	[MonsterLevel3] [smallint] NOT NULL,
	[KillCount3] [int] NULL,
	[MonsterIndex4] [smallint] NOT NULL,
	[MonsterLevel4] [smallint] NOT NULL,
	[KillCount4] [int] NULL,
	[MonsterIndex5] [smallint] NOT NULL,
	[MonsterLevel5] [smallint] NOT NULL,
	[KillCount5] [int] NULL,
	[AccumDmg] [bigint] NOT NULL,
 CONSTRAINT [PK_IGC_EvolutionMonster_AccountID_Name] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_FavouriteWarpData]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_FavouriteWarpData](
	[Name] [varchar](10) NOT NULL,
	[WarpIndex_1] [smallint] NOT NULL,
	[WarpMapNum_1] [smallint] NOT NULL,
	[WarpIndex_2] [smallint] NOT NULL,
	[WarpMapNum_2] [smallint] NOT NULL,
	[WarpIndex_3] [smallint] NOT NULL,
	[WarpMapNum_3] [smallint] NOT NULL,
	[WarpIndex_4] [smallint] NOT NULL,
	[WarpMapNum_4] [smallint] NOT NULL,
	[WarpIndex_5] [smallint] NOT NULL,
	[WarpMapNum_5] [smallint] NOT NULL,
 CONSTRAINT [PK_IGC_FavouriteWarpData] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_FriendChat_BannedCharacters]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IGC_FriendChat_BannedCharacters](
	[Name] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_IGC_FriendChat_BannedCharacters] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IGC_FriendChat_BannedIPs]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IGC_FriendChat_BannedIPs](
	[IP] [nvarchar](15) NOT NULL,
 CONSTRAINT [PK_IGC_FriendChat_BannedIPs] PRIMARY KEY CLUSTERED 
(
	[IP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IGC_FriendChat_MessageLog]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IGC_FriendChat_MessageLog](
	[Name] [nvarchar](10) NOT NULL,
	[FriendName] [nvarchar](2800) NULL,
	[Text] [nvarchar](135) NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IGC_Gens]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_Gens](
	[Name] [varchar](10) NOT NULL,
	[Influence] [tinyint] NOT NULL,
	[Rank] [int] NOT NULL,
	[Points] [int] NOT NULL,
	[Reward] [tinyint] NOT NULL,
	[Class] [smallint] NOT NULL,
	[LeaveDate] [smalldatetime] NULL,
 CONSTRAINT [PK_IGC_Gens] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_GensAbuse]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_GensAbuse](
	[Name] [varchar](10) NOT NULL,
	[KillName] [varchar](10) NOT NULL,
	[KillCount] [smallint] NULL,
 CONSTRAINT [IX_IGC_GensAbuse] UNIQUE NONCLUSTERED 
(
	[Name] ASC,
	[KillName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_GremoryCase]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_GremoryCase](
	[GremoryCaseIndex] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[GCType] [tinyint] NOT NULL,
	[GiveType] [tinyint] NOT NULL,
	[ItemType] [tinyint] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[ItemDur] [tinyint] NOT NULL,
	[Skill] [tinyint] NOT NULL,
	[Luck] [int] NOT NULL,
	[Opt] [tinyint] NOT NULL,
	[SetOpt] [tinyint] NOT NULL,
	[NewOpt] [int] NOT NULL,
	[BonusSocketOpt] [tinyint] NOT NULL,
	[SocketOpt1] [tinyint] NOT NULL,
	[SocketOpt2] [tinyint] NOT NULL,
	[SocketOpt3] [tinyint] NOT NULL,
	[SocketOpt4] [tinyint] NOT NULL,
	[SocketOpt5] [tinyint] NOT NULL,
	[UsedInfo] [tinyint] NOT NULL,
	[Serial] [bigint] NOT NULL,
	[RecvDate] [smalldatetime] NOT NULL,
	[ReceiptDate] [smalldatetime] NULL,
	[RecvExpireDate] [smalldatetime] NOT NULL,
	[ItemExpireDate] [smalldatetime] NOT NULL,
	[RecvDateConvert] [bigint] NOT NULL,
	[RecvExpireDateConvert] [bigint] NOT NULL,
	[ItemExpireDateConvert] [bigint] NOT NULL,
 CONSTRAINT [PK_IGC_GremoryCase] PRIMARY KEY NONCLUSTERED 
(
	[GremoryCaseIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_GuildMatching]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_GuildMatching](
	[identNo] [bigint] IDENTITY(1,1) NOT NULL,
	[GuildName] [varchar](8) NOT NULL,
	[GuildNum] [int] NULL,
	[GuildMasterName] [varchar](10) NOT NULL,
	[GuildMasterLevel] [smallint] NULL,
	[GuildMasterClass] [tinyint] NULL,
	[GuildMemberCnt] [smallint] NULL,
	[Memo] [varchar](40) NOT NULL,
	[InterestType] [tinyint] NULL,
	[LevelRange] [tinyint] NULL,
	[ClassType] [tinyint] NULL,
	[GensType] [tinyint] NULL,
	[RegDate] [datetime] NULL,
 CONSTRAINT [PK_IGC_GuildMatching] PRIMARY KEY NONCLUSTERED 
(
	[identNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_HuntingRecord]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_HuntingRecord](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[MapIndex] [int] NOT NULL,
	[mYear] [int] NULL,
	[mMonth] [int] NULL,
	[mDay] [int] NULL,
	[CurrentLevel] [int] NULL,
	[HuntingAccrueSecond] [int] NULL,
	[NormalAccrueDamage] [bigint] NULL,
	[PentagramAccrueDamage] [bigint] NULL,
	[HealAccrueValue] [int] NULL,
	[MonsterKillCount] [int] NULL,
	[AccrueExp] [bigint] NULL,
	[Class] [int] NULL,
	[MaxNormalDamage] [int] NULL,
	[MinNormalDamage] [int] NULL,
	[MaxPentagramDamage] [int] NULL,
	[MinPentagramDamage] [int] NULL,
	[GetNormalAccrueDamage] [int] NULL,
	[GetPentagramAccrueDamage] [int] NULL,
	[mDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_HuntingRecordOption]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_HuntingRecordOption](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[UserOpen] [tinyint] NOT NULL,
 CONSTRAINT [PK_IGC_HuntingRecordOption_Name_AccountID] PRIMARY KEY CLUSTERED 
(
	[Name] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_LabyrinthClearLog]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_LabyrinthClearLog](
	[mDate] [datetime] NOT NULL,
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[mDimensionLevel] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_LabyrinthInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_LabyrinthInfo](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[DimensionLevel] [tinyint] NOT NULL,
	[ConfigNum] [smallint] NOT NULL,
	[CurrentZone] [tinyint] NOT NULL,
	[VisitedCnt] [tinyint] NOT NULL,
	[VisitedList] [binary](200) NOT NULL,
	[EntireExp] [bigint] NOT NULL,
	[EntireMonKillCnt] [bigint] NOT NULL,
	[ClearCnt] [int] NOT NULL,
	[ClearState] [tinyint] NOT NULL,
	[EndTime] [smalldatetime] NULL,
 CONSTRAINT [PK_IGC_LabyrinthInfo_Name] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_LabyrinthMissionInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_LabyrinthMissionInfo](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[ZoneNumber] [tinyint] NOT NULL,
	[MissionType] [tinyint] NOT NULL,
	[MissionValue] [int] NOT NULL,
	[AcquisitionValue] [int] NOT NULL,
	[MissionState] [tinyint] NULL,
	[IsMainMission] [tinyint] NOT NULL,
	[MainMissionOrder] [tinyint] NOT NULL,
	[RewardItemType] [smallint] NULL,
	[RewardItemIndex] [smallint] NULL,
	[RewardValue] [int] NULL,
	[RewardCheckState] [tinyint] NULL,
 CONSTRAINT [PK_IGC_LabyrinthMissionInfo_Name_ZoneNumber_MainMissionOrder] PRIMARY KEY CLUSTERED 
(
	[Name] ASC,
	[ZoneNumber] ASC,
	[MainMissionOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_MachineID_Banned]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_MachineID_Banned](
	[HWID] [varchar](100) NOT NULL,
	[Note] [varchar](200) NULL,
 CONSTRAINT [PK_IGC_MachineID_Banned] PRIMARY KEY CLUSTERED 
(
	[HWID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_Muun_ConditionInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_Muun_ConditionInfo](
	[Name] [varchar](10) NOT NULL,
	[SlotIndex] [tinyint] NOT NULL,
	[ConditionType] [tinyint] NOT NULL,
	[Value] [int] NOT NULL,
 CONSTRAINT [PK_IGC_Muun_ConditionInfo_Name_SlotIndex] PRIMARY KEY CLUSTERED 
(
	[Name] ASC,
	[SlotIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_Muun_Inventory]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_Muun_Inventory](
	[Name] [varchar](12) NOT NULL,
	[Items] [varbinary](3296) NULL,
 CONSTRAINT [PK_PetWarehouser] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_Muun_Period]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_Muun_Period](
	[Name] [varchar](10) NOT NULL,
	[ItemType] [int] NOT NULL,
	[UsedInfo] [tinyint] NOT NULL,
	[Serial] [bigint] NOT NULL,
	[GetItemDate] [smalldatetime] NOT NULL,
	[ExpireDate] [smalldatetime] NULL,
	[ExpireDateConvert] [bigint] NOT NULL,
 CONSTRAINT [PK_IGC_Muun_Period_Name_ItemType] PRIMARY KEY CLUSTERED 
(
	[Name] ASC,
	[ItemType] ASC,
	[Serial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_PartyMatching]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_PartyMatching](
	[IdentNo] [bigint] IDENTITY(1,1) NOT NULL,
	[PartyLeaderName] [varchar](10) NULL,
	[Title] [varchar](40) NULL,
	[MinLevel] [smallint] NULL,
	[MaxLevel] [smallint] NULL,
	[HuntingGround] [smallint] NULL,
	[WantedClass] [tinyint] NULL,
	[CurMemberCount] [tinyint] NULL,
	[AcceptType] [tinyint] NULL,
	[UsePassWord] [tinyint] NULL,
	[PassWord] [varchar](4) NULL,
	[WantedClassDetailInfo1] [tinyint] NULL,
	[WantedClassDetailInfo2] [tinyint] NULL,
	[WantedClassDetailInfo3] [tinyint] NULL,
	[WantedClassDetailInfo4] [tinyint] NULL,
	[WantedClassDetailInfo5] [tinyint] NULL,
	[WantedClassDetailInfo6] [tinyint] NULL,
	[WantedClassDetailInfo7] [tinyint] NULL,
	[LeaderChannel] [tinyint] NULL,
	[GensType] [tinyint] NULL,
	[LeaderLevel] [smallint] NULL,
	[LeaderClass] [tinyint] NULL,
	[RegDate] [datetime] NULL,
 CONSTRAINT [PK_IGC_PartyMatching] PRIMARY KEY CLUSTERED 
(
	[IdentNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_PentagramInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_PentagramInfo](
	[UserGuid] [int] NOT NULL,
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NULL,
	[JewelPos] [tinyint] NOT NULL,
	[PentagramInfo] [varbinary](4250) NULL,
	[id] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_IGC_PentagramInfo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_PeriodBuffInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_PeriodBuffInfo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CharacterName] [varchar](10) NOT NULL,
	[BuffIndex] [smallint] NOT NULL,
	[EffectType1] [smallint] NOT NULL,
	[EffectType2] [smallint] NULL,
	[ExpireDate] [bigint] NOT NULL,
	[Duration] [int] NOT NULL,
 CONSTRAINT [PK_IGC_PeriodBuffInfo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_PeriodItemInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_PeriodItemInfo](
	[PeriodIndex] [int] IDENTITY(1,1) NOT NULL,
	[UserGuid] [int] NOT NULL,
	[CharacterName] [char](10) NULL,
	[ItemCode] [int] NOT NULL,
	[EffectType1] [tinyint] NOT NULL,
	[EffectType2] [tinyint] NULL,
	[UsedTime] [int] NOT NULL,
	[LeftTime] [int] NOT NULL,
	[BuyDate] [smalldatetime] NOT NULL,
	[ExpireDate] [smalldatetime] NOT NULL,
	[UsedInfo] [tinyint] NOT NULL,
	[OptionType] [tinyint] NOT NULL,
	[ItemType] [tinyint] NOT NULL,
	[SerialCode] [bigint] NULL,
	[BuyDateConvert] [bigint] NULL,
	[ExpireDateConvert] [bigint] NULL,
	[SetExpire] [tinyint] NULL,
 CONSTRAINT [PK_IGC_PeriodItemInfo_PeriodIndex] PRIMARY KEY NONCLUSTERED 
(
	[PeriodIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_RestoreItem_Inventory]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_RestoreItem_Inventory](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[RestoreInven] [varbinary](230) NOT NULL,
 CONSTRAINT [PK_IGC_RestoreItem_Inventory_Name_AccountID] PRIMARY KEY CLUSTERED 
(
	[Name] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_WaitGuildMatching]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_WaitGuildMatching](
	[identNo] [bigint] IDENTITY(1,1) NOT NULL,
	[GuildNumber] [int] NOT NULL,
	[GuildName] [varchar](8) NOT NULL,
	[GuildMasterName] [varchar](10) NOT NULL,
	[ApplicantName] [varchar](10) NOT NULL,
	[ApplicantClass] [tinyint] NULL,
	[ApplicantLevel] [smallint] NULL,
	[State] [tinyint] NULL,
	[RegDate] [datetime] NULL,
 CONSTRAINT [PK_IGC_WaitGuildMatching] PRIMARY KEY NONCLUSTERED 
(
	[identNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IGC_WaitPartyMatching]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IGC_WaitPartyMatching](
	[IdentNo] [bigint] IDENTITY(1,1) NOT NULL,
	[LeaderName] [varchar](10) NULL,
	[MemberName] [varchar](10) NULL,
	[Class] [tinyint] NULL,
	[MemberLevel] [smallint] NULL,
	[MemberDBNumber] [int] NULL,
	[RegDate] [datetime] NULL,
 CONSTRAINT [PK_IGC_WaitPartyMatching] PRIMARY KEY CLUSTERED 
(
	[IdentNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MEMB_CREDITS]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MEMB_CREDITS](
	[memb___id] [varchar](10) NOT NULL,
	[credits] [int] NOT NULL,
	[used] [int] NULL,
 CONSTRAINT [PK_MEMB_CREDITS] PRIMARY KEY CLUSTERED 
(
	[memb___id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MEMB_INFO]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MEMB_INFO](
	[memb_guid] [int] IDENTITY(1,1) NOT NULL,
	[memb___id] [varchar](10) NOT NULL,
	[memb__pwd] [varchar](20) NOT NULL,
	[memb_name] [varchar](10) NOT NULL,
	[sno__numb] [char](13) NOT NULL,
	[post_code] [char](6) NULL,
	[addr_info] [varchar](50) NULL,
	[addr_deta] [varchar](50) NULL,
	[tel__numb] [varchar](20) NULL,
	[phon_numb] [varchar](15) NULL,
	[mail_addr] [varchar](50) NULL,
	[fpas_ques] [varchar](50) NULL,
	[fpas_answ] [varchar](50) NULL,
	[job__code] [char](2) NULL,
	[appl_days] [datetime] NULL,
	[modi_days] [datetime] NULL,
	[out__days] [datetime] NULL,
	[true_days] [datetime] NULL,
	[mail_chek] [char](1) NULL,
	[bloc_code] [char](1) NOT NULL,
	[ctl1_code] [char](1) NOT NULL,
	[cspoints] [int] NULL,
	[VipType] [int] NULL,
	[VipStart] [datetime] NULL,
	[VipDays] [datetime] NULL,
	[JoinDate] [varchar](23) NULL,
 CONSTRAINT [PK_MEMB_INFO_1] PRIMARY KEY NONCLUSTERED 
(
	[memb_guid] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_MEMB_INFO_1] UNIQUE NONCLUSTERED 
(
	[memb___id] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MEMB_STAT]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MEMB_STAT](
	[memb___id] [varchar](10) NOT NULL,
	[ConnectStat] [tinyint] NULL,
	[ServerName] [varchar](20) NULL,
	[IP] [varchar](15) NULL,
	[ConnectTM] [smalldatetime] NULL,
	[DisConnectTM] [smalldatetime] NULL,
 CONSTRAINT [PK_MEMB_STAT] PRIMARY KEY CLUSTERED 
(
	[memb___id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Mu_DBID]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Mu_DBID](
	[DESC] [varchar](20) NOT NULL,
	[Version] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MuCastle_DATA]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MuCastle_DATA](
	[MAP_SVR_GROUP] [int] NOT NULL,
	[SIEGE_START_DATE] [datetime] NOT NULL,
	[SIEGE_END_DATE] [datetime] NOT NULL,
	[SIEGE_GUILDLIST_SETTED] [bit] NOT NULL,
	[SIEGE_ENDED] [bit] NOT NULL,
	[CASTLE_OCCUPY] [bit] NOT NULL,
	[OWNER_GUILD] [varchar](8) NOT NULL,
	[MONEY] [money] NOT NULL,
	[TAX_RATE_CHAOS] [int] NOT NULL,
	[TAX_RATE_STORE] [int] NOT NULL,
	[TAX_HUNT_ZONE] [int] NOT NULL,
 CONSTRAINT [PK_MuCastle_DATA] PRIMARY KEY CLUSTERED 
(
	[MAP_SVR_GROUP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MuCastle_MONEY_STATISTICS]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MuCastle_MONEY_STATISTICS](
	[MAP_SVR_GROUP] [int] NOT NULL,
	[LOG_DATE] [datetime] NOT NULL,
	[MONEY_CHANGE] [money] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MuCastle_NPC]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MuCastle_NPC](
	[MAP_SVR_GROUP] [int] NOT NULL,
	[NPC_NUMBER] [int] NOT NULL,
	[NPC_INDEX] [int] NOT NULL,
	[NPC_DF_LEVEL] [int] NOT NULL,
	[NPC_RG_LEVEL] [int] NOT NULL,
	[NPC_MAXHP] [int] NOT NULL,
	[NPC_HP] [int] NOT NULL,
	[NPC_X] [tinyint] NOT NULL,
	[NPC_Y] [tinyint] NOT NULL,
	[NPC_DIR] [tinyint] NOT NULL,
	[NPC_CREATEDATE] [datetime] NOT NULL,
 CONSTRAINT [IX_NPC_SUBKEY] UNIQUE NONCLUSTERED 
(
	[MAP_SVR_GROUP] ASC,
	[NPC_NUMBER] ASC,
	[NPC_INDEX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MuCastle_REG_SIEGE]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MuCastle_REG_SIEGE](
	[MAP_SVR_GROUP] [int] NOT NULL,
	[REG_SIEGE_GUILD] [varchar](8) NOT NULL,
	[REG_MARKS] [int] NOT NULL,
	[IS_GIVEUP] [tinyint] NOT NULL,
	[SEQ_NUM] [int] NOT NULL,
 CONSTRAINT [IX_ATTACK_GUILD_SUBKEY] UNIQUE NONCLUSTERED 
(
	[MAP_SVR_GROUP] ASC,
	[REG_SIEGE_GUILD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MuCastle_SIEGE_GUILDLIST]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MuCastle_SIEGE_GUILDLIST](
	[MAP_SVR_GROUP] [int] NOT NULL,
	[GUILD_NAME] [varchar](10) NOT NULL,
	[GUILD_ID] [int] NOT NULL,
	[GUILD_INVOLVED] [bit] NOT NULL,
	[GUILD_SCORE] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MuCrywolf_DATA]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MuCrywolf_DATA](
	[MAP_SVR_GROUP] [int] NOT NULL,
	[CRYWOLF_OCCUFY] [int] NOT NULL,
	[CRYWOLF_STATE] [int] NOT NULL,
	[CHAOSMIX_PLUS_RATE] [int] NOT NULL,
	[CHAOSMIX_MINUS_RATE] [int] NOT NULL,
 CONSTRAINT [PK_MuCrywolf_DATA] PRIMARY KEY CLUSTERED 
(
	[MAP_SVR_GROUP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OptionData]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OptionData](
	[Name] [varchar](10) NOT NULL,
	[SkillKey] [binary](20) NULL,
	[GameOption] [tinyint] NULL,
	[Qkey] [tinyint] NULL,
	[Wkey] [tinyint] NULL,
	[Ekey] [tinyint] NULL,
	[ChatWindow] [tinyint] NULL,
	[Rkey] [tinyint] NULL,
	[QWERLevel] [int] NULL,
	[EnableChangeMode] [tinyint] NULL,
	[PlayGuideLv] [smallint] NULL,
	[PlayGuideCK] [tinyint] NULL,
 CONSTRAINT [PK_OptionData] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_BombGameScore]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_BombGameScore](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[mTotalScore] [int] NULL,
 CONSTRAINT [PK_T_BombGameScore] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_CGuid]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_CGuid](
	[GUID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](10) NOT NULL,
 CONSTRAINT [PK_T_CGuid] PRIMARY KEY CLUSTERED 
(
	[GUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_CurCharName]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_CurCharName](
	[Name] [char](10) NOT NULL,
	[cDate] [smalldatetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_Event_Inventory]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_Event_Inventory](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[Inventory] [varbinary](1024) NULL,
 CONSTRAINT [CL_PK_T_Event_Inventory] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_FriendList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_FriendList](
	[GUID] [int] NOT NULL,
	[FriendGuid] [int] NULL,
	[FriendName] [varchar](10) NULL,
	[Del] [tinyint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_FriendMail]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_FriendMail](
	[MemoIndex] [int] NOT NULL,
	[GUID] [int] NOT NULL,
	[FriendName] [varchar](10) NULL,
	[wDate] [smalldatetime] NOT NULL,
	[Subject] [varchar](50) NULL,
	[bRead] [bit] NOT NULL,
	[Memo] [varbinary](1000) NULL,
	[Photo] [binary](19) NULL,
	[Dir] [tinyint] NULL,
	[Act] [tinyint] NULL,
 CONSTRAINT [PK_T_FriendMemo] PRIMARY KEY CLUSTERED 
(
	[GUID] ASC,
	[MemoIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_FriendMain]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_FriendMain](
	[GUID] [int] NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[FriendCount] [tinyint] NULL,
	[MemoCount] [int] NULL,
	[MemoTotal] [int] NULL,
 CONSTRAINT [PK_T_FriendMain] PRIMARY KEY CLUSTERED 
(
	[GUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_GMSystem]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_GMSystem](
	[Name] [varchar](10) NOT NULL,
	[AuthorityMask] [int] NOT NULL,
	[Expiry] [smalldatetime] NULL,
 CONSTRAINT [PK_T_GMSystem] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_GUIDE_QUEST_INFO]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_GUIDE_QUEST_INFO](
	[Name] [varchar](10) NOT NULL,
	[QuestIndex] [int] NOT NULL,
	[QuestState] [tinyint] NOT NULL,
	[KillCount] [tinyint] NULL,
 CONSTRAINT [PK_T_GUIDE_QUEST_INFO] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_InGameShop_Items]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_InGameShop_Items](
	[AccountID] [varchar](10) NOT NULL,
	[UniqueCode] [int] IDENTITY(1,1) NOT NULL,
	[AuthCode] [int] NOT NULL,
	[UniqueID1] [int] NOT NULL,
	[UniqueID2] [int] NOT NULL,
	[UniqueID3] [int] NOT NULL,
	[InventoryType] [int] NOT NULL,
	[GiftName] [varchar](10) NULL,
	[Message] [varchar](200) NULL,
	[UsedItem] [int] NOT NULL,
 CONSTRAINT [PK_T_InGameShop_Items] PRIMARY KEY CLUSTERED 
(
	[UniqueCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_InGameShop_Point]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_InGameShop_Point](
	[AccountID] [varchar](10) NOT NULL,
	[WCoin] [float] NOT NULL,
	[GoblinPoint] [float] NOT NULL,
 CONSTRAINT [PK_T_InGameShop_Point] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_LUCKY_ITEM_INFO]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_LUCKY_ITEM_INFO](
	[nIndex] [int] IDENTITY(1,1) NOT NULL,
	[UserGuid] [int] NOT NULL,
	[CharName] [varchar](10) NOT NULL,
	[ItemCode] [int] NOT NULL,
	[ItemSerial] [bigint] NOT NULL,
	[DurabilitySmall] [smallint] NOT NULL,
 CONSTRAINT [PK_T_LUCKY_ITEM_INFO] PRIMARY KEY CLUSTERED 
(
	[CharName] ASC,
	[ItemCode] ASC,
	[ItemSerial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_MineSystem]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_MineSystem](
	[CharacterName] [varchar](10) NOT NULL,
	[TwinkleType] [int] NOT NULL,
	[CurrentStage] [int] NOT NULL,
 CONSTRAINT [PK_T_MineSystem] PRIMARY KEY CLUSTERED 
(
	[CharacterName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_MU2003_EVENT]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_MU2003_EVENT](
	[AccountID] [varchar](50) NOT NULL,
	[EventChips] [smallint] NOT NULL,
	[MuttoIndex] [int] NOT NULL,
	[MuttoNumber] [int] NOT NULL,
	[Check_Code] [char](1) NOT NULL,
 CONSTRAINT [PK_T_MU2003_EVENT_1] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_MuRummy]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_MuRummy](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[mSequence] [int] NULL,
	[mNumber] [int] NULL,
	[mColor] [int] NULL,
	[mPosition] [int] NULL,
	[mStatus] [int] NULL,
	[id] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_T_MuRummy] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_MuRummyInfo]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_MuRummyInfo](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[mTotalScore] [int] NULL,
	[mGameType] [int] NOT NULL,
	[mSPUseCnt] [int] NOT NULL,
	[id] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_T_MuRummyInfo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_MuRummyLog]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_MuRummyLog](
	[mDate] [datetime] NOT NULL,
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[mScore] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_PetItem_Info]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_PetItem_Info](
	[ItemSerial] [bigint] NOT NULL,
	[Pet_Level] [smallint] NULL,
	[Pet_Exp] [bigint] NULL,
 CONSTRAINT [PK_T_Pet_Info] PRIMARY KEY CLUSTERED 
(
	[ItemSerial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[T_PSHOP_ITEMVALUE_INFO]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_PSHOP_ITEMVALUE_INFO](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[ItemInvenNum] [int] NOT NULL,
	[ItemSerial] [bigint] NOT NULL,
	[Money] [int] NOT NULL,
	[BlessJewelValue] [int] NOT NULL,
	[SoulJewelValue] [int] NOT NULL,
	[ChaosJewelValue] [int] NOT NULL,
 CONSTRAINT [CL_PK_T_PSHOP_ITEMVALUE_INFO] PRIMARY KEY CLUSTERED 
(
	[Name] ASC,
	[ItemInvenNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_QUEST_EXP_INFO]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_QUEST_EXP_INFO](
	[nINDEX] [int] IDENTITY(1,1) NOT NULL,
	[CHAR_NAME] [varchar](10) NOT NULL,
	[EPISODE] [smallint] NOT NULL,
	[QUEST_SWITCH] [smallint] NOT NULL,
	[ASK_INDEX] [varbinary](5) NOT NULL,
	[ASK_VALUE] [varbinary](5) NOT NULL,
	[ASK_STATE] [varbinary](5) NOT NULL,
	[PROG_STATE] [smallint] NULL,
	[QUEST_START_DATE] [datetime] NULL,
	[QUEST_END_DATE] [datetime] NULL,
	[StartDateConvert] [bigint] NOT NULL,
	[EndDateConvert] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[nINDEX] ASC,
	[CHAR_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_VIPList]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_VIPList](
	[AccountID] [varchar](10) NOT NULL,
	[Date] [smalldatetime] NULL,
	[Type] [tinyint] NULL,
 CONSTRAINT [PK_T_VIPList] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_WaitFriend]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_WaitFriend](
	[GUID] [int] NOT NULL,
	[FriendGuid] [int] NOT NULL,
	[FriendName] [varchar](10) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[warehouse]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[warehouse](
	[AccountID] [varchar](10) NOT NULL,
	[Items] [varbinary](7680) NULL,
	[Money] [int] NULL,
	[EndUseDate] [smalldatetime] NULL,
	[pw] [smallint] NULL,
	[Expanded] [tinyint] NOT NULL,
	[WHOpen] [tinyint] NOT NULL,
 CONSTRAINT [PK_warehouse] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ZenEvent]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ZenEvent](
	[Guid] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [varchar](10) NOT NULL,
	[Zen] [int] NULL,
 CONSTRAINT [PK_ZenEvent] PRIMARY KEY CLUSTERED 
(
	[Guid] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vCharacterPreview]    Script Date: 11/11/2018 6:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCharacterPreview]
AS
SELECT        Name, cLevel, Class, Inventory, CtlCode, mLevel
FROM            dbo.Character






GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [CL_IGC_GremoryCase_AccountID]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE CLUSTERED INDEX [CL_IGC_GremoryCase_AccountID] ON [dbo].[IGC_GremoryCase]
(
	[AccountID] ASC,
	[GCType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [CL_IGC_HuntingRecord_Name_AccountID]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE CLUSTERED INDEX [CL_IGC_HuntingRecord_Name_AccountID] ON [dbo].[IGC_HuntingRecord]
(
	[Name] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [CL_IGC_LabyrinthClearLog_mDate]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE CLUSTERED INDEX [CL_IGC_LabyrinthClearLog_mDate] ON [dbo].[IGC_LabyrinthClearLog]
(
	[mDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [CL_IGC_PeriodItemInfo_UserGuid]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE CLUSTERED INDEX [CL_IGC_PeriodItemInfo_UserGuid] ON [dbo].[IGC_PeriodItemInfo]
(
	[UserGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [XI_MEMB_INFO_2]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE CLUSTERED INDEX [XI_MEMB_INFO_2] ON [dbo].[MEMB_INFO]
(
	[memb___id] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_MuCastle_MONEY_STATISTICS]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE CLUSTERED INDEX [IX_MuCastle_MONEY_STATISTICS] ON [dbo].[MuCastle_MONEY_STATISTICS]
(
	[MAP_SVR_GROUP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_NPC_PK]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE CLUSTERED INDEX [IX_NPC_PK] ON [dbo].[MuCastle_NPC]
(
	[MAP_SVR_GROUP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ATTACK_GUILD_KEY]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE CLUSTERED INDEX [IX_ATTACK_GUILD_KEY] ON [dbo].[MuCastle_REG_SIEGE]
(
	[MAP_SVR_GROUP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MuCastle_SIEGE_GUILDLIST]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE CLUSTERED INDEX [IX_MuCastle_SIEGE_GUILDLIST] ON [dbo].[MuCastle_SIEGE_GUILDLIST]
(
	[MAP_SVR_GROUP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GUILD_G_RIVAL]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IDX_GUILD_G_RIVAL] ON [dbo].[Guild]
(
	[G_Rival] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GUILD_G_UNION]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IDX_GUILD_G_UNION] ON [dbo].[Guild]
(
	[G_Union] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GUILD_NUMBER]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IDX_GUILD_NUMBER] ON [dbo].[Guild]
(
	[Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_IGC_Players_DuelLog]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_IGC_Players_DuelLog] ON [dbo].[IGC_DuelLog]
(
	[Player1] ASC,
	[Player2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_IGC_GremoryCase_Name]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_IGC_GremoryCase_Name] ON [dbo].[IGC_GremoryCase]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_IGC_GremoryCase_RecvDateConvert]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_IGC_GremoryCase_RecvDateConvert] ON [dbo].[IGC_GremoryCase]
(
	[RecvDateConvert] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [UIX_IGC_GremoryCase_GremoryCaseIndex]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UIX_IGC_GremoryCase_GremoryCaseIndex] ON [dbo].[IGC_GremoryCase]
(
	[GremoryCaseIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_IGC_HuntingRecord_mDate]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_IGC_HuntingRecord_mDate] ON [dbo].[IGC_HuntingRecord]
(
	[mDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_IGC_Muun_Period_ExpireDate]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_IGC_Muun_Period_ExpireDate] ON [dbo].[IGC_Muun_Period]
(
	[ExpireDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_IGC_PentagramInfo_Name]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_IGC_PentagramInfo_Name] ON [dbo].[IGC_PentagramInfo]
(
	[UserGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_IGC_PeriodItemInfo_CharacterName]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_IGC_PeriodItemInfo_CharacterName] ON [dbo].[IGC_PeriodItemInfo]
(
	[CharacterName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [UIX_IGC_PeriodItemInfo_PeriodIndex]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UIX_IGC_PeriodItemInfo_PeriodIndex] ON [dbo].[IGC_PeriodItemInfo]
(
	[PeriodIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MEMB_DETAIL]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_MEMB_DETAIL] ON [dbo].[MEMB_INFO]
(
	[sno__numb] DESC,
	[memb_name] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MuCastle_MONEY_STATISTICS_NC]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_MuCastle_MONEY_STATISTICS_NC] ON [dbo].[MuCastle_MONEY_STATISTICS]
(
	[MAP_SVR_GROUP] ASC,
	[LOG_DATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_T_CGuid_Name]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_T_CGuid_Name] ON [dbo].[T_CGuid]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_T_FriendList]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_T_FriendList] ON [dbo].[T_FriendList]
(
	[GUID] ASC,
	[FriendGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_T_InGameShop_Items_AccID]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_T_InGameShop_Items_AccID] ON [dbo].[T_InGameShop_Items]
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_T_MuRummy_Name]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_T_MuRummy_Name] ON [dbo].[T_MuRummy]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_T_MuRummyInfo_Name]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_T_MuRummyInfo_Name] ON [dbo].[T_MuRummyInfo]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_T_WaitFriend]    Script Date: 11/11/2018 6:19:14 PM ******/
CREATE NONCLUSTERED INDEX [IX_T_WaitFriend] ON [dbo].[T_WaitFriend]
(
	[GUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccountCharacter] ADD  CONSTRAINT [DF__AccountCh__MoveC__7A3223E8]  DEFAULT ((0)) FOR [MoveCnt]
GO
ALTER TABLE [dbo].[AccountCharacter] ADD  CONSTRAINT [DF_AccountCharacter_Summoner]  DEFAULT ((0)) FOR [Summoner]
GO
ALTER TABLE [dbo].[AccountCharacter] ADD  CONSTRAINT [DF_AccountCharacter_WarehouseExpansion]  DEFAULT ((0)) FOR [WarehouseExpansion]
GO
ALTER TABLE [dbo].[AccountCharacter] ADD  CONSTRAINT [DF_AccountCharacter_RageFighter]  DEFAULT ((0)) FOR [RageFighter]
GO
ALTER TABLE [dbo].[AccountCharacter] ADD  DEFAULT ((0)) FOR [SecCode]
GO
ALTER TABLE [dbo].[AccountCharacter] ADD  DEFAULT ((0)) FOR [GrowLancer]
GO
ALTER TABLE [dbo].[AccountCharacter] ADD  DEFAULT ((0)) FOR [MagicGladiator]
GO
ALTER TABLE [dbo].[AccountCharacter] ADD  DEFAULT ((0)) FOR [DarkLord]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_cLevel]  DEFAULT ((1)) FOR [cLevel]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_LevelUpPoint]  DEFAULT ((0)) FOR [LevelUpPoint]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_Experience]  DEFAULT ((0)) FOR [Experience]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_Money]  DEFAULT ((0)) FOR [Money]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_MapDir]  DEFAULT ((0)) FOR [MapDir]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_PkCount]  DEFAULT ((0)) FOR [PkCount]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_PkLevel]  DEFAULT ((3)) FOR [PkLevel]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_PkTime]  DEFAULT ((0)) FOR [PkTime]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_CtlCode]  DEFAULT ((0)) FOR [CtlCode]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF__Character__Quest__40F9A68C]  DEFAULT ((0)) FOR [Quest]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [ChatLimitTime]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [FruitPoint]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_RESETS]  DEFAULT ((0)) FOR [RESETS]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_Married]  DEFAULT ((0)) FOR [Married]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [mLevel]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [mlPoint]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [mlExperience]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [mlNextExp]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_InventoryExpansion]  DEFAULT ((0)) FOR [InventoryExpansion]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_WinDuels]  DEFAULT ((0)) FOR [WinDuels]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_LoseDuels]  DEFAULT ((0)) FOR [LoseDuels]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [PenaltyMask]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [BlockChatTime]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [Ruud]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [OpenHuntingLog]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [StatCoin]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [StatGP]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [i4thSkillPoint]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [AddStrength]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [AddDexterity]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [AddVitality]
GO
ALTER TABLE [dbo].[Character] ADD  DEFAULT ((0)) FOR [AddEnergy]
GO
ALTER TABLE [dbo].[DefaultClassType] ADD  CONSTRAINT [DF__DefaultCl__Leade__719CDDE7]  DEFAULT ((0)) FOR [Leadership]
GO
ALTER TABLE [dbo].[DefaultClassType] ADD  CONSTRAINT [DF__DefaultCl__Level__72910220]  DEFAULT ((0)) FOR [Level]
GO
ALTER TABLE [dbo].[DefaultClassType] ADD  CONSTRAINT [DF__DefaultCl__Level__73852659]  DEFAULT ((0)) FOR [LevelUpPoint]
GO
ALTER TABLE [dbo].[GameServerInfo] ADD  CONSTRAINT [DF_GameServerInfo_Number]  DEFAULT ((0)) FOR [Number]
GO
ALTER TABLE [dbo].[GameServerInfo] ADD  CONSTRAINT [DF_GameServerInfo_ZenCount]  DEFAULT ((0)) FOR [ZenCount]
GO
ALTER TABLE [dbo].[GameServerInfo] ADD  DEFAULT ((1)) FOR [GensRankingMonth]
GO
ALTER TABLE [dbo].[GameServerInfo] ADD  DEFAULT ((0)) FOR [GCItemCount]
GO
ALTER TABLE [dbo].[Guild] ADD  DEFAULT ((0)) FOR [G_Score]
GO
ALTER TABLE [dbo].[Guild] ADD  CONSTRAINT [DF__Guild__G_Type__7EF6D905]  DEFAULT ((0)) FOR [G_Type]
GO
ALTER TABLE [dbo].[Guild] ADD  CONSTRAINT [DF__Guild__G_Rival__7FEAFD3E]  DEFAULT ((0)) FOR [G_Rival]
GO
ALTER TABLE [dbo].[Guild] ADD  CONSTRAINT [DF__Guild__G_Union__00DF2177]  DEFAULT ((0)) FOR [G_Union]
GO
ALTER TABLE [dbo].[GuildMember] ADD  CONSTRAINT [DF__GuildMemb__G_Sta__01D345B0]  DEFAULT ((0)) FOR [G_Status]
GO
ALTER TABLE [dbo].[IGC_ClassQuest_MonsterKill] ADD  CONSTRAINT [DF_IGC_ClassQuest_MonsterKill_QuestIndex]  DEFAULT ((-1)) FOR [QuestIndex]
GO
ALTER TABLE [dbo].[IGC_ClassQuest_MonsterKill] ADD  CONSTRAINT [DF_IGC_ClassQuest_MonsterKill_MonsterIndex_1]  DEFAULT ((-1)) FOR [MonsterIndex_1]
GO
ALTER TABLE [dbo].[IGC_ClassQuest_MonsterKill] ADD  CONSTRAINT [DF_IGC_ClassQuest_MonsterKill_MonsterKillCount_1]  DEFAULT ((0)) FOR [MonsterKillCount_1]
GO
ALTER TABLE [dbo].[IGC_ClassQuest_MonsterKill] ADD  CONSTRAINT [DF_IGC_ClassQuest_MonsterKill_MonsterIndex_2]  DEFAULT ((-1)) FOR [MonsterIndex_2]
GO
ALTER TABLE [dbo].[IGC_ClassQuest_MonsterKill] ADD  CONSTRAINT [DF_IGC_ClassQuest_MonsterKill_MonsterKillCount_2]  DEFAULT ((0)) FOR [MonsterKillCount_2]
GO
ALTER TABLE [dbo].[IGC_ClassQuest_MonsterKill] ADD  CONSTRAINT [DF_IGC_ClassQuest_MonsterKill_MonsterIndex_3]  DEFAULT ((-1)) FOR [MonsterIndex_3]
GO
ALTER TABLE [dbo].[IGC_ClassQuest_MonsterKill] ADD  CONSTRAINT [DF_IGC_ClassQuest_MonsterKill_MonsterKillCount_3]  DEFAULT ((0)) FOR [MonsterKillCount_3]
GO
ALTER TABLE [dbo].[IGC_ClassQuest_MonsterKill] ADD  CONSTRAINT [DF_IGC_ClassQuest_MonsterKill_MonsterIndex_4]  DEFAULT ((-1)) FOR [MonsterIndex_4]
GO
ALTER TABLE [dbo].[IGC_ClassQuest_MonsterKill] ADD  CONSTRAINT [DF_IGC_ClassQuest_MonsterKill_MonsterKillCount_4]  DEFAULT ((0)) FOR [MonsterKillCount_4]
GO
ALTER TABLE [dbo].[IGC_ClassQuest_MonsterKill] ADD  CONSTRAINT [DF_IGC_ClassQuest_MonsterKill_MonsterIndex_5]  DEFAULT ((-1)) FOR [MonsterIndex_5]
GO
ALTER TABLE [dbo].[IGC_ClassQuest_MonsterKill] ADD  CONSTRAINT [DF_IGC_ClassQuest_MonsterKill_MonsterKillCount_5]  DEFAULT ((0)) FOR [MonsterKillCount_5]
GO
ALTER TABLE [dbo].[IGC_EventMapEnterLimit] ADD  CONSTRAINT [DF_IGC_EventMapEnterLimit_BloodCastle]  DEFAULT ((0)) FOR [BloodCastle]
GO
ALTER TABLE [dbo].[IGC_EventMapEnterLimit] ADD  CONSTRAINT [DF_IGC_EventMapEnterLimit_ChaosCastle]  DEFAULT ((0)) FOR [ChaosCastle]
GO
ALTER TABLE [dbo].[IGC_EventMapEnterLimit] ADD  CONSTRAINT [DF_IGC_EventMapEnterLimit_DevilSquare]  DEFAULT ((0)) FOR [DevilSquare]
GO
ALTER TABLE [dbo].[IGC_EventMapEnterLimit] ADD  CONSTRAINT [DF_IGC_EventMapEnterLimit_DoppelGanger]  DEFAULT ((0)) FOR [DoppelGanger]
GO
ALTER TABLE [dbo].[IGC_EventMapEnterLimit] ADD  CONSTRAINT [DF_IGC_EventMapEnterLimit_ImperialGuardian_Weekdays]  DEFAULT ((0)) FOR [ImperialGuardian]
GO
ALTER TABLE [dbo].[IGC_EventMapEnterLimit] ADD  CONSTRAINT [DF_IGC_EventMapEnterLimit_IllusionTempleRenewal]  DEFAULT ((0)) FOR [IllusionTempleRenewal]
GO
ALTER TABLE [dbo].[IGC_EventMapEnterLimit] ADD  CONSTRAINT [DF_IGC_EventMapEnterLimit_LastDate]  DEFAULT (getdate()) FOR [LastDate]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_MonsterIndex1]  DEFAULT ((-1)) FOR [MonsterIndex1]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_MonsterLevel1]  DEFAULT ((0)) FOR [MonsterLevel1]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_KillCount1]  DEFAULT ((0)) FOR [KillCount1]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_MonsterIndex2]  DEFAULT ((-1)) FOR [MonsterIndex2]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_MonsterLevel2]  DEFAULT ((0)) FOR [MonsterLevel2]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_KillCount2]  DEFAULT ((0)) FOR [KillCount2]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_MonsterIndex3]  DEFAULT ((-1)) FOR [MonsterIndex3]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_MonsterLevel3]  DEFAULT ((0)) FOR [MonsterLevel3]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_KillCount3]  DEFAULT ((0)) FOR [KillCount3]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_MonsterIndex4]  DEFAULT ((-1)) FOR [MonsterIndex4]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_MonsterLevel4]  DEFAULT ((0)) FOR [MonsterLevel4]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_KillCount4]  DEFAULT ((0)) FOR [KillCount4]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_MonsterIndex5]  DEFAULT ((-1)) FOR [MonsterIndex5]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_MonsterLevel5]  DEFAULT ((0)) FOR [MonsterLevel5]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_KillCount5]  DEFAULT ((0)) FOR [KillCount5]
GO
ALTER TABLE [dbo].[IGC_EvolutionMonster] ADD  CONSTRAINT [DF_IGC_EvolutionMonster_AccumDmg]  DEFAULT ((0)) FOR [AccumDmg]
GO
ALTER TABLE [dbo].[IGC_Gens] ADD  CONSTRAINT [DF_IGC_Gens_Rank]  DEFAULT ((0)) FOR [Rank]
GO
ALTER TABLE [dbo].[IGC_Gens] ADD  CONSTRAINT [DF_IGC_Gens_Points]  DEFAULT ((0)) FOR [Points]
GO
ALTER TABLE [dbo].[IGC_Gens] ADD  CONSTRAINT [DF_IGC_Gens_Reward]  DEFAULT ((1)) FOR [Reward]
GO
ALTER TABLE [dbo].[IGC_Gens] ADD  CONSTRAINT [DF_IGC_Gens_Class]  DEFAULT ((0)) FOR [Class]
GO
ALTER TABLE [dbo].[IGC_GremoryCase] ADD  CONSTRAINT [DF_IGC_GremoryCase_UsedInfo]  DEFAULT ((0)) FOR [UsedInfo]
GO
ALTER TABLE [dbo].[IGC_GuildMatching] ADD  CONSTRAINT [DF_IGC_GuildMatching_InterestType]  DEFAULT ((0)) FOR [InterestType]
GO
ALTER TABLE [dbo].[IGC_GuildMatching] ADD  CONSTRAINT [DF_IGC_GuildMatching_LevelRange]  DEFAULT ((0)) FOR [LevelRange]
GO
ALTER TABLE [dbo].[IGC_GuildMatching] ADD  CONSTRAINT [DF_IGC_GuildMatching_ClassType]  DEFAULT ((0)) FOR [ClassType]
GO
ALTER TABLE [dbo].[IGC_LabyrinthInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthInfo_DimensionLevel]  DEFAULT ((0)) FOR [DimensionLevel]
GO
ALTER TABLE [dbo].[IGC_LabyrinthInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthInfo_ConfigNum]  DEFAULT ((-1)) FOR [ConfigNum]
GO
ALTER TABLE [dbo].[IGC_LabyrinthInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthInfo_EntireExp]  DEFAULT ((0)) FOR [EntireExp]
GO
ALTER TABLE [dbo].[IGC_LabyrinthInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthInfo_EntireMonKillCnt]  DEFAULT ((0)) FOR [EntireMonKillCnt]
GO
ALTER TABLE [dbo].[IGC_LabyrinthInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthInfo_ClearCnt]  DEFAULT ((0)) FOR [ClearCnt]
GO
ALTER TABLE [dbo].[IGC_LabyrinthInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthInfo_ClearState]  DEFAULT ((0)) FOR [ClearState]
GO
ALTER TABLE [dbo].[IGC_LabyrinthMissionInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthMissionInfo_AcquisitionValue]  DEFAULT ((0)) FOR [AcquisitionValue]
GO
ALTER TABLE [dbo].[IGC_LabyrinthMissionInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthMissionInfo_MissionState]  DEFAULT ((0)) FOR [MissionState]
GO
ALTER TABLE [dbo].[IGC_LabyrinthMissionInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthMissionInfo_RewardItemType]  DEFAULT ((-1)) FOR [RewardItemType]
GO
ALTER TABLE [dbo].[IGC_LabyrinthMissionInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthMissionInfo_RewardItemIndex]  DEFAULT ((-1)) FOR [RewardItemIndex]
GO
ALTER TABLE [dbo].[IGC_LabyrinthMissionInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthMissionInfo_RewardValue]  DEFAULT ((0)) FOR [RewardValue]
GO
ALTER TABLE [dbo].[IGC_LabyrinthMissionInfo] ADD  CONSTRAINT [DF_IGC_LabyrinthMissionInfo_RewardCheckState]  DEFAULT ((0)) FOR [RewardCheckState]
GO
ALTER TABLE [dbo].[IGC_Muun_Period] ADD  CONSTRAINT [DF_IGC_Muun_Period_UsedInfo]  DEFAULT ((0)) FOR [UsedInfo]
GO
ALTER TABLE [dbo].[IGC_PartyMatching] ADD  CONSTRAINT [DF_IGC_PartyMatching_UsePassWord]  DEFAULT ((0)) FOR [UsePassWord]
GO
ALTER TABLE [dbo].[IGC_PeriodItemInfo] ADD  CONSTRAINT [DF_IGC_PeriodItemInfo_UsedTime]  DEFAULT ((0)) FOR [UsedTime]
GO
ALTER TABLE [dbo].[IGC_PeriodItemInfo] ADD  CONSTRAINT [DF_IGC_PeriodItemInfo_UsedInfo]  DEFAULT ((0)) FOR [UsedInfo]
GO
ALTER TABLE [dbo].[IGC_PeriodItemInfo] ADD  CONSTRAINT [DF_IGC_PeriodItemInfo_OptionType]  DEFAULT ((2)) FOR [OptionType]
GO
ALTER TABLE [dbo].[IGC_PeriodItemInfo] ADD  CONSTRAINT [DF_IGC_PeriodItemInfo_ItemType]  DEFAULT ((1)) FOR [ItemType]
GO
ALTER TABLE [dbo].[IGC_PeriodItemInfo] ADD  CONSTRAINT [DF_IGC_PeriodItemInfo_SetExpire]  DEFAULT ((0)) FOR [SetExpire]
GO
ALTER TABLE [dbo].[MEMB_CREDITS] ADD  CONSTRAINT [DF_MEMB_CREDITS_credits]  DEFAULT ((0)) FOR [credits]
GO
ALTER TABLE [dbo].[MEMB_INFO] ADD  CONSTRAINT [DF_MEMB_INFO_mail_chek]  DEFAULT ((0)) FOR [mail_chek]
GO
ALTER TABLE [dbo].[Mu_DBID] ADD  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[MuCastle_DATA] ADD  CONSTRAINT [DF_MuCastle_Data_SEIGE_ENDED]  DEFAULT ((0)) FOR [SIEGE_ENDED]
GO
ALTER TABLE [dbo].[MuCastle_DATA] ADD  CONSTRAINT [DF_MuCastle_Data_CASTLE_OCCUPY]  DEFAULT ((0)) FOR [CASTLE_OCCUPY]
GO
ALTER TABLE [dbo].[MuCastle_DATA] ADD  CONSTRAINT [DF_MuCastle_Data_MONEY]  DEFAULT ((0)) FOR [MONEY]
GO
ALTER TABLE [dbo].[MuCastle_DATA] ADD  CONSTRAINT [DF_MuCastle_Data_TAX_RATE]  DEFAULT ((0)) FOR [TAX_RATE_CHAOS]
GO
ALTER TABLE [dbo].[MuCastle_DATA] ADD  CONSTRAINT [DF_MuCastle_DATA_TAX_RATE_STORE]  DEFAULT ((0)) FOR [TAX_RATE_STORE]
GO
ALTER TABLE [dbo].[MuCastle_DATA] ADD  CONSTRAINT [DF_MuCastle_DATA_TAX_HUNT_ZONE]  DEFAULT ((0)) FOR [TAX_HUNT_ZONE]
GO
ALTER TABLE [dbo].[MuCastle_SIEGE_GUILDLIST] ADD  CONSTRAINT [DF_MuCastle_SIEGE_GUILDLIST_GUILD_SCORE]  DEFAULT ((0)) FOR [GUILD_SCORE]
GO
ALTER TABLE [dbo].[MuCrywolf_DATA] ADD  CONSTRAINT [DF_MuCrywolf_DATA_CRYWOLF_OCCUFY]  DEFAULT ((0)) FOR [CRYWOLF_OCCUFY]
GO
ALTER TABLE [dbo].[MuCrywolf_DATA] ADD  CONSTRAINT [DF_MuCrywolf_DATA_CRYWOLF_STATE]  DEFAULT ((0)) FOR [CRYWOLF_STATE]
GO
ALTER TABLE [dbo].[MuCrywolf_DATA] ADD  CONSTRAINT [DF_MuCrywolf_DATA_CHAOSMIX_PLUS_RATE]  DEFAULT ((0)) FOR [CHAOSMIX_PLUS_RATE]
GO
ALTER TABLE [dbo].[MuCrywolf_DATA] ADD  CONSTRAINT [DF_MuCrywolf_DATA_CHAOSMIX_MINUS_RATE]  DEFAULT ((0)) FOR [CHAOSMIX_MINUS_RATE]
GO
ALTER TABLE [dbo].[OptionData] ADD  CONSTRAINT [DF__OptionDat__ChatW__4A8310C6]  DEFAULT ((255)) FOR [ChatWindow]
GO
ALTER TABLE [dbo].[OptionData] ADD  DEFAULT ((0)) FOR [EnableChangeMode]
GO
ALTER TABLE [dbo].[OptionData] ADD  DEFAULT ((0)) FOR [PlayGuideLv]
GO
ALTER TABLE [dbo].[OptionData] ADD  DEFAULT ((0)) FOR [PlayGuideCK]
GO
ALTER TABLE [dbo].[T_CurCharName] ADD  CONSTRAINT [DF__T_CurChar__cDate__6BE40491]  DEFAULT (getdate()) FOR [cDate]
GO
ALTER TABLE [dbo].[T_FriendList] ADD  CONSTRAINT [DF_T_FriendList_Del]  DEFAULT ((0)) FOR [Del]
GO
ALTER TABLE [dbo].[T_FriendMail] ADD  CONSTRAINT [DF_T_FriendMemo_MemoIndex]  DEFAULT ((10)) FOR [MemoIndex]
GO
ALTER TABLE [dbo].[T_FriendMail] ADD  CONSTRAINT [DF_T_FriendMemo_wDate]  DEFAULT (getdate()) FOR [wDate]
GO
ALTER TABLE [dbo].[T_FriendMail] ADD  CONSTRAINT [DF_T_FriendMemo_MemoRead]  DEFAULT ((0)) FOR [bRead]
GO
ALTER TABLE [dbo].[T_FriendMail] ADD  CONSTRAINT [DF_T_FriendMemo_Dir]  DEFAULT ((0)) FOR [Dir]
GO
ALTER TABLE [dbo].[T_FriendMail] ADD  CONSTRAINT [DF_T_FriendMemo_Action]  DEFAULT ((0)) FOR [Act]
GO
ALTER TABLE [dbo].[T_FriendMain] ADD  CONSTRAINT [DF_T_FriendMain_MemoCount]  DEFAULT ((10)) FOR [MemoCount]
GO
ALTER TABLE [dbo].[T_FriendMain] ADD  CONSTRAINT [DF_T_FriendMain_MemoTotal]  DEFAULT ((0)) FOR [MemoTotal]
GO
ALTER TABLE [dbo].[T_GMSystem] ADD  CONSTRAINT [DF_T_GMSystem_AuthorityMask]  DEFAULT ((0)) FOR [AuthorityMask]
GO
ALTER TABLE [dbo].[T_GUIDE_QUEST_INFO] ADD  CONSTRAINT [DF_T_GUIDE_QUEST_INFO_QuestIndex]  DEFAULT ((0)) FOR [QuestIndex]
GO
ALTER TABLE [dbo].[T_GUIDE_QUEST_INFO] ADD  CONSTRAINT [DF_T_GUIDE_QUEST_INFO_QuestState]  DEFAULT ((0)) FOR [QuestState]
GO
ALTER TABLE [dbo].[T_GUIDE_QUEST_INFO] ADD  CONSTRAINT [DF_T_GUIDE_QUEST_INFO_KillCount]  DEFAULT ((0)) FOR [KillCount]
GO
ALTER TABLE [dbo].[T_InGameShop_Items] ADD  CONSTRAINT [DF_T_InGameShop_Items_UsedItem]  DEFAULT ((0)) FOR [UsedItem]
GO
ALTER TABLE [dbo].[T_InGameShop_Point] ADD  CONSTRAINT [DF_T_InGameShop_Point_WCoinC]  DEFAULT ((0.00)) FOR [WCoin]
GO
ALTER TABLE [dbo].[T_InGameShop_Point] ADD  CONSTRAINT [DF_T_InGameShop_Point_GoblinPoint]  DEFAULT ((0.00)) FOR [GoblinPoint]
GO
ALTER TABLE [dbo].[T_MU2003_EVENT] ADD  CONSTRAINT [DF_T_MU2003_EVENT_EventChips_1]  DEFAULT ((0)) FOR [EventChips]
GO
ALTER TABLE [dbo].[T_MU2003_EVENT] ADD  CONSTRAINT [DF_T_MU2003_EVENT_MuttoIndex_1]  DEFAULT ((-1)) FOR [MuttoIndex]
GO
ALTER TABLE [dbo].[T_MU2003_EVENT] ADD  CONSTRAINT [DF_T_MU2003_EVENT_MuttoNumber_1]  DEFAULT ((0)) FOR [MuttoNumber]
GO
ALTER TABLE [dbo].[T_MU2003_EVENT] ADD  CONSTRAINT [DF_T_MU2003_EVENT_Check_Code]  DEFAULT ((0)) FOR [Check_Code]
GO
ALTER TABLE [dbo].[T_PetItem_Info] ADD  CONSTRAINT [DF_T_Pet_Info_Pet_Level]  DEFAULT ((0)) FOR [Pet_Level]
GO
ALTER TABLE [dbo].[T_PetItem_Info] ADD  CONSTRAINT [DF_T_Pet_Info_Pet_Exp]  DEFAULT ((0)) FOR [Pet_Exp]
GO
ALTER TABLE [dbo].[T_PSHOP_ITEMVALUE_INFO] ADD  DEFAULT ((0)) FOR [ItemInvenNum]
GO
ALTER TABLE [dbo].[T_PSHOP_ITEMVALUE_INFO] ADD  DEFAULT ((0)) FOR [ItemSerial]
GO
ALTER TABLE [dbo].[T_PSHOP_ITEMVALUE_INFO] ADD  DEFAULT ((0)) FOR [Money]
GO
ALTER TABLE [dbo].[T_PSHOP_ITEMVALUE_INFO] ADD  DEFAULT ((0)) FOR [BlessJewelValue]
GO
ALTER TABLE [dbo].[T_PSHOP_ITEMVALUE_INFO] ADD  DEFAULT ((0)) FOR [SoulJewelValue]
GO
ALTER TABLE [dbo].[T_PSHOP_ITEMVALUE_INFO] ADD  DEFAULT ((0)) FOR [ChaosJewelValue]
GO
ALTER TABLE [dbo].[T_QUEST_EXP_INFO] ADD  DEFAULT ((0)) FOR [ASK_INDEX]
GO
ALTER TABLE [dbo].[T_QUEST_EXP_INFO] ADD  DEFAULT ((0)) FOR [ASK_VALUE]
GO
ALTER TABLE [dbo].[T_QUEST_EXP_INFO] ADD  DEFAULT ((0)) FOR [ASK_STATE]
GO
ALTER TABLE [dbo].[T_QUEST_EXP_INFO] ADD  DEFAULT ((0)) FOR [QUEST_START_DATE]
GO
ALTER TABLE [dbo].[T_QUEST_EXP_INFO] ADD  DEFAULT ((0)) FOR [QUEST_END_DATE]
GO
ALTER TABLE [dbo].[T_QUEST_EXP_INFO] ADD  CONSTRAINT [DF_T_QUEST_EXP_INFO_StartDateConvert]  DEFAULT ((0)) FOR [StartDateConvert]
GO
ALTER TABLE [dbo].[T_QUEST_EXP_INFO] ADD  CONSTRAINT [DF_T_QUEST_EXP_INFO_EndDateConvert]  DEFAULT ((0)) FOR [EndDateConvert]
GO
ALTER TABLE [dbo].[warehouse] ADD  CONSTRAINT [DF_warehouse_Money]  DEFAULT ((0)) FOR [Money]
GO
ALTER TABLE [dbo].[warehouse] ADD  CONSTRAINT [DF__warehouse__pw__40058253]  DEFAULT ((0)) FOR [pw]
GO
ALTER TABLE [dbo].[warehouse] ADD  CONSTRAINT [DF_warehouse_Expansion]  DEFAULT ((0)) FOR [Expanded]
GO
ALTER TABLE [dbo].[warehouse] ADD  DEFAULT ((0)) FOR [WHOpen]
GO
ALTER TABLE [dbo].[ZenEvent] ADD  CONSTRAINT [DF_ZenEvent_Zen]  DEFAULT ((0)) FOR [Zen]
GO
ALTER TABLE [dbo].[GuildMember]  WITH CHECK ADD  CONSTRAINT [FK_GuildMember_Guild] FOREIGN KEY([G_Name])
REFERENCES [dbo].[Guild] ([G_Name])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GuildMember] CHECK CONSTRAINT [FK_GuildMember_Guild]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Account Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'AccountID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Character Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Monster Class' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'MonsterIndex1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Monster Level' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'MonsterLevel1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kill Count' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'KillCount1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Monster Class' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'MonsterIndex2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Monster Level' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'MonsterLevel2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kill Count' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'KillCount2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Monster Class' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'MonsterIndex3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Monster Level' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'MonsterLevel3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kill Count' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'KillCount3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Monster Class' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'MonsterIndex4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Monster Level' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'MonsterLevel4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kill Count' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'KillCount4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Monster Class' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'MonsterIndex5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Monster Level' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'MonsterLevel5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kill Count' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'KillCount5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Damage information applied to monsters' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_EvolutionMonster', @level2type=N'COLUMN',@level2name=N'AccumDmg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'GremoryCaseIndex'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'AccountID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'GCType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'GiveType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'ItemType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'ItemIndex'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'Level'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'ItemDur'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'Skill'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'Luck'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'Opt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'SetOpt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'NewOpt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'BonusSocketOpt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'SocketOpt1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'SocketOpt2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'SocketOpt3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'SocketOpt4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'SocketOpt5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'UsedInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'Serial'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'RecvDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'ReceiptDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'RecvExpireDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'ItemExpireDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'RecvDateConvert'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'RecvExpireDateConvert'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IGC_GremoryCase', @level2type=N'COLUMN',@level2name=N'ItemExpireDateConvert'
GO
USE [master]
GO
ALTER DATABASE [s13p2_MuOnline] SET  READ_WRITE 
GO

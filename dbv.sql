USE [Plus_MuOnline]
GO
/****** Object:  StoredProcedure [dbo].[IGC_DBVersionUpdate]    Script Date: 6/24/2020 12:54:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[IGC_DBVersionUpdate]
	@updateVersion varchar(50),
	@nextVersion varchar(50)
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRANSACTION;

	IF NOT EXISTS ( SELECT param_value FROM IGC_Config  WITH ( READUNCOMMITTED ) WHERE param_name = 'db_version' and param_value = @updateVersion )
	BEGIN 
		RAISERROR ('The script executed does not match expected version. Scripts must be executed in proper order', 16, 1);
	END 

	ELSE
	BEGIN
		UPDATE IGC_Config SET param_value = @nextVersion WHERE param_name = 'db_version';
	END
 
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE 
		COMMIT TRANSACTION
	SET NOCOUNT OFF 
END

GO

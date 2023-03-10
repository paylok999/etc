USE [PMU_s18p1_MuOnline]
GO
/****** Object:  Table [dbo].[DefaultClassType]    Script Date: 11/2/2022 1:16:49 PM ******/
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
	[MagicList] [varbinary](2250) NULL,
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
	[GateNumber] [smallint] NULL,
 CONSTRAINT [PK_DefaultClassType] PRIMARY KEY CLUSTERED 
(
	[Class] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[DefaultClassType] ADD  CONSTRAINT [DF__DefaultCl__Leade__719CDDE7]  DEFAULT ((0)) FOR [Leadership]
GO
ALTER TABLE [dbo].[DefaultClassType] ADD  CONSTRAINT [DF__DefaultCl__Level__72910220]  DEFAULT ((0)) FOR [Level]
GO
ALTER TABLE [dbo].[DefaultClassType] ADD  CONSTRAINT [DF__DefaultCl__Level__73852659]  DEFAULT ((0)) FOR [LevelUpPoint]
GO
ALTER TABLE [dbo].[DefaultClassType] ADD  DEFAULT ((17)) FOR [GateNumber]
GO

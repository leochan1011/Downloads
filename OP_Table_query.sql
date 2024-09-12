/****** Object:  Table [dbo].[ODS_DATA_Account]    Script Date: 8/2/2024 11:01:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_Account](
	[AccountId] [int] NOT NULL,
	[AccountAK] [varchar](32) NOT NULL,
	[AccountType] [smallint] NOT NULL,
	[Enabled] [smallint] NOT NULL,
	[ParentAccountId] [int] NULL,
	[DmgCategoryId] [int] NOT NULL,
	[DisplayName] [nvarchar](200) NULL,
	[FirstName] [nvarchar](200) NULL,
	[SurName] [nvarchar](200) NULL,
	[CompanyName] [nvarchar](200) NULL,
	[Address1] [nvarchar](200) NULL,
	[ZipCode] [nvarchar](200) NULL,
	[City] [nvarchar](200) NULL,
	[State] [nvarchar](200) NULL,
	[Country] [nvarchar](200) NULL,
	[HomePhone] [nvarchar](200) NULL,
	[BusinessPhone] [nvarchar](200) NULL,
	[Fax] [nvarchar](200) NULL,
	[MobilePhone] [nvarchar](200) NULL,
	[EmailAddress1] [nvarchar](200) NULL,
	[InsDateTime] [datetime] NOT NULL,
	[UpdDateTime] [datetime] NOT NULL,
	[ExternalCode1] [nvarchar](200) NULL,
	[UpdUserId] [int] NOT NULL,
	[InsUserId] [int] NOT NULL,
	[OfflineAccountAK] [varchar](32) NULL,
	[UserId] [int] NULL,
	[BillingAccountId] [int] NULL,
	[DisplayField2] [nvarchar](200) NULL,
	[DisplayField1] [nvarchar](200) NULL,
	[Password] [nvarchar](100) NULL,
	[AccountGUID] [nvarchar](200) NULL,
	[Membership] [smallint] NOT NULL,
	[LoginAttempts] [smallint] NOT NULL,
	[LanguageId] [int] NULL,
	[ExpirationDate] [datetime] NULL,
	[FinancialBlacklistOption] [smallint] NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[PointsEmailSent] [int] NOT NULL,
	[etl_update_datetime] [datetime] NULL,
 CONSTRAINT [PK__ODS_DATA_Account] PRIMARY KEY CLUSTERED 
(
	[AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[D_Account]    Script Date: 8/2/2024 11:01:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[D_Account](
	[AccountKey] [Bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ETL_Update_Datetime] [datetime] NULL,
	[RecStartDate] [Date] NOT NULL,
	[RecEndDate] [Date] NOT NULL,
	[AccountId] [int] NOT NULL,
	[DisplayName] [nvarchar](200) NULL,
	[FirstName] [nvarchar](200) NULL,
	[SurName] [nvarchar](200) NULL,
	[AccountStatus] [varchar](10) NULL,
	[AccountType] [varchar](30) NULL,
	[DmgCategoryCode] [nvarchar](10) NULL,
	[DmgDescription] [nvarchar](50) NULL,
	[DmgRecursiveName] [nvarchar](200) NULL,
	[PIC] [nvarchar](100) NULL,
	[Market] [nvarchar](100) NULL,
	[B2BCountry] [nvarchar](100) NULL,
	[Region] [nvarchar](100) NULL,
	[Entity] [nvarchar](100) NULL,
	[Sector] [nvarchar](100) NULL,
	[OptInOut] [Bit] NULL,
	[Address1] [varbinary](256) NULL,
	--[Address1] [nvarchar](200) NULL,
	[ZipCode] [nvarchar](200) NULL,
	[City] [nvarchar](200) NULL,
	[State] [nvarchar](200) NULL,
	[Country] [nvarchar](200) NULL,
	--[HomePhone] [nvarchar](200) NULL,
	--[BusinessPhone] [nvarchar](200) NULL,
	[HomePhone] [varbinary](256) NULL,
	[BusinessPhone] [varbinary](256) NULL,
	[Fax] [nvarchar](200) NULL,
	--[MobilePhone] [nvarchar](200) NULL,
	--[EmailAddress1] [nvarchar](200) NULL,
	[MobilePhone] [varbinary](256) NULL,
	[EmailAddress1] [varbinary](256) NULL,

 CONSTRAINT [PK__D_Account] PRIMARY KEY CLUSTERED 
(
	[AccountKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_UF_AccountMaster]    Script Date: 8/5/2024 3:22:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_UF_AccountMaster](
	[AccountId] [int] NOT NULL,
	[AccountName] [nvarchar](200) NULL,
	[EffectiveStartDate] [date] NOT NULL,
	[EffectiveEndDate] [date] NOT NULL,
	[B2BAccountCategory] [varchar](20) NULL,
	[PIC] [nvarchar](100) NULL,
	[Market] [nvarchar](100) NULL,
	[Country] [nvarchar](100) NULL,
	[Region] [nvarchar](100) NULL,
	[Entity] [nvarchar](100) NULL,
	[Sector] [nvarchar](100) NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK_ODS_UF_AccountMaster] PRIMARY KEY CLUSTERED 
(
	[AccountId] ASC,
	[EffectiveStartDate] ASC,
	[EffectiveEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_DATA_Transaction]    Script Date: 7/23/2024 5:43:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ODS_DATA_Transaction](
	[TransactionId] [int] NOT NULL,
	[SystemId] [int] NOT NULL,
	[SiteId] [int] NOT NULL,
	[SaleId] [int] NOT NULL,
	[TransactionAK] [varchar](32) NOT NULL,
	[TransactionType] [smallint] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[FTransactionDate] [datetime] NOT NULL,
	[Serial] [int] NOT NULL,
	[WorkstationId] [int] NOT NULL,
	[OperatingAreaId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[BoxId] [int] NOT NULL,
	[Items] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[TotalAmount] [float] NOT NULL,
	[TotalTaxes] [float] NOT NULL,
	[Revenue] [float] NOT NULL,
	[TaxRevenue] [float] NOT NULL,
	[Change] [float] NOT NULL,
	[Tip] [float] NOT NULL,
	[TransactionStatus] [smallint] NOT NULL,
	[Approved] [smallint] NOT NULL,
	[Validated] [smallint] NOT NULL,
	[Encoded] [smallint] NOT NULL,
	[Completed] [smallint] NOT NULL,
	[Paid] [smallint] NOT NULL,
	[ShiftId] [int] NULL,
	[TimeSlot] [smallint] NULL,
	[Rounding] [float] NOT NULL,
	[UserGroupId] [int] NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[FlexContractStatus] [smallint] NULL,
	[IsBulk] [smallint] NULL,
	[Invoice] [smallint] NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK__DATA_Tra__55433A6B3E52440B] PRIMARY KEY CLUSTERED 
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__DATA_Tra__55437B49412EB0B6] UNIQUE NONCLUSTERED 
(
	[TransactionAK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

------------------------------------------
/****** Object:  Table [dbo].[ODS_DATA_TransactionItem]    Script Date: 7/24/2024 11:28:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_TransactionItem](
	[ItemId] [int] NOT NULL,
	[SystemId] [int] NOT NULL,
	[SiteId] [int] NOT NULL,
	[TransactionId] [int] NOT NULL,
	[SaleItemId] [int] NOT NULL,
	[ProductType] [smallint] NOT NULL,
	[TransactionItemOperation] [smallint] NOT NULL,
	[Position] [int] NULL,
	[Quantity] [smallint] NULL,
	[UnitPrice] [float] NULL,
	[TotalAmount] [float] NULL,
	[UnitTaxes] [float] NULL,
	[TotalTaxes] [float] NULL,
	[GroupingCode] [smallint] NULL,
	[UnitRecharge] [float] NOT NULL,
	[Discount] [money] NOT NULL,
	[QtyUsedForPromotion] [money] NOT NULL,
	[PromotionItemRuleId] [int] NULL,
	[ComboRef] [nvarchar](10) NULL,
	[PersonOnEachMediaIdentifier] [smallint] NULL,
	[SubscriptionId] [int] NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[QuantityToPrint] [int] NULL,
	[ItemTransactionType] [smallint] NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK_Z_ODS_DATA_TransactionItem] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_DATA_Sale]    Script Date: 7/24/2024 1:00:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_Sale](
	[SaleId] [int] NOT NULL,
	[SystemId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[ParentId] [int] NULL,
	[WorkstationId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[SaleType] [smallint] NOT NULL,
	[SaleAK] [varchar](32) NOT NULL,
	[SaleDate] [datetime] NOT NULL,
	[FSaleDate] [datetime] NOT NULL,
	[StatusCode] [smallint] NOT NULL,
	[Serial] [int] NOT NULL,
	[Paid] [smallint] NULL,
	[Approved] [smallint] NULL,
	[Validated] [smallint] NULL,
	[Encoded] [smallint] NULL,
	[Completed] [smallint] NULL,
	[Quantity] [smallint] NOT NULL,
	[TicketCount] [smallint] NOT NULL,
	[TotalAmount] [float] NOT NULL,
	[TotalTaxes] [float] NOT NULL,
	[Revenue] [float] NOT NULL,
	[TaxRevenue] [float] NOT NULL,
	[PerformanceId] [int] NULL,
	[PerformanceCount] [smallint] NOT NULL,
	[GiftAid] [smallint] NULL,
	[RefAccountId] [int] NULL,
	[Operation] [smallint] NOT NULL,
	[OwnerAccountId] [int] NULL,
	[Externalorderid] [varchar](255) NULL,
	[LanguageId] [int] NULL,
	[TaxExempt] [smallint] NOT NULL,
	[PaidTransactionId] [int] NULL,
	[EncodedTransactionId] [int] NULL,
	[ValidatedTransactionId] [int] NULL,
	[CompletedTransactionId] [int] NULL,
	[VoidTransactionId] [int] NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[SalesElapsedTime] [time](0) NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK__DATA_Sal__1EE3C3FF7F60ED59] PRIMARY KEY CLUSTERED 
(
	[SaleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__DATA_Sal__1EE10B19023D5A04] UNIQUE NONCLUSTERED 
(
	[SaleAK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_DATA_SaleItem]    Script Date: 7/26/2024 10:56:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_SaleItem](
	[SaleItemId] [int] NOT NULL,
	[SaleId] [int] NOT NULL,
	[ProductType] [smallint] NOT NULL,
	[Position] [int] NULL,
	[Quantity] [smallint] NOT NULL,
	[UnitRawPrice] [float] NOT NULL,
	[ProductTaxType] [smallint] NOT NULL,
	[UnitPrice] [float] NOT NULL,
	[TotalAmount] [float] NOT NULL,
	[UnitTaxes] [float] NOT NULL,
	[TotalTaxes] [float] NOT NULL,
	[GroupingCode] [smallint] NULL,
	[MatrixCellId] [int] NOT NULL,
	[VoucherId] [int] NULL,
	[UnitRecharge] [float] NOT NULL,
	[MediaId] [int] NULL,
	[PrintOption] [smallint] NOT NULL,
	[TicketId] [int] NULL,
	[ItemTicketId] [int] NULL,
	[GiftAid] [smallint] NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[PeopleCount] [int] NOT NULL,
	[PromotionItemRuleId] [int] NULL,
	[ProductSaleItemId] [int] NULL,
	[RefundedQuantity] [smallint] NULL,
	[ComboRef] [nvarchar](10) NULL,
	[PersonOnEachMediaIdentifier] [smallint] NULL,
	[AttachedMediaId] [int] NULL,
	[OrigMatrixCellId] [int] NULL,
	[OrigUnitSellPrice] [float] NULL,
	[SubscriptionId] [int] NULL,
	[PriceType] [int] NULL,
	[OrigSaleItemId] [int] NULL,
	[BaseSaleId] [int] NULL,
	[GeneratedByTheSystem] [smallint] NULL,
	[UpSellMatrixCellId] [smallint] NULL,
	[CardDependencyType] [int] NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[ShareableEntitlements] [smallint] NULL,
	[ItemGuid] [varchar](38) NULL,
	[ItemTransactionType] [smallint] NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK_Z_ODS_DATA_SaleItem] PRIMARY KEY CLUSTERED 
(
	[SaleItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_DATA_Media]    Script Date: 7/18/2024 12:26:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_Media](
	[MediaId] [int] NOT NULL,
	[VoidType] [smallint] NOT NULL,
	[Printed] [smallint] NOT NULL,
	[DocTemplateId] [int] NULL,
	[PrintDateTime] [datetime] NULL,
	[ExternalMedia] [smallint] NOT NULL,
	[SaveStoredValue] [smallint] NOT NULL,
	[WriteInfoOnChip] [smallint] NOT NULL,
	[LastSerial] [int] NULL,
	[LastAccountId] [int] NULL,
	[LastVoidType] [smallint] NULL,
	[PerformanceID] [int] NULL,
	[ExternalId] [int] NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK_Z_ODS_DATA_Media] PRIMARY KEY CLUSTERED 
(
	[MediaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_DATA_Reservation]    Script Date: 7/18/2024 12:19:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_Reservation](
	[SaleId] [int] NOT NULL,
	[ReservationAK] [varchar](32) NOT NULL,
	[ExternalResCode] [varchar](40) NULL,
	[PickUpDate] [datetime] NULL,
	[PickUpArea] [int] NULL,
	[PickUpType] [smallint] NULL,
	[BatchId] [int] NULL,
	[AccountId] [int] NOT NULL,
	[BillingAccountId] [int] NULL,
	[OperatingAreaId] [int] NULL,
	[B2BAccountId] [int] NULL,
	[batchcode] [varchar](30) NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[Hotel_CheckIn] [datetime] NULL,
	[Hotel_CheckOut] [datetime] NULL,
	[ApprovalStatus] [smallint] NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK_Z_ODS_DATA_Reservation] PRIMARY KEY CLUSTERED 
(
	[SaleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Z_ODS_DATA_Reservation] UNIQUE NONCLUSTERED 
(
	[SaleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Z_ODS_DATA_ReservationAK] UNIQUE NONCLUSTERED 
(
	[ReservationAK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_DATA_SaleCoupon]    Script Date: 7/18/2024 12:23:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_SaleCoupon](
	[SaleCouponId] [int] NOT NULL,
	[SaleId] [int] NOT NULL,
	[PromotionId] [int] NOT NULL,
	[Qty] [int] NOT NULL,
	[CouponId] [int] NULL,
	[SaleItemId] [int] NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[etl_update_datetime] [datetime] NULL,
 CONSTRAINT [PK_Z_ODS_DATA_SaleCoupon] PRIMARY KEY CLUSTERED 
(
	[SaleCouponId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_DATA_Ticket]    Script Date: 7/29/2024 3:01:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_Ticket](
	[TicketId] [int] NOT NULL,
	[WorkstationId] [int] NOT NULL,
	[AccountId] [int] NULL,
	[FEncodeDate] [datetime] NULL,
	[SiteId] [smallint] NOT NULL,
	[WorkstationCode] [smallint] NOT NULL,
	[Serial] [int] NOT NULL,
	[TransactionSerial] [int] NOT NULL,
	[VoidType] [smallint] NOT NULL,
	[PrintDateTime] [datetime] NULL,
	[CurrencyId] [int] NOT NULL,
	[Price] [float] NOT NULL,
	[PrintedPrice] [float] NULL,
	[Taxes] [float] NOT NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[TaxExempt] [smallint] NULL,
	[MaxDebit] [float] NULL,
	[Expire] [datetime] NULL,
	[MatrixCellId] [int] NOT NULL,
	[DmgCategoryId] [int] NULL,
	[SaleItemId] [int] NULL,
	[RawPrice] [float] NOT NULL,
	[ProductTaxType] [smallint] NOT NULL,
	[TaxPackageId] [int] NULL,
	[CreationType] [smallint] NOT NULL,
	[PeopleCount] [int] NOT NULL,
	[Renewed] [smallint] NOT NULL,
	[ExternalReferenceId] [varchar](400) NULL,
	[LastVoidType] [smallint] NULL,
	[Membership] [smallint] NULL,
	[ValidityXML] [varchar](max) NULL,
	[ReprintCounter] [int] NOT NULL,
	[MoneyCardAmount] [float] NULL,
	[Weight] [int] NULL,
	[ProductType] [smallint] NOT NULL,
	[DeliveryType] [smallint] NOT NULL,
	[FirstUsageId] [int] NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[DocStatus] [smallint] NULL,
	[UsedPeopleCount] [int] NOT NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK__DATA_Tic__712CC607571DF1D5] PRIMARY KEY CLUSTERED 
(
	[TicketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_DATA_SaleItem2Ticket]    Script Date: 7/29/2024 2:39:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_SaleItem2Ticket](
	[SaleItem2TicketId] [int] NOT NULL,
	[TicketId] [int] NOT NULL,
	[SaleItemId] [int] NOT NULL,
	[OperationType] [smallint] NOT NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK__DATA_Sal__943D75A71AF3F935] PRIMARY KEY CLUSTERED 
(
	[SaleItem2TicketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_DATA_Ticket2Media]    Script Date: 7/29/2024 3:15:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_Ticket2Media](
	[Ticket2MediaId] [int] NOT NULL,
	[MediaId] [int] NOT NULL,
	[TicketId] [int] NOT NULL,
	[DefaultMedia] [smallint] NOT NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK__DATA_Tic__BFAA222F627A95E8] PRIMARY KEY CLUSTERED 
(
	[Ticket2MediaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_DATA_Transaction2Ticket]    Script Date: 7/29/2024 3:31:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_Transaction2Ticket](
	[Transaction2TicketId] [int] NOT NULL,
	[TransactionId] [int] NOT NULL,
	[TicketId] [int] NOT NULL,
	[OperationType] [smallint] NOT NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK__DATA_Tra__C193FD331EC48A19] PRIMARY KEY CLUSTERED 
(
	[Transaction2TicketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[DATA_PaymentCredit]    Script Date: 9/5/2024 10:15:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_PaymentCredit](
	[PaymentId] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[CreditStatus] [smallint] NOT NULL,
	[DueDate] [datetime] NULL,
	[SettleTransactionId] [int] NULL,
	[AccountId] [int] NOT NULL,
	[EntityTable] [smallint] NOT NULL,
	[AmountDisc] [float] NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
 CONSTRAINT [PK__ODS_DATA_PaymentCredit] PRIMARY KEY CLUSTERED 
(
	[PaymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ODS_DATA_Payment]    Script Date: 9/5/2024 10:52:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ODS_DATA_Payment](
	[PaymentId] [int] NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[FPaymentDate] [datetime] NOT NULL,
	[PaymentAK] [varchar](32) NOT NULL,
	[PaymentStatus] [smallint] NOT NULL,
	[TransactionId] [int] NOT NULL,
	[PaymentAmount] [float] NULL,
	[PaymentType] [smallint] NULL,
	[PaymentMethodId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[CurrencyAmount] [float] NOT NULL,
	[ExchangeRate] [float] NOT NULL,
	[PaymentFee] [float] NOT NULL,
	[ChangeAmount] [float] NOT NULL,
	[ChangeType] [smallint] NOT NULL,
	[DonationAmount] [float] NOT NULL,
	[DonationFormId] [int] NULL,
	[Last_UserId_Log] [int] NULL,
	[Last_WorkstationId_Log] [int] NULL,
	[Last_DateTime_Log] [datetime] NULL,
	[ForeignCurrencyPriceDiff] [float] NULL,
	[etl_Update_Datetime] [datetime] NULL,
 CONSTRAINT [PK__ODS_DATA_Payment] PRIMARY KEY CLUSTERED 
(
	[PaymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__ODS_DATA_Payment] UNIQUE NONCLUSTERED 
(
	[PaymentAK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

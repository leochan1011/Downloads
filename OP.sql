public void Main()
{
    // TODO: Add your code here
    String errMsg = "Error: " + Dts.Variables["lMapErrorCountTotal"].Value.ToString() + " "
                  + Dts.Variables["PackageName"].Value.ToString() + " "
                  + "Error Records Found";
    Dts.Events.FireError(-1, "", errMsg, "", 0);
}

public void Main()
{
    int error_count = (int)Dts.Variables["tplErrorCount"].Value;
    if (error_count=0){

    }
    String errMsg = "Error: " + Dts.Variables["tplErrorCount"].Value.ToString() + " "
                  + Dts.Variables["PackageName"].Value.ToString() + " "
                  + "Error Records Found";
    Dts.Events.FireError(-1, "", errMsg, "", 0);
}

public void Main()
		{
            // TODO: Add your code here
            MessageBox.Show(Dts.Variables["lMapErrorCountTotal"].Value.ToString());
			Dts.TaskResult = (int)ScriptResults.Success;
		}

public void Main()
{
    // TODO: Add your code here
    int error_count = (int) Dts.Variables["lMapErrorCountTotal"].Value;
    if (error_count != 0)
    {
        String errMsg = "Error: " + Dts.Variables["lMapErrorCountTotal"].Value.ToString() + " "
                    + Dts.Variables["PackageName"].Value.ToString() + " "
                    + "Error Records Found";
        Dts.Events.FireError(-1, "", errMsg, "", 0);
        MessageBox.Show(Dts.Variables["lMapErrorCountTotal"].Value.ToString());
        Dts.TaskResult = (int)DTSExecResult.Failure;
    }
    else
    {
        MessageBox.Show(Dts.Variables["lMapErrorCountTotal"].Value.ToString());
        Dts.TaskResult = (int)DTSExecResult.Success;
    }
    Dts.TaskResult = (int)DTSExecResult.Success;


SELECT * FROM SSISDB.catalog.operation_messages

smtp: smtprelay.oceanpark.com.hk
Port number: 25.
sender: dw-admin@oceanpark.com.hk
-----------------------------------------------------------------------------------
# Introduction to the script task

#region Namespaces
using System;
using System.Data;
using Microsoft.SqlServer.Dts.Runtime;
using System.Windows.Forms;
using System.Net;
using System.Net.Mail;
using System.Data.SqlClient;
#endregion

namespace ST_5094f7fc59e0421fb435a265a74ee175
{
	[Microsoft.SqlServer.Dts.Tasks.ScriptTask.SSISScriptTaskEntryPointAttribute]
	public partial class ScriptMain : Microsoft.SqlServer.Dts.Tasks.ScriptTask.VSTARTScriptObjectModelBase
	{
        public void Main()
        {
            string EmailRecipient = Dts.Variables["vEmailWarningsTo"].Value.ToString();
            string EmailSender = Dts.Variables["vEmailWarningsFrom"].Value.ToString();

            string SMTPEndPoint = Dts.Variables["vSMTPEndPoint"].Value.ToString();
            Int32.TryParse(Dts.Variables["vSMTPPort"].Value.ToString(), out int SMTPPort);

            string MessageSubject = "[Failed] SSIS Package: '"+ Dts.Variables["vReportPkname"].Value.ToString() + "' completed on " + DateTime.Now.ToString("ddd, dd MMM yyy HH':'mm':'ss 'GMT'");
            string MessageBody = "JOB RUN:" + Dts.Variables["vReportPkname"].Value.ToString() + "." + "<br>" + "<br>"
                        + "<p><u>Details</u>:</p>"
                        + "Event Handler Type: " + Dts.Variables["_08eventHandlerType"].Value.ToString() + "<br>" + "<br>"
                        + "Container GUID: " + Dts.Variables["_07parentGUID"].Value.ToString() + "<br>" + "<br>"
                        + "Task Name: " + Dts.Variables["_06taskName"].Value.ToString() + "<br>" + "<br>"
                        + " <p style=\"font-size:50px\"> &#128526; </p>"
                        + "SSIS";

            "<table style='font-family:Arial'>
                <tr>
                    <td>RUN JOB:</td>
                    <td>'" + Dts.Variables["vReportPkname"].Value.ToString()+ "' was run on " + DateTime.Now.ToString("ddd, dd MMM yyy HH':'mm':'ss 'GMT'") + "
                </tr>
                <tr>
                    <td>RUN USER:</td>
                    <td>" + Dts.Variables["vReportUserName"].Value.ToString() + "</td>
                </tr>
                <tr>
                    <td>DURATION:</td>
                    <td>" + Dts.Variables["vReportTime"].Value.ToString()+ "</td>
                </tr>
                <tr>
                    <td>STATUS:</td>
                    <td>Failed</td>
                </tr>
                <tr>
                    <td>MESSAGES:</td>
                    <td>The job failed. " + Dts.Variables["vReportErrorSQL"].Value.ToString() + " Check the error log file for detail.</td>
                </tr>
            </table>"


            MailMessage msg = new MailMessage();
            //Attachment objattachments = new Attachment(@"c:\\abc");

            msg.To.Add(new MailAddress(EmailRecipient));
            msg.From = new MailAddress(EmailSender);
            msg.Subject = MessageSubject;
            msg.IsBodyHtml = true;
            msg.Body = "<span style="
                + "\"font-size:15px; font-family:Arial;\""
                + ">"
                + MessageBody
                + "</span>";
            //msg.Attachments.Add(objattachments);


            //SMTP Connection
            SmtpClient client = new SmtpClient(SMTPEndPoint, SMTPPort)
            {
                UseDefaultCredentials = false,
                EnableSsl = false,
                DeliveryMethod = SmtpDeliveryMethod.Network
            };
            //End of SMTP Connection

            try
            {
                client.Send(msg);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            Dts.TaskResult = (int)ScriptResults.Success;
        }

        #region ScriptResults declaration
        /// <summary>
        /// This enum provides a convenient shorthand within the scope of this class for setting the
        /// result of the script.
        /// 
        /// This code was generated automatically.
        /// </summary>
        enum ScriptResults
        {
            Success = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Success,
            Failure = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Failure
        };
        #endregion

	}
}



UPDATE [dbo].[ODS_DATA_Transaction]
   SET [SystemId] = t.SystemId
      ,[SiteId] = t.SiteId
      ,[SaleId] = t.SaleId
      ,[TransactionAK] = t.TransactionAK
      ,[TransactionType] = t.TransactionType
      ,[TransactionDate] = t.TransactionDate
      ,[FTransactionDate] = t.FTransactionDate
      ,[Serial] = t.Serial
      ,[WorkstationId] = t.WorkstationId
      ,[OperatingAreaId] = t.OperatingAreaId
      ,[UserId] = t.UserId
      ,[BoxId] = t.BoxId
      ,[Items] = t.Items
      ,[Quantity] = t.Quantity
      ,[TotalAmount] = t.TotalAmount
      ,[TotalTaxes] = t.TotalTaxes
      ,[Revenue] = t.Revenue
      ,[TaxRevenue] = t.TaxRevenue
      ,[Change] = t.Change
      ,[Tip] = t.Tip
      ,[TransactionStatus] = t.TransactionStatus
      ,[Approved] = t.Approved
      ,[Validated] = t.Validated
      ,[Encoded] = t.Encoded
      ,[Completed] = t.Completed
      ,[Paid] = t.Paid
      ,[ShiftId] = t.ShiftId
      ,[TimeSlot] = t.TimeSlot
      ,[Rounding] = t.Rounding
      ,[UserGroupId] = t.UserGroupId
      ,[Last_UserId_Log] = t.Last_UserId_Log
      ,[Last_WorkstationId_Log] = t.Last_WorkstationId_Log
      ,[Last_DateTime_Log] = t.Last_DateTime_Log
      ,[IsBulk] = t.IsBulk
      ,[Invoice] = t.Invoice
      ,[etl_Update_Datetime] = ?
FROM         dbo.STG_DATA_Transaction AS t INNER JOIN
                      dbo.ODS_DATA_Transaction ON t.TransactionId = dbo.ODS_DATA_Transaction.TransactionId
WHERE     (t.etl_Update_Datetime < ?)
----------------------------------------------------

UPDATE [dbo].[ODS_DATA_Transaction]
   SET [SystemId] = ?
      ,[SiteId] = ?
      ,[SaleId] = ?
      ,[TransactionAK] = ?
      ,[TransactionType] = ?
      ,[TransactionDate] = ?
      ,[FTransactionDate] = ?
      ,[Serial] = ?
      ,[WorkstationId] = ?
      ,[OperatingAreaId] = ?
      ,[UserId] = ?
      ,[BoxId] = ?
      ,[Items] = ?
      ,[Quantity] = ?
      ,[TotalAmount] = ?
      ,[TotalTaxes] = ?
      ,[Revenue] = ?
      ,[TaxRevenue] = ?
      ,[Change] = ?
      ,[Tip] = ?
      ,[TransactionStatus] = ?
      ,[Approved] = ?
      ,[Validated] = ?
      ,[Encoded] = ?
      ,[Completed] = ?
      ,[Paid] = ?
      ,[ShiftId] = ?
      ,[TimeSlot] = ?
      ,[Rounding] = ?
      ,[UserGroupId] = ?
      ,[Last_UserId_Log] = ?
      ,[Last_WorkstationId_Log] = ?
      ,[Last_DateTime_Log] = ?
      ,[IsBulk] = ?
      ,[Invoice] = ?
      ,[etl_Update_Datetime] = ?
FROM         dbo.STG_DATA_Transaction 
WHERE [TransactionId] = ?


INSERT INTO [dbo].[ODS_DATA_Transaction] ([TransactionId],[SystemId],[SiteId],[SaleId],[TransactionAK],[TransactionType],[TransactionDate],[FTransactionDate],[Serial],[WorkstationId],[OperatingAreaId],[UserId],[BoxId],[Items],[Quantity],[TotalAmount],[TotalTaxes],[Revenue],[TaxRevenue],[Change],[Tip],[TransactionStatus],[Approved],[Validated],[Encoded],[Completed],[Paid],[ShiftId],[TimeSlot],[Rounding],[UserGroupId],[Last_UserId_Log],[Last_WorkstationId_Log],[Last_DateTime_Log],[IsBulk],[Invoice],[etl_Update_Datetime])
VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)

UPDATE [dbo].[ODS_DATA_Ticket]
   SET [WorkstationId] = ?
        ,[AccountId] = ?
        ,[FEncodeDate] = ?
        ,[SiteId] = ?
        ,[WorkstationCode] = ?
        ,[Serial] = ?
        ,[TransactionSerial] = ?
        ,[VoidType] = ?
        ,[PrintDateTime] = ?
        ,[CurrencyId] = ?
        ,[Price] = ?
        ,[PrintedPrice] = ?
        ,[Taxes] = ?
        ,[ActiveFrom] = ?
        ,[ActiveTo] = ?
        ,[TaxExempt] = ?
        ,[MaxDebit] = ?
        ,[Expire] = ?
        ,[MatrixCellId] = ?
        ,[DmgCategoryId] = ?
        ,[SaleItemId] = ?
        ,[RawPrice] = ?
        ,[ProductTaxType] = ?
        ,[TaxPackageId] = ?
        ,[CreationType] = ?
        ,[PeopleCount] = ?
        ,[Renewed] = ?
        ,[ExternalReferenceId] = ?
        ,[LastVoidType] = ?
        ,[Membership] = ?
        ,[ValidityXML] = ?
        ,[ReprintCounter] = ?
        ,[MoneyCardAmount] = ?
        ,[Weight] = ?
        ,[ProductType] = ?
        ,[DeliveryType] = ?
        ,[FirstUsageId] = ?
        ,[Last_UserId_Log] = ?
        ,[Last_WorkstationId_Log] = ?
        ,[Last_DateTime_Log] = ?
        ,[DocStatus] = ?
        ,[UsedPeopleCount] = ?
        ,[etl_Update_Datetime] = ?
WHERE [TicketId] = ?


------------------------------------------------------------------------------------------------
/* Selecting the Target and the Source */
MERGE ODS_DATA_SaleItem AS TARGET
    USING STG_DATA_SaleItem AS SOURCE 

    ON (TARGET.SaleItemId = SOURCE.SaleItemId)
    WHEN MATCHED 
        AND (TARGET.SystemId <> SOURCE.SystemId
        OR TARGET.SiteId <> SOURCE.SiteId
        OR TARGET.SaleId <> SOURCE.SaleId
        OR TARGET.TransactionAK <> SOURCE.TransactionAK
        OR TARGET.TransactionType <> SOURCE.TransactionType
        OR TARGET.TransactionDate <> SOURCE.TransactionDate
        OR TARGET.FTransactionDate <> SOURCE.FTransactionDate
        OR TARGET.Serial <> SOURCE.Serial
        OR TARGET.WorkstationId <> SOURCE.WorkstationId
        OR TARGET.OperatingAreaId <> SOURCE.OperatingAreaId
        OR TARGET.UserId <> SOURCE.UserId
        OR TARGET.BoxId <> SOURCE.BoxId
        OR TARGET.Items <> SOURCE.Items
        OR TARGET.Quantity <> SOURCE.Quantity
        OR TARGET.TotalAmount <> SOURCE.TotalAmount
        OR TARGET.TotalTaxes <> SOURCE.TotalTaxes
        OR TARGET.Revenue <> SOURCE.Revenue
        OR TARGET.TaxRevenue <> SOURCE.TaxRevenue
        OR TARGET.Change <> SOURCE.Change
        OR TARGET.Tip <> SOURCE.Tip
        OR TARGET.TransactionStatus <> SOURCE.TransactionStatus
        OR TARGET.Approved <> SOURCE.Approved
        OR TARGET.Validated <> SOURCE.Validated
        OR TARGET.Encoded <> SOURCE.Encoded
        OR TARGET.Completed <> SOURCE.Completed
        OR TARGET.Paid <> SOURCE.Paid
        OR TARGET.ShiftId <> SOURCE.ShiftId
        OR TARGET.TimeSlot <> SOURCE.TimeSlot
        OR TARGET.Rounding <> SOURCE.Rounding
        OR TARGET.UserGroupId <> SOURCE.UserGroupId
        OR TARGET.Last_UserId_Log <> SOURCE.Last_UserId_Log
        OR TARGET.Last_WorkstationId_Log <> SOURCE.Last_WorkstationId_Log
        OR TARGET.Last_DateTime_Log <> SOURCE.Last_DateTime_Log
        OR TARGET.IsBulk <> SOURCE.IsBulk
        OR TARGET.Invoice <> SOURCE.Invoice
        OR TARGET.etl_Update_Datetime <> SOURCE.etl_Update_Datetime)

    THEN UPDATE 
        SET TARGET.SystemId = SOURCE.SystemId
            ,TARGET.SiteId = SOURCE.SiteId
            ,TARGET.SaleId = SOURCE.SaleId
            ,TARGET.TransactionAK = SOURCE.TransactionAK
            ,TARGET.TransactionType = SOURCE.TransactionType
            ,TARGET.TransactionDate = SOURCE.TransactionDate
            ,TARGET.FTransactionDate = SOURCE.FTransactionDate
            ,TARGET.Serial = SOURCE.Serial
            ,TARGET.WorkstationId = SOURCE.WorkstationId
            ,TARGET.OperatingAreaId = SOURCE.OperatingAreaId
            ,TARGET.UserId = SOURCE.UserId
            ,TARGET.BoxId = SOURCE.BoxId
            ,TARGET.Items = SOURCE.Items
            ,TARGET.Quantity = SOURCE.Quantity
            ,TARGET.TotalAmount = SOURCE.TotalAmount
            ,TARGET.TotalTaxes = SOURCE.TotalTaxes
            ,TARGET.Revenue = SOURCE.Revenue
            ,TARGET.TaxRevenue = SOURCE.TaxRevenue
            ,TARGET.Change = SOURCE.Change
            ,TARGET.Tip = SOURCE.Tip
            ,TARGET.TransactionStatus = SOURCE.TransactionStatus
            ,TARGET.Approved = SOURCE.Approved
            ,TARGET.Validated = SOURCE.Validated
            ,TARGET.Encoded = SOURCE.Encoded
            ,TARGET.Completed = SOURCE.Completed
            ,TARGET.Paid = SOURCE.Paid
            ,TARGET.ShiftId = SOURCE.ShiftId
            ,TARGET.TimeSlot = SOURCE.TimeSlot
            ,TARGET.Rounding = SOURCE.Rounding
            ,TARGET.UserGroupId = SOURCE.UserGroupId
            ,TARGET.Last_UserId_Log = SOURCE.Last_UserId_Log
            ,TARGET.Last_WorkstationId_Log = SOURCE.Last_WorkstationId_Log
            ,TARGET.Last_DateTime_Log = SOURCE.Last_DateTime_Log
            ,TARGET.IsBulk = SOURCE.IsBulk
            ,TARGET.Invoice = SOURCE.Invoice
            ,TARGET.etl_Update_Datetime = ?
     
    /* 2. Performing the INSERT operation */
    WHEN NOT MATCHED BY TARGET 
    THEN INSERT ([TransactionId],[SystemId],[SiteId],[SaleId],[TransactionAK],[TransactionType],[TransactionDate],[FTransactionDate],[Serial],[WorkstationId],[OperatingAreaId],[UserId],[BoxId],[Items],[Quantity],[TotalAmount],[TotalTaxes],[Revenue],[TaxRevenue],[Change],[Tip],[TransactionStatus],[Approved],[Validated],[Encoded],[Completed],[Paid],[ShiftId],[TimeSlot],[Rounding],[UserGroupId],[Last_UserId_Log],[Last_WorkstationId_Log],[Last_DateTime_Log],[IsBulk],[Invoice],[etl_Update_Datetime])          
        VALUES (SOURCE.TransactionId
        ,SOURCE.SystemId
        ,SOURCE.SiteId
        ,SOURCE.SaleId
        ,SOURCE.TransactionAK
        ,SOURCE.TransactionType
        ,SOURCE.TransactionDate
        ,SOURCE.FTransactionDate
        ,SOURCE.Serial
        ,SOURCE.WorkstationId
        ,SOURCE.OperatingAreaId
        ,SOURCE.UserId
        ,SOURCE.BoxId
        ,SOURCE.Items
        ,SOURCE.Quantity
        ,SOURCE.TotalAmount
        ,SOURCE.TotalTaxes
        ,SOURCE.Revenue
        ,SOURCE.TaxRevenue
        ,SOURCE.Change
        ,SOURCE.Tip
        ,SOURCE.TransactionStatus
        ,SOURCE.Approved
        ,SOURCE.Validated
        ,SOURCE.Encoded
        ,SOURCE.Completed
        ,SOURCE.Paid
        ,SOURCE.ShiftId
        ,SOURCE.TimeSlot
        ,SOURCE.Rounding
        ,SOURCE.UserGroupId
        ,SOURCE.Last_UserId_Log
        ,SOURCE.Last_WorkstationId_Log
        ,SOURCE.Last_DateTime_Log
        ,SOURCE.IsBulk
        ,SOURCE.Invoice
        ,?);
--------------------------------------------------------------------
------For package-----------------
MERGE ODS_DATA_PaymentCredit AS TARGET
    USING STG_DATA_PaymentCredit AS SOURCE 

    ON (TARGET.PaymentId = SOURCE.PaymentId)
    WHEN MATCHED 
        AND TARGET.EntityId <> SOURCE.EntityId
        OR TARGET.CreditStatus <> SOURCE.CreditStatus
        OR TARGET.DueDate <> SOURCE.DueDate
        OR TARGET.SettleTransactionId <> SOURCE.SettleTransactionId
        OR TARGET.AccountId <> SOURCE.AccountId
        OR TARGET.EntityTable <> SOURCE.EntityTable
        OR TARGET.AmountDisc <> SOURCE.AmountDisc
        OR TARGET.Last_UserId_Log <> SOURCE.Last_UserId_Log
        OR TARGET.Last_WorkstationId_Log <> SOURCE.Last_WorkstationId_Log
        OR TARGET.Last_DateTime_Log <> SOURCE.Last_DateTime_Log

    THEN UPDATE
        SET 
        TARGET.EntityId = SOURCE.EntityId
        , TARGET.CreditStatus = SOURCE.CreditStatus
        , TARGET.DueDate = SOURCE.DueDate
        , TARGET.SettleTransactionId = SOURCE.SettleTransactionId
        , TARGET.AccountId = SOURCE.AccountId
        , TARGET.EntityTable = SOURCE.EntityTable
        , TARGET.AmountDisc = SOURCE.AmountDisc
        , TARGET.Last_UserId_Log = SOURCE.Last_UserId_Log
        , TARGET.Last_WorkstationId_Log = SOURCE.Last_WorkstationId_Log
        , TARGET.Last_DateTime_Log = ?

    WHEN NOT MATCHED BY TARGET 
    THEN INSERT (PaymentId, EntityId, CreditStatus, DueDate, SettleTransactionId, AccountId, EntityTable, AmountDisc, Last_UserId_Log, Last_WorkstationId_Log, Last_DateTime_Log)
        VALUES (SOURCE.PaymentId
                ,SOURCE.EntityId
                ,SOURCE.CreditStatus
                ,SOURCE.DueDate
                ,SOURCE.SettleTransactionId
                ,SOURCE.AccountId
                ,SOURCE.EntityTable
                ,SOURCE.AmountDisc
                ,SOURCE.Last_UserId_Log
                ,SOURCE.Last_WorkstationId_Log
                ,?);









ISNULL([InsDateTime]) ? NULL(DT_DBTIMESTAMP):(DT_DBTIMESTAMP)(SUBSTRING([InsDateTime],1,4) + "-" + SUBSTRING([InsDateTime],6,2) + "-" + SUBSTRING([InsDateTime],9,2) +" " + SUBSTRING([InsDateTime],12,18))


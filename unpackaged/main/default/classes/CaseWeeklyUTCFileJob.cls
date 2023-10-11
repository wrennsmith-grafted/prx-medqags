/**
 * @description       : CaseWeeklyUTCFileJob Client class. Once a week (Sunday 10pm ET), sweep all Cases with the Status = “Transfer to Health Plan”.
 *                                                          For all records identified, set Sent to Aetna (new field) to “Queued”
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-11-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   05-19-2022   Ricardy Banks					   Initial Version: MBP-459 Salesforce: Sweep all Cases with the Status = “Transfer to Health Plan”
 *
 **/

//public with sharing class CaseRoutingJob {
/**
 * Class implements the required interfaces for Scheduling and executing in Batch
 *
 * NOTE: The server and selector methods are reused, logic in this batch class is thus very light,
 *        focusing on passing parameters in and handling errors and notifications
 *
 **/

global with sharing class CaseWeeklyUTCFileJob
        implements System.Schedulable, Database.Batchable<SObject>, Database.Stateful
{
    // Simple job log for errors
    private List<JobError> jobErrors = new List<JobError>();

    global void execute(SchedulableContext sc)
    {
        // Start the job once the scheduled time has arrived
        Database.executeBatch(new CaseWeeklyUTCFileJob());
    }

    public Database.QueryLocator start(Database.BatchableContext context)
    {

        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
        // Obtain appropriate query locator from the selector
        return casesSelector.queryCasesStatusTransfertoHealthPlan();
    }

    public void execute(Database.BatchableContext context, List<Case> caseList)
    {
        try
        {
            System.debug('The list of case records passed on to the execute method in CaseWeeklyUTCFileJob is: '+caseList);

            //CaseService casesService = (CaseService) PMd_Application.Selector.newInstance(Case.SObjectType);
            List<Case> casesSetSendToAetnaQueued = CaseService.setSendToAetna(caseList, 'Queued');
            System.debug('casesSetSendToAetnaQueued.size() = '+casesSetSendToAetnaQueued.size());
            update casesSetSendToAetnaQueued;
        }
        catch (Exception e)
        {
            // Capture context and error for reporting once job complete
            JobError jobError = new JobError();
            jobError.records = caseList;
            jobError.message = e.getMessage();
            System.debug('jobError.records = '+jobError.records);
            System.debug('jobError.message = '+jobError.message);
            jobErrors.add(jobError);
        }
    }

    public void finish(Database.BatchableContext context)
    {
        // Simple notification of any errors received via email
        if(jobErrors.size() > 0)
        {
            // Email address from user
            Map<Id, String> usersEmail =
                    new UsersSelector().getUsersEmail(
                            new Set<Id> { UserInfo.getUserId() });
            // Construct email body
            String emailBody = '';
            for(JobError jobError : jobErrors)
            {
                List<String> failedCases = new List<String>();
                for (Case caseRecord : jobError.records)
                {
                    failedCases.add(caseRecord.CaseNumber);
                }
                emailBody += String.format('<p>Error {0} occurred during the processing of Cases {1}</p>',
                        new List<String> { jobError.message, String.join(failedCases, ',') });
            }
            // Send email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { usersEmail.get(UserInfo.getUserId()) });
            mail.setReplyTo(usersEmail.get(UserInfo.getUserId()));
            mail.setSenderDisplayName(UserInfo.getUserName());
            mail.setSubject('Create CaseWeeklyUTCFileJob  Failures');
            mail.setHtmlBody(emailBody);
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    /**
     * Simple wrapper class containing the error message and the records in scope at the time
     **/
    public class JobError
    {
        public String message;
        public List<Case> records;
    }
}
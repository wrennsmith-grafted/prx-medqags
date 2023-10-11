/**
 * @description       : MBP-470 Reimbursement cases - add the age of claim / case
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 01-26-2023
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   01-26-2023   Ricardy Banks					   Initial Version
 *
 *
 **/
/**
 * Class implements the required interfaces for Scheduling and executing in Batch
 *
 * NOTE: The server and selector methods are reused, logic in this batch class is thus very light,
 *        focusing on passing parameters in and handling errors and notifications
 *
 **/

global with sharing class CaseAgingJob
        implements System.Schedulable, Database.Batchable<SObject>, Database.Stateful
{

    // Simple job log for errors
    private List<JobError> jobErrors = new List<JobError>();

    global void execute(SchedulableContext sc)
    {
        // Start the job once the scheduled time has arrived
        Database.executeBatch(new CaseRoutingJob());

    }

    public Database.QueryLocator start(Database.BatchableContext context)
    {
        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
        // Obtain appropriate query locator from the selector
        return casesSelector.queryOpenReimbursementCases();
    }

    public void execute(Database.BatchableContext context, List<Case> caseList)
    {

        System.debug('The list of case records passed on to the execute method in setSendToAetna is: '+caseList);
        List<Case> casesUpdatedList = CaseService.setOpenCaseAge(caseList);
        System.debug('casesRoutedList.size() = '+casesUpdatedList.size());
        String method = 'CaseAgingJob.execute';
        String errorMessage = '';

        /**
        try
        {
            update casesUpdatedList;
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
        **/

        if(casesUpdatedList.size()>0) {

            Database.SaveResult[] saveResultList = Database.update(casesUpdatedList, false);

            // Iterate through saveResultList based on isSuccess capture the failed records
            for (Database.SaveResult sr : saveResultList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Communications Successfully inserted' + sr.getId());
                } else {
                    // Operation failed, so get all errors
                    for (Database.Error err : sr.getErrors()) {
                        errorMessage += '\n ' + err.getMessage();
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Communications fields that affected this error: ' + err.getFields());
                        String emailBody = method + '<p>Communications fields that affected this error:  ' + errorMessage;
                        ErrorLog.sendErrorLogEmail('Error processing ' + method, emailBody);
                    }
                }
            }
        }
    }

    public void finish(Database.BatchableContext context)
    {
        if (Test.isRunningTest()) {
            JobError testJobError = new JobError();
            testJobError.message = 'Test Job Error message';
            testJobError.records =  new List<Case>();
            jobErrors.add(testJobError);
        }
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
                emailBody += String.format('<p>Error {0} occurred during the processing of Case Aging {1}</p>',
                        new List<String> { jobError.message, String.join(failedCases, ',') });
            }
            // Send email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { usersEmail.get(UserInfo.getUserId()) });
            mail.setReplyTo(usersEmail.get(UserInfo.getUserId()));
            mail.setSenderDisplayName(UserInfo.getUserName());
            mail.setSubject('Create Case Job Failures');
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
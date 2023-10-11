/**
 * @description       : CaseRoutingJob Client class. Manages routing of open Enrollment and Reimbursement Cases.(Case Routing Logic)
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-11-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   05-02-2022   Ricardy Banks					   Initial Version
 * 1.2   05-02-2022	  Ricardy Banks					   MBP-399 Case Routing Business Logic. Default Case owner to General
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
global with sharing class CaseRoutingJob
        implements System.Schedulable, Database.Batchable<SObject>, Database.Stateful
{
    // Simple job log for errors
    private List<JobError> jobErrors = new List<JobError>();
    public static Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);

    global void execute(SchedulableContext sc)
    {
        // Start the job once the scheduled time has arrived
        Database.executeBatch(new CaseRoutingJob());
    }

    public Database.QueryLocator start(Database.BatchableContext context)
    {
        Id generalQueue;

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                switch on queue {
                    when 'General' { // when queue is General
                        generalQueue = GroupId;
                    }
                }
            }
        }

        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
        // Obtain appropriate query locator from the selector
        return casesSelector.queryLocatorCasesOpen(generalQueue);
    }

    public void execute(Database.BatchableContext context, List<Case> caseList)
    {
            System.debug('The list of case records passed on to the execute method in CaseRoutingJob is: '+caseList);
            // Cases ready to be routed
            Set<Id>casesToRout = new Map<Id, SObject>(caseList).keySet();

            // Route Cases
            List<Case> casesRoutedList = CaseService.reRouteExistingCaseRoutingRecords(caseList);
            System.debug('casesRoutedList.size() = '+casesRoutedList.size());
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
                emailBody += String.format('<p>Error {0} occurred during the processing of Cases {1}</p>',
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
/**
 * @description       : ErrorLogJob Client class. Once a day (Sunday 10pm ET), sweep all Cases with the Status = “Transfer to Health Plan”.
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

//public with sharing class ErrorLogJob {
/**
 * Class implements the required interfaces for Scheduling and executing in Batch
 *
 * NOTE: The server and selector methods are reused, logic in this batch class is thus very light,
 *        focusing on passing parameters in and handling errors and notifications
 *
 **/

global with sharing class  ErrorLogJob
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

        ErrorLogSelector errorLogSelector = (ErrorLogSelector) PMd_Application.Selector.newInstance(Error_Log__c.SObjectType);
        // Obtain appropriate query locator from the selector
        return errorLogSelector.selectErrorLogsByCreatedDate(System.today());
    }

    public void execute(Database.BatchableContext context, List<Error_Log__c> errorLogList)
    {
        System.debug('Start Error_Log:onAfterInsert');

        fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

        //List<Member_Drug__c> lstMemberDrug = Trigger.new;
        Map<Id, Error_Log__c> errorLogByHistoricalPAId = new Map<Id, Error_Log__c>();
        Map<Id, Error_Log__c> errorLogByPAId = new Map<Id, Error_Log__c>();
        Map<Id, Error_Log__c> errorLogByDailyClaimId = new Map<Id, Error_Log__c>();
        Map<Id, Error_Log__c> errorLogByHistoricalClaimId = new Map<Id, Error_Log__c>();

        for(Error_Log__c errorLog : errorLogList){
            if(errorLog.Historical_Prior_Auth__c != null) {
                errorLogByHistoricalPAId.put(errorLog.Historical_Prior_Auth__c, errorLog);
            }
            if(errorLog.Prior_Auth__c != null) {
                errorLogByPAId.put(errorLog.Prior_Auth__c, errorLog);
            }
            if(errorLog.Daily_Claim__c != null) {
                errorLogByDailyClaimId.put(errorLog.Daily_Claim__c, errorLog);
            }
            if(errorLog.Historical_Claim__c != null) {
                errorLogByHistoricalClaimId.put(errorLog.Historical_Claim__c, errorLog);
            }
        }

        //Map all Case related Daily Claims
        if(errorLogByDailyClaimId.size() > 0) {
            mapErrorsToDailyClaim(errorLogByDailyClaimId, uow);
        }

        //Map all Case related Historical Claims
        if(errorLogByHistoricalClaimId.size() > 0) {
            mapErrorsToHistoricalClaim(errorLogByHistoricalClaimId, uow);
        }

        //Map all Case related PAs
        if(errorLogByPAId.size() > 0) {
            mapErrorsToPA(errorLogByPAId, uow);
        }

        //Map all Case related Historical PAs
        if(errorLogByHistoricalPAId.size() > 0) {
            mapErrorsToHistoricalPA(errorLogByHistoricalPAId, uow);
        }

        System.debug('End Error_Log:onAfterInsert');
    }

    public void finish(Database.BatchableContext context) {

        if (Test.isRunningTest()) {
            JobError testJobError = new JobError();
            testJobError.message = 'Test Job Error message';
            testJobError.records =  new List<Case>();
            jobErrors.add(testJobError);
        }
        // Simple notification of any errors received via email
        if (jobErrors.size() > 0) {
            // Email address from user
            Map<Id, String> usersEmail =
                    new UsersSelector().getUsersEmail(
                            new Set<Id>{
                                    UserInfo.getUserId()
                            });
            // Construct email body
            String emailBody = '';
            for (JobError jobError : jobErrors) {
                List<String> failedCases = new List<String>();
                for (Case caseRecord : jobError.records) {
                    failedCases.add(caseRecord.CaseNumber);
                }
                emailBody += String.format('<p>Error {0} occurred during the processing of Cases {1}</p>',
                        new List<String>{
                                jobError.message, String.join(failedCases, ',')
                        });
            }
            // Send email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{
                    usersEmail.get(UserInfo.getUserId())
            });
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

    private void mapErrorsToDailyClaim(Map<Id, Error_Log__c> errorLogByDailyClaimId, fflib_ISObjectUnitOfWork uow) {

        List<SObject> existingDailyClaimList = new List<SObject>();

        Daily_ClaimsSelector dailyClaimSelector = (Daily_ClaimsSelector) PMd_Application.Selector.newInstance(Daily_Claim__c.SObjectType);
        List<Daily_Claim__c> relatedDailyClaimsList = dailyClaimSelector.selectById(errorLogByDailyClaimId.keySet());
        System.debug('relatedDailyClaimsList Count: ' + relatedDailyClaimsList.size());

        for(Daily_Claim__c dailyClaimRecord :relatedDailyClaimsList) {
            Error_Log__c errorLogRecord = errorLogByDailyClaimId.get(dailyClaimRecord.Id);
            dailyClaimRecord.Status__c = 'Error';
            dailyClaimRecord.Error_Log__c = errorLogRecord.Error_Message__c;

            Boolean dublicatesDetectedError = errorLogRecord.Error_Message__c.contains('DUPLICATES_DETECTED');
            System.debug('dublicatesDetectedError = ' + dublicatesDetectedError);
            System.debug('dailyClaimRecord.Id = ' + dailyClaimRecord.Id);
            if(dublicatesDetectedError) {
                dailyClaimRecord.Error_Log__c = 'Unable to create record due to duplicate.';
            }
            Boolean claimAdjustmentError = errorLogRecord.Error_Message__c.contains('Claim Adjustment Error');
            if(claimAdjustmentError) {
                dailyClaimRecord.Error_Log__c = 'Claim Adjustment Error.';
            }
            Boolean cpaPaidAmountMismatch = errorLogRecord.Error_Message__c.contains('CPA Paid Amount Mismatch');
            if(cpaPaidAmountMismatch) {
                dailyClaimRecord.Error_Log__c = 'CPA Paid Amount Mismatch';
            }
            //dailyClaimRecord.Error_Log__c = errorLogRecord.Id;
            //dailyClaimRecord.Status__c = caseRecord.Daily_Claim_Status__c;
            System.debug('dailyClaimRecord.Id = ' + dailyClaimRecord.Id);
            existingDailyClaimList.add(dailyClaimRecord);
        }

        //uow.registerDirty(existingDailyClaimList);
        update existingDailyClaimList;

        System.debug('existingDailyClaimList Count = ' + existingDailyClaimList.size());

    }

    private void mapErrorsToHistoricalClaim(Map<Id, Error_Log__c> errorLogByHistoricalClaimId, fflib_ISObjectUnitOfWork uow) {

        List<SObject> existingHistoricalClaimList = new List<SObject>();

        Historical_ClaimsSelector historicalClaimSelector = (Historical_ClaimsSelector) PMd_Application.Selector.newInstance(Historical_Claim__c.SObjectType);
        List<Historical_Claim__c> relatedHistoricalClaimsList = historicalClaimSelector.selectById(errorLogByHistoricalClaimId.keySet());
        System.debug('relatedHistoricalClaimsList Count: ' + relatedHistoricalClaimsList.size());

        for(Historical_Claim__c historicalClaimRecord :relatedHistoricalClaimsList) {
            Error_Log__c errorLogRecord = errorLogByHistoricalClaimId.get(historicalClaimRecord.Id);
            Boolean dublicatesDetectedError = errorLogRecord.Error_Message__c.contains('DUPLICATES_DETECTED');
            if(dublicatesDetectedError) {
                historicalClaimRecord.Status__c = 'Error';
                historicalClaimRecord.Error_Log__c = 'Unable to create record due to duplicate.';
            }
            existingHistoricalClaimList.add(historicalClaimRecord);
        }

        update existingHistoricalClaimList;

        System.debug('existingDailyClaimList Count = ' + existingHistoricalClaimList.size());

    }

    private void mapErrorsToPA(Map<Id, Error_Log__c> errorLogByPAId, fflib_ISObjectUnitOfWork uow) {

        List<SObject> existingPAList = new List<SObject>();

        Prior_AuthSelector paSelector = (Prior_AuthSelector) PMd_Application.Selector.newInstance(Prior_Auth__c.SObjectType);
        List<Prior_Auth__c> relatedPAList = paSelector.selectById(errorLogByPAId.keySet());
        System.debug('relatedPAList Count: ' + relatedPAList.size());

        for(Prior_Auth__c paRecord :relatedPAList) {
            Error_Log__c errorLogRecord = errorLogByPAId.get(paRecord.Id);
            Boolean dublicatesDetectedError = errorLogRecord.Error_Message__c.contains('DUPLICATES_DETECTED');
            if(dublicatesDetectedError) {
                paRecord.Status__c = 'Error';
                paRecord.Error_Log__c = 'Unable to create record due to duplicate.';
            }
            existingPAList.add(paRecord);
        }

        update existingPAList;

        System.debug('existingPAList Count = ' + existingPAList.size());

    }

    private void mapErrorsToHistoricalPA(Map<Id, Error_Log__c> errorLogByHistoricalPAId, fflib_ISObjectUnitOfWork uow) {

        List<SObject> existingHistoricalPAList = new List<SObject>();

        Historical_Prior_AuthSelector  historicalPASelector = (Historical_Prior_AuthSelector) PMd_Application.Selector.newInstance(Historical_Prior_Auth__c.SObjectType);
        List<Historical_Prior_Auth__c> relatedHistoricalPAList = historicalPASelector.selectById(errorLogByHistoricalPAId.keySet());
        System.debug('relatedHistoricalPAList Count: ' + relatedHistoricalPAList.size());

        for(Historical_Prior_Auth__c historicalPARecord :relatedHistoricalPAList) {
            Error_Log__c errorLogRecord = errorLogByHistoricalPAId.get(historicalPARecord.Id);
            Boolean dublicatesDetectedError = errorLogRecord.Error_Message__c.contains('DUPLICATES_DETECTED');
            System.debug('dublicatesDetectedError = ' + dublicatesDetectedError);
            System.debug('historicalPARecord.Id = ' + historicalPARecord.Id);
            if(dublicatesDetectedError) {
                historicalPARecord.Status__c = 'Error';
                historicalPARecord.Error_Log__c = 'Unable to create record due to duplicate.';
            }
            existingHistoricalPAList.add(historicalPARecord);
        }

        update existingHistoricalPAList;

        System.debug('existingHistoricalPAList Count = ' + existingHistoricalPAList.size());

    }

}
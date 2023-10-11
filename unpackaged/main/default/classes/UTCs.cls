/**
 * @description       : UTC__c Domain class.
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 02-27-2023
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   02-27-2023   Ricardy						Initial Version
 *
 **/

public inherited sharing class UTCs extends fflib_SObjectDomain
        implements IUTCs
{

    //This sets up the super class (fflib_SObjectDomain) to have the records variable filled out
    public UTCs(List<UTC__c> utcRecords){
        super(utcRecords);
        //Cases.getTriggerEvent(Cases.class).disableBeforeInsert();
    }

    public List<UTC__c> getUTCs()
    {
        return (List<UTC__c>) getRecords();
    }

    //This helps allow for the fflib_SObjectDomain class to run its triggerHandler method
    //using the correct Domain class. This must be implemented in all domain classes.
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<SObject> sObjectList){
            return new UTCs(sObjectList);
        }
    }

    private void mapUTCsToCases(Map<String, UTC__c> utcByCaseNumber, fflib_ISObjectUnitOfWork uow) {

        String method = 'UTCs.mapUTCsToCases';
        String errorMessage = '';
        Id postGoLiveReimbursementFollowUpQueue;

        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);

        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
        List<Case> relatedCasesList = casesSelector.selectCaseByCaseNumber(utcByCaseNumber.keySet());
        System.debug('relatedCasesList Count: ' + relatedCasesList.size());

        if(relatedCasesList.size() > 0) {
            if (mapPrudentMedBenQueues.size() > 0) {
                for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                    String queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                    switch on queue {
                            when 'Post_Go_Live_Reimbursement_Follow_Up' { // when queue is Post-Go-Live Reimbursement - Follow-Up
                            postGoLiveReimbursementFollowUpQueue = GroupId;
                        }
                    }
                }
            }
        }

        for(Case caseRecord :relatedCasesList) {
            UTC__c utcRecord = utcByCaseNumber.get(caseRecord.CaseNumber);
            //SF will update the case routing logic upon receiving response file. SF will update case routing to be immediate (Post-Go-Live Reimbursement - Follow-Up)
            caseRecord.OwnerId = postGoLiveReimbursementFollowUpQueue;
            //SF will present case status tracker of Response Received. SF will post a new case status of “Response Received.”
            caseRecord.Status = 'Response Received';
            //SF will update the case comments with the who, when, and what from the response file.
            /* Case Comment layout below:
                Who/User = Integration User
                Created date = date UTC response file was ingested
                Comment = [Health Plan comments] from UTC response file
             */
            caseRecord.Comments = 'Who/User = Integration User\nCreated date = ' + System.today() + '\nComment = ' + utcRecord.Outreach_Comments__c;
            System.debug('caseRecord.Comments = ' + caseRecord.Comments);
            //SF will capture the response date for reporting capability but not on UI.
            caseRecord.Response_Date__c = System.today();
            //Response Received should only be selected by the system when a response comment is received/populated by UTC file.
            //pA.Contact_Drug__c = utcRecord.
            //existingPAList.add(pA);
            if(System.Test.isRunningTest() && utcRecord.Control_Number__c == 'GenerateError') {
                caseRecord.Status = 'Transfer to Health Plan';
            }
        }

        //uow.registerDirty(relatedCasesList);

        if(relatedCasesList.size()>0) {

            Database.SaveResult[] saveResultList = Database.update(relatedCasesList, false);

            // Iterate through saveResultList based on isSuccess capture the failed records
            for (Database.SaveResult sr : saveResultList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Case Successfully update by UTC' + sr.getId());
                } else {
                    // Operation failed, so get all errors
                    //SF will create error log for UTC cases that were not opened and/or process by UTC response file from Aetna. "Unprocessed UTC responses"
                    for (Database.Error err : sr.getErrors()) {
                        errorMessage += 'Unprocessed UTC responses\n ' + err.getMessage();
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Case fields that affected this error: ' + err.getFields());
                        String emailBody = method + '<p>Case fields that affected this error:  ' + errorMessage;
                        ErrorLog.sendErrorLogEmail('Error processing ' + method, emailBody);
                    }
                }
            }
        }

        System.debug('relatedCasesList Count = ' + relatedCasesList.size());

    }

    /***************************************************************************************************************************************
     * Trigger Operations
     **************************************************************************************************************************************/

    //Get all UTCs by caseId
    public override void onAfterInsert() {
        System.debug('Start UTCs:onAfterInsert');

        fflib_ISObjectUnitOfWork uow = PMd_Application.UnitOfWork.newInstance();

        List<UTC__c> utcList = Records;
        Map<String, UTC__c> utcByCaseNumber = new Map<String, UTC__c>();

        for (UTC__c utcRecord : utcList) {
            //SF will need to ingest multiple UTC response(s) file(s) for one case if outreach type = both on the case object and update the original case with the notes from the file.
            utcByCaseNumber.put(utcRecord.CaseNumber__c , utcRecord);
        }

        //Map all UTCs related Cases
        if(utcByCaseNumber.size() > 0) {
            mapUTCsToCases(utcByCaseNumber, uow);
        }

        System.debug('End UTCs:onAfterInsert');
    }

}
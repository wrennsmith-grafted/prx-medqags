/**
 * @description       :
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-08-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-06-2021   Ricardy Banks					   Initial Version
 *
 **/

public interface ICases extends fflib_ISObjects {
    List<Case> getCases();
    void process(List<Daily_Claim__c> dailyClaimsList,
                Map<String, CSA__c> csasByCSA_Number,
                Map<Id, Contact> existingContactsByDailyClaimId,
                List<Contact_Drug__c> existingContact_DrugsList,
                //List<Claim_Information__c> allClaim_InformationBeforeTxList,
                fflib_ISObjectUnitOfWork unitOfWorkBeforeTx,
                fflib_ISObjectUnitOfWork unitOfWorkAfterTx
    );
    void process(List<Historical_Claim__c> historicalClaimsList,
                Map<Id, Contact> existingContactsByHistoricalClaimId,
                List<Contact_Drug__c> existingContact_DrugsList,
                fflib_ISObjectUnitOfWork unitOfWorkBeforeTx,
                fflib_ISObjectUnitOfWork unitOfWorkAfterTx
    );
    void process(List<Prior_Auth__c> priorAuthList,
                List<Contact_Drug__c> existingContact_DrugsList,
                fflib_ISObjectUnitOfWork unitOfWork
    );
    void process(List<Historical_Prior_Auth__c> historicalPriorAuthList,
                List<Contact_Drug__c> existingContact_DrugsList,
                fflib_ISObjectUnitOfWork unitOfWork
    );
    //String getServiceProviderFax(Contact contactRecord);
}
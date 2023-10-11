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

public interface IContacts extends fflib_ISObjects {
    List<Contact> getContacts();
    void setDescription(String description);
    Map<Id, Contact> process(List<Daily_Claim__c> dailyClaims, Map<String, CSA__c> csasByCSA_Number, fflib_ISObjectUnitOfWork unitOfWork);
    Map<Id, Contact> process(List<Historical_Claim__c> historicalClaims, fflib_ISObjectUnitOfWork unitOfWork);
    Map<Id, Contact> process(List<Prior_Auth__c> priorAuth, fflib_ISObjectUnitOfWork unitOfWork);
    Map<Id, Contact> process(List<Historical_Prior_Auth__c> historicalPriorAuthClaims, fflib_ISObjectUnitOfWork unitOfWork);
    Map<Id, Contact> mapContactsByDailyClaimId(List<Contact> existingContactList, List<Daily_Claim__c> dailyClaimsList);
    Map<Id, Contact> getExistingContactsByDailyClaimId(List<Daily_Claim__c> dailyClaimsList);
    Map<Id, Contact> getExistingContactsByHistoricalClaimId(List<Historical_Claim__c> historicalClaimsList);
    Map<Id, Contact> getExistingContactsByPriorAuthId(List<Prior_Auth__c> priorAuthsList);
    Map<Id, Contact> getExistingContactsByHistoricalPriorAuthId(List<Historical_Prior_Auth__c> historicalPriorAuthsList);
}
/**
 * @description       :
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-08-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-06-2021   Ricardy Banks					   Initial Version
 * P
 **/

public interface IContact_Drugs extends fflib_ISObjects {
    List<Contact_Drug__c> getContact_Drugs();
    List<Contact_Drug__c> process(List<Daily_Claim__c> dailyClaims, Map<Id, Contact> existingContactsByDailyClaimId, fflib_ISObjectUnitOfWork unitOfWork);
    List<Contact_Drug__c> process(List<Historical_Claim__c> historicalClaims, fflib_ISObjectUnitOfWork unitOfWork);
    List<Contact_Drug__c> process(List<Prior_Auth__c> priorAuthClaims, fflib_ISObjectUnitOfWork unitOfWork);
    List<Contact_Drug__c> process(List<Historical_Prior_Auth__c> historicalPriorAuthClaims, fflib_ISObjectUnitOfWork unitOfWork);
}
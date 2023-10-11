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

public interface IClaim_Informations extends fflib_ISObjects {
    List<Claim_Information__c> getClaim_Informations();
    List<Claim_Information__c> process(List<Daily_Claim__c> dailyClaimsList,
                                        Map<Id, Contact> existingContactsByDailyClaimId,
                                        List<Contact_Drug__c> contact_DrugList,
                                        fflib_ISObjectUnitOfWork unitOfWork
    );
    List<Claim_Information__c> process(List<Historical_Claim__c> historicalClaimsList,
                                        Map<Id, Contact> existingContactsByHistoricalClaimId,
                                        List<Contact_Drug__c> contact_DrugList,
                                        fflib_ISObjectUnitOfWork unitOfWork
    );
}
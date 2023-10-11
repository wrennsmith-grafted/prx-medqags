/**
 * @description       : Interface for Daily_Claims
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-11-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 * 
 **/
public interface IDaily_Claims extends fflib_ISObjects {

	//Daily_Claim__c newInstance(Daily_Claim_JSONRequest request);
	void ProcessDailyClaimsAfterInsert(List<Daily_Claim__c> dailyClaimsList, Map<Id, CSA__c> csaByDailyClaimId);
	void processDailyClaimContacts(List<Daily_Claim__c> dailyClaimsList, fflib_ISObjectUnitOfWork uow);
	void processDailyClaimContactDrugs(List<Daily_Claim__c> dailyClaimsList, fflib_ISObjectUnitOfWork uow);
	void processDailyClaimClaim_Informations(List<Daily_Claim__c> dailyClaimsList, fflib_ISObjectUnitOfWork uow);
	void processDailyClaimCases(List<Daily_Claim__c> dailyClaimsList, fflib_ISObjectUnitOfWork uowBeforeTx, fflib_ISObjectUnitOfWork uowAfterTx);
}
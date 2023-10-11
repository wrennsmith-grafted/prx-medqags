/**
 * @description       : Claim_Information__c Selector Implementation
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 *
 **/
public interface IClaim_InformationsSelector extends fflib_ISObjectSelector
{
    List<Claim_Information__c> selectById(Set<Id> idSet);
    List<Claim_Information__c> selectByContactId(Set<Id> contactIds);
    List<Claim_Information__c> selectByPrimary_Claim_Number(Set<String> Primary_Claim_NumberSet);
}
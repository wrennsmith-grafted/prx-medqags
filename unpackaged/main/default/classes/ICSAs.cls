/**
 * @description       : Interface for CSAs Domain
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-11-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 *
 **/

public interface ICSAs extends fflib_ISObjects {
    //List<CSA__c> getCSAs();
    //void setGoLiveDate(Date goLiveDate);
    //Map<Id, CSA__c> getCSAsById(Map<String, Id> dailyClaimIdByCSANumber);
    Map<String, CSA__c> getCSAsByCSANumber(Map<Id, String> idByCSANumber);
}
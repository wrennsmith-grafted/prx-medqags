/**
 * @description       : CSA__c Selector Implementation
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 *
 **/
public interface ICSAsSelector extends fflib_ISObjectSelector
{
    List<CSA__c> selectById(Set<Id> idSet);
}
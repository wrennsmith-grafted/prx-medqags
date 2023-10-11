/**
 * @description       : NDC__c Selector Implementation
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 05-24-2022
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   05-24-2022   Ricardy Banks					   Initial Version: MBP-458 Business Logic: Update logic to match the correct Contact Drug based on inbound files
 *
 **/

public interface INDCsSelector extends fflib_ISObjectSelector
{
    List<NDC__c> selectById(Set<Id> idSet);
}
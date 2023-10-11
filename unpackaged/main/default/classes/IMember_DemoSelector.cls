/** 
 * @description       : IHistorical_ClaimsSelector class.
 * @author            : jyothi.gandhamaneni@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-18-2021
 * @last modified by  : Jyothi Gandhamaneni
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-18-2021   Jyothi Gandhamaneni			   Initial Version
 * 
 **/
public interface IMember_DemoSelector extends fflib_ISObjectSelector 
{
	List<Member_Demographic__c> selectById(Set<Id> idSet);
}
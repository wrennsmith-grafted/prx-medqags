/** 
 * @description       : IProvider_Demographic Domain class.
 * @author            : jyothi.gandhamaneni@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-25-2021
 * @last modified by  : Jyothi Gandhamaneni
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-25-2021   Jyothi Gandhamaneni			   Initial Version
 * 
 **/
public interface IProvider_Demographic extends fflib_ISObjects {

    Provider_Demographic__c newInstance(Provider_Demographic_JSONRequest request);
}
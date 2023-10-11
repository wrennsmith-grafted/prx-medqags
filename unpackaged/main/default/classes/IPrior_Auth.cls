/** 
 * @description       : IHistorical_Claims Domain class.
 * @author            : jyothi.gandhamaneni@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-18-2021
 * @last modified by  : Jyothi Gandhamaneni
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-18-2021   Jyothi Gandhamaneni			   Initial Version
 * 
 **/
public interface IPrior_Auth extends fflib_ISObjects {

    Prior_Auth__c newInstance(Prior_Auth_JSONRequest request);
}
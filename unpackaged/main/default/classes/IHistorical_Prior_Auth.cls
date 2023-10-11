/**
 * @description       : IHistorical_Prior_Auth Domain class.
 * @author            : jyothi.gandhamaneni@PrudentRx.com
 * @group             :
 * @last modified on  : 08-18-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
* 1.0   09-09-2021   Ricardy Banks			           Initial Version
 *
 **/

public interface IHistorical_Prior_Auth extends fflib_ISObjects {

    Historical_Prior_Auth__c newInstance(Historical_Prior_Auth_JSONRequest request);
}
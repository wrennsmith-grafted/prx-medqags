/**
 * @description       : Formatter Service Interface
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 *
 **/
public interface IFormatterUtilService {

    Date dateFormatter(String dateString);
    String phoneFormatter(String phoneString);
    String textFormatter(String textString);
    String truncate(String textString, Integer maxSize);
    String genderFormatter(String textString);
    String numberFormatter(String textString);
}
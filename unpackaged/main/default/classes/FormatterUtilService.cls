/**
 * @description       : Formatter Service
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 *
 **/
public with sharing class FormatterUtilService {

    public static Date dateFormatter(String dateString) {
        return service().dateFormatter(dateString);
    }

    public static String phoneFormatter(String phoneString) {
        return service().phoneFormatter(phoneString);
    }

    public static String textFormatter(String textString) {
        return service().textFormatter(textString);
    }

    public static String truncate(String textString, Integer maxSize) {
        return service().truncate(textString, maxSize);
    }

    public static String genderFormatter(String textString) {
        return service().genderFormatter(textString);
    }

    public static String numberFormatter(String textString) {
        return service().numberFormatter(textString);
    }

    private static IFormatterUtilService service()
    {
        return (IFormatterUtilService) PMd_Application.Service.newInstance(IFormatterUtilService.class);
    }
}
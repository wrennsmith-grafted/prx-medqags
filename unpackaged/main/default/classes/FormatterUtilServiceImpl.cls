public with sharing class FormatterUtilServiceImpl
        implements IFormatterUtilService
{

    public static Date dateFormatter(String dateString){
        //Convert mmddyyyy format to yyyy-mm-dd
        if(String.isEmpty(dateString) != true && dateString.length() == 8){
            String month = dateString.substring(0,2);
            String day = dateString.substring(2,4);
            String year = dateString.substring(4,8);
            Date sfDate = Date.valueOf(year + '-' + month + '-' + day);
            return sfDate;
        }
        else{
            return null;
        }
    }

    public static String phoneFormatter(String phoneString){
        if(String.isEmpty(phoneString) != true && phoneString.length() > 0){
            String sfPhone = phoneString.replaceAll('[-|,|.]','');
            return sfPhone;
        }
        return '';
    }

    public static String textFormatter(String textString){

        if(textString == null) {
            textString = '';
        }
        return textString.equals('null') ? '' : textString;
    }

    public static String truncate(String textString, Integer maxSize) {
        if(textString.length() > maxSize && textString != 'null' ) {
            textString = FormatterUtilService.textFormatter(textString);
            return textString.substring(0, maxSize);
        }
        return '';
    }

    public static String genderFormatter(String textString){
        textString = FormatterUtilService.textFormatter(textString);
        textString = textString.equals('F') ? 'Female' : textString;
        textString = textString.equals('M') ? 'Male' : textString;

        return textString;
    }

    public static String numberFormatter(String textString){

        return textString.equals('null') ? '' : textString;
    }

}
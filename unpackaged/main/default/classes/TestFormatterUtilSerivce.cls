/**
 * Created by ricardy.banks on 10/20/2021.
 */

@isTest
public with sharing class TestFormatterUtilSerivce {

    @isTest(SeeAllData=false)
    public static void dateFormatter() {
        Test.startTest();

        String month = '07';
        String day = '21';
        String year = '2020';
        Date patient_Birth_Date = Date.valueOf(year + '-' + month + '-' + day);

        Date patient_Birth_DateFormatted = FormatterUtilService.dateFormatter('07212020');

        System.assertEquals(patient_Birth_DateFormatted, patient_Birth_Date, 'Date format incorrect');
        Test.stopTest();
    }

    @isTest(SeeAllData=false)
    public static void textFormatter() {
        Test.startTest();

        String account_Number = 'AC012345';
        String csa_AccountFormatted = FormatterUtilService.textFormatter(account_Number);

        System.assertEquals(account_Number, csa_AccountFormatted, 'Text format incorrect');

        Test.stopTest();
    }

    @isTest(SeeAllData=false)
    public static void phoneFormatter() {
        Test.startTest();

        String phone_Number = '123-123-1234';
        String phone_NumberFormatted = FormatterUtilService.phoneFormatter(phone_Number);

        System.assertEquals('1231231234', phone_NumberFormatted, 'Phone format incorrect.');

        Test.stopTest();
    }

    @isTest(SeeAllData=false)
    public static void truncateFormatter() {
        Test.startTest();

        String phone_Number = '123123123456';
        String phone_NumberFormatted = FormatterUtilService.truncate(phone_Number, 10);

        System.assertEquals('1231231234', phone_NumberFormatted, 'String truncate incorrect.');

        Test.stopTest();
    }

    @isTest(SeeAllData=false)
    public static void genderFormatter() {
        Test.startTest();

        String gender = 'F';
        String genderFormatted = FormatterUtilService.genderFormatter(gender);

        System.assertEquals('Female', genderFormatted, 'Gender format incorrect');

        Test.stopTest();
    }

    @isTest(SeeAllData=false)
    public static void numberFormatter() {
        Test.startTest();

        String numberText = '1234';
        String numberTextFormatted = FormatterUtilService.numberFormatter(numberText);

        System.assertEquals(numberText, numberTextFormatted, 'Number format incorrect');

        Test.stopTest();
    }
}
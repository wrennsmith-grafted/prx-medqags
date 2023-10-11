public without sharing class Constants {

    //LOB Constants / keys
    /// Refactor into a custom metadata ?
    public static String apiKeyProduction = 'live_412697caa3ebc82f9f38b58bf1cede69592';
    public static String apiKey = 'test_0f52f0cc1c325fdbd1ad3806864a398ee63';
    public static String endPoint = 'https://api.lob.com/v1/letters';
    public static String fromAddressId = 'adr_58f40d88d72202f4'; //Test PrudentRx 
    public static String fromAddressIdProduction = 'adr_79b6913ac5c7b7c6'; //Prod PrudentRx 
    public static String welcomeTemplateId = 'tmpl_c2b35c176f2406e'; //Test Welcome template
    public static String welcomePostGoLIveTemplateTestId = 'tmpl_c8b5b3373314656'; //Test Post Go-Live Welcome template
    public static String welcomeTemplateIdProduction = 'tmpl_ff1ec3bf0a332e1'; //Prod Welcome Template
    public static String welcomePostGoLIveTemplateProductionId = 'tmpl_0283165fd85331e'; //Prod Post Go-Live Welcome template
    public static String finalNoticeTemplateId = 'tmpl_4333523983424f6';
    public static String finalNoticeTemplateIdProduction = 'tmpl_3b5368b5b57dc7f';
    public static final String WELCOMELETTER = 'Send Welcome';
    public static final String FINALNOTICELETTER = 'Send Final Notice';
    // Refactor into a custom metadata 
    public static String SandboxFaxNumber = '8664224402';
    public static String ProdFaxNumber = '8132003905';
    public static String SendFromFaxNumber = '8132003905';/// Look into a custom metadata ?
    public static String BarcodeLeftPixles = '430'; /// Look into a custom metadata ? 
    public static String BarcodeTopPixles = '20'; /// Look into a custom metadata ?
    public static String BarcodeSize = '40'; /// Look into a custom metadata ?
    public static String PRXPhoneNumber = '8554764118'; /// Look into a custom metadata ?

    public Constants() {

    }
}
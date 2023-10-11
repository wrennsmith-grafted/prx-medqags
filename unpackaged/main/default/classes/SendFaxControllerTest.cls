@isTest
public with sharing class SendFaxControllerTest {
    @TestSetup
    public static void setupData() {
        //Create Account
        //Create Contact
        //Create Drug
        //Create Contact Drug
        //Create Claim
        //Create Case      

        Account a = new Account();
        a.Name='Test Account';
        a.Health_Plan_Name__c = 'Test Health Plan Name';
        a.Go_Live_Date__c = Date.newInstance(2023,1, 17);
        insert a;
        
        Drug__c d = new Drug__c();
        d.J_Code__c = 'J5679';
        d.Copay_Assistance_Available__c = 'Yes';
        d.Drug_Brand_Name__c = 'Special Drug Brand';
        insert d;
        
        Contact c = new Contact();
        c.FirstName='Test';
        c.LastName = 'Contact';
        c.Patient_Phone_Number__c = '1234567890';
        c.Alternative_Phone__c = '0987654321';
        c.Patient_Birth_Date__c = Date.newInstance(1995, 4, 5);
        c.Patient_CUMB_ID__c = 'ID123456789';
        insert c;

        Contact_Drug__c cd = new Contact_Drug__c();
        cd.Contact__c = c.Id;
        cd.Drug_Name__c = d.Id;
        insert cd;

        Claim_Information__c cl = new Claim_Information__c();
        cl.Primary_Claim_Number__c='JG12389';
        cl.Claim_Segment__c='0';
        cl.Claim_Line__c='3';
        cl.Prior_Authorization__c='B123';
        cl.Amount_Paid_By_Primary__c = 200;
        cl.Source_File_Type__c = 'Historical Claims';
        cl.Drug__c = d.Id;
        cl.Contact_Drug__c = cd.Id;
        cl.Contact__c = c.Id;
        cl.Billing_Provider_Fax__c = '1234567890';
        cl.Billing_Provider_First_Name__c = 'First';
        cl.Billing_Provider_Last_Name__c = 'Last';
        cl.Billing_Provider_Address_Line_1__c = 'billing address line 1';
        cl.Billing_Provider_City__c = 'City1';
        cl.Billing_Provider_State_Code__c = 'SC';
        cl.Billing_Provider_Zip_Code__c = '99999';
        cl.Service_Provider_Fax__c = '1234567890';
        cl.Service_Provider_Last_Name__c = 'First';
        cl.Service_Provider_First_Name__c = 'Last';
        cl.Service_Provider_Practice__c  = 'Practice';
        cl.Service_Provider_Address_Line_1__c = 'address line 1';        
        cl.Service_Provider_State__c = 'SC';
        cl.Service_Provider_City__c = 'City1';
        cl.Service_Provider_Zip__c = '99999';
        cl.Date_Of_Service_From__c = Date.newInstance(2022, 4, 5);
        insert cl;
        Id EnrollmentCaseRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
        Case ca = new Case();
        ca.RecordTypeId = EnrollmentCaseRTId;
        ca.Claim_Information__c = cl.Id;
        ca.Contact_Drug__c = cd.Id;
        ca.ContactId = c.Id;
        ca.AccountId = a.Id;        
        ca.Service_Provider_Last_Name__c = 'First';
        ca.Service_Provider_First_Name__c = 'Last';
        ca.Service_Provider_Practice__c  = 'Practice';
        ca.Service_Provider_Address_Line_1__c = 'address line 1';        
        ca.Service_Provider_State__c = 'SC';
        ca.Service_Provider_City__c = 'City1';
        ca.Service_Provider_Zip__c = '99999';     
        ca.Service_Provider_Fax__c = '1234567890';
        insert ca;

        Blob html1 = Blob.valueof('<html><body>Enrollment</body></html>');
        ContentVersion cv1 = new ContentVersion();
        cv1.Title = 'Enrollment Fax Template';
        cv1.VersionData = html1;
        cv1.PathOnClient = 'EnrollmentFaxTemplate.html';
        cv1.IsMajorVersion = true;
        insert cv1;
        
        Blob html2 = Blob.valueof('<html><body>Reimbursement</body></html>');
        ContentVersion cv2 = new ContentVersion();
        cv2.Title = 'Reimbursement Fax Template';
        cv2.VersionData = html2;
        cv2.PathOnClient = 'ReimbursementFaxTemplate.html';
        cv2.IsMajorVersion = true;
        insert cv2;
        
        Blob html3 = Blob.valueof('<html><body>No CPA Fax Template</body></html>');
        ContentVersion cv3 = new ContentVersion();
        cv3.Title = 'No CPA Fax Template';
        cv3.VersionData = html3;
        cv3.PathOnClient = 'NoCPAFaxTemplate.html';
        cv3.IsMajorVersion = true;
        insert cv3;

        Blob html4 = Blob.valueof('<html><body>Final Notice</body></html>');
        ContentVersion cv4 = new ContentVersion();
        cv4.Title = 'Final Notice Fax Template';
        cv4.VersionData = html4;
        cv4.PathOnClient = 'FinalNoticeFaxTemplate.html';
        cv4.IsMajorVersion = true;
        insert cv4;        

    }
//Success Cases
    @isTest
    public static void testSimpleEnrollment() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c FROM Case];
        lstCases[0].Contact.Alternative_Phone__c = '';
        update lstCases[0];
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('Success: Fax is on its way to (123) 456-7890', response);
    }
    @isTest
    public static void testSimpleReimbursement() {
        //Update to change to reimbrusement
        List<Case> lstCases = [SELECT Id, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c FROM Case];
        changeToReimbursement(lstCases[0].Id);
        lstCases[0].Contact.Alternative_Phone__c = '';
        update lstCases[0];
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('Success: Fax is on its way to (123) 456-7890', response);
    }
    @isTest
    public static void testSimpleEnrollmentNoCPA() {
        //Update to change to reimbrusement
        List<Case> lstCases = [SELECT Id, Contact_Drug__r.Drug_Name__c FROM Case];
        changeToNoCPA(lstCases[0].Contact_Drug__r.Drug_Name__c);

        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('Success: Fax is on its way to (123) 456-7890', response);
    }
    @isTest
    public static void testSimpleReimbursementNoCPA() {
        //Update to change to reimbrusement
        List<Case> lstCases = [SELECT Id, Contact_Drug__r.Drug_Name__c FROM Case];
        changeToReimbursement(lstCases[0].Id);
        changeToNoCPA(lstCases[0].Contact_Drug__r.Drug_Name__c);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('Success: Fax is on its way to (123) 456-7890', response);
    }

    @isTest
    public static void testFinalNoticeFax() {
        List<Case> lstCases = [SELECT Id, EOP_Date__c, Status FROM Case]; 
        // Update case to meet final notice criteria 
        lstCases[0].Status = '3rd Attempt Needed';
        lstCases[0].EOP_Date__c = Date.today().addDays(-75);
        update lstCases[0];
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id); 
        System.assertEquals('Success: Fax is on its way to (123) 456-7890', response);
    }

    @isTest
    public static void testNoPatientPhone() {
        List<Case> lstCases = [SELECT Id, Contact_Drug__r.Drug_Name__c, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c FROM Case];
        changeToReimbursement(lstCases[0].Id);
        lstCases[0].Contact.Patient_Phone_Number__c = '';
        update lstCases[0];
        //SendFaxController controller = new SendFaxController();
        String response = FaxService.getContactNumber(lstCases[0]);
        System.assertEquals('0987654321', response);
    }
    @isTest
    public static void testNoAlternativePhone() {
        List<Case> lstCases = [SELECT Id, Contact_Drug__r.Drug_Name__c, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c FROM Case];
        changeToReimbursement(lstCases[0].Id);
        lstCases[0].Contact.Alternative_Phone__c = '';
        update lstCases[0];
        //SendFaxController controller = new SendFaxController();
        String response = FaxService.getContactNumber(lstCases[0]);
        System.assertEquals('1234567890', response);
    }
    /* Final Notice
    @isTest
    public static void testSimpleNoCPA() {
        //Update to change to reimbrusement
        List<Case> lstCases = [SELECT Id, Contact_Drug__r.Drug_Name__c FROM Case];
        Drug__c d = new Drug__c();
        d.Id = lstCases[0].Contact_Drug__r.Drug_Name__c;
        d.Copay_Assistance_Available__c = 'No';
        update d;
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('Success: Fax is on its way to (123) 456-7890', response);
    } */

//Missing Account Information  
    @isTest
    public static void testEnrollmentNoAccountInfo() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, AccountId FROM Case];
        clearAccountData(lstCases[0].AccountId);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Accounts Health Plan Name, Accounts Go Live Date', response);
    }
    
    @isTest
    public static void testReimbursementNoAccountInfo() { // ???
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, AccountId FROM Case];
        clearAccountData(lstCases[0].AccountId);
        changeToReimbursement(lstCases[0].Id);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Accounts Health Plan Name', response);
    }
    
    @isTest
    public static void testEnrollmentNoCPANoAccountInfo() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, AccountId, Contact_Drug__r.Drug_Name__c FROM Case];
        clearAccountData(lstCases[0].AccountId); 
        changeToNoCPA(lstCases[0].Contact_Drug__r.Drug_Name__c);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Accounts Health Plan Name, Accounts Go Live Date', response);
        
    }
    
    @isTest
    public static void testReimbursementNoCPANoAccountInfo() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, AccountId, Contact_Drug__r.Drug_Name__c  FROM Case];
        clearAccountData(lstCases[0].AccountId); 
        changeToReimbursement(lstCases[0].Id);
        changeToNoCPA(lstCases[0].Contact_Drug__r.Drug_Name__c);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Accounts Health Plan Name, Accounts Go Live Date', response);
        
    }

//Missing Contact Information  
    @isTest
    public static void testEnrollmentNoContactInfo() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, ContactId FROM Case];
        clearContactData(lstCases[0].ContactId);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Patient Birthdate', response);
    }

    @isTest
    public static void testReimbursementNoContactInfo() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, ContactId FROM Case];
        clearContactData(lstCases[0].ContactId);
        changeToReimbursement(lstCases[0].Id);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Patient Birthdate', response);
    }

    @isTest
    public static void testReimbursementNoCPANoContactInfo() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, ContactId, Contact_Drug__r.Drug_Name__c  FROM Case];
        clearContactData(lstCases[0].ContactId); 
        changeToReimbursement(lstCases[0].Id);
        changeToNoCPA(lstCases[0].Contact_Drug__r.Drug_Name__c);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Patient Birthdate', response);
        
    }

    @isTest
    public static void testEnrollmentNoCPANoContactInfo() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, ContactId, Contact_Drug__r.Drug_Name__c FROM Case];
        clearContactData(lstCases[0].ContactId); 
        changeToNoCPA(lstCases[0].Contact_Drug__r.Drug_Name__c);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Patient Birthdate', response);
        
    }

//Missing Case
    @isTest
    public static void testNoCase() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, ContactId FROM Case];
        Case c = new Case();
        c.Id = lstCases[0].Id;
        delete c;
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('Error: User does not have valid permissions or case does not exist', response);
    }

/*Multiple Cases
@isTest
public static void testNoCase() {
    //Grab Case record .... create case first
    List<Case> lstCases = [SELECT Id, ContactId FROM Case];
    Case c = new Case();
    c.Id = lstCases[0].Id;
    delete c;
    //SendFaxController controller = new SendFaxController();
    String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
    System.assertEquals('Error: User does not have valid permissions or case does not exist', response);
}*/

//Missing Claim Information  
   /* @isTest
    public static void testEnrollmentNoClaimInfo() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, Claim_Information__c FROM Case];
        clearClaimData(lstCases[0].Claim_Information__c);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Service Provider Fax or Alternate Fax', response);
    }*/

    @isTest
    public static void testReimbursementNoClaimInfo() { ///??
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, Claim_Information__c FROM Case];
        clearClaimData(lstCases[0].Claim_Information__c);
        changeToReimbursement(lstCases[0].Id);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Billing Provider Name, Billing Provider Address, Billing Provider Fax or Alternate Fax, Date of Service From', response);
    }

    @isTest
    public static void testReimbursementNoCPANoClaimInfo() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, Claim_Information__c, Contact_Drug__r.Drug_Name__c  FROM Case];
        clearClaimData(lstCases[0].Claim_Information__c); 
        changeToReimbursement(lstCases[0].Id);
        changeToNoCPA(lstCases[0].Contact_Drug__r.Drug_Name__c);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Billing Provider Fax or Alternate Fax', response);
        
    }

   /* @isTest
    public static void testEnrollmentNoCPANoClaimInfo() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, Claim_Information__c, Contact_Drug__r.Drug_Name__c FROM Case];
        clearClaimData(lstCases[0].Claim_Information__c); 
        changeToNoCPA(lstCases[0].Contact_Drug__r.Drug_Name__c);
        //SendFaxController controller = new SendFaxController();
        String response = SendFaxController.sendFaxProcess(lstCases[0].Id);
        System.assertEquals('You are missing the following required fields to be able to send a fax: Service Provider Fax or Alternate Fax', response);
        
    }*/

    //Test Contact.Patient_Phone_Number__c is blank and Contact Alternative_Phone__c chosen for Fax #
    @isTest
    public static void testPatientPhoneNumberBlank() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, ContactId, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c FROM Case];
        Contact contactRecord = clearContactPatientPhoneNumber(lstCases[0].ContactId);
        lstCases = [SELECT Id, ContactId, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c FROM Case];
        //SendFaxController controller = new SendFaxController();
        String chosenFaxNumber =  FaxService.formatPhone(FaxService.getContactNumber(lstCases[0]));
        System.assertEquals('', contactRecord.Patient_Phone_Number__c, 'Contact Patient_Phone_Number__c should be blank');
        System.assertEquals(chosenFaxNumber, FaxService.formatPhone(lstCases[0].Contact.Alternative_Phone__c),'Contact Alternative_Phone__c should be Fax Number chosen');
    }

    //Test Contact.Alternative_Phone__c is blank and Contact Patient_Phone_Number__c chosen for Fax #
    @isTest
    public static void testAltPhoneNumberBlank() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, ContactId,RecordType.Name, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c FROM Case];
        Contact contactRecord = clearContactAltPhoneNumber(lstCases[0].ContactId);
        lstCases = [SELECT Id, ContactId, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c FROM Case];
        //SendFaxController controller = new SendFaxController();
        String chosenFaxNumber =  FaxService.formatPhone(FaxService.getContactNumber(lstCases[0]));
        System.assertEquals('', contactRecord.Alternative_Phone__c, 'Contact Alternative_Phone__c should be blank');
        System.assertEquals(chosenFaxNumber, FaxService.formatPhone(lstCases[0].Contact.Patient_Phone_Number__c),'Contact Patient_Phone_Number__c should be Fax Number chosen');
    }

    //Test Contact.Patient_Phone_Number__c & Contact.Alternative_Phone__c is not blank and Contact Patient_Phone_Number__c chosen for Fax #
    @isTest
    public static void testAltAndPatientPhoneNumberNotBlank() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, ContactId, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c FROM Case];
        //SendFaxController controller = new SendFaxController();
        String chosenFaxNumber = FaxService.formatPhone(FaxService.getContactNumber(lstCases[0]));
        System.assertEquals(chosenFaxNumber, FaxService.formatPhone(lstCases[0].Contact.Alternative_Phone__c),'Contact Alternative_Phone__c should be Fax Number chosen');
    }

    //Test Contact.Patient_Phone_Number__c & Contact.Alternative_Phone__c is blank and Contact Patient_Phone_Number__c chosen for Fax #
    @isTest
    public static void testAltAndPatientPhoneNumberBlank() {
        //Grab Case record .... create case first
        List<Case> lstCases = [SELECT Id, ContactId, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c FROM Case];
        Contact contactRecord = clearContactAltAndPatientPhoneNumber(lstCases[0].ContactId);
        lstCases = [SELECT Id, ContactId, Contact.Patient_Phone_Number__c, Contact.Alternative_Phone__c FROM Case];
        //SendFaxController controller = new SendFaxController();
        String chosenFaxNumber = FaxService.formatPhone(FaxService.getContactNumber(lstCases[0]));
        System.assertEquals('', contactRecord.Patient_Phone_Number__c, 'Contact Patient_Phone_Number__c should be blank');
        System.assertEquals('', contactRecord.Alternative_Phone__c, 'Contact Alternative_Phone__c should be blank');
        System.assertEquals(chosenFaxNumber, 'UNKNOWN','UNKNOWN should be Fax Number chosen');
    }

//Context Helper methods
    public static void clearAccountData(String Id)
    {
        Account a = new Account();
        a.Id = Id;
        a.Health_Plan_Name__c = ''; 
        a.Go_Live_Date__c = null;
        update a;  
    }

    public static void changeToNoCPA(String Id)
    {
        Drug__c d = new Drug__c();
        d.Id = Id;
        d.Copay_Assistance_Available__c = 'No';
        update d;
    }

    public static void changeToReimbursement(String Id)
    {
        Case c = new Case();
        c.Id = Id;
        Id ReimbursementCaseRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
        Case ca = new Case();
        c.RecordTypeId = ReimbursementCaseRTId;
        update c;
    }

    public static void clearContactData(String Id)
    {
        Contact c = new Contact();
        c.Id = Id;
        c.FirstName = ''; 
        c.Patient_Birth_Date__c = null;
        c.Patient_CUMB_ID__c = '';
        update c;  
    }

    public static Contact clearContactPatientPhoneNumber(String Id)
    {
        Contact c = new Contact();
        c.Id = Id;
        c.Patient_Phone_Number__c = '';
        update c;

        return c;
    }

    public static Contact clearContactAltPhoneNumber(String Id)
    {
        Contact c = new Contact();
        c.Id = Id;
        c.Alternative_Phone__c = '';
        update c;

        return c;
    }

    public static Contact clearContactAltAndPatientPhoneNumber(String Id)
    {
        Contact c = new Contact();
        c.Id = Id;
        c.Patient_Phone_Number__c = '';
        c.Alternative_Phone__c = '';
        update c;

        return c;
    }


    public static void clearClaimData(String Id)
    {
        Claim_Information__c cl = new Claim_Information__c();
        cl.Id = Id;
        cl.Billing_Provider_Fax__c = '';
        cl.Billing_Provider_First_Name__c = '';
        cl.Billing_Provider_Last_Name__c = '';
        cl.Billing_Provider_Address_Line_1__c = '';
        cl.Billing_Provider_City__c = '';
        cl.Billing_Provider_State_Code__c = '';
        cl.Billing_Provider_Zip_Code__c = '';
        cl.Service_Provider_Fax__c = '';
        cl.Service_Provider_Last_Name__c = '';
        cl.Service_Provider_First_Name__c = '';
        cl.Service_Provider_Practice__c  = '';
        cl.Service_Provider_Address_Line_1__c = '';        
        cl.Service_Provider_State__c = '';
        cl.Service_Provider_City__c = '';
        cl.Service_Provider_Zip__c = '';
        cl.Date_Of_Service_From__c = null;
        update cl;
    }
    
    
    /*
    errorMessage += String.isBlank(c.Contact_Drug__r.Drug_Brand_Name__c) ? 'Contact Drugs Drug Brand Name, ' : '';
    */
}
@isTest
public with sharing class SendLetterControllerTest {

    private static Implementation__c implementationInstance;
    private static Contract contractInstance;
    private static Account accountInstance;

    @TestSetup
    public static void setupData() {

        List<CSA__c> csaList = new List<CSA__c>();
        Date goLiveDate = Date.newInstance(2023,1, 17);

        //Create Account
        //Create Contact
        //Create Drug
        //Create Contact Drug
        //Create Claim
        //Create Case      

        Account accountInstance = new Account();
        accountInstance.Name='Test Account';
        accountInstance.Health_Plan_Name__c = 'Test Health Plan Name';
        //a.Go_Live_Date__c = Date.newInstance(2023,1, 17);
        insert accountInstance;

        system.debug('Setup Contracts');
        contractInstance = new Contract(
                Name = 'Model Office Test-Integration Contract',
                Go_Live_Date__c = goLiveDate,
                AccountId = accountInstance.Id
        );
        insert contractInstance;

        system.debug('Setup Implementation__c');
        implementationInstance =  new Implementation__c(
                Account__c = accountInstance.Id,
                Contract__c = contractInstance.Id
        );
        insert implementationInstance;
        
        Drug__c d = new Drug__c();
        d.J_Code__c = 'J5679';
        d.Copay_Assistance_Available__c = 'Yes';
        d.Drug_Brand_Name__c = 'Special Drug Brand';
        insert d;

        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = goLiveDate,
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '777',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-' +
                        csaInstance.CSA_Suffix__c + '-' +
                        csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        insert csaList;
        
        Contact c = new Contact();
        c.FirstName='Test';
        c.LastName = 'Contact';
        c.Patient_First_Name__c='Test';
        c.Patient_Last_Name__c = 'Contact';
        c.Patient_Phone_Number__c = '1234567890';
        c.Patient_Birth_Date__c = Date.newInstance(1995, 4, 5);
        c.Policy_Group_ID__c = 'ID123456789';
        c.MailingStreet = 'address line 1';
        c.MailingCity = 'Raleigh';
        c.MailingState = 'NC';
        c.MailingPostalCode = '27616';
        c.AccountId = accountInstance.Id;
        //c.Welcome_Letter_Id__c = 'ltr_70347496d0c7be52';
        c.CSA__c = csaList[0].Id;
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

        Case ca = new Case();
        ca.Type = 'Enrollment';
        ca.Claim_Information__c = cl.Id;
        ca.Contact_Drug__c = cd.Id;
        ca.ContactId = c.Id;
        ca.AccountId = accountInstance.Id;
        insert ca;

    }

//Success Cases
    @isTest
    public static void testWelcomeLetterSuccess() {
        //Grab Contact record .... create Contact first
        List<Contact> lstContacts = [SELECT Id, CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, AccountId FROM Contact];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testWelcomeLetterSuccess'));
        String response = SendLetterController.sendLetterProcess(lstContacts[0].Id, Constants.WELCOMELETTER);
        System.assertEquals('Success: Letter sent to vendor for processing', response); 
       
        List<Communication__c> lstCommunications = [SELECT Id, Letter_ID__c FROM Communication__c WHERE Contact__c = :lstContacts[0].Id];
        System.assertEquals('ltr_70347496d0c7be52', lstCommunications[0].Letter_ID__c); 

        Test.stopTest();

    }

    @isTest
    public static void testWelcomeLetterSuccessAltAddress() {
        //Grab Contact record .... create Contact first
        List<Contact> lstContacts = [SELECT Id, CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, AccountId FROM Contact];
        lstContacts[0].Alternative_Mailing_Address_City__c = 'Charleston';
        lstContacts[0].Alternative_Mailing_Address_State__c = 'SC'; 
        lstContacts[0].Alternative_Mailing_Address_Street__c = 'address line 1'; 
        lstContacts[0].Alternative_Mailing_Address_Zip_Code__c = '29420';
        update lstContacts; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testWelcomeLetterSuccess'));
        String response = SendLetterController.sendLetterProcess(lstContacts[0].Id, Constants.WELCOMELETTER);
        System.assertEquals('Success: Letter sent to vendor for processing', response); 
       
        List<Communication__c> lstCommunications = [SELECT Id, Letter_ID__c, Mailing_City__c, Mailing_Postal_Code__c, Mailing_State__c, Mailing_Street__c FROM Communication__c WHERE Contact__c = :lstContacts[0].Id];
        System.assertEquals('ltr_70347496d0c7be52', lstCommunications[0].Letter_ID__c);
        System.assertEquals('Charleston', lstCommunications[0].Mailing_City__c); 
        System.assertEquals('SC', lstCommunications[0].Mailing_State__c);
        System.assertEquals('29420', lstCommunications[0].Mailing_Postal_Code__c);
        System.assertEquals('address line 1', lstCommunications[0].Mailing_Street__c);
        
        Test.stopTest();

    }

    @isTest
    public static void testFinalNoticeLetterSuccess() {
        //Grab Contact record .... create Contact first
        List<Contact> lstContacts = [SELECT Id, AccountId, CSA__r.Implementation__r.Contract__r.Go_Live_Date__c FROM Contact];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testFinalNoticeLetterSuccess'));
        String response = SendLetterController.sendLetterProcess(lstContacts[0].Id, Constants.FINALNOTICELETTER);
        System.assertEquals('Success: Letter sent to vendor for processing', response); 
        
        List<Communication__c> lstCommunications = [SELECT Contact__c,Letter_ID__c FROM Communication__c WHERE Contact__c =:lstContacts[0].Id];
        System.assertEquals('ltr_70347496d0c7be34', lstCommunications[0].Letter_ID__c); 
        
        Test.stopTest();

    }

 @isTest
    public static void testLetterWebhookSuccess() {
        //Create sample communication and contact for webhook
        Contact c = new Contact();
        c.FirstName='Test';
        c.LastName = 'Contact';
        insert c; 

        Communication__c comm = new Communication__c(); 
        comm.Contact__c = c.Id;
        insert comm; 
        
        List<Communication__c> lstComm = [SELECT Id FROM Communication__c];
        lstComm[0].Letter_ID__c = 'ltr_70347496d0c7be52';
        update lstComm;
        
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri = getURL();
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"event_type": {"resource": "letters","enabled_for_test": true,"id": "letter.rendered_pdf","object": "event_type"},"reference_id": "ltr_70347496d0c7be52","date_created": "2022-06-01T23:37:08.635Z","id": "evt_3daca3d174ca39d4","body": {"id": "ltr_70347496d0c7be52","description": null,"metadata": {},"to": {  "id": "adr_8cb275792d6a6cea",  "description": null,  "name": "GARRETT HEATHCOTE",  "company": null,  "phone": null,  "email": null,  "address_line1": "3820 NORTHDALE BLVD STE 311C",  "address_line2": null,  "address_city": "TAMPA",  "address_state": "FL",  "address_zip": "33624-1863",  "address_country": "UNITED STATES",  "metadata": {},  "date_created": "2022-06-01T23:37:05.477Z",  "date_modified": "2022-06-01T23:37:05.477Z",  "deleted": true,  "object": "address"},"from": {  "id": "adr_58f40d88d72202f4",  "description": null,  "name": null,  "company": "PRUDENTRX",  "phone": null,  "email": null,  "address_line1": "3820 NORTHDALE BLVD STE 311A",  "address_line2": null,  "address_city": "TAMPA",  "address_state": "FL",  "address_zip": "33624-1857",  "address_country": "UNITED STATES",  "metadata": {},  "date_created": "2022-05-11T20:47:01.600Z",  "date_modified": "2022-05-11T20:47:01.600Z",  "object": "address"},"color": true,"double_sided": true,"address_placement": "top_first_page","return_envelope": false,"perforated_page": null,"custom_envelope": null,"extra_service": null,"mail_type": "usps_standard","url": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4.pdf?version=v1&expires=1656718628&signature=4WxuSjkVk2ECTkubDwC57F8F_OucK3A4HyG4cv0YDK9RSAwHjoBv3yQEEIBylaJnOBJFwl_xdB0p-oUHs-XsDg","merge_variables": {  "ClientSignOff": "The PrudentMed Team",  "DSPlus5": "June 6,  2022",  "DateSent": "June 1,  2022",  "GoLiveDate": "May 1,  2022",  "PatientFirstName": "Garrett"},"template_id": "tmpl_ff1ec3bf0a332e1","template_version_id": "vrsn_7147fcd69386276","carrier": "USPS","tracking_number": null,"tracking_events": [],"thumbnails": [  {    "small": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_small_1.png?version=v1&expires=1656718628&signature=LNRm5x9HQN6ovINvIJBMfUD6w17SFGhTK_OMTuGhGE96__B6WA4fNv5y78TelVxwjTOlp7sTc0T3jAT4ngV-DA",    "medium": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_medium_1.png?version=v1&expires=1656718628&signature=NaVC5hMbtUghfBX8hHIpnklN3PTVZcA9YxVdSQKcrIoEzEVcPn3SI1m8PUi59sFjT9kO_ZEdyAAlb6WQsET6Bw",    "large": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_large_1.png?version=v1&expires=1656718628&signature=BiEOS60MA2aMTHXWfRwjlZS8wYoG_UadRYGqwsFk1zqHxVOzE704KOK6tFATtfIAHZMtqASjx_inr1UeXTdAAQ"  },  {    "small": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_small_2.png?version=v1&expires=1656718628&signature=KNDJp3gV2OLS2MC_0HtIiZdeyD42rUM0MSmwusuHwuazHyxKh_51eKF8QdB1jGHay0YgRNtrcYnOhDVcfO4wAw",    "medium": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_medium_2.png?version=v1&expires=1656718628&signature=awF3arBjGPba-G4FGGRNEx5Tl8pRKYuDQnbe-7DO5t4Y0Qgej4T7K5W34zyx23Oyt-oU5ak0BRROrtkV_l75AA",    "large": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_large_2.png?version=v1&expires=1656718628&signature=4HD5U9zU0S5C4QjIC85FYYeO--20MwGKFFYGHhZ8alN6WN-ZkOnpWptbL0eOk_4fyagK-IMQc_qfrfc_v7VVDQ"  }],"expected_delivery_date": "2022-06-20","date_created": "2022-06-01T23:37:05.602Z","date_modified": "2022-06-01T23:37:08.361Z","send_date": "2022-06-01T23:42:05.592Z","cards": null,"object": "letter"},"object": "event"}');
        RestContext.request = request;
        webhookLOBEvents.handleNotification();
        
        List<Communication__c> lstCommNew  = [SELECT Id,Letter_ID__c,Mailed_Date__c FROM Communication__c WHERE Id =:lstComm[0].Id];
        System.assertNotEquals(null, lstCommNew[0].Mailed_Date__c); 
        
        Test.stopTest();

    }

    @isTest
       public static void testFinalNoticeLetterWebhookSuccess() {
           //Create sample communication and contact for webhook
           Contact c = new Contact();
           c.FirstName='Test';
           c.LastName = 'Contact';
           insert c; 

           Communication__c comm = new Communication__c(); 
           comm.Contact__c = c.Id;
           insert comm; 
           
           List<Communication__c> lstComm = [SELECT Id FROM Communication__c];
           lstComm[0].Letter_ID__c = 'ltr_70347496d0c7be52';
           update lstComm;
           
           Test.startTest();
           RestRequest request = new RestRequest();
           request.requestUri = getURL();
           request.httpMethod = 'POST';
           request.addHeader('Content-Type', 'application/json');
           request.requestBody = Blob.valueOf('{"event_type": {"resource": "letters","enabled_for_test": true,"id": "letter.rendered_pdf","object": "event_type"},"reference_id": "ltr_70347496d0c7be52","date_created": "2022-06-01T23:37:08.635Z","id": "evt_3daca3d174ca39d4","body": {"id": "ltr_70347496d0c7be52","description": null,"metadata": {},"to": {  "id": "adr_8cb275792d6a6cea",  "description": null,  "name": "GARRETT HEATHCOTE",  "company": null,  "phone": null,  "email": null,  "address_line1": "3820 NORTHDALE BLVD STE 311C",  "address_line2": null,  "address_city": "TAMPA",  "address_state": "FL",  "address_zip": "33624-1863",  "address_country": "UNITED STATES",  "metadata": {},  "date_created": "2022-06-01T23:37:05.477Z",  "date_modified": "2022-06-01T23:37:05.477Z",  "deleted": true,  "object": "address"},"from": {  "id": "adr_58f40d88d72202f4",  "description": null,  "name": null,  "company": "PRUDENTRX",  "phone": null,  "email": null,  "address_line1": "3820 NORTHDALE BLVD STE 311A",  "address_line2": null,  "address_city": "TAMPA",  "address_state": "FL",  "address_zip": "33624-1857",  "address_country": "UNITED STATES",  "metadata": {},  "date_created": "2022-05-11T20:47:01.600Z",  "date_modified": "2022-05-11T20:47:01.600Z",  "object": "address"},"color": true,"double_sided": true,"address_placement": "top_first_page","return_envelope": false,"perforated_page": null,"custom_envelope": null,"extra_service": null,"mail_type": "usps_standard","url": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4.pdf?version=v1&expires=1656718628&signature=4WxuSjkVk2ECTkubDwC57F8F_OucK3A4HyG4cv0YDK9RSAwHjoBv3yQEEIBylaJnOBJFwl_xdB0p-oUHs-XsDg","merge_variables": {  "ClientSignOff": "The PrudentMed Team",  "DSPlus5": "June 6,  2022",  "DateSent": "June 1,  2022",  "GoLiveDate": "May 1,  2022",  "PatientFirstName": "Garrett"},"template_id": "tmpl_4333523983424f6","template_version_id": "vrsn_7147fcd69386276","carrier": "USPS","tracking_number": null,"tracking_events": [],"thumbnails": [  {    "small": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_small_1.png?version=v1&expires=1656718628&signature=LNRm5x9HQN6ovINvIJBMfUD6w17SFGhTK_OMTuGhGE96__B6WA4fNv5y78TelVxwjTOlp7sTc0T3jAT4ngV-DA",    "medium": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_medium_1.png?version=v1&expires=1656718628&signature=NaVC5hMbtUghfBX8hHIpnklN3PTVZcA9YxVdSQKcrIoEzEVcPn3SI1m8PUi59sFjT9kO_ZEdyAAlb6WQsET6Bw",    "large": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_large_1.png?version=v1&expires=1656718628&signature=BiEOS60MA2aMTHXWfRwjlZS8wYoG_UadRYGqwsFk1zqHxVOzE704KOK6tFATtfIAHZMtqASjx_inr1UeXTdAAQ"  },  {    "small": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_small_2.png?version=v1&expires=1656718628&signature=KNDJp3gV2OLS2MC_0HtIiZdeyD42rUM0MSmwusuHwuazHyxKh_51eKF8QdB1jGHay0YgRNtrcYnOhDVcfO4wAw",    "medium": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_medium_2.png?version=v1&expires=1656718628&signature=awF3arBjGPba-G4FGGRNEx5Tl8pRKYuDQnbe-7DO5t4Y0Qgej4T7K5W34zyx23Oyt-oU5ak0BRROrtkV_l75AA",    "large": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_large_2.png?version=v1&expires=1656718628&signature=4HD5U9zU0S5C4QjIC85FYYeO--20MwGKFFYGHhZ8alN6WN-ZkOnpWptbL0eOk_4fyagK-IMQc_qfrfc_v7VVDQ"  }],"expected_delivery_date": "2022-06-20","date_created": "2022-06-01T23:37:05.602Z","date_modified": "2022-06-01T23:37:08.361Z","send_date": "2022-06-01T23:42:05.592Z","cards": null,"object": "letter"},"object": "event"}');
           RestContext.request = request;
           webhookLOBEvents.handleNotification();
           
           List<Communication__c> lstCommNew  = [SELECT Id,Letter_ID__c,Mailed_Date__c FROM Communication__c WHERE Id =:lstComm[0].Id];
           System.assertNotEquals(null, lstCommNew[0].Mailed_Date__c); 
           
           Test.stopTest();
   
       }

    @isTest
       public static void testLetterWebhookBlank() {
           //Create sample communication and contact for webhook
           Contact c = new Contact();
           c.FirstName='Test';
           c.LastName = 'Contact';
           insert c; 

           Communication__c comm = new Communication__c(); 
           comm.Contact__c = c.Id;
           insert comm; 

           List<Communication__c> lstComm = [SELECT Id FROM Communication__c];
           lstComm[0].Letter_ID__c = 'ltr_70347496d0c7be52';
           update lstComm;
           Test.startTest();
           RestRequest request = new RestRequest();
           request.requestUri = getURL();
           request.httpMethod = 'POST';
           request.addHeader('Content-Type', 'application/json');
           request.requestBody = Blob.valueOf('{"event_type": {"resource": "letters","enabled_for_test": true,"id": "letter.rendered_pdf","object": "event_type"},"reference_id": "","date_created": "2022-06-01T23:37:08.635Z","id": "evt_3daca3d174ca39d4","body": {"id": "ltr_70347496d0c7be52","description": null,"metadata": {},"to": {  "id": "adr_8cb275792d6a6cea",  "description": null,  "name": "GARRETT HEATHCOTE",  "company": null,  "phone": null,  "email": null,  "address_line1": "3820 NORTHDALE BLVD STE 311C",  "address_line2": null,  "address_city": "TAMPA",  "address_state": "FL",  "address_zip": "33624-1863",  "address_country": "UNITED STATES",  "metadata": {},  "date_created": "2022-06-01T23:37:05.477Z",  "date_modified": "2022-06-01T23:37:05.477Z",  "deleted": true,  "object": "address"},"from": {  "id": "adr_58f40d88d72202f4",  "description": null,  "name": null,  "company": "PRUDENTRX",  "phone": null,  "email": null,  "address_line1": "3820 NORTHDALE BLVD STE 311A",  "address_line2": null,  "address_city": "TAMPA",  "address_state": "FL",  "address_zip": "33624-1857",  "address_country": "UNITED STATES",  "metadata": {},  "date_created": "2022-05-11T20:47:01.600Z",  "date_modified": "2022-05-11T20:47:01.600Z",  "object": "address"},"color": true,"double_sided": true,"address_placement": "top_first_page","return_envelope": false,"perforated_page": null,"custom_envelope": null,"extra_service": null,"mail_type": "usps_standard","url": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4.pdf?version=v1&expires=1656718628&signature=4WxuSjkVk2ECTkubDwC57F8F_OucK3A4HyG4cv0YDK9RSAwHjoBv3yQEEIBylaJnOBJFwl_xdB0p-oUHs-XsDg","merge_variables": {  "ClientSignOff": "The PrudentMed Team",  "DSPlus5": "June 6,  2022",  "DateSent": "June 1,  2022",  "GoLiveDate": "May 1,  2022",  "PatientFirstName": "Garrett"},"template_id": "tmpl_ff1ec3bf0a332e1","template_version_id": "vrsn_7147fcd69386276","carrier": "USPS","tracking_number": null,"tracking_events": [],"thumbnails": [  {    "small": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_small_1.png?version=v1&expires=1656718628&signature=LNRm5x9HQN6ovINvIJBMfUD6w17SFGhTK_OMTuGhGE96__B6WA4fNv5y78TelVxwjTOlp7sTc0T3jAT4ngV-DA",    "medium": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_medium_1.png?version=v1&expires=1656718628&signature=NaVC5hMbtUghfBX8hHIpnklN3PTVZcA9YxVdSQKcrIoEzEVcPn3SI1m8PUi59sFjT9kO_ZEdyAAlb6WQsET6Bw",    "large": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_large_1.png?version=v1&expires=1656718628&signature=BiEOS60MA2aMTHXWfRwjlZS8wYoG_UadRYGqwsFk1zqHxVOzE704KOK6tFATtfIAHZMtqASjx_inr1UeXTdAAQ"  },  {    "small": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_small_2.png?version=v1&expires=1656718628&signature=KNDJp3gV2OLS2MC_0HtIiZdeyD42rUM0MSmwusuHwuazHyxKh_51eKF8QdB1jGHay0YgRNtrcYnOhDVcfO4wAw",    "medium": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_medium_2.png?version=v1&expires=1656718628&signature=awF3arBjGPba-G4FGGRNEx5Tl8pRKYuDQnbe-7DO5t4Y0Qgej4T7K5W34zyx23Oyt-oU5ak0BRROrtkV_l75AA",    "large": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_large_2.png?version=v1&expires=1656718628&signature=4HD5U9zU0S5C4QjIC85FYYeO--20MwGKFFYGHhZ8alN6WN-ZkOnpWptbL0eOk_4fyagK-IMQc_qfrfc_v7VVDQ"  }],"expected_delivery_date": "2022-06-20","date_created": "2022-06-01T23:37:05.602Z","date_modified": "2022-06-01T23:37:08.361Z","send_date": "2022-06-01T23:42:05.592Z","cards": null,"object": "letter"},"object": "event"}');
           RestContext.request = request;
           webhookLOBEvents.handleNotification();
           
           List<Communication__c> lstCommNew = [SELECT Id,Letter_ID__c, Mailed_Date__c FROM Communication__c WHERE Id =:lstComm[0].Id];
           System.assertEquals(null, lstCommNew[0].Mailed_Date__c); 
           
           Test.stopTest();
   
       }    
       
       @isTest
       public static void testLetterWebhookDNE() {
           //Create sample communication and contact for webhook
           Contact c = new Contact();
           c.FirstName='Test';
           c.LastName = 'Contact';
           insert c; 

           Communication__c comm = new Communication__c(); 
           comm.Contact__c = c.Id;
           insert comm; 

           List<Communication__c> lstComm = [SELECT Id FROM Communication__c];
           lstComm[0].Letter_ID__c = 'ltr_70347496d0c7be52';
           update lstComm;
           Test.startTest();
           RestRequest request = new RestRequest();
           request.requestUri = getURL();
           request.httpMethod = 'POST';
           request.addHeader('Content-Type', 'application/json');
           request.requestBody = Blob.valueOf('{"event_type": {"resource": "letters","enabled_for_test": true,"id": "letter.rendered_pdf","object": "event_type"},"reference_id": "12324567","date_created": "2022-06-01T23:37:08.635Z","id": "evt_3daca3d174ca39d4","body": {"id": "ltr_70347496d0c7be52","description": null,"metadata": {},"to": {  "id": "adr_8cb275792d6a6cea",  "description": null,  "name": "GARRETT HEATHCOTE",  "company": null,  "phone": null,  "email": null,  "address_line1": "3820 NORTHDALE BLVD STE 311C",  "address_line2": null,  "address_city": "TAMPA",  "address_state": "FL",  "address_zip": "33624-1863",  "address_country": "UNITED STATES",  "metadata": {},  "date_created": "2022-06-01T23:37:05.477Z",  "date_modified": "2022-06-01T23:37:05.477Z",  "deleted": true,  "object": "address"},"from": {  "id": "adr_58f40d88d72202f4",  "description": null,  "name": null,  "company": "PRUDENTRX",  "phone": null,  "email": null,  "address_line1": "3820 NORTHDALE BLVD STE 311A",  "address_line2": null,  "address_city": "TAMPA",  "address_state": "FL",  "address_zip": "33624-1857",  "address_country": "UNITED STATES",  "metadata": {},  "date_created": "2022-05-11T20:47:01.600Z",  "date_modified": "2022-05-11T20:47:01.600Z",  "object": "address"},"color": true,"double_sided": true,"address_placement": "top_first_page","return_envelope": false,"perforated_page": null,"custom_envelope": null,"extra_service": null,"mail_type": "usps_standard","url": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4.pdf?version=v1&expires=1656718628&signature=4WxuSjkVk2ECTkubDwC57F8F_OucK3A4HyG4cv0YDK9RSAwHjoBv3yQEEIBylaJnOBJFwl_xdB0p-oUHs-XsDg","merge_variables": {  "ClientSignOff": "The PrudentMed Team",  "DSPlus5": "June 6,  2022",  "DateSent": "June 1,  2022",  "GoLiveDate": "May 1,  2022",  "PatientFirstName": "Garrett"},"template_id": "tmpl_ff1ec3bf0a332e1","template_version_id": "vrsn_7147fcd69386276","carrier": "USPS","tracking_number": null,"tracking_events": [],"thumbnails": [  {    "small": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_small_1.png?version=v1&expires=1656718628&signature=LNRm5x9HQN6ovINvIJBMfUD6w17SFGhTK_OMTuGhGE96__B6WA4fNv5y78TelVxwjTOlp7sTc0T3jAT4ngV-DA",    "medium": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_medium_1.png?version=v1&expires=1656718628&signature=NaVC5hMbtUghfBX8hHIpnklN3PTVZcA9YxVdSQKcrIoEzEVcPn3SI1m8PUi59sFjT9kO_ZEdyAAlb6WQsET6Bw",    "large": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_large_1.png?version=v1&expires=1656718628&signature=BiEOS60MA2aMTHXWfRwjlZS8wYoG_UadRYGqwsFk1zqHxVOzE704KOK6tFATtfIAHZMtqASjx_inr1UeXTdAAQ"  },  {    "small": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_small_2.png?version=v1&expires=1656718628&signature=KNDJp3gV2OLS2MC_0HtIiZdeyD42rUM0MSmwusuHwuazHyxKh_51eKF8QdB1jGHay0YgRNtrcYnOhDVcfO4wAw",    "medium": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_medium_2.png?version=v1&expires=1656718628&signature=awF3arBjGPba-G4FGGRNEx5Tl8pRKYuDQnbe-7DO5t4Y0Qgej4T7K5W34zyx23Oyt-oU5ak0BRROrtkV_l75AA",    "large": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_large_2.png?version=v1&expires=1656718628&signature=4HD5U9zU0S5C4QjIC85FYYeO--20MwGKFFYGHhZ8alN6WN-ZkOnpWptbL0eOk_4fyagK-IMQc_qfrfc_v7VVDQ"  }],"expected_delivery_date": "2022-06-20","date_created": "2022-06-01T23:37:05.602Z","date_modified": "2022-06-01T23:37:08.361Z","send_date": "2022-06-01T23:42:05.592Z","cards": null,"object": "letter"},"object": "event"}');
           RestContext.request = request;
           webhookLOBEvents.handleNotification();
           
           List<Communication__c> lstCommNew = [SELECT Id,Letter_ID__c, Mailed_Date__c FROM Communication__c WHERE Id =:lstComm[0].Id];
           System.assertEquals(null, lstCommNew[0].Mailed_Date__c); 
           
           Test.stopTest();
   
       }

       @isTest
          public static void testLetterWebhookBadRequest() {
              //Create sample communication and contact for webhook
              Contact c = new Contact();
              c.FirstName='Test';
              c.LastName = 'Contact';
              insert c; 

              Communication__c comm = new Communication__c(); 
              comm.Contact__c = c.Id;
              insert comm; 

              List<Communication__c> lstComm = [SELECT Id FROM Communication__c];
              lstComm[0].Letter_ID__c = 'ltr_70347496d0c7be52';
              update lstComm;
              Test.startTest();
              RestRequest request = new RestRequest();
              request.requestUri = getURL();
              request.httpMethod = 'POST';
              request.addHeader('Content-Type', 'application/json');
              request.requestBody = Blob.valueOf('tters","enabled_for_test": true,"id": "letter.rendered_pdf","object": "event_type"},"reference_id": "","date_created": "2022-06-01T23:37:08.635Z","id": "evt_3daca3d174ca39d4","body": {"id": "ltr_70347496d0c7be52","description": null,"metadata": {},"to": {  "id": "adr_8cb275792d6a6cea",  "description": null,  "name": "GARRETT HEATHCOTE",  "company": null,  "phone": null,  "email": null,  "address_line1": "3820 NORTHDALE BLVD STE 311C",  "address_line2": null,  "address_city": "TAMPA",  "address_state": "FL",  "address_zip": "33624-1863",  "address_country": "UNITED STATES",  "metadata": {},  "date_created": "2022-06-01T23:37:05.477Z",  "date_modified": "2022-06-01T23:37:05.477Z",  "deleted": true,  "object": "address"},"from": {  "id": "adr_58f40d88d72202f4",  "description": null,  "name": null,  "company": "PRUDENTRX",  "phone": null,  "email": null,  "address_line1": "3820 NORTHDALE BLVD STE 311A",  "address_line2": null,  "address_city": "TAMPA",  "address_state": "FL",  "address_zip": "33624-1857",  "address_country": "UNITED STATES",  "metadata": {},  "date_created": "2022-05-11T20:47:01.600Z",  "date_modified": "2022-05-11T20:47:01.600Z",  "object": "address"},"color": true,"double_sided": true,"address_placement": "top_first_page","return_envelope": false,"perforated_page": null,"custom_envelope": null,"extra_service": null,"mail_type": "usps_standard","url": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4.pdf?version=v1&expires=1656718628&signature=4WxuSjkVk2ECTkubDwC57F8F_OucK3A4HyG4cv0YDK9RSAwHjoBv3yQEEIBylaJnOBJFwl_xdB0p-oUHs-XsDg","merge_variables": {  "ClientSignOff": "The PrudentMed Team",  "DSPlus5": "June 6,  2022",  "DateSent": "June 1,  2022",  "GoLiveDate": "May 1,  2022",  "PatientFirstName": "Garrett"},"template_id": "tmpl_ff1ec3bf0a332e1","template_version_id": "vrsn_7147fcd69386276","carrier": "USPS","tracking_number": null,"tracking_events": [],"thumbnails": [  {    "small": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_small_1.png?version=v1&expires=1656718628&signature=LNRm5x9HQN6ovINvIJBMfUD6w17SFGhTK_OMTuGhGE96__B6WA4fNv5y78TelVxwjTOlp7sTc0T3jAT4ngV-DA",    "medium": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_medium_1.png?version=v1&expires=1656718628&signature=NaVC5hMbtUghfBX8hHIpnklN3PTVZcA9YxVdSQKcrIoEzEVcPn3SI1m8PUi59sFjT9kO_ZEdyAAlb6WQsET6Bw",    "large": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_large_1.png?version=v1&expires=1656718628&signature=BiEOS60MA2aMTHXWfRwjlZS8wYoG_UadRYGqwsFk1zqHxVOzE704KOK6tFATtfIAHZMtqASjx_inr1UeXTdAAQ"  },  {    "small": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_small_2.png?version=v1&expires=1656718628&signature=KNDJp3gV2OLS2MC_0HtIiZdeyD42rUM0MSmwusuHwuazHyxKh_51eKF8QdB1jGHay0YgRNtrcYnOhDVcfO4wAw",    "medium": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_medium_2.png?version=v1&expires=1656718628&signature=awF3arBjGPba-G4FGGRNEx5Tl8pRKYuDQnbe-7DO5t4Y0Qgej4T7K5W34zyx23Oyt-oU5ak0BRROrtkV_l75AA",    "large": "https://lob-assets.com/letters/ltr_8ca32bc602206aa4_thumb_large_2.png?version=v1&expires=1656718628&signature=4HD5U9zU0S5C4QjIC85FYYeO--20MwGKFFYGHhZ8alN6WN-ZkOnpWptbL0eOk_4fyagK-IMQc_qfrfc_v7VVDQ"  }],"expected_delivery_date": "2022-06-20","date_created": "2022-06-01T23:37:05.602Z","date_modified": "2022-06-01T23:37:08.361Z","send_date": "2022-06-01T23:42:05.592Z","cards": null,"object": "letter"},"object": "event"}');
              RestContext.request = request;
              webhookLOBEvents.handleNotification();
              
              List<Communication__c> lstCommNew = [SELECT Id,Letter_ID__c, Mailed_Date__c FROM Communication__c WHERE Id =:lstComm[0].Id];
              System.assertEquals(null, lstCommNew[0].Mailed_Date__c); 
              
              Test.stopTest();
      
          }

//Error Cases
        @isTest
        public static void testLetterBadAddress() {
            //Grab Contact record .... create Contact first
            List<Contact> lstContacts = [SELECT Id FROM Contact];            
            lstContacts[0].Patient_State__c = 'CA';
            lstContacts[0].Patient_Zip_Code__c = '11111';
            lstContacts[0].Invalid_Address__c = false;
            update lstContacts;
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testLetterBadAddress'));
            String response = SendLetterController.sendLetterProcess(lstContacts[0].Id, Constants.WELCOMELETTER);
            System.assertEquals('Error: Invalid USPS Address. Please review Contact\'s address.', response); 
            
            List<Communication__c> lstCommunications = [SELECT Id, Invalid_Address__c FROM Communication__c WHERE Contact__c = :lstContacts[0].Id];
            System.assertEquals(true, lstCommunications[0].Invalid_Address__c); 
            
            Test.stopTest();
    
        }

        @isTest
        public static void testLetterBadCallout() {
            //Grab Contact record .... create Contact first
            List<Contact> lstContacts = [SELECT Id FROM Contact];            

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new LetterServiceMock(''));
            String response = SendLetterController.sendLetterProcess(lstContacts[0].Id, Constants.WELCOMELETTER);
            System.assertEquals('Error: 500 {"error":{"message":"Something is bad"}}', response); 
            
            Test.stopTest();
    
        }
//Success Cases against letter Status
        @isTest
        public static void testLetterd2ndAttempt() {
            //Grab Contact record .... create Contact first
            List<Contact> lstContacts = [SELECT Id, disableLetterButton__c FROM Contact];
            lstContacts[0].Welcome_Letter_Id__c = 'ltr_123456789';
            update lstContacts;     
            Test.startTest();   
            Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testWelcomeLetterSuccess'));
            String response1 = SendLetterController.sendLetterProcess(lstContacts[0].Id, Constants.WELCOMELETTER);
            List<Communication__c> lstCommunications = [SELECT Id, Disable_Letter_Button__c FROM Communication__c WHERE Contact__c = :lstContacts[0].Id];
            lstCommunications[0].Disable_Letter_Button__c = false; 
            update lstCommunications; 
            String response = SendLetterController.displayLetterButtonStatus(lstContacts[0].Id);
            System.assertEquals('Welcome2nd', response);             
            Test.stopTest();
    
        }
        @isTest
        public static void testLetterdDoNotDisableButton() {
            //Grab Contact record .... create Contact first
            List<Contact> lstContacts = [SELECT Id FROM Contact];
            Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testLetterSuccess'));
            String response = SendLetterController.displayLetterButtonStatus(lstContacts[0].Id);
            System.assertEquals('Welcome', response);             
            Test.stopTest();
    
        }
        @isTest
        public static void testLetterdDisableButton() {
            //Grab Contact record .... create Contact first
            List<Contact> lstContacts = [SELECT Id, disableLetterButton__c FROM Contact];
            lstContacts[0].disableLetterButton__c = true;
            update lstContacts;     
            Test.startTest();   
            Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testWelcomeLetterSuccess'));
            String response1 = SendLetterController.sendLetterProcess(lstContacts[0].Id, Constants.WELCOMELETTER);
            List<Communication__c> lstCommunications = [SELECT Id, Disable_Letter_Button__c FROM Communication__c WHERE Contact__c = :lstContacts[0].Id];
            Communication__c clonedComm = lstCommunications[0].clone();  
            clonedComm.Contact__c = lstContacts[0].Id;
            insert clonedComm; 
            String response = SendLetterController.displayLetterButtonStatus(lstContacts[0].Id);
            System.assertEquals('WelcomeDisabled', response);             
            Test.stopTest();
    
        }
        @isTest
        public static void testLetterdDisableButtonNoContact() {

            Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new LetterServiceMock('testLetterSuccess'));
            String response = SendLetterController.displayLetterButtonStatus('123456');
            System.assertEquals('Error: Could not find Contact', response);             
            Test.stopTest();
    
        }

        public static String getURL()
        {
            System.Domain d = System.DomainParser.parse(URL.getOrgDomainUrl());
            String env = d.getSandboxName();

            // Devs if you need to test webhooks in your personal sandbox, add your URL here and add it to the condition in the return statement
            String medtsURL = 'https://prudentrx2--medts.sandbox.my.salesforce-sites.com/services/apexrest/api/Webhooks/LOBEventsPharmacy';
            String qaURL = 'https://prudentrx2--medqa.sandbox.my.salesforce-sites.com/services/apexrest/api/Webhooks/LOBEventsPharmacy'; 
            String uatURL = 'https://prudentrx2--uat.sandbox.my.salesforce-sites.com/services/apexrest/api/Webhooks/LOBEventsPharmacy'; 
            String prodURL = 'https://prudentrx2.my.salesforce-sites.com/services/apexrest/api/Webhooks/LOBEventsPharmacy'; 
        
            return env == 'medts' ? medtsURL : env == 'medqa' ? qaURL : env == 'uat' ? uatURL : prodURL; 
            
        }

}
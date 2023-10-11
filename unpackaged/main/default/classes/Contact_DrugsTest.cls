@isTest
public class Contact_DrugsTest {
    @isTest
    public static void HistoricalPA_NewContact_Drugs()
    {
        Account accountInstance = new Account(
                Name = 'Test Account'

        );

        insert accountInstance;

        Drug__c testDrug = new Drug__c();
        testDrug.Coding_Level__c = 'HCPCS + NDC';
        testDrug.J_Code__c = 'J5678';
        //testDrug.NDC__c = '123456792';
        insert testDrug;

        NDC__c testNDC = new NDC__c(Drug__c = testDrug.Id, Name = '123456792');
        insert testNDC;

        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-09-17'),
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Segment__c='0';
        claims.Claim_Line__c='3';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        claims.Source_File_Type__c = 'Historical Claims';
        insert claims;

        Historical_Prior_Auth__c HistoricalPA = new Historical_Prior_Auth__c();
        HistoricalPA.CSA_Account__c = 'AN0003';
        HistoricalPA.Prior_Authorization__c = 'A126';
        //HistoricalPA.Authorized_Representative__c = 'Ras And';
        //HistoricalPA.Authorized_Relationship__c = '4';
        //HistoricalPA.Billing_Provider_City__c = 'New York City';
        //HistoricalPA.Billing_Provider_PIN__c = '1234570';
        //HistoricalPA.Billing_Provider_State__c = 'NY';
        //HistoricalPA.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        //HistoricalPA.Billing_Provider_Zip_Code__c = '10118';
        HistoricalPA.CSA_Control__c = 'CN0003';
        HistoricalPA.Diagnosis_Code__c = '12345678989';
        HistoricalPA.Drug_Label_Name__c = 'Drug Four';
        HistoricalPA.HCPCS_Code__c = 'J5678';
        HistoricalPA.NDC__c = '123456792';
        HistoricalPA.Service_Start_Date__c = date.valueOf('2021-10-01');
        HistoricalPA.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalPA.Patient_Email_Address__c = 'lara@test.com';
        HistoricalPA.Patient_First_Name__c = 'Lara';
        HistoricalPA.Patient_Last_Name__c = 'Briyan';
        HistoricalPA.Patient_Middle_Initial__c = 'B';
        HistoricalPA.Patient_Phone_Number__c = '8888888890';
        HistoricalPA.Patient_Gender__c = 'Male';
        HistoricalPA.Plan_Sponsor_Name__c = 'TCS';
        HistoricalPA.Service_Provider_Fax__c = '5555555557';
        HistoricalPA.Service_Provider_Phone__c = '7777777779';
        HistoricalPA.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        HistoricalPA.Service_Provider_City__c = 'Chicago';
        HistoricalPA.Service_Provider_First_Name__c = 'Dave';
        HistoricalPA.Service_Provider_Last_Name__c = 'Dle';
        HistoricalPA.Service_Provider_NPI__c = '9998887778';
        HistoricalPA.Service_Provider_Practice__c = 'NONE';
        HistoricalPA.Service_Provider_Zip__c = '10125';
        HistoricalPA.Service_Provider_Specialty_Code__c = '3';
        HistoricalPA.Service_Provider_State__c = 'NY';
        HistoricalPA.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalPA.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalPA.Patient_City__c = 'Los Angeles';
        HistoricalPA.Patient_CUMB_ID__c = 'W12345680';
        HistoricalPA.Patient_State__c = 'NY';
        HistoricalPA.Patient_Zip_Code__c = '10153';
        HistoricalPA.CSA_Suffix__c = 'SN0003';
        //HistoricalPA.Total_Copay__c = 72;
        HistoricalPA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert HistoricalPA;

        Test.startTest();
        List<Contact_Drug__c> contactDrugList = [SELECT id, Historical_Prior_Auth__c from Contact_Drug__c];
        system.assertequals(1,contactDrugList.size(), '1 Contact Drug should have been processed & created');
        List<Historical_Prior_Auth__c> historicalPAList = [SELECT id, Contact_Drug__c from Historical_Prior_Auth__c];
        system.assertequals(1,historicalPAList.size(), 'Source HPA should be linked to the procesed Contact Drug');
        Test.stopTest();

    }

    @isTest
    public static void HistoricalPANewContactDrugsRunAsNonSysUser()
    {

        // Setup test data
        // Create a unique UserName
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Patient Advocates'];
        User u = new User(Alias = 'standt', Email='CallCenterMgt@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/New_York',
        UserName=uniqueUserName);

        Account accountInstance = new Account(
                Name = 'Test Account'

        );

        insert accountInstance;

        Drug__c testDrug = new Drug__c();
        testDrug.Coding_Level__c = 'HCPCS + NDC';
        testDrug.J_Code__c = 'J5678';
        //testDrug.NDC__c = '123456792';
        insert testDrug;

        NDC__c testNDC = new NDC__c(Drug__c = testDrug.Id, Name = '123456792');
        insert testNDC;

        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-09-17'),
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;
        Claim_Information__c claims = new Claim_Information__c();
        claims.Primary_Claim_Number__c='JG12389';
        claims.Claim_Segment__c='0';
        claims.Claim_Line__c='3';
        claims.Prior_Authorization__c='B123';
        claims.Amount_Paid_By_Primary__c = 200;
        claims.Source_File_Type__c = 'Historical Claims';
        insert claims;

        Historical_Prior_Auth__c HistoricalPA = new Historical_Prior_Auth__c();
        HistoricalPA.CSA_Account__c = 'AN0003';
        HistoricalPA.Prior_Authorization__c = 'A126';
        //HistoricalPA.Authorized_Representative__c = 'Ras And';
        //HistoricalPA.Authorized_Relationship__c = '4';
        //HistoricalPA.Billing_Provider_City__c = 'New York City';
        //HistoricalPA.Billing_Provider_PIN__c = '1234570';
        //HistoricalPA.Billing_Provider_State__c = 'NY';
        //HistoricalPA.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        //HistoricalPA.Billing_Provider_Zip_Code__c = '10118';
        HistoricalPA.CSA_Control__c = 'CN0003';
        HistoricalPA.Diagnosis_Code__c = '12345678989';
        HistoricalPA.Drug_Label_Name__c = 'Drug Four';
        HistoricalPA.HCPCS_Code__c = 'J5678';
        HistoricalPA.NDC__c = '123456792';
        HistoricalPA.Service_Start_Date__c = date.valueOf('2021-10-01');
        HistoricalPA.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalPA.Patient_Email_Address__c = 'lara@test.com';
        HistoricalPA.Patient_First_Name__c = 'Lara';
        HistoricalPA.Patient_Last_Name__c = 'Briyan';
        HistoricalPA.Patient_Middle_Initial__c = 'B';
        HistoricalPA.Patient_Phone_Number__c = '8888888890';
        HistoricalPA.Patient_Gender__c = 'Male';
        HistoricalPA.Plan_Sponsor_Name__c = 'TCS';
        HistoricalPA.Service_Provider_Fax__c = '5555555557';
        HistoricalPA.Service_Provider_Phone__c = '7777777779';
        HistoricalPA.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        HistoricalPA.Service_Provider_City__c = 'Chicago';
        HistoricalPA.Service_Provider_First_Name__c = 'Dave';
        HistoricalPA.Service_Provider_Last_Name__c = 'Dle';
        HistoricalPA.Service_Provider_NPI__c = '9998887778';
        HistoricalPA.Service_Provider_Practice__c = 'NONE';
        HistoricalPA.Service_Provider_Zip__c = '10125';
        HistoricalPA.Service_Provider_Specialty_Code__c = '3';
        HistoricalPA.Service_Provider_State__c = 'NY';
        HistoricalPA.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalPA.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalPA.Patient_City__c = 'Los Angeles';
        HistoricalPA.Patient_CUMB_ID__c = 'W12345680';
        HistoricalPA.Patient_State__c = 'NY';
        HistoricalPA.Patient_Zip_Code__c = '10153';
        HistoricalPA.CSA_Suffix__c = 'SN0003';
        //HistoricalPA.Total_Copay__c = 72;
        HistoricalPA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert HistoricalPA;

        Test.startTest();
        List<Contact> conList = [SELECT id from Contact WHERE CSA_Account__c =: HistoricalPA.CSA_Account__c];
        system.assertequals(1,conList.size(), '1 Contact should have been processed & created');
        List<Contact_Drug__c> contactDrugList = [SELECT id, Historical_Prior_Auth__c FROM Contact_Drug__c];
        system.assertequals(1,contactDrugList.size(), '1 Contact Drug should have been processed & created');
        List<Case> caselst = [SELECT id from Case];
        system.assertequals(1,caselst.size()); //HPAs only create an Enrollment Case & no Reimbursement Case
        List<Historical_Prior_Auth__c> historicalPAList = [SELECT id, Contact_Drug__c FROM Historical_Prior_Auth__c];
        system.assertequals(1,historicalPAList.size(), 'Source HPA should be linked to the processed Contact Drug');

        List<Contact> updatedContactList = new List<Contact>();
        for(Contact contactRecord: updatedContactList) {
            contactRecord.Patient_Priority_Note__c = 'HCP and MBR must re-enroll every 12 months by submitting a new enrollment form.';
            updatedContactList.add(contactRecord);
        }

        List<Contact_Drug__c> updatedContactDrugList = new List<Contact_Drug__c>();
        for(Contact_Drug__c contactDrug: contactDrugList) {
            contactDrug.Provider_Notes__c = 'HCP and MBR must re-enroll every 12 months by submitting a new enrollment form.';
            updatedContactDrugList.add(contactDrug);
        }

        List<Case> updatedCaseRecordList = new List<Case>();
        for(Case caseRecord: caselst) {
            caseRecord.Subject = 'HCP and MBR must re-enroll every 12 months by submitting a new enrollment form.';
            updatedCaseRecordList.add(caseRecord);
        }

        System.runAs(u) {
            // The following code runs as user 'u'
            update updatedContactList;
            update updatedContactDrugList;
            update updatedCaseRecordList;
        }

        historicalPAList = [SELECT id, Contact_Drug__c, LastModifiedBy.Alias FROM Historical_Prior_Auth__c];
        for(Historical_Prior_Auth__c hpaRecord: historicalPAList) {
            system.assertequals(hpaRecord.LastModifiedBy.Alias != u.Alias, true, 'Onl user with profile System Administrator Full should be able to change the HPA record');
        }

        Test.stopTest();

    }

    @isTest
    public static void HistoricalPA_ExistingContact_Drugs()
    {
        Account accountInstance = new Account(
                Name = 'Test Account'

        );

        insert accountInstance;

        Drug__c testDrug = new Drug__c();
        testDrug.Coding_Level__c = 'HCPCS';
        testDrug.J_Code__c = 'J5678';
        //testDrug.NDC__c = '123456792';
        insert testDrug;

        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-09-17'),
                CSA_Control__c = 'CN0003',
                CSA_Suffix__c = 'SN0003',
                CSA_Account__c = 'AN0003'
        );
        insert csaInstance;

        Historical_Prior_Auth__c HistoricalPA = new Historical_Prior_Auth__c();
        HistoricalPA.CSA_Account__c = 'AN0003';
        HistoricalPA.Prior_Authorization__c = 'A126';
        //HistoricalPA.Authorized_Representative__c = 'Ras And';
        //HistoricalPA.Authorized_Relationship__c = '4';
        //HistoricalPA.Billing_Provider_City__c = 'New York City';
        //HistoricalPA.Billing_Provider_PIN__c = '1234570';
        //HistoricalPA.Billing_Provider_State__c = 'NY';
        //HistoricalPA.Billing_Provider_Address_Line_1__c = '459 Test Lane';
        //HistoricalPA.Billing_Provider_Zip_Code__c = '10118';
        HistoricalPA.CSA_Control__c = 'CN0003';
        HistoricalPA.Diagnosis_Code__c = '12345678989';
        HistoricalPA.Drug_Label_Name__c = 'Drug Four';
        HistoricalPA.HCPCS_Code__c = 'J5678';
        HistoricalPA.NDC__c = '123456792';
        HistoricalPA.Service_Start_Date__c = date.valueOf('2021-10-01');
        HistoricalPA.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalPA.Patient_Email_Address__c = 'lara@test.com';
        HistoricalPA.Patient_First_Name__c = 'Lara';
        HistoricalPA.Patient_Last_Name__c = 'Briyan';
        HistoricalPA.Patient_Middle_Initial__c = 'B';
        HistoricalPA.Patient_Phone_Number__c = '8888888890';
        HistoricalPA.Patient_Gender__c = 'Male';
        HistoricalPA.Plan_Sponsor_Name__c = 'TCS';
        HistoricalPA.Service_Provider_Fax__c = '5555555557';
        HistoricalPA.Service_Provider_Phone__c = '7777777779';
        HistoricalPA.Service_Provider_Address_Line_1__c = '458 Plane Lane';
        HistoricalPA.Service_Provider_City__c = 'Chicago';
        HistoricalPA.Service_Provider_First_Name__c = 'Dave';
        HistoricalPA.Service_Provider_Last_Name__c = 'Dle';
        HistoricalPA.Service_Provider_NPI__c = '9998887778';
        HistoricalPA.Service_Provider_Practice__c = 'NONE';
        HistoricalPA.Service_Provider_Zip__c = '10125';
        HistoricalPA.Service_Provider_Specialty_Code__c = '3';
        HistoricalPA.Service_Provider_State__c = 'NY';
        HistoricalPA.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalPA.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalPA.Patient_City__c = 'Los Angeles';
        HistoricalPA.Patient_CUMB_ID__c = 'W12345680';
        HistoricalPA.Patient_State__c = 'NY';
        HistoricalPA.Patient_Zip_Code__c = '10153';
        HistoricalPA.CSA_Suffix__c = 'SN0003';
        // HistoricalPA.Total_Copay__c = 72;
        HistoricalPA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert HistoricalPA;

        Historical_Prior_Auth__c HistoricalPA1 = new Historical_Prior_Auth__c();
        HistoricalPA1.CSA_Account__c = 'AN0003';
        HistoricalPA1.Prior_Authorization__c = 'A127';
        //HistoricalPA1.Authorized_Representative__c = 'Dup con';
        //HistoricalPA1.Authorized_Relationship__c = '4';
        //HistoricalPA1.Billing_Provider_City__c = 'New York City';
        //HistoricalPA1.Billing_Provider_PIN__c = '1234570';
        //HistoricalPA1.Billing_Provider_State__c = 'NY';
        //HistoricalPA1.Billing_Provider_Address_Line_1__c = '468 Test Lane';
        //HistoricalPA1.Billing_Provider_Zip_Code__c = '10119';
        HistoricalPA1.CSA_Control__c = 'CN0003';
        HistoricalPA1.Diagnosis_Code__c = '12345678989';
        HistoricalPA1.Drug_Label_Name__c = 'Drug Four';
        HistoricalPA1.HCPCS_Code__c = 'J5678';
        HistoricalPA1.NDC__c = '123456792';
        HistoricalPA1.Service_Start_Date__c = date.valueOf('2021-10-01');
        HistoricalPA1.Patient_Birth_Date__c = date.valueOf('1991-01-11');
        //HistoricalPA1.Patient_Email_Address__c = 'duptest@test.com';
        HistoricalPA1.Patient_First_Name__c = 'sach';
        HistoricalPA1.Patient_Last_Name__c = 'tenafd';
        HistoricalPA1.Patient_Middle_Initial__c = 'R';
        HistoricalPA1.Patient_Phone_Number__c = '8888888444';
        HistoricalPA1.Patient_Gender__c = 'Male';
        HistoricalPA1.Plan_Sponsor_Name__c = 'TCS';
        HistoricalPA1.Service_Provider_Fax__c = '9995555557';
        HistoricalPA1.Service_Provider_Phone__c = '9999777779';
        HistoricalPA1.Service_Provider_Address_Line_1__c = '459 Plane Lane';
        HistoricalPA1.Service_Provider_City__c = 'Chicago';
        HistoricalPA1.Service_Provider_First_Name__c = 'Casd';
        HistoricalPA1.Service_Provider_Last_Name__c = 'Fox';
        HistoricalPA1.Service_Provider_NPI__c = '9998887778';
        HistoricalPA1.Service_Provider_Practice__c = 'NONE';
        HistoricalPA1.Service_Provider_Zip__c = '10125';
        HistoricalPA1.Service_Provider_Specialty_Code__c = '3';
        HistoricalPA1.Service_Provider_State__c = 'NY';
        HistoricalPA1.Patient_Address_Line_1__c = '125 Sesame Street';
        HistoricalPA1.Patient_Address_Line_2__c = 'Apt 4';
        HistoricalPA1.Patient_City__c = 'Los Angeles';
        HistoricalPA1.Patient_CUMB_ID__c = 'W12345680';
        HistoricalPA1.Patient_State__c = 'NY';
        HistoricalPA1.Patient_Zip_Code__c = '10153';
        HistoricalPA1.CSA_Suffix__c = 'SN0003';
        // HistoricalPA1.Total_Copay__c = 72;
        HistoricalPA1.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + '-' + 'SN0003' + '-' +'AN0003');

        insert HistoricalPA1;

        Test.startTest();
        List<Contact_Drug__c> contactDrugList = [SELECT id from Contact_Drug__c];
        system.assertequals(1,contactDrugList.size());
        Test.stopTest();

    }
}
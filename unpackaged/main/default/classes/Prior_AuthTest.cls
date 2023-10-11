/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-29-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class Prior_AuthTest {

    private static Implementation__c implementationInstance;
    private static Contract contractInstance;
    private static Account accountInstance;

    private static void paTestSetup(Boolean preGoLive, Boolean allowCaseRouting, Boolean allowMBROutreach) {
        system.debug('PriorAuthTestSetup');

        List<Drug__c> testDrugList = new List<Drug__c>();
        List<CSA__c> csaList = new List<CSA__c>();
        Date goLiveDate;

        if(preGoLive) {
            goLiveDate = date.today().addDays(20);
        } else {
            goLiveDate = date.today().addDays(-60);
        }

        system.debug('Setup Accounts');
        accountInstance = new Account(
                Name = 'Model Office Test-Integration',
                Medical_Drug_List__c = 'PRUDENTMED',
                Go_Live_Date__c = goLiveDate
                //Allow_Case_Routing__c = allowCaseRouting,
                //Allow_MBR_Outreach__c = allowMBROutreach
        );
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

        system.debug('Setup Drugs');
        Drug__c testDrug = new Drug__c(
                J_Code__c = 'J9023',
                Coding_Level__c = 'HCPCS',
                Name = 'BAVENCIO',
                Therapy_Class__c = 'ONCOLOGY',
                PRx_Program_Description__c = 'Non-Essential',
                Pronunciation__c = 'bah-VEN-see-oh',
                Annual_Max__c = 300000.00,
                Reimbursement_Vehicle__c = 'False debit card',
                Member_Minimum_Per_Claim__c = 0,
                PRx_Website__c = 'https://www.coverone.com/en/Co-Pay_Assistance.html',
                Program_Fax__c = '1-800-214-7295',
                PRx_Help_Line_Number__c = '1-844-826-8371',
                PRx_Enrollment_Process__c = 'HCP and member fax CoverOne Enrollment Form to 1-800-214-7295. If using renal : use combination form. All other indications use single agent form.',
                Re_Imbursement_Deadline__c = '180',
                Re_Enrollment_Date_Eligibility__c = '12 Months',
                When_Re_Enrollment_Action_Is_Needed__c = '12 Months'

        );
        testDrugList.add(testDrug);

        testDrug = new Drug__c(
                J_Code__c = 'J9035',
                Coding_Level__c = 'HCPCS',
                Name = 'AVASTIN',
                Therapy_Class__c = 'ONCOLOGY',
                PRx_Program_Description__c = 'Non-Essential',
                Pronunciation__c = 'uh-VAH-stin',
                Copay_Assistance_Available__c = 'No',
                Annual_Max__c = 0.00,
                //Reimbursement_Vehicle__c = 'False debit card',
                Member_Minimum_Per_Claim__c = 0
                //PRx_Website__c = 'https://www.coverone.com/en/Co-Pay_Assistance.html',
                //Program_Fax__c = '1-800-214-7295',
                //PRx_Help_Line_Number__c = '1-844-826-8371',
                //PRx_Enrollment_Process__c = 'HCP and member fax CoverOne Enrollment Form to 1-800-214-7295. If using renal : use combination form. All other indications use single agent form.',
                //Re_Imbursement_Deadline__c = '180',
                //Re_Enrollment_Date_Eligibility__c = '12 Months',
                //When_Re_Enrollment_Action_Is_Needed__c = '12 Months'

        );
        testDrugList.add(testDrug);

        testDrug = new Drug__c(
                J_Code__c = 'J0179',
                Coding_Level__c = 'HCPCS',
                Name = 'BEOVU',
                Therapy_Class__c = 'OCULAR DISORDERS',
                PRx_Program_Description__c = 'Non-Essential',
                Pronunciation__c = 'Bay-u',
                Copay_Assistance_Available__c = 'No',
                Annual_Max__c = 0.00,
                //Reimbursement_Vehicle__c = 'False debit card',
                Member_Minimum_Per_Claim__c = 0
                //PRx_Website__c = 'https://www.coverone.com/en/Co-Pay_Assistance.html',
                //Program_Fax__c = '1-800-214-7295',
                //PRx_Help_Line_Number__c = '1-844-826-8371',
                //PRx_Enrollment_Process__c = 'HCP and member fax CoverOne Enrollment Form to 1-800-214-7295. If using renal : use combination form. All other indications use single agent form.',
                //Re_Imbursement_Deadline__c = '180',
                //Re_Enrollment_Date_Eligibility__c = '12 Months',
                //When_Re_Enrollment_Action_Is_Needed__c = '12 Months'

        );
        testDrugList.add(testDrug);

        testDrug = new Drug__c(
                J_Code__c = 'J0178',
                Coding_Level__c = 'HCPCS',
                Name = 'EYLEA',
                Therapy_Class__c = 'OCULAR DISORDERS',
                PRx_Program_Description__c = 'Non-Essential',
                Pronunciation__c = 'eye-LEE-uh',
                Copay_Assistance_Available__c = 'No',
                Annual_Max__c = 15000.00,
                //Reimbursement_Vehicle__c = 'False debit card',
                Member_Minimum_Per_Claim__c = 0,
                PRx_Website__c = 'https://eylea.us/support/co-pay-card',
                Program_Fax__c = '1-888-335-3264',
                PRx_Help_Line_Number__c = '1-855-395-324871',
                PRx_Enrollment_Process__c = 'HCP can enroll member online ; PRx can 3-way call the patient and program to enroll them, card details can be provided at the end, for immediate use',
                Retroactive_Backdates__c = '120 Days',
                Re_Imbursement_Deadline__c = '365 Days'
                //Re_Enrollment_Date_Eligibility__c = '12 Months',
                //When_Re_Enrollment_Action_Is_Needed__c = '12 Months'

        );
        testDrugList.add(testDrug);

        testDrug = new Drug__c(
                J_Code__c = 'J9173',
                Coding_Level__c = 'HCPCS',
                Name = 'IMFINZI',
                Therapy_Class__c = 'OCULAR DISORDERS',
                PRx_Program_Description__c = 'Non-Essential',
                Pronunciation__c = 'im-FIN-zee',
                TAT__c = '3 Days',
                //Copay_Assistance_Available__c = 'No',
                Annual_Max__c = 26000.00,
                //Reimbursement_Vehicle__c = 'False debit card',
                Member_Minimum_Per_Claim__c = 0,
                PRx_Website__c = 'https://www.astrazenecaspecialtysavings.com/pdf/IMFINZI_Affordability_Brochure.pdf',
                Program_Fax__c = '844-329-2360',
                PRx_Help_Line_Number__c = '844-275-2360',
                PRx_Enrollment_Process__c = 'Members HCP must enroll patient online to receive medication, with "IMFINZI" Access360. Once members are approved, they can call 1.844.275.2360 to verify/ or enroll.',
                Retroactive_Backdates__c = '120 Days',
                Re_Imbursement_Deadline__c = '180 Days',
                Re_Enrollment_Date_Eligibility__c = 'Calendar Year',
                When_Re_Enrollment_Action_Is_Needed__c = 'Calendar Year'

        );
        testDrugList.add(testDrug);
        insert testDrugList;

        List<NDC__c> ndcList = new List<NDC__c>();
        for(Drug__c drugInstance: testDrugList) {
            NDC__c testNDC = new NDC__c(Drug__c = drugInstance.Id, Name = '123456789');
            ndcList.add(testNDC);
        }
        insert ndcList;

        system.debug('Setup CSAs');

        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                //Go_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '711',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-'
                        + csaInstance.CSA_Suffix__c + '-'
                        + csaInstance.CSA_Account__c
        );
        //insert csaInstance;
        //System.debug('csaInstance.CSA_Number__c = ' + csaInstance.CSA_Number__c);
        csaList.add(csaInstance);

        System.debug('accountInstance.Id = ' + accountInstance.Id);
        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                //Go_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '757',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-'
                        + csaInstance.CSA_Suffix__c + '-'
                        + csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                //Go_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '911',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-'
                        + csaInstance.CSA_Suffix__c + '-'
                        + csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                //o_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '777',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-'
                        + csaInstance.CSA_Suffix__c + '-'
                        + csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        insert csaList;
        System.Debug(' csaList[0].CSA_Number__c = ' + csaList[0].CSA_Number__c);
    }


    @isTest
    public static void PriorAuthSuccessTest() {
        Test.startTest();

        String json = '[{"prudentInDataStagingId": "09022021591307","Account_Number": "013","Authorization_Number": "A126","Authorized_Representative": "Rasu And","Authorized_Representative_Relationship": "04","Copay_Amount": "33","Control_Number": "900990","Diagnosis_Code": "12345678989","Drug_Label_Name": "Drug four","ICD9_Procedure_Code": "J1237","National_Drug_Code": "123456792","PA_Approval_Dates": "10012021","Patient_Birth_Date": "01011993","Patient_Email_Address": "resul@test.com","Patient_First_Name": "Rasul","Patient_Last_Name": "Adnre","Patient_Middle_Initial": "A","Patient_Phone_Number": "8888888891","Patient_Sex": "M","Policy_Holder_Name": "Wipro","Prescriber_Address_Line1": "792 Test Lane","Prescriber_City": "New York City","Prescriber_Fax": "6666666669","Prescriber_First_Name": "Gare","Prescriber_Last_Name": "Rod","Prescriber_Phone": "9999999993","Prescriber_Practice_Name": "Test4","Prescriber_NPI_Number": "9998887779","Prescriber_Specialty": "NONE","Prescriber_State": "NY","Prescriber_Zip_Code": "10126","Service_Provider_Fax": "5555555558","Service_Provider_Phone": "7777777780","Servicing_Provider_Address_Line_1": "459 Test Lane","Servicing_Provider_City": "New York City","Servicing_Provider_First_Name": "Gare","Servicing_Provider_Last_Name": "Rod","Servicing_Provider_National_Provider_Identifier": "9998887778","Servicing_Provider_Service_Location_Zip_Code": "10126","Servicing_Provider_Specialty_Code": "04","Servicing_Provider_State_Code": "NY","Servicing_Provider_Practice_Role_Name": "NONE","Subscriber_Address_Line_1": "126 Sesame Street","Subscriber_Address_Line_2": "0","Subscriber_City": "New York City","Subscriber_CUMB_ID": "W12345681", "Subscriber_State_Code": "NY","Subscriber_Zip_Code": "10126","Suffix_Number": "29","Billing_Provider_PIN": "1234570","Billing_Provider_Street_Address_Line_1": "459 Test Lane","Billing_Provider_City": "New York City","Billing_Provider_State_Code": "NY","Billing_Provider_Zip_Code": "10126","File_Upsert": "Prior Authorization"}]';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;

        String responseJSON = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> responseList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(responseJSON, List<RestAPI_JSONResponse>.class);

        //System.assertEquals('Success', responseList.get(0).status);

        Test.stopTest();

    }

    @isTest
    public static void PriorAuthFailureTest() {
        Test.startTest();

        String json = '[{"prudentInDataStagingId": "09022021591307","Account_Number": "013","Authorization_Number": "A126","Authorized_Representative": "Rasu And","Authorized_Representative_Relationship": "04","Copay_Amount": "33","Control_Number": "900990","Diagnosis_Code": "12345678989","Drug_Label_Name": "Drug four","ICD9_Procedure_Code": "J1237","National_Drug_Code": "123456792","PA_Approval_Dates": "10012021","Patient_Birth_Date": "01011993","Patient_Email_Address": "resul@test.com","Patient_First_Name": "Rasul","Patient_Last_Name": "Adnre","Patient_Middle_Initial": "A","Patient_Phone_Number": "8888888891","Patient_Sex": "M","Policy_Holder_Name": "Wipro","Prescriber_Address_Line1": "792 Test Lane","Prescriber_City": "New York City","Prescriber_Fax": "6666666669","Prescriber_First_Name": "Gare","Prescriber_Last_Name": "Rod","Prescriber_Phone": "9999999993","Prescriber_Practice_Name": "Test4","Prescriber_NPI_Number": "9998887779","Prescriber_Specialty": "NONE","Prescriber_State": "NY","Prescriber_Zip_Code": "10126","Service_Provider_Fax": "5555555558","Service_Provider_Phone": "7777777780","Servicing_Provider_Address_Line_1": "459 Test Lane","Servicing_Provider_City": "New York City","Servicing_Provider_First_Name": "Gare","Servicing_Provider_Last_Name": "Rod","Servicing_Provider_National_Provider_Identifier": "9998887778","Servicing_Provider_Service_Location_Zip_Code": "10126","Servicing_Provider_Specialty_Code": "04","Servicing_Provider_State_Code": "NY","Servicing_Provider_Practice_Role_Name": "NONE","Subscriber_Address_Line_1": "126 Sesame Street","Subscriber_Address_Line_2": "0","Subscriber_City": "New York City","Subscriber_CUMB_ID": "W12345681","Subscriber_State_Code": "NY","Subscriber_Zip_Code": "10126","Suffix_Number": "29","Billing_Provider_PIN": "1234570","Billing_Provider_Street_Address_Line_1": "459 Test Lane","Billing_Provider_City": "New York City","Billing_Provider_State_Code": "NY","Billing_Provider_Zip_Code": "10126","File_Upsert": Prior Authorization"}]';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/PrudentMd/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;

        String responseJSON = PrudentRestAPIResource.doPost();
        List<RestAPI_JSONResponse> responseList = (List<RestAPI_JSONResponse>) System.JSON.deserialize(responseJSON, List<RestAPI_JSONResponse>.class);

        //System.assertEquals('Failure', responseList.get(0).status);

        Test.stopTest();

    }

    @IsTest
    public static void scenario1PATest()
    {
        Test.startTest();

        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        paTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: ');
        List<Prior_Auth__c> priorAuthsList = new List<Prior_Auth__c>();
        Prior_Auth__c priorAuth = new Prior_Auth__c();
        priorAuth.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        priorAuth.CSA_Control__c = '865431';
        priorAuth.CSA_Account__c = '711';
        priorAuth.CSA_Suffix__c = '15';
        priorAuth.Patient_CUMB_ID__c = '185494722';
        priorAuth.Relationship_Code__c = 'M';
        //historicalClaim.COB_Indicator__c = 'N';
        //historicalClaim.Prior_Authorization__c = 'A126';
        priorAuth.Authorized_Representative__c = 'Adam Pawlik';
        priorAuth.Authorized_Relationship__c = 'Father';
        priorAuth.Diagnosis_Code__c = 'C4A30';
        priorAuth.Drug_Label_Name__c = 'BAVENCIO';
        priorAuth.HCPCS_Code__c = 'J9023';
        //historicalClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        priorAuth.NDC__c = '44087353501';
        //historicalClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        priorAuth.Patient_First_Name__c = 'KHALIAH';
        priorAuth.Patient_Last_Name__c = 'HINGSTON';
        priorAuth.Patient_Middle_Initial__c = '';
        priorAuth.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        priorAuth.Patient_Gender__c = 'Male';
        //priorAuth.Patient_Email_Address__c = 'lara@test.com';

        priorAuth.Patient_Phone_Number__c = '5083161245';
        priorAuth.Plan_Sponsor_Name__c = 'TCS';
        priorAuth.Service_Provider_Fax__c = '6178970801';
        priorAuth.Service_Provider_Phone__c = '9785268288';
        priorAuth.Service_Provider_Address_Line_1__c = '40 Beach Street';
        priorAuth.Service_Provider_City__c = 'Manchester';
        priorAuth.Service_Provider_First_Name__c = 'Rebecca L';
        priorAuth.Service_Provider_Last_Name__c = 'Allred';
        priorAuth.Service_Provider_NPI__c = '1417948050';
        priorAuth.Service_Provider_Practice__c = 'NONE';
        priorAuth.Service_Provider_Zip__c = '01944';
        priorAuth.Service_Provider_Specialty_Code__c = '';
        priorAuth.Service_Provider_State__c = 'NY';
        priorAuth.Patient_Address_Line_1__c = '39276 HACE STREET';
        priorAuth.Patient_Address_Line_2__c = '';
        priorAuth.Patient_City__c = 'HOLTSVILLE';
        priorAuth.Patient_State__c = 'NY';
        priorAuth.Patient_Zip_Code__c = '00501';
        priorAuth.Relationship_Code__c = '01';
        priorAuth.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                priorAuth.CSA_Control__c + '-'
                        + priorAuth.CSA_Suffix__c + '-'
                        + priorAuth.CSA_Account__c
        );
        System.Debug('priorAuth.CSA_Number__c = '+priorAuth.CSA_Number__c);

        priorAuthsList.add(priorAuth);

        priorAuth = new Prior_Auth__c();
        priorAuth.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        priorAuth.CSA_Control__c = '865431';
        priorAuth.CSA_Account__c = '711';
        priorAuth.CSA_Suffix__c = '15';
        priorAuth.Patient_CUMB_ID__c = '185494721';
        priorAuth.Relationship_Code__c = 'M';
        //historicalClaim.COB_Indicator__c = 'N';
        //historicalClaim.Prior_Authorization__c = 'A126';
        //priorAuth.Authorized_Representative__c = 'Adam Pawlik';
        priorAuth.Authorized_Relationship__c = 'Father';
        priorAuth.Diagnosis_Code__c = 'C4A30';
        priorAuth.Drug_Label_Name__c = 'BAVENCIO';
        priorAuth.HCPCS_Code__c = 'J9023';
        //historicalClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        priorAuth.NDC__c = '44087353501';
        //historicalClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        priorAuth.Patient_First_Name__c = 'VALERIA';
        priorAuth.Patient_Last_Name__c = 'CYPHERT';
        priorAuth.Patient_Middle_Initial__c = '';
        priorAuth.Patient_Birth_Date__c = date.valueOf('1967-09-23');
        priorAuth.Patient_Gender__c = 'Female';
        //priorAuth.Patient_Email_Address__c = 'lara@test.com';

        priorAuth.Patient_Phone_Number__c = '9179770046';
        priorAuth.Plan_Sponsor_Name__c = 'TCS';
        priorAuth.Service_Provider_Fax__c = '6178970801';
        priorAuth.Service_Provider_Phone__c = '9785268288';
        priorAuth.Service_Provider_Address_Line_1__c = '40 Beach Street';
        priorAuth.Service_Provider_City__c = 'Manchester';
        priorAuth.Service_Provider_First_Name__c = 'Rebecca L';
        priorAuth.Service_Provider_Last_Name__c = 'Allred';
        priorAuth.Service_Provider_NPI__c = '1417948050';
        priorAuth.Service_Provider_Practice__c = 'NONE';
        priorAuth.Service_Provider_Zip__c = '01944';
        priorAuth.Service_Provider_Specialty_Code__c = '';
        priorAuth.Service_Provider_State__c = 'MA';
        priorAuth.Patient_Address_Line_1__c = '15858 JODHPUR STREET';
        priorAuth.Patient_Address_Line_2__c = '';
        priorAuth.Patient_City__c = 'HOLTSVILLE';
        priorAuth.Patient_State__c = 'NY';
        priorAuth.Patient_Zip_Code__c = '00501';
        priorAuth.Relationship_Code__c = '01';
        priorAuth.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                priorAuth.CSA_Control__c + '-'
                        + priorAuth.CSA_Suffix__c + '-'
                        + priorAuth.CSA_Account__c
        );
        System.Debug('priorAuth.CSA_Number__c = '+priorAuth.CSA_Number__c);

        priorAuthsList.add(priorAuth);

        insert priorAuthsList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: historicalClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByPAId = contactsDomain.getExistingContactsByPriorAuthId(priorAuthsList);
        Contact existingContact1 = existingContactsByPAId.get(priorAuthsList[0].Id);
        Contact existingContact2 = existingContactsByPAId.get(priorAuthsList[1].Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('priorAuth.CSA_Number__c = '+priorAuth.CSA_Number__c);
       // system.assertequals(false,existingContact1==null, 'No Contacts found');
        //system.assertequals(false,existingContact2==null, 'No Contacts found');
        // List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: priorAuth.CSA_Account__c];
        //List<Contact_Drug__c> contactDrugList1 = [SELECT Id, Prior_Auth__c FROM Contact_Drug__c WHERE Contact__c =:existingContact1.Id ];
        //List<Contact_Drug__c> contactDrugList2 = [SELECT Id, Prior_Auth__c FROM Contact_Drug__c WHERE Contact__c =:existingContact2.Id ];
        //system.assertequals(1,contactDrugList1.size(),'Member has no Contact Drugs');
        //system.assertequals(1,contactDrugList2.size(),'Member has no Contact Drugs');

//        system.assertequals(2,claimList.size());
        //system.assertNotEquals(contactDrugList1[0].Prior_Auth__c,contactDrugList2[0].Prior_Auth__c,'Contact Drug for 2 different members linked to same PA record');
        //for (Claim_Information__c claim: claimList){
        //List<Case> caseList = [SELECT Id FROM Case WHERE Claim_Information__c =: claimList[1].id ];
        //system.assertEquals(2, caseList.size());
        //}

        //system.assertequals(1,contactDrugList.size());

        Test.stopTest();

    }

    @IsTest
    public static void reopenPAEnrollmentCaseTest()
    {
        Test.startTest();

        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        paTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: ');
        List<Prior_Auth__c> priorAuthsList = new List<Prior_Auth__c>();
        Prior_Auth__c priorAuth = new Prior_Auth__c();
        priorAuth.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        priorAuth.CSA_Control__c = '865431';
        priorAuth.CSA_Account__c = '711';
        priorAuth.CSA_Suffix__c = '15';
        priorAuth.Patient_CUMB_ID__c = '185494722';
        priorAuth.Relationship_Code__c = 'M';
        //historicalClaim.COB_Indicator__c = 'N';
        //historicalClaim.Prior_Authorization__c = 'A126';
        priorAuth.Authorized_Representative__c = 'Adam Pawlik';
        priorAuth.Authorized_Relationship__c = 'Father';
        priorAuth.Diagnosis_Code__c = 'C4A30';
        priorAuth.Drug_Label_Name__c = 'BAVENCIO';
        priorAuth.HCPCS_Code__c = 'J9023';
        //historicalClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        priorAuth.NDC__c = '44087353501';
        //historicalClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        priorAuth.Patient_First_Name__c = 'KHALIAH';
        priorAuth.Patient_Last_Name__c = 'HINGSTON';
        priorAuth.Patient_Middle_Initial__c = '';
        priorAuth.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        priorAuth.Patient_Gender__c = 'Male';
        //priorAuth.Patient_Email_Address__c = 'lara@test.com';

        priorAuth.Patient_Phone_Number__c = '5083161245';
        priorAuth.Plan_Sponsor_Name__c = 'TCS';
        priorAuth.Service_Provider_Fax__c = '6178970801';
        priorAuth.Service_Provider_Phone__c = '9785268288';
        priorAuth.Service_Provider_Address_Line_1__c = '40 Beach Street';
        priorAuth.Service_Provider_City__c = 'Manchester';
        priorAuth.Service_Provider_First_Name__c = 'Rebecca L';
        priorAuth.Service_Provider_Last_Name__c = 'Allred';
        priorAuth.Service_Provider_NPI__c = '1417948050';
        priorAuth.Service_Provider_Practice__c = 'NONE';
        priorAuth.Service_Provider_Zip__c = '01944';
        priorAuth.Service_Provider_Specialty_Code__c = '';
        priorAuth.Service_Provider_State__c = 'NY';
        priorAuth.Patient_Address_Line_1__c = '39276 HACE STREET';
        priorAuth.Patient_Address_Line_2__c = '';
        priorAuth.Patient_City__c = 'HOLTSVILLE';
        priorAuth.Patient_State__c = 'NY';
        priorAuth.Patient_Zip_Code__c = '00501';
        priorAuth.Relationship_Code__c = '01';
        priorAuth.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                priorAuth.CSA_Control__c + '-'
                        + priorAuth.CSA_Suffix__c + '-'
                        + priorAuth.CSA_Account__c
        );
        System.Debug('priorAuth.CSA_Number__c = '+priorAuth.CSA_Number__c);

        priorAuthsList.add(priorAuth);

        insert priorAuth;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: historicalClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByPAId = contactsDomain.getExistingContactsByPriorAuthId(priorAuthsList);
        Contact existingContact1 = existingContactsByPAId.get(priorAuthsList[0].Id);

        List<Contact_Drug__c> contactDrugList1 = [SELECT Id, Prior_Auth__c FROM Contact_Drug__c WHERE Contact__c =:existingContact1.Id ];
        contactDrugList1[0].Copay_Enrollment_Status__c = 'Not on File';
        contactDrugList1[0].Member_Ineligible_for_CPA__c = FALSE;
        update contactDrugList1[0];

        List<Case> caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c FROM Case WHERE Contact_Drug__c =: contactDrugList1[0].Id];
        caseList[0].Status = 'Outreach Completed';
        caseList[0].HCP_Enrollment_Outreach__c = 'Outreach Complete';
        update caseList[0];

        priorAuth = new Prior_Auth__c();
        priorAuth.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        priorAuth.CSA_Control__c = '865431';
        priorAuth.CSA_Account__c = '711';
        priorAuth.CSA_Suffix__c = '15';
        priorAuth.Patient_CUMB_ID__c = '185494722';
        priorAuth.Relationship_Code__c = 'M';
        //historicalClaim.COB_Indicator__c = 'N';
        //historicalClaim.Prior_Authorization__c = 'A126';
        //priorAuth.Authorized_Representative__c = 'Adam Pawlik';
        priorAuth.Authorized_Relationship__c = 'Father';
        priorAuth.Diagnosis_Code__c = 'C4A30';
        priorAuth.Drug_Label_Name__c = 'BAVENCIO';
        priorAuth.HCPCS_Code__c = 'J9023';
        //historicalClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        priorAuth.NDC__c = '44087353501';
        //historicalClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        priorAuth.Patient_First_Name__c = 'KHALIAH';
        priorAuth.Patient_Last_Name__c = 'HINGSTON';
        priorAuth.Patient_Middle_Initial__c = '';
        priorAuth.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        priorAuth.Patient_Gender__c = 'Male';
        //priorAuth.Patient_Email_Address__c = 'lara@test.com';

        priorAuth.Patient_Phone_Number__c = '5083161245';
        priorAuth.Plan_Sponsor_Name__c = 'TCS';
        priorAuth.Service_Provider_Fax__c = '6178970801';
        priorAuth.Service_Provider_Phone__c = '9785268288';
        priorAuth.Service_Provider_Address_Line_1__c = '40 Beach Street';
        priorAuth.Service_Provider_City__c = 'Manchester';
        priorAuth.Service_Provider_First_Name__c = 'Rebecca L';
        priorAuth.Service_Provider_Last_Name__c = 'Allred';
        priorAuth.Service_Provider_NPI__c = '1417948050';
        priorAuth.Service_Provider_Practice__c = 'NONE';
        priorAuth.Service_Provider_Zip__c = '01944';
        priorAuth.Service_Provider_Specialty_Code__c = '';
        priorAuth.Service_Provider_State__c = 'MA';
        priorAuth.Patient_Address_Line_1__c = '15858 JODHPUR STREET';
        priorAuth.Patient_Address_Line_2__c = '';
        priorAuth.Patient_City__c = 'HOLTSVILLE';
        priorAuth.Patient_State__c = 'NY';
        priorAuth.Patient_Zip_Code__c = '00501';
        priorAuth.Relationship_Code__c = '01';
        priorAuth.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                priorAuth.CSA_Control__c + '-'
                        + priorAuth.CSA_Suffix__c + '-'
                        + priorAuth.CSA_Account__c
        );
        System.Debug('priorAuth.CSA_Number__c = '+priorAuth.CSA_Number__c);

        priorAuthsList.add(priorAuth);

        insert priorAuth;

        existingContactsByPAId = contactsDomain.getExistingContactsByPriorAuthId(priorAuthsList);
        existingContact1 = existingContactsByPAId.get(priorAuthsList[0].Id);
        //existingContact2 = existingContactsByPAId.get(priorAuthsList[1].Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('priorAuth.CSA_Number__c = '+priorAuth.CSA_Number__c);
        /*
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE Contact__c =: existingContact2.Id];
        Set<Id> claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        */
        caseList = [SELECT Id, Status, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c FROM Case];
        Set<Id> contactDrugIds = new Set<Id>();
        for(Case caseRec: caseList)
        {
            system.debug('Case records='+caseRec);
            contactDrugIds.add(caseRec.Contact_Drug__c);
            if(caseRec.RecordType.Name == 'Enrollment') {
                system.assertEquals('Outreach Needed',caseRec.HCP_Enrollment_Outreach__c);
                system.assertEquals('Verify Fax Number',caseRec.Status);
            }

        }

        // system.assertequals(false,existingContact1==null, 'No Contacts found');
        //system.assertequals(false,existingContact2==null, 'No Contacts found');
        // List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: priorAuth.CSA_Account__c];
        //List<Contact_Drug__c> contactDrugList1 = [SELECT Id, Prior_Auth__c FROM Contact_Drug__c WHERE Contact__c =:existingContact1.Id ];
        //List<Contact_Drug__c> contactDrugList2 = [SELECT Id, Prior_Auth__c FROM Contact_Drug__c WHERE Contact__c =:existingContact2.Id ];
        //system.assertequals(1,contactDrugList1.size(),'Member has no Contact Drugs');
        //system.assertequals(1,contactDrugList2.size(),'Member has no Contact Drugs');

//        system.assertequals(2,claimList.size());
        //system.assertNotEquals(contactDrugList1[0].Prior_Auth__c,contactDrugList2[0].Prior_Auth__c,'Contact Drug for 2 different members linked to same PA record');
        //for (Claim_Information__c claim: claimList){
        //List<Case> caseList = [SELECT Id FROM Case WHERE Claim_Information__c =: claimList[1].id ];
        //system.assertEquals(2, caseList.size());
        //}

        //system.assertequals(1,contactDrugList.size());

        Test.stopTest();
    }

}
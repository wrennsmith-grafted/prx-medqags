/**
 * Created by ricardy.banks on 4/1/2022.
 */

@IsTest
private class StressTest {

    private static void stressTestSetup() {
        system.debug('stressTestSetup');

        List<Drug__c> testDrugList = new List<Drug__c>();
        List<CSA__c> csaList = new List<CSA__c>();

        system.debug('Setup Accounts');
        Account accountInstance = new Account(
                Name = 'Model Office Test-Integration',
                Medical_Drug_List__c = 'PRUDENTMED',
                Go_Live_Date__c = date.valueOf('2021-11-08')
        );
        insert accountInstance;

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

        system.debug('Setup CSAs');

        Id mockCSAId = fflib_IDGenerator.generate(CSA__c.SObjectType);
        CSA__c csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '711',
                Medical_Drug_List__c = 'PRUDENTMED'
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-' +
                        csaInstance.CSA_Suffix__c + '-' +
                        csaInstance.CSA_Account__c
        );
        //insert csaInstance;
        //System.debug('csaInstance.CSA_Number__c = ' + csaInstance.CSA_Number__c);
        csaList.add(csaInstance);

        System.debug('accountInstance.Id = ' + accountInstance.Id);
        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '757',
                Medical_Drug_List__c = 'PRUDENTMED'
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-' +
                        csaInstance.CSA_Suffix__c + '-' +
                        csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '911',
                Medical_Drug_List__c = 'PRUDENTMED'
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-' +
                        csaInstance.CSA_Suffix__c + '-' +
                        csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = date.valueOf('2021-11-08'),
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '777',
                Medical_Drug_List__c = 'PRUDENTMED'
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-' +
                        csaInstance.CSA_Suffix__c + '-' +
                        csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        insert csaList;
        System.Debug(' csaList[0].CSA_Number__c = ' + csaList[0].CSA_Number__c);
    }

    //Stress Test Historical Claims
    //
    @IsTest
    public static void insert3000HistoricalClaims()
    {
        Integer maxClaims = 10;
        List<Historical_Claim__c> historicalClaimsList = new List<Historical_Claim__c>();

        Test.startTest();
        stressTestSetup();

        // Test Scenario: 'Existing patient taking same Drug' but the member will be created instead of updated
        System.Debug('Test Scenario: \'Existing patient taking same Drug\' but the member will be created instead of updated');
        for(integer i = 0; i < maxClaims; i++) {
            Historical_Claim__c historicalClaims = new Historical_Claim__c();

            historicalClaims.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
            historicalClaims.CSA_Control__c = '865431';
            historicalClaims.CSA_Account__c = '711';
            historicalClaims.CSA_Suffix__c = '15';
            historicalClaims.Relationship_Code__c = 'M';
            //historicalClaims.COB_Indicator__c = 'N';
            historicalClaims.Units_Billed__c = 30;
            historicalClaims.Amount_Paid_By_Primary__c = 7000;
            //historicalClaims.Prior_Authorization__c = 'A126';
            //historicalClaims.Authorized_Representative__c = 'Adam Pawlik';
            //historicalClaims.Authorized_Relationship__c = 'Father';
            historicalClaims.Billing_Provider_City__c = 'Manchester';
            historicalClaims.Billing_Provider_First_Name__c = 'Rebecca L';
            historicalClaims.Billing_Provider_Last_Name__c = 'Allred';
            historicalClaims.Billing_Provider_Specialty__c = '';
            historicalClaims.Billing_Provider_PIN__c = '1417948050';
            historicalClaims.Billing_Provider_State__c = 'MA';
            historicalClaims.Billing_Provider_Address_Line_1__c = '40 Beach Street';
            historicalClaims.Billing_Provider_Zip_Code__c = '01944';
            historicalClaims.Billing_Provider_Phone__c = '9785268288';
            historicalClaims.Billing_Provider_Fax__c = '6178970801';
            historicalClaims.Primary_Claim_Number__c = 'PNFATF4D0';
            //historicalClaims.Claim_Code__c = '';
            historicalClaims.Claim_Line__c = '1';
            //historicalClaims.Claim_Segment__c = '0';
            historicalClaims.COB_Code__c = 'Secondary';
            //historicalClaims.Days_Supply__c = 30;
            historicalClaims.Diagnosis_Code__c = 'C4A30';
            historicalClaims.Drug_Label_Name__c = 'BAVENCIO';
            historicalClaims.HCPCS_Code__c = 'J9023';
            //historicalClaims.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
            historicalClaims.NDC__c = '44087353501';
            //historicalClaims.PA_Approval_Dates__c = date.valueOf('2021-10-01');
            historicalClaims.Patient_Gender__c = 'Female';
            //historicalClaims.Patient_Email_Address__c = 'lara@test.com';

            historicalClaims.Patient_Phone_Number__c = '9179770046';
            historicalClaims.Plan_Sponsor_Name__c = 'TCS';
            historicalClaims.Preferred_Provider__c = 'Y';
            historicalClaims.Date_Of_Service_From__c = date.valueOf('2021-07-10');
            historicalClaims.Service_Provider_Fax__c = '6178970801';
            historicalClaims.Service_Provider_Phone__c = '9785268288';
            historicalClaims.Date_Of_Service_To__c = date.valueOf('2021-07-10');
            historicalClaims.Service_Provider_Address_Line_1__c = '40 Beach Street';
            historicalClaims.Service_Provider_City__c = 'Manchester';
            historicalClaims.Service_Provider_First_Name__c = 'Rebecca L';
            historicalClaims.Service_Provider_Last_Name__c = 'Allred';
            historicalClaims.Service_Provider_NPI__c = '1417948050';
            historicalClaims.Service_Provider_Practice__c = 'NONE';
            historicalClaims.Service_Provider_Zip__c = '01944';
            historicalClaims.Service_Provider_Specialty_Code__c = '';
            historicalClaims.Service_Provider_State__c = 'MA';
            historicalClaims.Patient_Address_Line_1__c = '15858 JODHPUR STREET';
            historicalClaims.Patient_Address_Line_2__c = '';
            historicalClaims.Patient_City__c = 'HOLTSVILLE';
            historicalClaims.Patient_State__c = 'NY';
            historicalClaims.Patient_Zip_Code__c = '00501';
            historicalClaims.Total_Coinsurance__c = 0;
            historicalClaims.Total_Copay__c = 3000;
            historicalClaims.Total_Deductible__c = 0;
            //historicalClaims.Previous_Claim__c = '';
            historicalClaims.Relationship_Code__c = '01';
            //historicalClaims.Claim_Adjustment_Amount__c = null;
            //historicalClaims.Coverage_Code_Indicator__c = null;
            historicalClaims.Place_of_Service__c = '11';
            historicalClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(historicalClaims.CSA_Control__c + '-'
                    + historicalClaims.CSA_Suffix__c + '-'
                    + historicalClaims.CSA_Account__c
            );
            //System.Debug('historicalClaims.CSA_Number__c = '+historicalClaims.CSA_Number__c);

            historicalClaims.Patient_CUMB_ID__c = '185494721'+i;
            historicalClaims.Patient_First_Name__c = 'VALERIA'+i;
            historicalClaims.Patient_Last_Name__c = 'CYPHERT'+i;
            historicalClaims.Patient_Middle_Initial__c = '';
            historicalClaims.Patient_Birth_Date__c = date.valueOf('1967-09-23')+i;

            historicalClaimsList.add(historicalClaims);
        }
        insert historicalClaimsList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: historicalClaims.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByHistoricalClaimId(historicalClaimsList);
        //system.debug('historicalClaims.Id = ' + historicalClaims.Id);
        system.debug('existingContactsByHistoricalClaimId.size() = ' + existingContactsByHistoricalClaimId.size());
        system.debug('existingContactsByHistoricalClaimId = ' + existingContactsByHistoricalClaimId);

        Set<Id> historicalIds = new Set<Id>();
        Set<String> historicalCSAAccounts = new Set<String>();
        Set<Id> existingContactIds = new Set<Id>();
        for(integer i = 0; i < maxClaims; i++) {
            historicalIds.add(historicalClaimsList[i].Id);
            historicalCSAAccounts.add(historicalClaimsList[i].CSA_Account__c);

            Contact existingContact = existingContactsByHistoricalClaimId.get(historicalClaimsList[i].Id);
            existingContactIds.add(existingContact.Id);
            //system.debug('existingContact = ' + existingContact);

            //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
            //system.debug('historicalClaims.CSA_Number__c = '+historicalClaims.CSA_Number__c);
            system.assertequals(false, existingContact == null, 'No Contacts found');
        }
            List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c IN :historicalCSAAccounts];
            List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c IN :existingContactIds];
            system.assertequals(maxClaims,contactDrugList.size());

            system.assertequals(maxClaims,claimList.size());
            system.assertequals(maxClaims,contactDrugList.size());

            List<Case> caseList = [SELECT id FROM Case WHERE Claim_Information__c =: claimList[0].id ];
            system.assertequals(0,caseList.size());


        Test.stopTest();

    }

}
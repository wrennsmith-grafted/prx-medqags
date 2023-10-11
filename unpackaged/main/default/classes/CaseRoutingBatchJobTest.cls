/**
 * Created by ricardy.banks on 5/6/2022.
 */

@IsTest
private class CaseRoutingBatchJobTest {

    private static Implementation__c implementationInstance;
    private static Contract contractInstance;
    private static Account accountInstance;
    private static Datetime mbrFollowupTime;
    private static List<Case> followUpCaseList = new List<Case>();

    private static void caseRoutingTestSetup(Boolean preGoLive, Boolean allowCaseRouting, Boolean allowMBROutreach) {
        system.debug('caseRoutingTestSetup');

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
                //Implementation__c = implementationInstance.Id,
                Medical_Drug_List__c = 'PRUDENTMED'
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

        //accountInstance.Implementation__c = implementationInstance.Id;
        //update accountInstance;

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
                Go_Live_Date__c = goLiveDate,
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '711',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
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
                Go_Live_Date__c = goLiveDate,
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '757',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-' +
                        csaInstance.CSA_Suffix__c + '-' +
                        csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        csaInstance = new CSA__c(
                Account__c = accountInstance.Id,
                Go_Live_Date__c = goLiveDate,
                CSA_Control__c = '865431',
                CSA_Suffix__c = '15',
                CSA_Account__c = '911',
                Medical_Drug_List__c = 'PRUDENTMED',
                Implementation__c = implementationInstance.Id
        );
        csaInstance.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(
                csaInstance.CSA_Control__c + '-' +
                        csaInstance.CSA_Suffix__c + '-' +
                        csaInstance.CSA_Account__c
        );
        csaList.add(csaInstance);

        csaInstance = new CSA__c(
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
        System.Debug(' csaList[0].CSA_Number__c = ' + csaList[0].CSA_Number__c);
    }

    @IsTest
    public static void preGoLiveTest()
    {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveFaxValidation, postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLiveReimbursementFollowUp;

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLiveReimbursementFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Fax_Validation' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLiveFaxValidation = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseRoutingTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);

        // Test Scenario: Insert 2 DCs
        // Original Claim will create the Enrollment case
        System.Debug('Test Scenario: Insert 2 DCs');
        List<Daily_Claim__c> dailyClaimList = new List<Daily_Claim__c>();
        Daily_Claim__c dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 7000;
        //dailyClaim.Prior_Authorization__c = 'A126';
        dailyClaim.Authorized_Representative__c = 'Adam Pawlik';
        dailyClaim.Authorized_Relationship__c = 'Father';
        dailyClaim.Billing_Provider_City__c = 'Manchester';
        dailyClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Billing_Provider_Last_Name__c = 'Allred';
        dailyClaim.Billing_Provider_Specialty__c = '';
        dailyClaim.Billing_Provider_PIN__c = '1417948050';
        dailyClaim.Billing_Provider_State__c = 'MA';
        dailyClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Billing_Provider_Zip_Code__c = '01944';
        dailyClaim.Billing_Provider_Phone__c = '9785268288';
        dailyClaim.Billing_Provider_Fax__c = '6178970801';
        dailyClaim.Primary_Claim_Number__c = 'P2JKS27W5';
        dailyClaim.Claim_Code__c = 'O';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.Claim_Segment__c = '0';
        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.NDC__c = '44087353501';
        //dailyClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaim.Patient_First_Name__c = 'KHALIAH';
        dailyClaim.Patient_Last_Name__c = 'HINGSTON';
        dailyClaim.Patient_Middle_Initial__c = '';
        dailyClaim.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        dailyClaim.Patient_Gender__c = 'M';
        //dailyClaim.Patient_Email_Address__c = 'lara@test.com';

        dailyClaim.Patient_Phone_Number__c = '5083161245';
        dailyClaim.Plan_Sponsor_Name__c = 'TCS';
        dailyClaim.Preferred_Provider__c = 'Y';
        dailyClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Fax__c = '6178970801';
        dailyClaim.Service_Provider_Phone__c = '9785268288';
        dailyClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Service_Provider_City__c = 'Manchester';
        dailyClaim.Service_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Service_Provider_Last_Name__c = 'Allred';
        dailyClaim.Service_Provider_NPI__c = '1417948050';
        //dailyClaim.Service_Provider_Practice__c = 'NONE';
        dailyClaim.Service_Provider_Zip__c = '01944';
        dailyClaim.Service_Provider_Specialty_Code__c = '';
        dailyClaim.Service_Provider_State__c = 'NY';
        dailyClaim.Patient_Address_Line_1__c = '39276 HACE STREET';
        dailyClaim.Patient_Address_Line_2__c = '';
        dailyClaim.Patient_City__c = 'HOLTSVILLE';
        dailyClaim.Patient_State__c = 'NY';
        dailyClaim.Patient_Zip_Code__c = '00501';
        dailyClaim.Total_Coinsurance__c = 0;
        dailyClaim.Total_Copay__c = 3000;
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        for(Claim_Information__c claimRecord: claimList) {
            claimRecord.CPA_Indicator__c = 'Opt-in - Paid in full';
            claimRecord.CPA_Funds_Paid__c = 1000;
        }
        update claimList;
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        List<Case> caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        System.debug('Start Routing Cases');
        DateTime currentDateTime = DateTime.now();
        //currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        mbrFollowupTime = currentDateTime;
        //implementationInstance.Allow_MBR_Outreach__c = False;
        //update implementationInstance;
        //PostGoLive
        //Case.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = false
        //Case Status != Verify Fax Number
        //Follow_up_Time__c = null
        Integer iaddhours = 0;
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(postGoLiveFaxValidation, caseRecord.OwnerId);
            if(caseRecord.Type == 'Reimbursement')
                system.assertEquals(postGoLiveFaxValidation, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = preGoLiveFaxValidation;
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = False;
            caseRecord.Follow_up_Time__c = null;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        Test.startTest();
        // Route Existing Cases
        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);
        followUpCaseList = new List<Case>();

        Id enrollment_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
            Id reimbursement_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
            

        //Case.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = false
        //Case Status = Verify Fax Number
        iaddhours = 0;
        for(Case caseRecord: caseList) {
            iaddhours = iaddhours + 1;
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(postGoLiveFaxValidation, caseRecord.OwnerId);
            if(caseRecord.Type == 'Reimbursement')
                system.assertEquals(postGoLiveFaxValidation, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            caseRecord.HCP_Enrollment_Outreach__c = 'Outreach Complete';
            caseRecord.Follow_up_Time__c = System.now().addhours(-iaddhours);
            if(caseRecord.RecordTypeId == enrollment_RecordTypeId){
                caseRecord.Enrollment_Case_Close_Reason__c = 'CPA obtained';
            }else if(caseRecord.RecordTypeId == reimbursement_RecordTypeId){
                caseRecord.Reimbursement_Case_Close_Reason__c = 'No CPA available';
            }

            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        // Route Existing Cases
        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);
        followUpCaseList = new List<Case>();

        //Case.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = false
        //Case Status != Verify Fax Number
        iaddhours = 0;
        for(Case caseRecord: caseList) {
            iaddhours = iaddhours + 1;
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(postGoLiveFaxValidation, caseRecord.OwnerId);
            if(caseRecord.Type == 'Reimbursement')
                system.assertEquals(postGoLiveFaxValidation, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Follow_up_Time__c = System.now().addhours(-iaddhours);
            caseRecord.Status = 'Verify Fax Number';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        // Route Existing Cases
        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);
        followUpCaseList = new List<Case>();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        //Case.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = false
        //Case Status = Verify Fax Number
        iaddhours = 0;
        for(Case caseRecord: caseList) {
            iaddhours = iaddhours + 1;
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(postGoLiveFaxValidation, caseRecord.OwnerId);
            if(caseRecord.Type == 'Reimbursement')
                system.assertEquals(postGoLiveFaxValidation, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            caseRecord.HCP_Enrollment_Outreach__c = 'Outreach Complete';
            caseRecord.Follow_up_Time__c = System.now().addhours(-iaddhours);
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //implementationInstance.Allow_MBR_Outreach__c = True;
        //update implementationInstance;

        // Route Existing Cases
        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);
        followUpCaseList = new List<Case>();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        //Case.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(postGoLiveNewEnrollment, caseRecord.OwnerId);
            if(caseRecord.Type == 'Reimbursement')
                system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.HCP_Enrollment_Outreach__c = 'Fax Received';
            caseRecord.Status = 'Outreach Completed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        // Route Existing Cases
        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);
        followUpCaseList = new List<Case>();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        //Case.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True
        //Case Status = Verify Fax Number
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId);
            if(caseRecord.Type == 'Reimbursement')
                system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Outreach Completed';
            followUpCaseList.add(caseRecord);
        }

        CaseRoutingJob CaseRouting = new CaseRoutingJob();
        Database.executeBatch(CaseRouting,1);
        Test.stopTest();

    }

    @IsTest
    public static void postGoLiveTest()
    {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLivReimbursementFollowUp;

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLivReimbursementFollowUp = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = False;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseRoutingTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);


        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: Insert 2 DCs');
        List<Daily_Claim__c> dailyClaimList = new List<Daily_Claim__c>();
        Daily_Claim__c dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 7000;
        //dailyClaim.Prior_Authorization__c = 'A126';
        dailyClaim.Authorized_Representative__c = 'Adam Pawlik';
        dailyClaim.Authorized_Relationship__c = 'Father';
        dailyClaim.Billing_Provider_City__c = 'Manchester';
        dailyClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Billing_Provider_Last_Name__c = 'Allred';
        dailyClaim.Billing_Provider_Specialty__c = '';
        dailyClaim.Billing_Provider_PIN__c = '1417948050';
        dailyClaim.Billing_Provider_State__c = 'MA';
        dailyClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Billing_Provider_Zip_Code__c = '01944';
        dailyClaim.Billing_Provider_Phone__c = '9785268288';
        dailyClaim.Billing_Provider_Fax__c = '6178970801';
        dailyClaim.Primary_Claim_Number__c = 'P2JKS27W5';
        dailyClaim.Claim_Code__c = 'O';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.Claim_Segment__c = '0';
        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.NDC__c = '44087353501';
        //dailyClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaim.Patient_First_Name__c = 'KHALIAH';
        dailyClaim.Patient_Last_Name__c = 'HINGSTON';
        dailyClaim.Patient_Middle_Initial__c = '';
        dailyClaim.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        dailyClaim.Patient_Gender__c = 'M';
        //dailyClaim.Patient_Email_Address__c = 'lara@test.com';

        dailyClaim.Patient_Phone_Number__c = '5083161245';
        dailyClaim.Plan_Sponsor_Name__c = 'TCS';
        dailyClaim.Preferred_Provider__c = 'Y';
        dailyClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Fax__c = '6178970801';
        dailyClaim.Service_Provider_Phone__c = '9785268288';
        dailyClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Service_Provider_City__c = 'Manchester';
        dailyClaim.Service_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Service_Provider_Last_Name__c = 'Allred';
        dailyClaim.Service_Provider_NPI__c = '1417948050';
        //dailyClaim.Service_Provider_Practice__c = 'NONE';
        dailyClaim.Service_Provider_Zip__c = '01944';
        dailyClaim.Service_Provider_Specialty_Code__c = '';
        dailyClaim.Service_Provider_State__c = 'NY';
        dailyClaim.Patient_Address_Line_1__c = '39276 HACE STREET';
        dailyClaim.Patient_Address_Line_2__c = '';
        dailyClaim.Patient_City__c = 'HOLTSVILLE';
        dailyClaim.Patient_State__c = 'NY';
        dailyClaim.Patient_Zip_Code__c = '00501';
        dailyClaim.Total_Coinsurance__c = 0;
        dailyClaim.Total_Copay__c = 3000;
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        for(Claim_Information__c claimRecord: claimList) {
            claimRecord.CPA_Indicator__c = 'Opt-in - Paid in full';
            claimRecord.CPA_Funds_Paid__c = 1000;
        }
        update claimList;
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        List<Case> caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        System.debug('Start Routing Cases');
        DateTime currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        Datetime mbrFollowupTime = null;
        List<Case> followUpCaseList = new List<Case>();
        //Case Status != Verify Fax Number
        //mbrFollowupTime = null
        for(Case caseRecord: caseList) {
            system.assertEquals(generalQueue, caseRecord.OwnerId);
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Verify Fax Number';
            caseRecord.Follow_up_Time__c = null;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        mbrFollowupTime = currentDateTime;
        followUpCaseList = new List<Case>();
        //Case Status == Verify Fax Number
        for(Case caseRecord: caseList) {
            system.assertEquals(generalQueue, caseRecord.OwnerId);
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Verify Fax Number';
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(preGoLiveFaxValidation, caseRecord.OwnerId);
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = preGoLiveFaxValidation;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '1st Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        Test.startTest();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId);
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '1st Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //implementationInstance.Allow_MBR_Outreach__c = True;
        //update implementationInstance;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(preGoLiveEnrollmentFollowUp, caseRecord.OwnerId);
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = preGoLiveEnrollmentFollowUp;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = 'Outreach Completed';
            caseRecord.HCP_Enrollment_Outreach__c = 'Outreach Complete';

            Id enrollment_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
            Id reimbursement_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
            if(caseRecord.RecordTypeId == enrollment_RecordTypeId){
                caseRecord.Enrollment_Case_Close_Reason__c = 'CPA obtained';
            }else if(caseRecord.RecordTypeId == reimbursement_RecordTypeId){
                caseRecord.Reimbursement_Case_Close_Reason__c = 'No CPA available';
            }


            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(2, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId);
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Outreach Completed';
            //followUpCaseList.add(caseRecord);
        }
        //update followUpCaseList;

        CaseRoutingJob CaseRouting = new CaseRoutingJob();
        Database.executeBatch(CaseRouting,1);
        Test.stopTest();

    }

    @IsTest
    public static void preGoLive2ndAttemptNeededTest()
    {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLivReimbursementFollowUp;

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLivReimbursementFollowUp = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = True;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseRoutingTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);


        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: Insert 2 DCs');
        List<Daily_Claim__c> dailyClaimList = new List<Daily_Claim__c>();
        Daily_Claim__c dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 7000;
        //dailyClaim.Prior_Authorization__c = 'A126';
        dailyClaim.Authorized_Representative__c = 'Adam Pawlik';
        dailyClaim.Authorized_Relationship__c = 'Father';
        dailyClaim.Billing_Provider_City__c = 'Manchester';
        dailyClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Billing_Provider_Last_Name__c = 'Allred';
        dailyClaim.Billing_Provider_Specialty__c = '';
        dailyClaim.Billing_Provider_PIN__c = '1417948050';
        dailyClaim.Billing_Provider_State__c = 'MA';
        dailyClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Billing_Provider_Zip_Code__c = '01944';
        dailyClaim.Billing_Provider_Phone__c = '9785268288';
        dailyClaim.Billing_Provider_Fax__c = '6178970801';
        dailyClaim.Primary_Claim_Number__c = 'P2JKS27W5';
        dailyClaim.Claim_Code__c = 'O';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.Claim_Segment__c = '0';
        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.NDC__c = '44087353501';
        //dailyClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaim.Patient_First_Name__c = 'KHALIAH';
        dailyClaim.Patient_Last_Name__c = 'HINGSTON';
        dailyClaim.Patient_Middle_Initial__c = '';
        dailyClaim.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        dailyClaim.Patient_Gender__c = 'M';
        //dailyClaim.Patient_Email_Address__c = 'lara@test.com';

        dailyClaim.Patient_Phone_Number__c = '5083161245';
        dailyClaim.Plan_Sponsor_Name__c = 'TCS';
        dailyClaim.Preferred_Provider__c = 'Y';
        dailyClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Fax__c = '6178970801';
        dailyClaim.Service_Provider_Phone__c = '9785268288';
        dailyClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Service_Provider_City__c = 'Manchester';
        dailyClaim.Service_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Service_Provider_Last_Name__c = 'Allred';
        dailyClaim.Service_Provider_NPI__c = '1417948050';
        //dailyClaim.Service_Provider_Practice__c = 'NONE';
        dailyClaim.Service_Provider_Zip__c = '01944';
        dailyClaim.Service_Provider_Specialty_Code__c = '';
        dailyClaim.Service_Provider_State__c = 'NY';
        dailyClaim.Patient_Address_Line_1__c = '39276 HACE STREET';
        dailyClaim.Patient_Address_Line_2__c = '';
        dailyClaim.Patient_City__c = 'HOLTSVILLE';
        dailyClaim.Patient_State__c = 'NY';
        dailyClaim.Patient_Zip_Code__c = '00501';
        dailyClaim.Total_Coinsurance__c = 0;
        dailyClaim.Total_Copay__c = 3000;
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        List<Case> caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        System.debug('Start Routing Cases');
        DateTime currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        Datetime mbrFollowupTime = null;
        List<Case> followUpCaseList = new List<Case>();
        //Case Status != Verify Fax Number
        //mbrFollowupTime = null
        for(Case caseRecord: caseList) {
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = 'Verify Fax Number';
            caseRecord.Follow_up_Time__c = null;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        mbrFollowupTime = currentDateTime;
        followUpCaseList = new List<Case>();
        //Case Status == Verify Fax Number
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Verify Fax Number';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(preGoLiveFaxValidation, caseRecord.OwnerId, 'Case should be routed to preGoLiveFaxValidation queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = '2nd Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        Test.startTest();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '2nd Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = True;
        //update accountInstance;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement') {
                System.debug('caseRecord.OwnerId = preGoLiveEnrollmentFollowUp');
                system.assertEquals(preGoLiveEnrollmentFollowUp, caseRecord.OwnerId, 'Case should be routed to preGoLiveEnrollmentFollowUp queue');
            }
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            caseRecord.HCP_Enrollment_Outreach__c = 'Outreach Complete';

            Id enrollment_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
            Id reimbursement_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
            if(caseRecord.RecordTypeId == enrollment_RecordTypeId){
                caseRecord.Enrollment_Case_Close_Reason__c = 'CPA obtained';
            }
            //else if(caseRecord.RecordTypeId == reimbursement_RecordTypeId){
            //    caseRecord.Reimbursement_Case_Close_Reason__c = 'No CPA available';
            //}

            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = False;
            caseRecord.Status = '2nd Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = False;
        //update accountInstance;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Outreach Completed';
            //followUpCaseList.add(caseRecord);
        }
        //update followUpCaseList;

        CaseRoutingJob CaseRouting = new CaseRoutingJob();
        Database.executeBatch(CaseRouting,1);
        Test.stopTest();

    }

    @IsTest
    public static void preGoLive3rdAttemptNeededTest()
    {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLivReimbursementFollowUp;

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLivReimbursementFollowUp = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = True;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseRoutingTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);


        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: Insert 2 DCs');
        List<Daily_Claim__c> dailyClaimList = new List<Daily_Claim__c>();
        Daily_Claim__c dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 7000;
        //dailyClaim.Prior_Authorization__c = 'A126';
        dailyClaim.Authorized_Representative__c = 'Adam Pawlik';
        dailyClaim.Authorized_Relationship__c = 'Father';
        dailyClaim.Billing_Provider_City__c = 'Manchester';
        dailyClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Billing_Provider_Last_Name__c = 'Allred';
        dailyClaim.Billing_Provider_Specialty__c = '';
        dailyClaim.Billing_Provider_PIN__c = '1417948050';
        dailyClaim.Billing_Provider_State__c = 'MA';
        dailyClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Billing_Provider_Zip_Code__c = '01944';
        dailyClaim.Billing_Provider_Phone__c = '9785268288';
        dailyClaim.Billing_Provider_Fax__c = '6178970801';
        dailyClaim.Primary_Claim_Number__c = 'P2JKS27W5';
        dailyClaim.Claim_Code__c = 'O';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.Claim_Segment__c = '0';
        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.NDC__c = '44087353501';
        //dailyClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaim.Patient_First_Name__c = 'KHALIAH';
        dailyClaim.Patient_Last_Name__c = 'HINGSTON';
        dailyClaim.Patient_Middle_Initial__c = '';
        dailyClaim.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        dailyClaim.Patient_Gender__c = 'M';
        //dailyClaim.Patient_Email_Address__c = 'lara@test.com';

        dailyClaim.Patient_Phone_Number__c = '5083161245';
        dailyClaim.Plan_Sponsor_Name__c = 'TCS';
        dailyClaim.Preferred_Provider__c = 'Y';
        dailyClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Fax__c = '6178970801';
        dailyClaim.Service_Provider_Phone__c = '9785268288';
        dailyClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Service_Provider_City__c = 'Manchester';
        dailyClaim.Service_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Service_Provider_Last_Name__c = 'Allred';
        dailyClaim.Service_Provider_NPI__c = '1417948050';
        //dailyClaim.Service_Provider_Practice__c = 'NONE';
        dailyClaim.Service_Provider_Zip__c = '01944';
        dailyClaim.Service_Provider_Specialty_Code__c = '';
        dailyClaim.Service_Provider_State__c = 'NY';
        dailyClaim.Patient_Address_Line_1__c = '39276 HACE STREET';
        dailyClaim.Patient_Address_Line_2__c = '';
        dailyClaim.Patient_City__c = 'HOLTSVILLE';
        dailyClaim.Patient_State__c = 'NY';
        dailyClaim.Patient_Zip_Code__c = '00501';
        dailyClaim.Total_Coinsurance__c = 0;
        dailyClaim.Total_Copay__c = 3000;
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        List<Case> caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        System.debug('Start Routing Cases');
        DateTime currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        Datetime mbrFollowupTime = null;
        List<Case> followUpCaseList = new List<Case>();
        //Case Status != Verify Fax Number
        //mbrFollowupTime = null
        for(Case caseRecord: caseList) {
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = 'Verify Fax Number';
            caseRecord.Follow_up_Time__c = null;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        mbrFollowupTime = currentDateTime;
        followUpCaseList = new List<Case>();
        //Case Status == Verify Fax Number
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Verify Fax Number';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(preGoLiveFaxValidation, caseRecord.OwnerId, 'Case should be routed to preGoLiveFaxValidation queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = '3rd Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        Test.startTest();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '3rd Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = True;
        //update accountInstance;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        
        Id enrollment_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
        Id reimbursement_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
            
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement') {
                System.debug('caseRecord.OwnerId = preGoLiveEnrollmentFollowUp');
                system.assertEquals(preGoLiveEnrollmentFollowUp, caseRecord.OwnerId, 'Case should be routed to preGoLiveEnrollmentFollowUp queue');
            }
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            caseRecord.HCP_Enrollment_Outreach__c = 'Outreach Complete';
            
            if(caseRecord.RecordTypeId == enrollment_RecordTypeId){
                caseRecord.Enrollment_Case_Close_Reason__c = 'CPA obtained';
            }

            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = False;
            caseRecord.Status = '3rd Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = False;
        //update accountInstance;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Outreach Completed';
            //followUpCaseList.add(caseRecord);
        }
        //update followUpCaseList;

        CaseRoutingJob CaseRouting = new CaseRoutingJob();
        Database.executeBatch(CaseRouting,1);
        Test.stopTest();

    }

    @IsTest
    public static void preGoLive4thAttemptNeededTest()
    {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLivReimbursementFollowUp;

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLivReimbursementFollowUp = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = True;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseRoutingTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);


        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: Insert 2 DCs');
        List<Daily_Claim__c> dailyClaimList = new List<Daily_Claim__c>();
        Daily_Claim__c dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 7000;
        //dailyClaim.Prior_Authorization__c = 'A126';
        dailyClaim.Authorized_Representative__c = 'Adam Pawlik';
        dailyClaim.Authorized_Relationship__c = 'Father';
        dailyClaim.Billing_Provider_City__c = 'Manchester';
        dailyClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Billing_Provider_Last_Name__c = 'Allred';
        dailyClaim.Billing_Provider_Specialty__c = '';
        dailyClaim.Billing_Provider_PIN__c = '1417948050';
        dailyClaim.Billing_Provider_State__c = 'MA';
        dailyClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Billing_Provider_Zip_Code__c = '01944';
        dailyClaim.Billing_Provider_Phone__c = '9785268288';
        dailyClaim.Billing_Provider_Fax__c = '6178970801';
        dailyClaim.Primary_Claim_Number__c = 'P2JKS27W5';
        dailyClaim.Claim_Code__c = 'O';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.Claim_Segment__c = '0';
        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.NDC__c = '44087353501';
        //dailyClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaim.Patient_First_Name__c = 'KHALIAH';
        dailyClaim.Patient_Last_Name__c = 'HINGSTON';
        dailyClaim.Patient_Middle_Initial__c = '';
        dailyClaim.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        dailyClaim.Patient_Gender__c = 'M';
        //dailyClaim.Patient_Email_Address__c = 'lara@test.com';

        dailyClaim.Patient_Phone_Number__c = '5083161245';
        dailyClaim.Plan_Sponsor_Name__c = 'TCS';
        dailyClaim.Preferred_Provider__c = 'Y';
        dailyClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Fax__c = '6178970801';
        dailyClaim.Service_Provider_Phone__c = '9785268288';
        dailyClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Service_Provider_City__c = 'Manchester';
        dailyClaim.Service_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Service_Provider_Last_Name__c = 'Allred';
        dailyClaim.Service_Provider_NPI__c = '1417948050';
        //dailyClaim.Service_Provider_Practice__c = 'NONE';
        dailyClaim.Service_Provider_Zip__c = '01944';
        dailyClaim.Service_Provider_Specialty_Code__c = '';
        dailyClaim.Service_Provider_State__c = 'NY';
        dailyClaim.Patient_Address_Line_1__c = '39276 HACE STREET';
        dailyClaim.Patient_Address_Line_2__c = '';
        dailyClaim.Patient_City__c = 'HOLTSVILLE';
        dailyClaim.Patient_State__c = 'NY';
        dailyClaim.Patient_Zip_Code__c = '00501';
        dailyClaim.Total_Coinsurance__c = 0;
        dailyClaim.Total_Copay__c = 3000;
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        List<Case> caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        System.debug('Start Routing Cases');
        DateTime currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        Datetime mbrFollowupTime = null;
        List<Case> followUpCaseList = new List<Case>();
        //Case Status != Verify Fax Number
        //mbrFollowupTime = null
        for(Case caseRecord: caseList) {
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = 'Verify Fax Number';
            caseRecord.Follow_up_Time__c = null;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        mbrFollowupTime = currentDateTime;
        followUpCaseList = new List<Case>();
        //Case Status == Verify Fax Number
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Verify Fax Number';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(preGoLiveFaxValidation, caseRecord.OwnerId, 'Case should be routed to preGoLiveFaxValidation queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = '4th Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        Test.startTest();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        
        Id enrollment_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
            Id reimbursement_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
            
        
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '4th Attempt Needed';

            if(caseRecord.RecordTypeId == enrollment_RecordTypeId){
                caseRecord.Enrollment_Case_Close_Reason__c = 'CPA obtained';
            }

            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = True;
        //update accountInstance;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement') {
                System.debug('caseRecord.OwnerId = preGoLiveEnrollmentFollowUp');
                system.assertEquals(preGoLiveEnrollmentFollowUp, caseRecord.OwnerId, 'Case should be routed to preGoLiveEnrollmentFollowUp queue');
            }
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            caseRecord.HCP_Enrollment_Outreach__c = 'Outreach Complete';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = False;
            caseRecord.Status = '4th Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = False;
        //update accountInstance;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Outreach Completed';
            //followUpCaseList.add(caseRecord);
        }
        //update followUpCaseList;

        CaseRoutingJob CaseRouting = new CaseRoutingJob();
        Database.executeBatch(CaseRouting,1);
        Test.stopTest();

    }

    @IsTest
    public static void preGoLive5thAttemptNeededTest()
    {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLivReimbursementFollowUp;

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLivReimbursementFollowUp = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = True;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseRoutingTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);


        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: Insert 2 DCs');
        List<Daily_Claim__c> dailyClaimList = new List<Daily_Claim__c>();
        Daily_Claim__c dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 7000;
        //dailyClaim.Prior_Authorization__c = 'A126';
        dailyClaim.Authorized_Representative__c = 'Adam Pawlik';
        dailyClaim.Authorized_Relationship__c = 'Father';
        dailyClaim.Billing_Provider_City__c = 'Manchester';
        dailyClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Billing_Provider_Last_Name__c = 'Allred';
        dailyClaim.Billing_Provider_Specialty__c = '';
        dailyClaim.Billing_Provider_PIN__c = '1417948050';
        dailyClaim.Billing_Provider_State__c = 'MA';
        dailyClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Billing_Provider_Zip_Code__c = '01944';
        dailyClaim.Billing_Provider_Phone__c = '9785268288';
        dailyClaim.Billing_Provider_Fax__c = '6178970801';
        dailyClaim.Primary_Claim_Number__c = 'P2JKS27W5';
        dailyClaim.Claim_Code__c = 'O';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.Claim_Segment__c = '0';
        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.NDC__c = '44087353501';
        //dailyClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaim.Patient_First_Name__c = 'KHALIAH';
        dailyClaim.Patient_Last_Name__c = 'HINGSTON';
        dailyClaim.Patient_Middle_Initial__c = '';
        dailyClaim.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        dailyClaim.Patient_Gender__c = 'M';
        //dailyClaim.Patient_Email_Address__c = 'lara@test.com';

        dailyClaim.Patient_Phone_Number__c = '5083161245';
        dailyClaim.Plan_Sponsor_Name__c = 'TCS';
        dailyClaim.Preferred_Provider__c = 'Y';
        dailyClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Fax__c = '6178970801';
        dailyClaim.Service_Provider_Phone__c = '9785268288';
        dailyClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Service_Provider_City__c = 'Manchester';
        dailyClaim.Service_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Service_Provider_Last_Name__c = 'Allred';
        dailyClaim.Service_Provider_NPI__c = '1417948050';
        //dailyClaim.Service_Provider_Practice__c = 'NONE';
        dailyClaim.Service_Provider_Zip__c = '01944';
        dailyClaim.Service_Provider_Specialty_Code__c = '';
        dailyClaim.Service_Provider_State__c = 'NY';
        dailyClaim.Patient_Address_Line_1__c = '39276 HACE STREET';
        dailyClaim.Patient_Address_Line_2__c = '';
        dailyClaim.Patient_City__c = 'HOLTSVILLE';
        dailyClaim.Patient_State__c = 'NY';
        dailyClaim.Patient_Zip_Code__c = '00501';
        dailyClaim.Total_Coinsurance__c = 0;
        dailyClaim.Total_Copay__c = 3000;
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        List<Contact> contactList = new List<Contact>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        List<Case> caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        System.debug('Start Routing Cases');
        DateTime currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        Datetime mbrFollowupTime = null;
        List<Case> followUpCaseList = new List<Case>();
        //Case Status != Verify Fax Number
        //mbrFollowupTime = null
        for(Case caseRecord: caseList) {
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = 'Verify Fax Number';
            caseRecord.Follow_up_Time__c = null;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        mbrFollowupTime = currentDateTime;
        followUpCaseList = new List<Case>();
        //Case Status == Verify Fax Number
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Verify Fax Number';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(preGoLiveFaxValidation, caseRecord.OwnerId, 'Case should be routed to preGoLiveFaxValidation queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = '5th Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        Test.startTest();

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '5th Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = True;
        //update accountInstance;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);


        Id enrollment_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
            Id reimbursement_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
            

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement') {
                System.debug('caseRecord.OwnerId = preGoLiveEnrollmentFollowUp');
                system.assertEquals(preGoLiveEnrollmentFollowUp, caseRecord.OwnerId, 'Case should be routed to preGoLiveEnrollmentFollowUp queue');
            }
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            caseRecord.HCP_Enrollment_Outreach__c = 'Outreach Complete';

            if(caseRecord.RecordTypeId == enrollment_RecordTypeId){
                caseRecord.Enrollment_Case_Close_Reason__c = 'CPA obtained';
            }

            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = False;
            caseRecord.Status = '5th Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = False;
        //update accountInstance;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Outreach Completed';
            //followUpCaseList.add(caseRecord);
        }
        //update followUpCaseList;

        CaseRoutingJob CaseRouting = new CaseRoutingJob();
        Database.executeBatch(CaseRouting,1);
        Test.stopTest();

    }


    @IsTest
    public static void preGoLiveTransferToHealthPlanTest()
    {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLivReimbursementFollowUp;

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLivReimbursementFollowUp = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = True;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseRoutingTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);


        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: Insert 2 DCs');
        List<Daily_Claim__c> dailyClaimList = new List<Daily_Claim__c>();
        Daily_Claim__c dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 7000;
        //dailyClaim.Prior_Authorization__c = 'A126';
        dailyClaim.Authorized_Representative__c = 'Adam Pawlik';
        dailyClaim.Authorized_Relationship__c = 'Father';
        dailyClaim.Billing_Provider_City__c = 'Manchester';
        dailyClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Billing_Provider_Last_Name__c = 'Allred';
        dailyClaim.Billing_Provider_Specialty__c = '';
        dailyClaim.Billing_Provider_PIN__c = '1417948050';
        dailyClaim.Billing_Provider_State__c = 'MA';
        dailyClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Billing_Provider_Zip_Code__c = '01944';
        dailyClaim.Billing_Provider_Phone__c = '9785268288';
        dailyClaim.Billing_Provider_Fax__c = '6178970801';
        dailyClaim.Primary_Claim_Number__c = 'P2JKS27W5';
        dailyClaim.Claim_Code__c = 'O';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.Claim_Segment__c = '0';
        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.NDC__c = '44087353501';
        //dailyClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaim.Patient_First_Name__c = 'KHALIAH';
        dailyClaim.Patient_Last_Name__c = 'HINGSTON';
        dailyClaim.Patient_Middle_Initial__c = '';
        dailyClaim.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        dailyClaim.Patient_Gender__c = 'M';
        //dailyClaim.Patient_Email_Address__c = 'lara@test.com';

        dailyClaim.Patient_Phone_Number__c = '5083161245';
        dailyClaim.Plan_Sponsor_Name__c = 'TCS';
        dailyClaim.Preferred_Provider__c = 'Y';
        dailyClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Fax__c = '6178970801';
        dailyClaim.Service_Provider_Phone__c = '9785268288';
        dailyClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Service_Provider_City__c = 'Manchester';
        dailyClaim.Service_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Service_Provider_Last_Name__c = 'Allred';
        dailyClaim.Service_Provider_NPI__c = '1417948050';
        //dailyClaim.Service_Provider_Practice__c = 'NONE';
        dailyClaim.Service_Provider_Zip__c = '01944';
        dailyClaim.Service_Provider_Specialty_Code__c = '';
        dailyClaim.Service_Provider_State__c = 'NY';
        dailyClaim.Patient_Address_Line_1__c = '39276 HACE STREET';
        dailyClaim.Patient_Address_Line_2__c = '';
        dailyClaim.Patient_City__c = 'HOLTSVILLE';
        dailyClaim.Patient_State__c = 'NY';
        dailyClaim.Patient_Zip_Code__c = '00501';
        dailyClaim.Total_Coinsurance__c = 0;
        dailyClaim.Total_Copay__c = 3000;
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        List<Contact> contactList = new List<Contact>();
        List<Case> caseList = new List<Case>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        //system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        system.assertEquals(1, caseList.size());

        System.debug('Start Routing Cases');
        DateTime currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        Datetime mbrFollowupTime = null;
        List<Case> followUpCaseList = new List<Case>();
        //Case Status != Verify Fax Number
        //mbrFollowupTime = null
        for(Case caseRecord: caseList) {
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = 'Transfer to Health Plan';
            caseRecord.Follow_up_Time__c = null;
            caseRecord.Outreach_Type__c = 'Both';
            caseRecord.Outreach_Comments__c = 'Outreach_Comments__c';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        mbrFollowupTime = currentDateTime;
        followUpCaseList = new List<Case>();
        //Case Status == Verify Fax Number
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Verify Fax Number';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
        //        Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
        //        Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(preGoLiveFaxValidation, caseRecord.OwnerId, 'Case should be routed to preGoLiveFaxValidation queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = '2nd Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        Test.startTest();

        //caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
        //        Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
        //        Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = True;
            caseRecord.Status = '2nd Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = True;
        //update accountInstance;

        //caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
        //        Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
        //        Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement') {
                System.debug('caseRecord.OwnerId = preGoLiveEnrollmentFollowUp');
                system.assertEquals(preGoLiveEnrollmentFollowUp, caseRecord.OwnerId, 'Case should be routed to preGoLiveEnrollmentFollowUp queue');
            }
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            caseRecord.HCP_Enrollment_Outreach__c = 'Outreach Complete';
            
            Id enrollment_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
            Id reimbursement_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reimbursement').getRecordTypeId();
            if(caseRecord.RecordTypeId == enrollment_RecordTypeId){
                caseRecord.Enrollment_Case_Close_Reason__c = 'CPA obtained';
            }//else if(caseRecord.RecordTypeId == reimbursement_RecordTypeId){
                //caseRecord.Reimbursement_Case_Close_Reason__c = 'No CPA available';
            //}

            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
        //        Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
        //        Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            System.debug('caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = ' + caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c);
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            caseRecord.OwnerId = generalQueue;
            caseRecord.Follow_up_Time__c = mbrFollowupTime;
            if(preGoLive) {
                goLiveDate = date.today().addDays(60);
            } else {
                goLiveDate = date.today().addDays(-60);
            }
            caseRecord.Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c = goLiveDate;
            //caseRecord.Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c = False;
            caseRecord.Status = '2nd Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //accountInstance.Allow_MBR_Outreach__c = False;
        //update accountInstance;

        //caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
        //        Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
        //        Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = 'Outreach Completed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
        //        Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
        //        Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(caseList);

        followUpCaseList = new List<Case>();
        //Case Status = Outreach Completed
        for(Case caseRecord: caseList) {
            if(caseRecord.Type == 'Enrollement')
                system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(generalQueue, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            //caseRecord.Status = 'Outreach Completed';
            //followUpCaseList.add(caseRecord);
        }
        //update followUpCaseList;

        CaseRoutingJob CaseRouting = new CaseRoutingJob();
        Database.executeBatch(CaseRouting,1);
        Test.stopTest();

    }

    @IsTest
    public static void caseRoutingBatchTest() {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue;

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                switch on queue {
                    when 'General' { // when queue is General
                        generalQueue = GroupId;
                    }
                }
            }
        }

        CasesSelector casesSelector = (CasesSelector) PMd_Application.Selector.newInstance(Case.SObjectType);
        // Obtain appropriate query locator from the selector
        casesSelector.queryLocatorCasesOpen(generalQueue);
    }

    @IsTest
    public static void eopDateNoCaseRoutingTest()
    {
        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.RecordTypeInfo enrollmentCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Enrollment');
        Schema.RecordTypeInfo reimbursementCaseInfo = caseDescribe.getRecordTypeInfosByName().get('Reimbursement');
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLivReimbursementFollowUp;

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLivReimbursementFollowUp = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = True;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseRoutingTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);


        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: Insert 2 DCs');
        List<Daily_Claim__c> dailyClaimList = new List<Daily_Claim__c>();
        Daily_Claim__c dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 7000;
        //dailyClaim.Prior_Authorization__c = 'A126';
        dailyClaim.Authorized_Representative__c = 'Adam Pawlik';
        dailyClaim.Authorized_Relationship__c = 'Father';
        dailyClaim.Billing_Provider_City__c = 'Manchester';
        dailyClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Billing_Provider_Last_Name__c = 'Allred';
        dailyClaim.Billing_Provider_Specialty__c = '';
        dailyClaim.Billing_Provider_PIN__c = '1417948050';
        dailyClaim.Billing_Provider_State__c = 'MA';
        dailyClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Billing_Provider_Zip_Code__c = '01944';
        dailyClaim.Billing_Provider_Phone__c = '9785268288';
        dailyClaim.Billing_Provider_Fax__c = '6178970801';
        dailyClaim.Primary_Claim_Number__c = 'P2JKS27W5';
        dailyClaim.Claim_Code__c = 'O';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.Claim_Segment__c = '0';
        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.NDC__c = '44087353501';
        //dailyClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaim.Patient_First_Name__c = 'KHALIAH';
        dailyClaim.Patient_Last_Name__c = 'HINGSTON';
        dailyClaim.Patient_Middle_Initial__c = '';
        dailyClaim.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        dailyClaim.Patient_Gender__c = 'M';
        //dailyClaim.Patient_Email_Address__c = 'lara@test.com';

        dailyClaim.Patient_Phone_Number__c = '5083161245';
        dailyClaim.Plan_Sponsor_Name__c = 'TCS';
        dailyClaim.Preferred_Provider__c = 'Y';
        dailyClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Fax__c = '6178970801';
        dailyClaim.Service_Provider_Phone__c = '9785268288';
        dailyClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Service_Provider_City__c = 'Manchester';
        dailyClaim.Service_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Service_Provider_Last_Name__c = 'Allred';
        dailyClaim.Service_Provider_NPI__c = '1417948050';
        //dailyClaim.Service_Provider_Practice__c = 'NONE';
        dailyClaim.Service_Provider_Zip__c = '01944';
        dailyClaim.Service_Provider_Specialty_Code__c = '';
        dailyClaim.Service_Provider_State__c = 'NY';
        dailyClaim.Patient_Address_Line_1__c = '39276 HACE STREET';
        dailyClaim.Patient_Address_Line_2__c = '';
        dailyClaim.Patient_City__c = 'HOLTSVILLE';
        dailyClaim.Patient_State__c = 'NY';
        dailyClaim.Patient_Zip_Code__c = '00501';
        dailyClaim.Total_Coinsurance__c = 0;
        dailyClaim.Total_Copay__c = 3000;
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.EOP_Date__c = System.today().addDays(10);
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        List<Contact> contactList = new List<Contact>();
        List<Case> caseList = new List<Case>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        //system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        //caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
        //        Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
        //        Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(1, caseList.size());
        Set<Id> claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                    Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
                    Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c
                    FROM Case
                    WHERE Claim_Information__c IN : claimIdset];

        system.assertequals(1,caseList.size());
        DateTime currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        Datetime mbrFollowupTime = null;
        List<Case> followUpCaseList = new List<Case>();

        Test.startTest();
        //Case Status != Verify Fax Number
        //mbrFollowupTime = null
        for(Case caseRecord: caseList) {
            system.debug('generalQueue = '+ generalQueue);
            system.debug('caseRecord.OwnerId = '+ caseRecord.OwnerId);
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
        //        Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
        //        Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);
        system.assertequals(1,caseList.size());

        followUpCaseList = new List<Case>();
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            system.debug('caseRecord.Type = '+ caseRecord.Type);
            system.debug('preGoLiveFaxValidation = '+ preGoLiveFaxValidation);
            system.debug('preGoLiveNewEnrollment = '+ preGoLiveNewEnrollment);
            system.debug('caseRecord.OwnerId = '+ caseRecord.OwnerId);
            //if(caseRecord.Type == 'Enrollement')
                //system.assertEquals(preGoLiveFaxValidation, caseRecord.OwnerId, 'Case should be routed to preGoLiveFaxValidation queue');
            //if(caseRecord.RecordTypeId == enrollmentCaseInfo.getRecordTypeId())
            //    system.assertEquals(preGoLiveNewEnrollment, caseRecord.OwnerId, 'Case should be routed to preGoLiveNewEnrollment queue');
            if(caseRecord.RecordTypeId == reimbursementCaseInfo.getRecordTypeId())
                system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = '2nd Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        CaseRoutingJob CaseRouting = new CaseRoutingJob();
        Database.executeBatch(CaseRouting,1);
        Test.stopTest();

    }

    @IsTest
    public static void eopDateCaseRoutingTest()
    {
        Map<Id,Group> mapPrudentMedBenQueues = new Map<Id,Group>([select Id,Name,DeveloperName from Group where Type = 'Queue']);
        Id generalQueue, preGoLiveNewEnrollment, preGoLiveFaxValidation, preGoLiveEnrollmentFollowUp,
                postGoLiveEnrollmentFollowUp, postGoLiveNewEnrollment, postGoLiveNewReimbursement, postGoLivReimbursementFollowUp;

        if(mapPrudentMedBenQueues.size() > 0) {
            for (Id GroupId : mapPrudentMedBenQueues.keyset()) {
                String Queue = mapPrudentMedBenQueues.get(GroupId).DeveloperName;
                System.debug('Queue = '+Queue);
                System.debug('GroupId = '+GroupId);
                switch on Queue {
                    when 'General' { // when Queue is General
                        generalQueue = GroupId;
                    }
                    when 'PRE_Go_Live_New_Enrollment' { // when Queue is PRE-Go-Live New Enrollment
                        preGoLiveNewEnrollment = GroupId;
                    }
                    when 'Pre_Go_Live_Fax_Validation' { // when Queue is Pre-Go-Live Fax Validation
                        preGoLiveFaxValidation = GroupId;
                    }
                    when 'PRE_Go_Live_Enrollment_Follow_Up' { // when Queue is PRE-Go-Live  Enrollment Follow-Up
                        preGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_Enrollment_Follow_Up' { // when Queue is POST-Go-Live Enrollment Follow-Up
                        postGoLiveEnrollmentFollowUp = GroupId;
                    }
                    when 'POST_Go_Live_New_Enrollment' { // when Queue is Post-Go-Live Enrollment - NEW Queue
                        postGoLiveNewEnrollment = GroupId;
                    }
                    when 'Post_Go_Live_New_Reimbursement' { // when Queue is Post-Go-Live Reimbursement - NEW Queue
                        postGoLiveNewReimbursement = GroupId;
                    }
                    when 'Post_Go_Live_Reimbursement_Follow_Up' { // when Queue is Post-Go-Live Reimbursement - Follow-Up
                        postGoLivReimbursementFollowUp = GroupId;
                    }
                }
            }
        }

        //Test.startTest();
        Date goLiveDate;
        Boolean preGoLive = True;
        Boolean allowCaseRouting = True;
        Boolean allowMBROutreach = True;
        caseRoutingTestSetup(preGoLive, allowCaseRouting, allowMBROutreach);


        // Test Scenario: Insert 2 DCs
        System.Debug('Test Scenario: Insert 2 DCs');
        List<Daily_Claim__c> dailyClaimList = new List<Daily_Claim__c>();
        Daily_Claim__c dailyClaim = new Daily_Claim__c();
        dailyClaim.Plan_Sponsor_Name__c = 'SI PDP Retired Non-Bargaining Rx $500 PPO';
        dailyClaim.CSA_Control__c = '865431';
        dailyClaim.CSA_Account__c = '711';
        dailyClaim.CSA_Suffix__c = '15';
        dailyClaim.Patient_CUMB_ID__c = '185494722';
        dailyClaim.Relationship_Code__c = 'M';
        //dailyClaim.COB_Indicator__c = 'N';
        dailyClaim.Units_Billed__c = 30;
        dailyClaim.Amount_Paid_By_Primary__c = 7000;
        //dailyClaim.Prior_Authorization__c = 'A126';
        dailyClaim.Authorized_Representative__c = 'Adam Pawlik';
        dailyClaim.Authorized_Relationship__c = 'Father';
        dailyClaim.Billing_Provider_City__c = 'Manchester';
        dailyClaim.Billing_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Billing_Provider_Last_Name__c = 'Allred';
        dailyClaim.Billing_Provider_Specialty__c = '';
        dailyClaim.Billing_Provider_PIN__c = '1417948050';
        dailyClaim.Billing_Provider_State__c = 'MA';
        dailyClaim.Billing_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Billing_Provider_Zip_Code__c = '01944';
        dailyClaim.Billing_Provider_Phone__c = '9785268288';
        dailyClaim.Billing_Provider_Fax__c = '6178970801';
        dailyClaim.Primary_Claim_Number__c = 'P2JKS27W5';
        dailyClaim.Claim_Code__c = 'O';
        dailyClaim.Claim_Line__c = '1';
        dailyClaim.Claim_Segment__c = '0';
        dailyClaim.COB_Code__c = 'Secondary';
        dailyClaim.Days_Supply__c = 30;
        dailyClaim.Diagnosis_Code__c = 'C4A30';
        dailyClaim.Drug_Label_Name__c = 'BAVENCIO';
        dailyClaim.HCPCS_Code__c = 'J9023';
        //dailyClaim.ICD9_Procedure_Code__c = 'ICD9_PC_0002';
        dailyClaim.NDC__c = '44087353501';
        //dailyClaim.PA_Approval_Dates__c = date.valueOf('2021-10-01');
        dailyClaim.Patient_First_Name__c = 'KHALIAH';
        dailyClaim.Patient_Last_Name__c = 'HINGSTON';
        dailyClaim.Patient_Middle_Initial__c = '';
        dailyClaim.Patient_Birth_Date__c = date.valueOf('1970-07-30');
        dailyClaim.Patient_Gender__c = 'M';
        //dailyClaim.Patient_Email_Address__c = 'lara@test.com';

        dailyClaim.Patient_Phone_Number__c = '5083161245';
        dailyClaim.Plan_Sponsor_Name__c = 'TCS';
        dailyClaim.Preferred_Provider__c = 'Y';
        dailyClaim.Date_Of_Service_From__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Fax__c = '6178970801';
        dailyClaim.Service_Provider_Phone__c = '9785268288';
        dailyClaim.Date_Of_Service_To__c = date.valueOf('2021-07-10');
        dailyClaim.Service_Provider_Address_Line_1__c = '40 Beach Street';
        dailyClaim.Service_Provider_City__c = 'Manchester';
        dailyClaim.Service_Provider_First_Name__c = 'Rebecca L';
        dailyClaim.Service_Provider_Last_Name__c = 'Allred';
        dailyClaim.Service_Provider_NPI__c = '1417948050';
        //dailyClaim.Service_Provider_Practice__c = 'NONE';
        dailyClaim.Service_Provider_Zip__c = '01944';
        dailyClaim.Service_Provider_Specialty_Code__c = '';
        dailyClaim.Service_Provider_State__c = 'NY';
        dailyClaim.Patient_Address_Line_1__c = '39276 HACE STREET';
        dailyClaim.Patient_Address_Line_2__c = '';
        dailyClaim.Patient_City__c = 'HOLTSVILLE';
        dailyClaim.Patient_State__c = 'NY';
        dailyClaim.Patient_Zip_Code__c = '00501';
        dailyClaim.Total_Coinsurance__c = 0;
        dailyClaim.Total_Copay__c = 3000;
        dailyClaim.Total_Deductible__c = 0;
        dailyClaim.Previous_Claim__c = '';
        dailyClaim.Relationship_Code__c = '01';
        dailyClaim.Claim_Adjustment_Amount__c = null;
        dailyClaim.Coverage_Code_Indicator__c = null;
        dailyClaim.Place_of_Service__c = '11';
        dailyClaim.EOP_Date__c = System.today().addDays(-10);
        dailyClaim.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(dailyClaim.CSA_Control__c + '-'
                + dailyClaim.CSA_Suffix__c + '-'
                + dailyClaim.CSA_Account__c
        );
        System.Debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);

        dailyClaimList.add(dailyClaim);

        insert dailyClaimList;

        List<Contact> contactList = new List<Contact>();
        List<Case> caseList = new List<Case>();
        //List<Contact> conList = [SELECT Id FROM Contact WHERE CSA_Number__c =: dailyClaim.CSA_Number__c];
        IContacts contactsDomain = (IContacts) PMd_Application.Domain.newInstance(contactList);
        Map<Id, Contact> existingContactsByHistoricalClaimId = contactsDomain.getExistingContactsByDailyClaimId(dailyClaimList);
        Contact existingContact = existingContactsByHistoricalClaimId.get(dailyClaim.Id);
        //system.debug('conList.CSA_Account__c = '+conList[0].CSA_Account__c);
        system.debug('dailyClaim.CSA_Number__c = '+dailyClaim.CSA_Number__c);
        system.assertequals(false,existingContact==null, 'No Contacts found');
        List<Claim_Information__c> claimList = [SELECT Id FROM Claim_Information__c WHERE CSA_Account__c =: dailyClaim.CSA_Account__c];
        List<Contact_Drug__c> contactDrugList = [SELECT Id FROM Contact_Drug__c WHERE Contact__c =:existingContact.id ];
        system.assertequals(1,contactDrugList.size());

        //system.assertequals(1,claimList.size());
        system.assertequals(1,contactDrugList.size());
        //caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
        //        Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
        //        Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(1, caseList.size());
        Set<Id> claimIdset = new Set<Id>();
        for(Claim_Information__c claimRec: claimList)
        {
            system.debug('Claim records='+claimRec);
            claimIdset.add(claimRec.Id);
        }
        caseList = [SELECT Id, OwnerId, Status, Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
                Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c
        FROM Case
        WHERE Claim_Information__c IN : claimIdset];

        system.assertequals(1,caseList.size());
        DateTime currentDateTime = DateTime.now();
        currentDateTime = currentDateTime.addHours(-4); //System is using UTC time 4 hours ahead of EST

        Datetime mbrFollowupTime = null;
        List<Case> followUpCaseList = new List<Case>();

        Test.startTest();
        //Case Status != Verify Fax Number
        //mbrFollowupTime = null
        for(Case caseRecord: caseList) {
            system.debug('generalQueue = '+ generalQueue);
            system.debug('caseRecord.OwnerId = '+ caseRecord.OwnerId);
            system.assertEquals(generalQueue, caseRecord.OwnerId, 'Case should be routed to generalQueue queue');
            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //caseList = [SELECT Id, OwnerId, Status, Follow_up_Time__c, EOP_Date__c, Claim_Information__c, Contact.Name, CaseNumber, Type,
        //        Contact.CSA__r.Implementation__r.Contract__r.Go_Live_Date__c, Contact_Drug__r.Copay_Enrollment_Status__c, RecordTypeId, RecordType.Name, HCP_Enrollment_Outreach__c,
        //        Contact.CSA__r.Implementation__r.Allow_MBR_Outreach__c FROM Case WHERE Claim_Information__c =: claimList[0].id ];
        //system.assertEquals(1, caseList.size());

        caseList= CaseService.reRouteExistingCaseRoutingRecords(followUpCaseList);
        system.assertequals(1,caseList.size());

        followUpCaseList = new List<Case>();
        //Case Status = Verify Fax Number
        for(Case caseRecord: caseList) {
            system.debug('caseRecord.Type = '+ caseRecord.Type);
            system.debug('preGoLiveFaxValidation = '+ preGoLiveFaxValidation);
            system.debug('preGoLiveNewEnrollment = '+ preGoLiveNewEnrollment);
            system.debug('caseRecord.OwnerId = '+ caseRecord.OwnerId);
            //if(caseRecord.Type == 'Enrollement')
            //system.assertEquals(preGoLiveFaxValidation, caseRecord.OwnerId, 'Case should be routed to preGoLiveFaxValidation queue');
            system.assertEquals(preGoLiveNewEnrollment, caseRecord.OwnerId, 'Case should be routed to preGoLiveNewEnrollment queue');
            //if(caseRecord.Type == 'Reimbursement')
            //    system.assertEquals(postGoLiveNewReimbursement, caseRecord.OwnerId);

            //caseRecord.Follow_up_Time__c = mbrFollowupTime;
            caseRecord.Status = '2nd Attempt Needed';
            followUpCaseList.add(caseRecord);
        }
        update followUpCaseList;

        //CaseRoutingJob CaseRouting = new CaseRoutingJob();
        //Database.executeBatch(CaseRouting,1);
        Id jobId = CaseService.submitCaseRoutingJob();
        Test.stopTest();

    }


}
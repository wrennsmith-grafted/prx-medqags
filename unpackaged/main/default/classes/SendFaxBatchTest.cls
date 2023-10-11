/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-30-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class SendFaxBatchTest {
    @TestSetup
    public static void setupData() {
        Account a = new Account();
        a.Name='Test Account';
        a.Go_Live_Date__c = Date.newInstance(2023,1, 17);
        insert a;

        Drug__c d = new Drug__c(); 
        d.Drug_Brand_Name__c = 'Test';
        d.Name = 'Test'; 
        d.Coding_Level__c = 'HCPCS'; 
        d.J_Code__c = '123456';
        d.Copay_Assistance_Available__c = 'Yes';
        insert d; 

        List<Contact> lstContactsTobeCreated = new List<Contact>(); 

        Contact c = new Contact();
        c.FirstName='TestHello';
        c.LastName = 'ContactHello';
        c.Birthdate= Date.newInstance(1990,1, 11);
        c.Gender__c = 'Male';
        c.MailingStreet = 'address line 1\n addressline2';
        c.MailingCity = 'Raleigh';
        c.MailingState = 'NC';
        c.MailingPostalCode = '27616';
        c.AccountId = a.Id;
        lstContactsTobeCreated.add(c);

        Contact c1 = new Contact();
        c1.FirstName='Test';
        c1.LastName = 'TestHello';
        c1.Birthdate= Date.newInstance(1986,10, 18);
        c1.Gender__c = 'Female';
        c1.MailingStreet = 'address line 1\n addressline2';
        c1.MailingCity = 'Charleston';
        c1.MailingState = 'SC';
        c1.MailingPostalCode = '29420';
        c1.AccountId = a.Id;
        lstContactsTobeCreated.add(c1);

        Contact c2 = new Contact();
        c2.FirstName='TestThree';
        c2.LastName = 'Three';
        c2.Birthdate= Date.newInstance(1996,10, 18);
        c2.Gender__c = 'Male';
        c2.MailingStreet = 'address line 1\n addressline2';
        c2.MailingCity = 'Charleston';
        c2.MailingState = 'SC';
        c2.MailingPostalCode = '29420';
        c2.AccountId = a.Id;
        lstContactsTobeCreated.add(c2);

        Contact c3 = new Contact();
        c3.FirstName='TestFour';
        c3.LastName = 'Three';
        c3.Birthdate= Date.newInstance(1996,10, 18);
        c3.Gender__c = 'Male';
        c3.MailingStreet = 'address line 1\n addressline2';
        c3.MailingCity = 'Charleston';
        c3.MailingState = 'SC';
        c3.MailingPostalCode = '29420';
        c3.AccountId = a.Id;
        lstContactsTobeCreated.add(c3);        

        insert lstContactsTobeCreated; 

        List<Case> lstCasesToAdd = new List<Case>(); 

        Case case1 = new Case(); 
        case1.RecordTypeId = '0125e000000mHQ8AAM'; 
        case1.ContactId = c.Id; 
        case1.Outreach_Type__c = 'Both'; 
        case1.Outreach_Comments__c = 'UPDATE LATER'; 
        case1.Status = 'Verify Fax Number'; 
        case1.Latest_PRx_Outreach_Attempt__c = Date.today().addDays(-1); 
        lstCasesToAdd.add(case1); 

        Case case2 = new Case(); 
        case2.RecordTypeId = '0125e000000mHQ8AAM'; 
        case2.ContactId = c1.Id; 
        case2.Outreach_Type__c = 'Both'; 
        case2.Outreach_Comments__c = 'TEST'; 
        case2.Status = 'Verify Fax Number'; 
        case2.Latest_PRx_Outreach_Attempt__c = Date.today().addDays(-7); 
        lstCasesToAdd.add(case2); 

        Case case3 = new Case(); 
        case3.RecordTypeId = '0125e000000mHQ8AAM'; 
        case3.ContactId = c2.Id; 
        case3.Outreach_Type__c = 'Both'; 
        case3.Outreach_Comments__c = 'TEST'; 
        case3.Status = 'Outreach Complete'; 
        case3.Latest_PRx_Outreach_Attempt__c = Date.today(); 
        lstCasesToAdd.add(case3); 

        Case case4 = new Case(); 
        case4.RecordTypeId = '0125e000000mHQ8AAM'; 
        case4.ContactId = c3.Id; 
        case4.Outreach_Type__c = 'Both'; 
        case4.Outreach_Comments__c = 'TEST'; 
        case4.Status = 'Transfer to Health Plan'; 
        case4.Latest_PRx_Outreach_Attempt__c = Date.today().addDays(-1); 
        lstCasesToAdd.add(case4); 

        insert(lstCasesToAdd); 

        Contact_Drug__c cd = new Contact_Drug__c(); 
        cd.Drug_Name__c = d.Id; 
        cd.Copay_Enrollment_Status__c = 'Pending'; 
        cd.Related_Case__c = case2.Id; 
        insert cd; 

        List<Claim_Information__c> lstClaimsToAdd = new List<Claim_Information__c>(); 

        Claim_Information__c claim1 = new Claim_Information__c(); 
        claim1.Contact__c = c.Id; 
        claim1.EOP_Date__c = date.today().addDays(-75); 
        claim1.Drug__c = d.Id; 
        claim1.Contact_Drug__c = cd.Id; 
        claim1.CPA_Indicator__c = 'Opt-in - CPA not available';
        claim1.CPA_Funds_Paid__c = 30;
        lstClaimsToAdd.add(claim1);

        Claim_Information__c claim2 = new Claim_Information__c(); 
        claim2.Contact__c = c2.Id; 
        claim2.EOP_Date__c = date.today().addDays(-55);
        claim2.Drug__c = d.Id; 
        claim2.Contact_Drug__c = cd.Id; 
        claim2.CPA_Indicator__c = 'Opt-in - CPA not available';
        claim2.CPA_Funds_Paid__c = 30;
        lstClaimsToAdd.add(claim2); 

        insert lstClaimsToAdd; 
        
        // Update Cases with Claim Information values 
        List<Case> lstCasesToUpdate = new List<Case>(); 
        
        case1.Claim_Information__c = claim1.Id; 
        lstCasesToUpdate.add(case1); 

        case2.Claim_Information__c = claim2.Id; 
        lstCasesToUpdate.add(case2); 

        update lstCasesToUpdate; 
    }

    @isTest
    public static void testFinalNoticeFaxSuccess(){
        Test.startTest(); 
        SendFaxBatch batch = new SendFaxBatch('Final Notice'); 
        Database.executeBatch(batch);
        Test.stopTest(); 
    }

    @isTest
    public static void testFinalNoticeFaxNoRecords() {
        //Update status of case1 to make it so no valid records are found
        Case caseToUpdate = [SELECT Id, Status, HCP_Enrollment_Outreach__c FROM Case WHERE Outreach_Comments__c = 'UPDATE LATER' LIMIT 1];
        caseToUpdate.Status = 'Outreach Completed'; 
        caseToUpdate.HCP_Enrollment_Outreach__c = 'Outreach Complete';
        update caseToUpdate; 

        Test.startTest(); 
        SendFaxBatch batch = new SendFaxBatch('Final Notice'); 
        Database.executeBatch(batch);
        Test.stopTest(); 
    }
}
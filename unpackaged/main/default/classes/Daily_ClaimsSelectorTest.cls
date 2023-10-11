/**
 * @description       :
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-06-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-06-2021   Ricardy Banks             Initial Version
 *
 **/
@IsTest
private class Daily_ClaimsSelectorTest {

    @IsTest
    private static void testSelectById()
    {
        // Test data
        Daily_Claim__c dailyClaims = new Daily_Claim__c();
        dailyClaims.CSA_Account__c = 'AN0005';
        dailyClaims.Units_Billed__c = 2;
        dailyClaims.Amount_Paid_By_Primary__c = 100;
        dailyClaims.Prior_Authorization__c = 'A123';
        dailyClaims.Authorized_Representative__c = 'Jane Smith';
        dailyClaims.Authorized_Relationship__c = '1';
        dailyClaims.Billing_Provider_City__c = 'New York City';
        dailyClaims.Billing_Provider_First_Name__c = 'Test';
        dailyClaims.Billing_Provider_Last_Name__c = 'one';
        dailyClaims.Billing_Provider_Specialty__c = 'Specialty 1';
        dailyClaims.Billing_Provider_PIN__c = '1234567';
        dailyClaims.Billing_Provider_State__c = 'NY';
        dailyClaims.Billing_Provider_Address_Line_1__c = '456 Test Lane';
        dailyClaims.Billing_Provider_Zip_Code__c = '10123';
        dailyClaims.Billing_Provider_Phone__c = '5555555555';
        dailyClaims.Billing_Provider_Fax__c = '9999999999';
        dailyClaims.Primary_Claim_Number__c = 'E11111111111111';
        dailyClaims.Claim_Code__c = 'Initial Claim';
        dailyClaims.Claim_Line__c = '1';
        dailyClaims.Claim_Segment__c = '01';
        dailyClaims.COB_Code__c = 'Secondary';
        dailyClaims.CSA_Control__c = 'CN0005';
        dailyClaims.Days_Supply__c = 30;
        dailyClaims.Diagnosis_Code__c = '12345678987';
        dailyClaims.Drug_Label_Name__c = 'Drug One';
        dailyClaims.HCPCS_Code__c = 'J5678';
        dailyClaims.NDC__c = '123456789';
        dailyClaims.PA_Approval_Dates__c = date.valueOf('2021-07-01');
        //dailyClaims.Patient_Birth_Date__c = date.valueOf('1990-01-01');
        //dailyClaims.Patient_Email_Address__c = 'jsmith@test.com';
        dailyClaims.Patient_First_Name__c = 'Joe';
        dailyClaims.Patient_Last_Name__c = 'Smith';
        dailyClaims.Patient_Middle_Initial__c = 'H';
        dailyClaims.Patient_Phone_Number__c = '8888888888';
        dailyClaims.Patient_Gender__c = 'M';
        dailyClaims.Plan_Sponsor_Name__c = 'Sample Company';
        dailyClaims.Preferred_Provider__c = 'Preferred';
        dailyClaims.Date_Of_Service_From__c = date.valueOf('2021-07-01');
        dailyClaims.Service_Provider_Fax__c = '5555555555';
        dailyClaims.Service_Provider_Phone__c = '7777777777';
        dailyClaims.Date_Of_Service_To__c = date.valueOf('2021-07-02');
        dailyClaims.Service_Provider_Address_Line_1__c = '456 plane Lane';
        dailyClaims.Service_Provider_City__c = 'Chicago';
        dailyClaims.Service_Provider_First_Name__c = 'Jane';
        dailyClaims.Service_Provider_Last_Name__c = 'Doe';
        dailyClaims.Service_Provider_NPI__c = '9998887776';
        //dailyClaims.Service_Provider_Practice__c = 'NONE';
        dailyClaims.Service_Provider_Zip__c = '10123';
        dailyClaims.Service_Provider_State__c = 'NY';
        dailyClaims.Patient_Address_Line_1__c = '123 Sesame Street';
        dailyClaims.Patient_Address_Line_2__c = '0';
        dailyClaims.Patient_City__c = 'Los Angeles';
        dailyClaims.Patient_CUMB_ID__c = 'W12345678';
        dailyClaims.Patient_State__c = 'NY';
        dailyClaims.Patient_Zip_Code__c = '10151';
        dailyClaims.CSA_Suffix__c = 'SN0005';
        dailyClaims.Total_Coinsurance__c = 30;
        dailyClaims.Total_Copay__c = 30;
        dailyClaims.Total_Deductible__c = 500;
        dailyClaims.Previous_Claim__c = '';
        dailyClaims.Relationship_Code__c = '01';
        //dailyClaims.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash('CN0003' + 'SN0003' +'AN0003');
        //
        insert dailyClaims;

        // Query
        List<Daily_Claim__c> dailyClaimsList =
                new Daily_ClaimsSelector().selectById(new Set<Id> { dailyClaims.Id });

        // Assert
        //System.assertEquals('Something cool', dailyClaims[0].Billing_Provider_First_Name__c);
        //System.assertEquals('CoolName', dailyClaims[0].Name);
    }
}
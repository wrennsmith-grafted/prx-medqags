@isTest
public with sharing class TestPrudentRESTAPI_DailyClaim {   
    
   @isTest
    public static void Datasetup(){
        /*
        //Create new Account
        
        Account Acc = new Account();
        Acc.Name = 'Test Budding Bee Account';
        Acc.Type = 'Customer';
        Acc.Control_Number__c = '81';
        Acc.Description = 'This is a test account used on the test class';
        Acc.Go_Live_Date__c = System.today() + 20;
        Acc.PBM_Name__c = 'Caremark';
        insert Acc; 
        
        //Create a new CSA record with Pre Go-Live Date        
        CSA__c CSA = new CSA__c();
        CSA.Account__c = Acc.Id;
        CSA.CSA_Account__c = '81';
        CSA.CSA_Control__c = '900990';
        CSA.CSA_Suffix__c = '30';
        CSA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(CSA.CSA_Account__c + CSA.CSA_Control__c + CSA.CSA_Suffix__c);
        CSA.Go_Live_Date__c =  System.today() + 20; //Pre Go-Live Scenario
        CSA.Medical_Drug_List__c = 'Pilot Drug List';
        insert CSA;
        
        //Create a new Drug record
        Drug__c Drug = new Drug__c();
        Drug.Active_CPA__c = true;
        Drug.Copay_Assistance_Available__c = 'Yes';
        Drug.CPA_Change_Needs_Review__c = true;
        Drug.Name = 'Test Drug 30MG Injection';
        Drug.Drug_Brand_Name__c = 'MVASI';
        Drug.NDC__c = '123456793';
        Drug.NDC_Match_Exception__c = true;
        Drug.J_Code__c = 'J1915';
        insert Drug;  
        
        //Create a new Test Contact
        
        Contact Con = new Contact();
        Con.FirstName = 'Michael';
        Con.LastName = 'Parks';
        Con.Birthdate = Date.newinstance(1977,04,10);
        Con.Email = 'Michael.Parks@icloud.com';
        Con.Patient_Phone_Number__c = '5126669005';
        Con.Gender__c = 'Male';
        Con.AccountId = Acc.Id;
        insert Con;
        
        //Create a new Contact Drug record
        Contact_drug__c ConDrug = new Contact_Drug__c();
        ConDrug.Contact__c = Con.Id;
        ConDrug.Drug_Name__c = Drug.Id;
        insert ConDrug;        
                
        //Create a new Claim Information Record
        Claim_Information__c ClaimInfo = new Claim_Information__c();
        ClaimInfo.Amount_Paid_By_Primary__c = 1200;
        ClaimInfo.Billing_Provider_Address_Line_1__c = '458 Test Lane';
        ClaimInfo.Billing_Provider_City__c = 'New York City';
        ClaimInfo.Billing_Provider_First_Name__c = 'Test';
        ClaimInfo.Billing_Provider_Last_Name__c = 'Three';
        ClaimInfo.CSA_Account__c = '20';
        ClaimInfo.CSA_Control__c = '900915';
        ClaimInfo.CSA_Suffix__c = '28';
        ClaimInfo.Date_of_Service__c = System.today() - 1;
        ClaimInfo.Days_Supply__c = 60;
        ClaimInfo.Drug__c = Drug.Id;
        ClaimInfo.HCPCS_Code__c = 'J1915';
        ClaimInfo.NDC__c = '123456793';
        ClaimInfo.Primary_Claim_Number__c = 'E11111111111915';        
		insert ClaimInfo;            
        */
    }
    
    @isTest(SeeAllData=false)
    public static void PrudentRESTResourceCreateConClaimPreGoLive(){        
        Test.startTest();                        
    	try{              
            Account Acc = new Account();
            Acc.Name = 'Test Budding Bee Account';
            Acc.Type = 'Customer';
            Acc.Control_Number__c = '81';
            Acc.Description = 'This is a test account used on the test class';
            Acc.Go_Live_Date__c = System.today() + 20;
            Acc.PBM_Name__c = 'Caremark';
            insert Acc; 
            
            //Create a new CSA record with Pre Go-Live Date        
            CSA__c CSA = new CSA__c();
            CSA.Account__c = Acc.Id;
            CSA.CSA_Account__c = '81';
            CSA.CSA_Control__c = '900990';
            CSA.CSA_Suffix__c = '30';
            //CSA.CSA_Number__c = null;//6tUO0PgLhVMm/YZ1OlkG+lS7WhM=
            CSA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(CSA.CSA_Account__c + CSA.CSA_Control__c + CSA.CSA_Suffix__c);
            CSA.Go_Live_Date__c =  System.today() + 20; //Pre Go-Live Scenario
            CSA.Medical_Drug_List__c = 'Pilot Drug List';
            insert CSA;
            
             //Create a new Drug record
            Drug__c Drug = new Drug__c();
            Drug.Active_CPA__c = true;
            Drug.Copay_Assistance_Available__c = 'Yes';
            Drug.CPA_Change_Needs_Review__c = true;
            Drug.Name = 'Test Drug 30MG Injection';
            Drug.Drug_Brand_Name__c = 'MVASI';
            //Drug.NDC__c = '123456793';
            Drug.NDC_Match_Exception__c = true;
            Drug.J_Code__c = 'J1915';
            insert Drug;

            NDC__c testNDC = new NDC__c(Drug__c = Drug.Id, Name = '123456793');
            insert testNDC;
            
            String json = '[{"prudentInDataStagingId": "09032021411917","Account_Number": "81","Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "100.14","Authorization_Number": "A917","Authorized_Representative": "Rasu And","Authorized_Representative_Relationship": "4","Billing_Provider_City": "New York City","Billing_Provider_First_Name": "Test","Billing_Provider_Last_Name": "Four","Billing_Provider_Specialty": "Specialty 4","Billing_Provider_PIN": "1234569","Billing_Provider_State_Code": "NY","Billing_Provider_Street_Address_Line_1": "4917 Test Lane","Billing_Provider_Zip_Code": "10118","Billing_Provider_Phone": "3333333333","Billing_Provider_Fax": "9999999999","Claim_Identifier": "E11111111111917","Claim_Indicator": "Initial Claim","Claim_Line_Identifier": "4","Claim_Segment": "00","COB_indicator": "Secondary","Control_Number": "900990","Days_Supply": "60","Diagnosis_Code": "12345678989","Drug_Label_Name": "Drug Four","ICD9_Procedure_Code": "J1915","National_Drug_Code": "123456917","PA_Approval_Dates": "10012021","Patient_Birth_Date": "04011978","Patient_Email_Address": "Tom.Brooks@test.com","Patient_First_Name": "Thomas","Patient_Last_Name": "Brooks","Patient_Middle_Initial": "A","Patient_Phone_Number": "8888888891","Patient_Sex": "M","Policy_Holder_Name": "Wipro","Previous_Segment_Pointer": "null","Provider_Indicator": "Preferred","Service_From_Date": "07012024","Service_Provider_Fax": "5555555558","Service_Provider_Phone": "7777777780","Service_To_Date": "07022024","Servicing_Provider_Address_Line_1": "459 Plane Lane","Servicing_Provider_City": "Chicago","Servicing_Provider_First_Name": "Gare","Servicing_Provider_Last_Name": "Rod","Servicing_Provider_National_Provider_Identifier": "9998887779","Servicing_Provider_Practice_Role_Name": "NONE","Servicing_Provider_Service_Location_Zip_Code": "10126","Servicing_Provider_Specialty_Code": "4","Servicing_Provider_State_Code": "NY","Subscriber_Address_Line_1": "126 Sesame Street","Subscriber_Address_Line_2": "Apt 5","Subscriber_City": "Los Angeles","Subscriber_CUMB_ID": "W12345681","Subscriber_State_Code": "NY","Subscriber_Zip_Code": "10154","Suffix_Number": "30","Total_Coinsurance_Amount": "33.25","Total_Copay_Amount": "38.74","Total_Deductible_Amount": "503.96","Original_UCK_ID": "null","Person_Relationship_Code": "01","File_Upsert": "Daily Claims"}]';
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();             
            req.requestURI = '/services/apexrest/PrudentMD/';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueof(json);
            RestContext.request = req;
            String responseJSON = PrudentRestAPIResource.doPost();      
            
            List<Daily_Claim__c> DC = [SELECT Id,Status__c,Error_Log__c,Prudent_In_Data_Staging_ID__c,HCPCS_Code__c from Daily_Claim__c where Prudent_In_Data_Staging_ID__c = '09032021411917' LIMIT 1];
            if(DC != null && DC.size() > 0){
                System.debug('The Status value on the Daily Claim record is: '+DC[0].Status__c);
                System.debug('The Error Log value on the Daily Claim record is: '+DC[0].Error_Log__c);
                System.debug('The HCPCS Code or J Code value on Daily Claim is: '+DC[0].HCPCS_Code__c);
                System.assertEquals(null, DC[0].Error_Log__c);
                System.assertEquals(null, DC[0].Status__c); 
                
                List<Contact> newContactList = [SELECT Id,FirstName,LastName,Name from Contact where FirstName = 'Thomas' and LastName = 'Brooks'];
                System.debug('The newly created Contact record Name is: '+newContactList[0].Name);
                System.assertEquals(1,newContactList.size());
                
                System.assertEquals(1,newContactList.size());
                System.assertEquals(null, DC[0].Error_Log__c);
                System.assertEquals(null, DC[0].Status__c);  
                System.assertEquals('Thomas Brooks',newContactList[0].Name);
            }           
        }
        catch(Exception e){
            System.debug('Error calling the PrudentRESTResourceCSAMisMatch: '+e.getMessage());
        } 
    	Test.stopTest();
    }
    
    @isTest(SeeAllData=false)
    public static void PrudentRESTResourceCreateConClaimPostGoLive(){        
        Test.startTest();                        
    	try{              
            Account Acc = new Account();
            Acc.Name = 'Test Budding Bee Account';
            Acc.Type = 'Customer';
            Acc.Control_Number__c = '81';
            Acc.Description = 'This is a test account used on the test class';
            Acc.Go_Live_Date__c = System.today() + 20;
            Acc.PBM_Name__c = 'Caremark';
            insert Acc; 
            
            //Create a new CSA record with Pre Go-Live Date        
            CSA__c CSA = new CSA__c();
            CSA.Account__c = Acc.Id;
            CSA.CSA_Account__c = '81';
            CSA.CSA_Control__c = '900990';
            CSA.CSA_Suffix__c = '30';
            //CSA.CSA_Number__c = null;//6tUO0PgLhVMm/YZ1OlkG+lS7WhM=
            CSA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(CSA.CSA_Account__c + CSA.CSA_Control__c + CSA.CSA_Suffix__c);
            CSA.Go_Live_Date__c =  System.today() - 20; //Post Go-Live Scenario
            CSA.Medical_Drug_List__c = 'Pilot Drug List';
            insert CSA;
            
             //Create a new Drug record
            Drug__c Drug = new Drug__c();
            Drug.Active_CPA__c = true;
            Drug.Copay_Assistance_Available__c = 'Yes';
            Drug.CPA_Change_Needs_Review__c = true;
            Drug.Name = 'Test Drug 30MG Injection';
            Drug.Drug_Brand_Name__c = 'MVASI';
            //Drug.NDC__c = '123456793';
            Drug.NDC_Match_Exception__c = true;
            Drug.J_Code__c = 'J1915';
            insert Drug;

            NDC__c testNDC = new NDC__c(Drug__c = Drug.Id, Name = '123456793');
            insert testNDC;
            
            //Create a new Test Contact
        
            Contact Con = new Contact();
            Con.FirstName = 'Michael';
            Con.LastName = 'Parks';
            Con.Birthdate = Date.newinstance(1977,04,10);
            Con.Email = 'Michael.Parks@icloud.com';
            Con.Patient_Phone_Number__c = '5126669005';
            Con.Patient_Phone_Number__c = 'Male';
            Con.AccountId = Acc.Id;
            Con.CSA__c = CSA.Id;
            Con.CSA_Account__c= '81';
            Con.CSA_Control__c = '900990';
            Con.CSA_Suffix__c = '30';
            Con.Patient_CUMB_ID__c = 'W12345681';
            insert Con;
            
            //Create a new Contact Drug record
            Contact_drug__c ConDrug = new Contact_Drug__c();
            ConDrug.Contact__c = Con.Id;
            ConDrug.Drug_Name__c = Drug.Id;
            insert ConDrug; 
            
            String json = '[{"prudentInDataStagingId": "09032021411917","Account_Number": "81","Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "100.14","Authorization_Number": "A917","Authorized_Representative": "Rasu And","Authorized_Representative_Relationship": "4","Billing_Provider_City": "New York City","Billing_Provider_First_Name": "Test","Billing_Provider_Last_Name": "Four","Billing_Provider_Specialty": "Specialty 4","Billing_Provider_PIN": "1234569","Billing_Provider_State_Code": "NY","Billing_Provider_Street_Address_Line_1": "4917 Test Lane","Billing_Provider_Zip_Code": "10118","Billing_Provider_Phone": "3333333333","Billing_Provider_Fax": "9999999999","Claim_Identifier": "E11111111111917","Claim_Indicator": "Initial Claim","Claim_Line_Identifier": "4","Claim_Segment": "00","COB_indicator": "Secondary","Control_Number": "900990","Days_Supply": "60","Diagnosis_Code": "12345678989","Drug_Label_Name": "Drug Four","ICD9_Procedure_Code": "J1915","National_Drug_Code": "123456917","PA_Approval_Dates": "10012021","Patient_Birth_Date": "04011978","Patient_Email_Address": "Tom.Brooks@test.com","Patient_First_Name": "Thomas","Patient_Last_Name": "Brooks","Patient_Middle_Initial": "A","Patient_Phone_Number": "8888888891","Patient_Sex": "M","Policy_Holder_Name": "Wipro","Previous_Segment_Pointer": "null","Provider_Indicator": "Preferred","Service_From_Date": "07012024","Service_Provider_Fax": "5555555558","Service_Provider_Phone": "7777777780","Service_To_Date": "07022024","Servicing_Provider_Address_Line_1": "459 Plane Lane","Servicing_Provider_City": "Chicago","Servicing_Provider_First_Name": "Gare","Servicing_Provider_Last_Name": "Rod","Servicing_Provider_National_Provider_Identifier": "9998887779","Servicing_Provider_Practice_Role_Name": "NONE","Servicing_Provider_Service_Location_Zip_Code": "10126","Servicing_Provider_Specialty_Code": "4","Servicing_Provider_State_Code": "NY","Subscriber_Address_Line_1": "126 Sesame Street","Subscriber_Address_Line_2": "Apt 5","Subscriber_City": "Los Angeles","Subscriber_CUMB_ID": "W12345681","Subscriber_State_Code": "NY","Subscriber_Zip_Code": "10154","Suffix_Number": "30","Total_Coinsurance_Amount": "33.25","Total_Copay_Amount": "38.74","Total_Deductible_Amount": "503.96","Original_UCK_ID": "null","Person_Relationship_Code": "01","File_Upsert": "Daily Claims"}]';
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();             
            req.requestURI = '/services/apexrest/PrudentMD/';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueof(json);
            RestContext.request = req;
            String responseJSON = PrudentRestAPIResource.doPost();      
            
            List<Daily_Claim__c> DC = [SELECT Id,Status__c,Error_Log__c,Prudent_In_Data_Staging_ID__c,HCPCS_Code__c from Daily_Claim__c where Prudent_In_Data_Staging_ID__c = '09032021411917' LIMIT 1];
            if(DC != null && DC.size() > 0){
                System.debug('The Status value on the Daily Claim record is: '+DC[0].Status__c);
                System.debug('The Error Log value on the Daily Claim record is: '+DC[0].Error_Log__c);
                System.debug('The HCPCS Code or J Code value on Daily Claim is: '+DC[0].HCPCS_Code__c);
                List<Contact> newContactList = [SELECT Id,FirstName,LastName,Name from Contact where FirstName = 'Thomas' and LastName = 'Brooks'];
                System.debug('The newly created Contact record Name is: '+newContactList[0].Name);
                System.assertEquals(1,newContactList.size());
                List<Contact_Drug__c> ConMemberList = [SELECT Id,Name from Contact_Drug__c where Contact__c =:newContactList[0].Id];
                System.debug('The newly created Contact Drug record Name is: '+ConMemberList[0].Name);
                
                System.assertEquals(1,ConMemberList.size());
                System.assertEquals(null, DC[0].Error_Log__c);
                System.assertEquals(null, DC[0].Status__c);  
                System.assertEquals('Thomas Brooks',ConMemberList[0].Name);
            }           
        }
        catch(Exception e){
            System.debug('Error calling the PrudentRESTResourceCSAMisMatch: '+e.getMessage());
        } 
    	Test.stopTest();
    }
    
    @isTest(SeeAllData=false)
    public static void PrudentRESTResourceCSAMisMatch(){        
        Test.startTest();                        
    	try{                
            Account Acc = new Account();
            Acc.Name = 'Test Budding Bee Account';
            Acc.Type = 'Customer';
            Acc.Control_Number__c = '81';
            Acc.Description = 'This is a test account used on the test class';
            Acc.Go_Live_Date__c = System.today() + 20;
            Acc.PBM_Name__c = 'Caremark';
            insert Acc; 
            
            //Create a new CSA record with Pre Go-Live Date        
            CSA__c CSA = new CSA__c();
            CSA.Account__c = Acc.Id;
            CSA.CSA_Account__c = '81';
            CSA.CSA_Control__c = '900990';
            CSA.CSA_Suffix__c = '30';
            //CSA.CSA_Number__c = null;//6tUO0PgLhVMm/YZ1OlkG+lS7WhM=
            CSA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(CSA.CSA_Account__c + CSA.CSA_Control__c + CSA.CSA_Suffix__c);
            CSA.Go_Live_Date__c =  System.today() + 20; //Pre Go-Live Scenario
            CSA.Medical_Drug_List__c = 'Pilot Drug List';
            insert CSA;
            
             //Create a new Drug record
            Drug__c Drug = new Drug__c();
            Drug.Active_CPA__c = true;
            Drug.Copay_Assistance_Available__c = 'Yes';
            Drug.CPA_Change_Needs_Review__c = true;
            Drug.Name = 'Test Drug 30MG Injection';
            Drug.Drug_Brand_Name__c = 'MVASI';
            //Drug.NDC__c = '123456793';
            Drug.NDC_Match_Exception__c = true;
            Drug.J_Code__c = 'J1915';
            insert Drug;

            NDC__c testNDC = new NDC__c(Drug__c = Drug.Id, Name = '123456793');
            insert testNDC;
            
            String json = '[{"prudentInDataStagingId": "09032021411915","Account_Number": "20","Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "100.13","Authorization_Number": "A125","Authorized_Representative": "Miz Floss","Authorized_Representative_Relationship": "3","Billing_Provider_City": "New York City","Billing_Provider_First_Name": "Test","Billing_Provider_Last_Name": "Three","Billing_Provider_Specialty": "Specialty 3","Billing_Provider_PIN": "1234569","Billing_Provider_State_Code": "NY","Billing_Provider_Street_Address_Line_1": "458 Test Lane","Billing_Provider_Zip_Code": "10117","Billing_Provider_Phone": "3333333333","Billing_Provider_Fax": "9999999999","Claim_Identifier": "E11111111111915","Claim_Indicator": "Initial Claim","Claim_Line_Identifier": "3","Claim_Segment": "00","COB_indicator": "Secondary","Control_Number": "900915","Days_Supply": "60","Diagnosis_Code": "12345678915","Drug_Label_Name": "Drug One","ICD9_Procedure_Code": "J1915","National_Drug_Code": "123456793","PA_Approval_Dates": "09012021","Patient_Birth_Date": "01011992","Patient_Email_Address": "lara.bryan@test.com","Patient_First_Name": "Lara","Patient_Last_Name": "Bryan","Patient_Middle_Initial": "B","Patient_Phone_Number": "8888888890","Patient_Sex": "M","Policy_Holder_Name": "TCS","Previous_Segment_Pointer": "null","Provider_Indicator": "Preferred","Service_From_Date": "07012023","Service_Provider_Fax": "5555555557","Service_Provider_Phone": "7777777779","Service_To_Date": "07022023","Servicing_Provider_Address_Line_1": "458 Plane Lane","Servicing_Provider_City": "Chicago","Servicing_Provider_First_Name": "Dave","Servicing_Provider_Last_Name": "Dle","Servicing_Provider_National_Provider_Identifier": "9998887778","Servicing_Provider_Practice_Role_Name": "NONE","Servicing_Provider_Service_Location_Zip_Code": "10125","Servicing_Provider_Specialty_Code": "3","Servicing_Provider_State_Code": "NY","Subscriber_Address_Line_1": "125 Sesame Street","Subscriber_Address_Line_2": "Apt 4","Subscriber_City": "Los Angeles","Subscriber_CUMB_ID": "W12345680","Subscriber_State_Code": "NY","Subscriber_Zip_Code": "10153","Suffix_Number": "28","Total_Coinsurance_Amount": "32.54","Total_Copay_Amount": "72.57","Total_Deductible_Amount": "502.11","Original_UCK_ID": "null","Person_Relationship_Code": "01","File_Upsert": "Daily Claims"}]';
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();             
            req.requestURI = '/services/apexrest/PrudentMD/';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueof(json);
            RestContext.request = req;
            String responseJSON = PrudentRestAPIResource.doPost();      
            
            List<Daily_Claim__c> DC = [SELECT Id,Status__c,Error_Log__c,Prudent_In_Data_Staging_ID__c,HCPCS_Code__c from Daily_Claim__c where Prudent_In_Data_Staging_ID__c = '09032021411915' LIMIT 1];
            if(DC != null && DC.size() > 0){
                System.debug('The Status value on the Daily Claim record is: '+DC[0].Status__c);
                System.debug('The Error Log value on the Daily Claim record is: '+DC[0].Error_Log__c);
                System.debug('The HCPCS Code or J Code value on Daily Claim is: '+DC[0].HCPCS_Code__c);
                System.assertEquals('CSA Mismatch', DC[0].Error_Log__c);
                System.assertEquals('Error', DC[0].Status__c);                
            }           
        }
        catch(Exception e){
            System.debug('Error calling the PrudentRESTResourceCSAMisMatch: '+e.getMessage());
        } 
    	Test.stopTest();
    }
    
    @isTest
    public static void PrudentRestResourceMissingHCPCS(){
        
        Test.startTest();                        
    	try{      
             //Create new Account
            Account Acc = new Account();
            Acc.Name = 'Test Budding Bee Account';
            Acc.Type = 'Customer';
            Acc.Control_Number__c = '81';
            Acc.Description = 'This is a test account used on the test class';
            Acc.Go_Live_Date__c = System.today() + 20;
            Acc.PBM_Name__c = 'Caremark';
            insert Acc; 
            
            //Create a new CSA record with Pre Go-Live Date        
            CSA__c CSA = new CSA__c();
            CSA.Account__c = Acc.Id;
            CSA.CSA_Account__c = '81';
            CSA.CSA_Control__c = '900990';
            CSA.CSA_Suffix__c = '30';
            CSA.CSA_Number__c = SHA1UtilService.getBase64SHA1Hash(CSA.CSA_Account__c + CSA.CSA_Control__c + CSA.CSA_Suffix__c);
            CSA.Go_Live_Date__c =  System.today() + 20; //Pre Go-Live Scenario
            CSA.Medical_Drug_List__c = 'Pilot Drug List';
            insert CSA;
            
            //Create a new Drug record
            Drug__c Drug = new Drug__c();
            Drug.Active_CPA__c = true;
            Drug.Copay_Assistance_Available__c = 'Yes';
            Drug.CPA_Change_Needs_Review__c = true;
            Drug.Name = 'Test Drug 30MG Injection';
            Drug.Drug_Brand_Name__c = 'MVASI';
            //Drug.NDC__c = '123456793';
            Drug.NDC_Match_Exception__c = true;
            Drug.J_Code__c = 'J1915';
            insert Drug;

            NDC__c testNDC = new NDC__c(Drug__c = Drug.Id, Name = '123456793');
            insert testNDC;
            
            String json =  '[{"prudentInDataStagingId": "09032021411916","Account_Number": "20","Adjudicated_NDC_Units_Count": "2","Allowable_Amount": "100.13","Authorization_Number": "A125","Authorized_Representative": "Miz Floss","Authorized_Representative_Relationship": "3","Billing_Provider_City": "New York City","Billing_Provider_First_Name": "Test","Billing_Provider_Last_Name": "Three","Billing_Provider_Specialty": "Specialty 3","Billing_Provider_PIN": "1234569","Billing_Provider_State_Code": "NY","Billing_Provider_Street_Address_Line_1": "458 Test Lane","Billing_Provider_Zip_Code": "10117","Billing_Provider_Phone": "3333333333","Billing_Provider_Fax": "9999999999","Claim_Identifier": "E11111111111915","Claim_Indicator": "Initial Claim","Claim_Line_Identifier": "3","Claim_Segment": "00","COB_indicator": "Secondary","Control_Number": "900915","Days_Supply": "60","Diagnosis_Code": "12345678915","Drug_Label_Name": "Drug One","ICD9_Procedure_Code": "J1615","National_Drug_Code": "123456793","PA_Approval_Dates": "09012021","Patient_Birth_Date": "01011992","Patient_Email_Address": "lara.bryan@test.com","Patient_First_Name": "Lara","Patient_Last_Name": "Bryan","Patient_Middle_Initial": "B","Patient_Phone_Number": "8888888890","Patient_Sex": "M","Policy_Holder_Name": "TCS","Previous_Segment_Pointer": "null","Provider_Indicator": "Preferred","Service_From_Date": "07012023","Service_Provider_Fax": "5555555557","Service_Provider_Phone": "7777777779","Service_To_Date": "07022023","Servicing_Provider_Address_Line_1": "458 Plane Lane","Servicing_Provider_City": "Chicago","Servicing_Provider_First_Name": "Dave","Servicing_Provider_Last_Name": "Dle","Servicing_Provider_National_Provider_Identifier": "9998887778","Servicing_Provider_Practice_Role_Name": "NONE","Servicing_Provider_Service_Location_Zip_Code": "10125","Servicing_Provider_Specialty_Code": "3","Servicing_Provider_State_Code": "NY","Subscriber_Address_Line_1": "125 Sesame Street","Subscriber_Address_Line_2": "Apt 4","Subscriber_City": "Los Angeles","Subscriber_CUMB_ID": "W12345680","Subscriber_State_Code": "NY","Subscriber_Zip_Code": "10153","Suffix_Number": "28","Total_Coinsurance_Amount": "32.54","Total_Copay_Amount": "72.57","Total_Deductible_Amount": "502.11","Original_UCK_ID": "null","Person_Relationship_Code": "01","File_Upsert": "Daily Claims"}]';             
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();             
            req.requestURI = '/services/apexrest/PrudentMD/';
            req.httpMethod = 'POST';
            req.requestBody = Blob.valueof(json);
            RestContext.request = req;
            String responseJSON = PrudentRestAPIResource.doPost();      
            
            List<Daily_Claim__c> DC = [SELECT Id,Status__c,Error_Log__c,Prudent_In_Data_Staging_ID__c from Daily_Claim__c where Prudent_In_Data_Staging_ID__c = '09032021411916' LIMIT 1];
            if(DC != null && DC.size() > 0){
                System.debug('The Status value on the Daily Claim record is: '+DC[0].Status__c);
                System.debug('The Error Log value on the Daily Claim record is: '+DC[0].Error_Log__c);
                System.assertEquals('HCPCS Mismatch', DC[0].Error_Log__c);
                System.assertEquals('Error', DC[0].Status__c);                
            }           
        }
        catch(Exception e){
            System.debug('Error calling the PrudentRestResourceMissingHCPCS: '+e.getMessage());
        } 
    	Test.stopTest(); 	
    }

}
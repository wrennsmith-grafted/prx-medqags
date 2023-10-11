public class Historical_Claim_JSONRequest {

    public String Account_Number{get;set;}
    public String Adjudicated_NDC_Units_Count{get;set;}
    public String Allowable_Amount{get;set;}
    public String Authorization_Number{get;set;}
    //public String Authorized_Representative{get;set;}
    public String Authorized_Representative_Relationship{get;set;}
    public String Billing_Provider_City{get;set;}
    public String Billing_Provider_First_Name{get;set;}
    public String Billing_Provider_Last_Name{get;set;}
    public String Billing_Provider_Specialty{get;set;}
    public String Place_of_Service{get;set;}
    public String Billing_Provider_PIN{get;set;}
    public String Billing_Provider_State_Code{get;set;}
    public String Billing_Provider_Street_Address_Line_1{get;set;}
    public String Billing_Provider_Zip_Code{get;set;}
    public String Billing_Provider_Phone{get;set;}
    public String Billing_Provider_Fax{get;set;}
    public String Claim_Identifier{get;set;}
    public String Claim_Indicator{get;set;}
    public String Claim_Line_Identifier{get;set;}
    public String Claim_Segment{get;set;}
    public String COB_Indicator{get;set;}
    public String Control_Number{get;set;}
    public String Days_Supply{get;set;}
    public String Diagnosis_Code{get;set;}
    public String Drug_Label_Name{get;set;}
    public String ICD9_Procedure_Code{get;set;}
    public String National_Drug_Code{get;set;}
    public String Original_UCK_ID{get;set;}
    //public String PA_Approval_Dates{get;set;}
    public String Patient_Birth_Date{get;set;}
    //public String Patient_Email_Address{get;set;}
    public String Patient_First_Name{get;set;}
    public String Patient_Last_Name{get;set;}
    public String Patient_Middle_Initial{get;set;}
    public String Patient_Phone_Number{get;set;}
    public String Patient_Sex{get;set;}
    public String Policy_Holder_Name{get;set;}
    public String Provider_Indicator{get;set;}
    public String Claim_Adjusted_Amount{get;set;}
    public String Coverage_Code_Indicator{get;set;}
    public String Service_From_Date{get;set;}
    public String Service_Provider_Fax{get;set;}
    public String Service_Provider_Phone{get;set;}
    public String Service_To_Date{get;set;}
    public String Servicing_Provider_Address_Line_1{get;set;}
    public String Servicing_Provider_City{get;set;}
    public String Servicing_Provider_First_Name{get;set;}
    public String Servicing_Provider_Last_Name{get;set;}
    public String Servicing_Provider_National_Provider_Identifier{get;set;}
    public String Servicing_Provider_Practice_Role_Name{get;set;}
    public String Servicing_Provider_Service_Location_Zip_Code{get;set;}
    public String Servicing_Provider_Specialty_Code{get;set;}
    public String Servicing_Provider_State_Code{get;set;}
    public String Subscriber_Address_Line_1{get;set;}
    public String Subscriber_Address_Line_2{get;set;}
    public String Subscriber_City{get;set;}
    public String Subscriber_CUMB_ID{get;set;}
    public String Person_Relationship_Code{get;set;}
    public String Subscriber_State_Code{get;set;}
    public String Subscriber_Zip_Code{get;set;}
    public String Suffix_Number{get;set;}
    public String Total_Coinsurance_Amount{get;set;}
    public String Total_Copay_Amount{get;set;}
    public String Total_Deductible_Amount{get;set;}

    public String Plan_Sponsor_Unique_ID_Account_ID{get;set;}
    public String Plan_Letter{get;set;}
    public String Funding_Indicator{get;set;}
    public String Adjudication_Date{get;set;}

    public String File_Upsert{get;set;}
    public String prudentInDataStagingId{get;set;}
    public String Subscriber_Name{get;set;}
    public String Subscriber_Relationship{get;set;}

	public static Historical_Claim_JSONRequest parse(String json){
		return (Historical_Claim_JSONRequest) System.JSON.deserialize(json, Historical_Claim_JSONRequest.class);
	}
    
}
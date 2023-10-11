/**
 * @description       : Historical_Prior_Auth_JSONRequest class.
 * @author            : jyothi.gandhamaneni@PrudentRx.com
 * @group             :
 * @last modified on  : 09-09-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-18-2021   Ricardy Banks     			   Initial Version
 *
 **/

public class Historical_Prior_Auth_JSONRequest {

    public String Account_Number{get;set;}
    public String Service_Start_Date{get;set;}
    public String Service_End_Date{get;set;}
    public String Authorization_Number{get;set;}
    //public String Authorized_Representative{get;set;}
    public String Authorized_Representative_Relationship{get;set;}
    //public String Copay_Amount{get;set;}
    public String Control_Number{get;set;}
    public String Diagnosis_Code{get;set;}
    public String Drug_Label_Name{get;set;}
    public String ICD9_Procedure_Code{get;set;}
    public String National_Drug_Code{get;set;}
    //public String PA_Approval_Dates{get;set;}
    public String Patient_Birth_Date{get;set;}
    //public String Patient_Email_Address{get;set;}
    public String Patient_First_Name{get;set;}
    public String Patient_Last_Name{get;set;}
    public String Patient_Middle_Initial{get;set;}
    public String Patient_Phone_Number{get;set;}
    public String Patient_Sex{get;set;}
    public String Policy_Holder_Name{get;set;}
    public String Prescriber_Address_Line1{get;set;}
    public String Prescriber_City{get;set;}
    public String Prescriber_Fax{get;set;}
    public String Prescriber_First_Name{get;set;}
    public String Prescriber_Last_Name{get;set;}
    public String Prescriber_Phone{get;set;}
    public String Prescriber_Practice_Name{get;set;}
    public String Prescriber_NPI_Number{get;set;}
    public String Prescriber_Specialty{get;set;}
    public String Prescriber_State{get;set;}
    public String Prescriber_Zip_Code{get;set;}
    public String Service_Provider_Fax{get;set;}
    public String Service_Provider_Phone{get;set;}
    public String Servicing_Provider_Address_Line_1{get;set;}
    public String Servicing_Provider_City{get;set;}
    public String Servicing_Provider_First_Name{get;set;}
    public String Servicing_Provider_Last_Name{get;set;}
    public String Servicing_Provider_National_Provider_Identifier{get;set;}
    public String Servicing_Provider_Service_Location_Zip_Code{get;set;}
    public String Servicing_Provider_Specialty_Code{get;set;}
    public String Servicing_Provider_State_Code{get;set;}
    public String Servicing_Provider_Practice_Role_Name{get;set;}
    public String Subscriber_Address_Line_1{get;set;}
    public String Subscriber_Address_Line_2{get;set;}
    public String Subscriber_City{get;set;}
    public String Subscriber_CUMB_ID{get;set;}
    public String Member_Relationship_Code{get;set;}
    public String Subscriber_State_Code{get;set;}
    public String Subscriber_Zip_Code{get;set;}
    public String Suffix_Number{get;set;}
    public String Funding_Indicator{get;set;}
    public String Subscriber_Name{get;set;}
    public String Subscriber_Relationship{get;set;}
    //public String Billing_Provider_PIN{get;set;}
    //public String Billing_Provider_Street_Address_Line_1{get;set;}
    //public String Billing_Provider_City{get;set;}
    //public String Billing_Provider_State_Code{get;set;}
    //public String Billing_Provider_Zip_Code{get;set;}

    public String File_Upsert{get;set;}
    public String prudentInDataStagingId{get;set;}

    public static Historical_Prior_Auth_JSONRequest parse(String json){
        return (Historical_Prior_Auth_JSONRequest) System.JSON.deserialize(json, Historical_Prior_Auth_JSONRequest.class);
    }

}
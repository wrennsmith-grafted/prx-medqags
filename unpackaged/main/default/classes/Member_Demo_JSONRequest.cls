/** 
 * @description       : Member_Demo_JSONRequest class.
 * @author            : jyothi.gandhamaneni@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-19-2021
 * @last modified by  : Jyothi Gandhamaneni
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-18-2021   Jyothi Gandhamaneni			   Initial Version
 * 
 **/
public class Member_Demo_JSONRequest {
   
    public String Subscriber_CUMB_ID{get;set;}
    public String Patient_Email_Address{get;set;}
    public String Patient_Phone_Number{get;set;}
    public String Authorized_Representative{get;set;}
    public String Authorized_Representative_Relationship{get;set;}
    
    public String File_Upsert{get;set;}
    public String prudentInDataStagingId{get;set;}

	public static Member_Demo_JSONRequest parse(String json){
		return (Member_Demo_JSONRequest) System.JSON.deserialize(json, Member_Demo_JSONRequest.class);
	}
    
}
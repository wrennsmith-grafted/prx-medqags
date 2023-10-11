/** 
 * @description       : Provider_Demographic_JSONRequest class.
 * @author            : jyothi.gandhamaneni@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-19-2021
 * @last modified by  : Jyothi Gandhamaneni
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-18-2021   Jyothi Gandhamaneni			   Initial Version
 * 
 **/
public class Provider_Demographic_JSONRequest {

    public String Provider_NPI{get;set;}
    public String Service_Provider_Phone{get;set;}
    public String Service_Provider_Fax{get;set;}
    public String Billing_Provider_Phone{get;set;}
    public String Billing_Provider_Fax{get;set;}

    public String File_Upsert{get;set;}
    public String prudentInDataStagingId{get;set;}

	public static Provider_Demographic_JSONRequest parse(String json){
		return (Provider_Demographic_JSONRequest) System.JSON.deserialize(json, Provider_Demographic_JSONRequest.class);
	}
    
}
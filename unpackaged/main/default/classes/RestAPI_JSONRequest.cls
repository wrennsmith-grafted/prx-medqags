/**
 * @description       :
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-06-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-09-2021   Ricardy Banks					   Initial Version
 *
 **/
public class RestAPI_JSONRequest {
    public String File_Upsert{get;set;}
    public String prudentInDataStagingId{get;set;}

    public static RestAPI_JSONRequest parse(String json){
        return (RestAPI_JSONRequest) System.JSON.deserialize(json, RestAPI_JSONRequest.class);
    }
}
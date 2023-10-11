/**
 * @description       : 
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-08-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-06-2021   Ricardy Banks					   Initial Version
 *
 **/
public interface IRestAPIService {

    List<RestAPI_JSONResponse> doRestAPIPost(Map<String,String> mapAPILog, String JSONString);
}
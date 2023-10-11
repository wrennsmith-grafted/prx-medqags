/**
 * @description       : Daily Claims Service Interface
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 * 
 **/
public interface IDaily_ClaimsService {

    List<Daily_Claim_JSONResponse> doRestAPIPost(Map<String,String> mapAPILog, String JSONString);

}
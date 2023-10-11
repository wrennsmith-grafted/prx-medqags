/** 
 * @description       : IHistorical_ClaimsService class.
 * @author            : jyothi.gandhamaneni@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-18-2021
 * @last modified by  : Jyothi Gandhamaneni
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-18-2021   Jyothi Gandhamaneni			   Initial Version
 * 
 **/
public interface IPrior_AuthService {

    List<Prior_Auth_JSONResponse> doRestAPIPost(Map<String,String> mapAPILog, String JSONString);
}
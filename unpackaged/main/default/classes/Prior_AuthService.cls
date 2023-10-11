/** 
 * @description       : Prior_AuthService class.
 * @author            : jyothi.gandhamaneni@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-18-2021
 * @last modified by  : Jyothi Gandhamaneni
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-18-2021   Jyothi Gandhamaneni			   Initial Version
 * 
 **/
public with sharing class Prior_AuthService {

    public static List<Prior_Auth_JSONResponse> doRestAPIPost(Map<String,String> mapAPILog, String JSONString)
	{
		return service().doRestAPIPost(mapAPILog, JSONString);
	}

	private static IPrior_AuthService service()
	{
		return (IPrior_AuthService) PMd_Application.Service.newInstance(IPrior_AuthService.class);
	}
	
}
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
public with sharing class Daily_ClaimsService {

    public static List<Daily_Claim_JSONResponse> doRestAPIPost(Map<String,String> mapAPILog, String JSONString)
	{
		return service().doRestAPIPost(mapAPILog, JSONString);
	}

	private static IDaily_ClaimsService service()
	{
		return (IDaily_ClaimsService) PMd_Application.Service.newInstance(IDaily_ClaimsService.class);
	}
	
}
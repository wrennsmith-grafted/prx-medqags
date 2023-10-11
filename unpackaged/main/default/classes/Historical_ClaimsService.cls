public with sharing class Historical_ClaimsService {

    public static List<Historical_Claim_JSONResponse> doRestAPIPost(Map<String,String> mapAPILog, String JSONString)
	{
		return service().doRestAPIPost(mapAPILog, JSONString);
	}

	private static IHistorical_ClaimsService service()
	{
		return (IHistorical_ClaimsService) PMd_Application.Service.newInstance(IHistorical_ClaimsService.class);
	}
	
}
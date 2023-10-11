/**
 * @description       : SHA1 Service Interface
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 * 
 **/
public with sharing class SHA1UtilService {

    public static String getBase64SHA1Hash(String targetString)
	{
		return service().getBase64SHA1Hash(targetString);
	}

	private static ISHA1UtilService service()
	{
		return (ISHA1UtilService) PMd_Application.Service.newInstance(ISHA1UtilService.class);
	}

}
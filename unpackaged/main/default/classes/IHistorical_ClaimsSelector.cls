public interface IHistorical_ClaimsSelector extends fflib_ISObjectSelector 
{
	List<Historical_Claim__c> selectById(Set<Id> idSet);
}
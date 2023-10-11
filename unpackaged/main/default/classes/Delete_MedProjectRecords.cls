public class Delete_MedProjectRecords{
    public static void deleteAllRecords() {
        deleteContacts();
        deleteContactsDrugs();
        deleteClaimInfo();
        deleteCases();
        deleteDailyClaims();
        deleteHistoricalClaims();
        deletePriorAuth();
        deleteHistoricalPriorAuth();
        deleteMemberDemographic();
        deleteProviderDemographics();
        //deleteCSAs();
        //deleteDrugs();
        deleteContracts();
        //deleteAccounts();
    }
    public static void deleteContacts() {
        List<Contact> allcons=[Select Id,Name from Contact limit 9000];
        List<Case> allcases=[Select Id from Case where ContactId in:allcons];
        Database.delete(allcases,false);
        Database.delete(allcons,false);
    }
    public static void deleteContactsDrugs() {
        List<Contact_Drug__c> allcondrugs=[Select Id,Name from Contact_Drug__c limit 9000];
        Database.delete(allcondrugs,false);
    }
    public static void deleteClaimInfo() {
        List<Claim_Information__c> allclaims=[Select Id,Name from Claim_Information__c limit 9000];
        Database.delete(allclaims,false);
    }
    public static void deleteCases() {
        List<Case> allcases=[Select Id from Case limit 9000];
        Database.delete(allcases,false);
    }
    public static void deleteDailyClaims() {
        List<Daily_Claim__c> alldclaims=[Select Id,Name from Daily_Claim__c limit 9000];
        Database.delete(alldclaims,false);
    }
    public static void deleteHistoricalClaims() {
        List<Historical_Claim__c> allHist=[Select Id,Name from Historical_Claim__c limit 9000];
        Database.delete(allHist,false);
    }
    public static void deletePriorAuth() {
        List<Prior_Auth__c> allPrior=[Select Id,Name from Prior_Auth__c limit 9000];
        Database.delete(allPrior,false);
    }
    public static void deleteHistoricalPriorAuth() {
        List<Historical_Prior_Auth__c> allhist=[Select Id,Name from Historical_Prior_Auth__c limit 9000];
        Database.delete(allhist,false);
    }
    public static void deleteMemberDemographic() {
        List<Member_Demographic__c> allmem=[Select Id,Name from Member_Demographic__c limit 9000];
        Database.delete(allmem,false);
    }
    public static void deleteProviderDemographics() {
        List<Provider_Demographic__c> allProvdemo=[Select Id,Name from Provider_Demographic__c limit 9000];
        Database.delete(allProvdemo,false);
    }
    /*
    public static void deleteCSAs() {
        List<CSA__c> allCSAs=[Select Id,Name from CSA__c limit 9000];
        Database.delete(allCSAs,false);
    }
    public static void deleteDrugs() {
        List<Drug__c> allDrugs=[Select Id,Name from Drug__c limit 9000];
        Database.delete(allDrugs,false);
    }
    */
    public static void deleteContracts() {
        List<Contract> allContracts=[Select Id,Name from Contract limit 9000];
        Database.delete(allContracts,false);
    }
/*
    public static void deleteAccounts() {
        List<Account> allAccounts=[Select Id,Name from Account limit 9000];
        Database.delete(allAccounts,false);
    }
*/
}
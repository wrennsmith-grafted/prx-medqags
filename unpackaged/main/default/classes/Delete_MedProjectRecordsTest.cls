@IsTest
private class Delete_MedProjectRecordsTest{
    private static testmethod void deleteMedrecords() {
        Delete_MedProjectRecords.deleteContacts();
        Delete_MedProjectRecords.deleteContactsDrugs();
        Delete_MedProjectRecords.deleteClaimInfo();
        Delete_MedProjectRecords.deleteCases();
        Delete_MedProjectRecords.deleteDailyClaims();
        Delete_MedProjectRecords.deleteHistoricalClaims();
        Delete_MedProjectRecords.deletePriorAuth();
        Delete_MedProjectRecords.deleteHistoricalPriorAuth();
        Delete_MedProjectRecords.deleteMemberDemographic();
        Delete_MedProjectRecords.deleteProviderDemographics();
        //Delete_MedProjectRecords.deleteCSAs();
        //Delete_MedProjectRecords.deleteDrugs();
        Delete_MedProjectRecords.deleteContracts();
        //Delete_MedProjectRecords.deleteAccounts();
        Delete_MedProjectRecords.deleteAllRecords();
    }
}
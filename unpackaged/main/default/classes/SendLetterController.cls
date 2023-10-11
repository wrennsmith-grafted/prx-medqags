public with sharing class SendLetterController {
    @AuraEnabled
    public static String sendLetterProcess(String contactId, String letterType) {
        return LetterService.processLetterForContact(contactId,letterType);
    }   
    
    @AuraEnabled
    public static String displayLetterButtonStatus(String contactId) {
        return LetterService.displayLetterButtonStatus(contactId);
    }
}
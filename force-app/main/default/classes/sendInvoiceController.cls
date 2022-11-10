public with sharing class sendInvoiceController {
    @AuraEnabled(cacheable=true)
    public static void sendEmailToController(String body, String toSend, String subject){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {toSend};
            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setHtmlBody('<h1>'+ body + '</h1>');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getTemplateBody()
    {
        List<EmailTemplate> tempList = [SELECT id, Body FROM EmailTemplate WHERE id='00X5i000000YRrjEAG'];

        System.debug('tempList[0].Body ' + tempList[0].Body);
        return tempList[0].Body;

    }

    @AuraEnabled(cacheable=true)
    public static Contact getContact(String recordId)
    {
        System.debug('recordId ' + recordId);
        
        List<OpportunityContactRole> OCRlist2 = [SELECT OpportunityId, ContactId FROM OpportunityContactRole
                  WHERE OpportunityId = :recordId];

        String cId = OCRlist2[0].ContactId;
        
        List<Contact> result = [SELECT Name, Email FROM Contact WHERE id=:cId];

        System.debug('result[0] ' + result[0].Name);
        return result[0];
    }

        @AuraEnabled(cacheable=true)
        public static Map<ID, String> getRelatedFilesByRecordId(String recordId) {
            // Get record file IDs        
            List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            List<ID> fileIDs = new List<ID>();
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
     
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
            Map<ID, String> mapIdTitle = new Map<ID, String>();
            for (ContentVersion docLink : docs) {
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
            }
            return mapIdTitle;
        }
}
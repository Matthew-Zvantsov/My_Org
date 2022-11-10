@isTest
public class sendInvoiceControllerTest {
    @isTest
    public static void sendEmailToControllerTest() {
        Test.StartTest();
        sendInvoiceController.sendEmailToController('Unit Test X','test@test.com', 'Unit Test');
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
 
        System.assertEquals(1, invocations, 'An email has not been sent');
    }
    @isTest
    public static void getTemplateBodyTestPositive() {
        String str = sendInvoiceController.getTemplateBody();
        System.assertEquals('... нужно придумать текст письма клиенту', str);
    }
    @isTest
    public static void getContactTest() {
        Contact con = new Contact(LastName = 'Test');
        insert con;
        Contact coninsert = [SELECT id FROM Contact LIMIT 1];
        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId = '0065i000003qS9zAAE', ContactId = coninsert.id);
        insert ocr;
        Contact result = sendInvoiceController.getContact('0065i000003qS9zAAE');

        System.assertEquals('Test', result.Name);
    }

    @isTest
    public static void getRelatedFilesByRecordIdTest() {
        Opportunity opp = new Opportunity(Name = 'Test opp', StageName = 'Closed', CloseDate = date.parse('12/27/2009'));
        insert opp;
        Opportunity oppData = [SELECT id FROM Opportunity WHERE Name LIKE '%Test%' LIMIT 1];

        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; 
        cVersion.PathOnClient = 'Test';
        cVersion.Origin = 'H';
        cVersion.OwnerId = '0055i000001DSLqAAO';
        cVersion.Title = 'Test';
        cVersion.VersionData = blob.valueof('TEST');
        insert cVersion;

        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;

        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;
        cDocLink.LinkedEntityId = oppData.id;
        cDocLink.ShareType = 'I';
        cDocLink.Visibility = 'InternalUsers';
        cDocLink.Visibility = 'AllUsers';
        insert cDocLink;

        Map<ID, String> result = sendInvoiceController.getRelatedFilesByRecordId(oppData.id);

        List<String> value = result.values();
        System.debug('result ' + result);
        System.assertEquals('Test', value[0]);
    }
    
}
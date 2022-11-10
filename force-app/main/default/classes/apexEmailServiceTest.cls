@isTest
public class apexEmailServiceTest {
    @isTest
    public static void apexEmailTest()
    {
        Opportunity opp = new Opportunity(Name = 'Test opp', StageName = 'Closed Won', CloseDate = date.parse('12/27/2009'));
        insert opp;
        Opportunity oppData = [SELECT id, Invoice_Number__c, StageName FROM Opportunity WHERE Name LIKE '%Test%' LIMIT 1];
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = oppData.Invoice_Number__c;
        email.fromname = 'Test Test';
        env.fromAddress = 'Test@email.com';
        email.plainTextBody = 'Test';
        apexEmailService emailProcess = new apexEmailService();
        emailProcess.handleInboundEmail(email, env);
        System.assertEquals(oppData.StageName ,'Closed Won');
    }

    @isTest
    public static void apexEmailTest1()
    {
        Opportunity opp = new Opportunity(Name = 'Test opp', StageName = 'Prospecting', CloseDate = date.parse('12/27/2009'));
        insert opp;
        Opportunity oppData = [SELECT id, Invoice_Number__c, StageName FROM Opportunity WHERE Name LIKE '%Test%' LIMIT 1];
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = oppData.Invoice_Number__c;
        email.fromname = 'Test Test';
        env.fromAddress = 'Test@email.com';
        email.plainTextBody = 'Approved';
        apexEmailService emailProcess = new apexEmailService();
        emailProcess.handleInboundEmail(email, env);
        Opportunity oppData2 = [SELECT id, Invoice_Number__c, StageName FROM Opportunity WHERE Name LIKE '%Test%' LIMIT 1];
        System.assertEquals(oppData2.StageName ,'Qualification');
    }

    @isTest
    public static void apexEmailTest2()
    {
        Opportunity opp = new Opportunity(Name = 'Test opp', StageName = 'Prospecting', CloseDate = date.parse('12/27/2009'));
        insert opp;
        Opportunity oppData = [SELECT id, Invoice_Number__c, StageName FROM Opportunity WHERE Name LIKE '%Test%' LIMIT 1];
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = oppData.Invoice_Number__c;
        email.fromname = 'Test Test';
        env.fromAddress = 'Test@email.com';
        email.plainTextBody = 'Rejected';
        apexEmailService emailProcess = new apexEmailService();
        emailProcess.handleInboundEmail(email, env);
        Opportunity oppData2 = [SELECT id, Invoice_Number__c, StageName FROM Opportunity WHERE Name LIKE '%Test%' LIMIT 1];
        System.assertEquals(oppData2.StageName ,'Closed Lost');
    }

    @isTest
    public static void apexEmailTest3()
    {
        Opportunity opp = new Opportunity(Name = 'Test opp', StageName = 'Prospecting', CloseDate = date.parse('12/27/2009'));
        insert opp;
        Opportunity oppData = [SELECT id, Invoice_Number__c, StageName FROM Opportunity WHERE Name LIKE '%Test%' LIMIT 1];
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = oppData.Invoice_Number__c;
        email.fromname = 'Test Test';
        env.fromAddress = 'Test@email.com';
        email.plainTextBody = 'Something';
        apexEmailService emailProcess = new apexEmailService();
        emailProcess.handleInboundEmail(email, env);
        Opportunity oppData2 = [SELECT id, Invoice_Number__c, StageName FROM Opportunity WHERE Name LIKE '%Test%' LIMIT 1];
        System.assertEquals(oppData2.StageName ,'Something');
    }
}
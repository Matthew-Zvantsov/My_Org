@isTest
public class vsTestingMethods {
    @isTest
    public static void testOLIOCRController()
        {
            Opportunity opp = new Opportunity(Name = 'Test opp', StageName = 'Closed', CloseDate = date.parse('12/27/2009'));
            insert opp;
            PageReference testPage = Page.Invoice;
            Test.setCurrentPage(testPage);
            testPage.getParameters().put('Id', String.valueOf(opp.Id));
            
            ApexPages.StandardController sc = new ApexPages.StandardController(opp);
            OLIController ext = new OLIController(sc);
            OCRController ext2 = new OCRController(sc);
            
            List<Opportunity> ol = [Select Name from Opportunity where Name LIKE '%Test%' LIMIT 1];
            System.assertEquals(1, ol.size());
        }
    @isTest
    public static void testSupportController()
    {
        Opportunity opp = new Opportunity(Name = 'Test opp', StageName = 'Closed', CloseDate = date.parse('12/27/2009'));
        insert opp;
        List<Opportunity> ol = [Select Name from Opportunity where Name LIKE '%Test%' LIMIT 1];
        
        Test.startTest();
        PageReference testPage = Page.Support;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(opp.Id));
        supportController cont = new supportController();
        cont.savePDF();
        Test.stopTest();
        
        List<ContentVersion> cv = [SELECT id FROM ContentVersion LIMIT 200];
        System.assertEquals(1, cv.size());
        
        cont.savePDF();
        System.assertEquals(1, cv.size());
        
    }

}
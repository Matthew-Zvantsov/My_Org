@isTest
public class customersDataControllerTest {
    @isTest
    public static void getAccsTest() 
    {
        Account acc = new Account(Name = 'Test');
        insert acc;
        Account accData = [SELECT id FROM Account LIMIT 1];
        List<Account> acclist = customersDataController.getAccs('Test');
        Account accSingle = customersDataController.getSingleAcc(accData.id);
        System.assertEquals('Test', acclist[0].Name);
        System.assertEquals('Test', accSingle.Name);
    }
    @isTest
    public static void getProducts() 
    {
        Opportunity opp = new Opportunity(Name = 'Test opp', StageName = 'Closed', CloseDate = date.parse('12/27/2009'));
        insert opp;
        Opportunity oppData = [SELECT id FROM Opportunity WHERE Name LIKE '%Test%' LIMIT 1];

        Product2 prod = new Product2(Name = 'Test');
        insert prod;
        Product2 prodData = [SELECT id FROM Product2 LIMIT 1];

        PriceBookEntry stdPriceBookEntry = new PriceBookEntry();
        stdPriceBookEntry.Pricebook2Id=Test.getStandardPricebookId();
        stdPriceBookEntry.Product2Id=prodData.Id;
        stdPriceBookEntry.UnitPrice=2000;
        stdPriceBookEntry.IsActive=true;
        insert stdPriceBookEntry;

        PriceBookEntry stdPriceBookEntryData = [SELECT id FROM PriceBookEntry LIMIT 1];

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = oppData.id, Quantity = 111, TotalPrice = 111, PricebookEntryId = stdPriceBookEntryData.id);
        insert oli;

        List<OpportunityLineItem> oliList = customersDataController.getProducts(oppData.id);
        System.assertEquals(111, oliList[0].Quantity);
    }
}
@IsTest
public class apexWebServiceTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Phone = '12345';
        insert acc;
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.Phone = '12345';
        insert con;
    }

    /* @isTest
    public static void testCreatePayment() 
    {
        apexWebService aws = new apexWebService();
        aws.Amount = 345;
        aws.FirstName = 'Matthew';
        aws.Opportunity = '0065i000003BpYwAAK';
        apexWebService[] awsL = new apexWebService[] {aws};
        List<Payment__c> pL = apexWebService.createPayment(awsL);
        System.assert(pL != null);
        Payment__c p = [SELECT First_Name__c FROM Payment__c LIMIT 1];
        System.assertEquals(p.First_Name__c , 'Matthew');
    } */

    @isTest
    public static void catchCallTest() 
    {
        /* Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Phone = '123454321';
        insert acc; */
        String result = apexWebService.numberAnalyzer('12345');
        System.assertEquals('acc' ,result);
    }
}
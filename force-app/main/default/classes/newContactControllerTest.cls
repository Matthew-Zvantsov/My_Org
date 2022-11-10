@isTest
public with sharing class newContactControllerTest {
    @isTest
    public static void checkContactTest()
    {
        String result = newContactController.checkContact('First', 'Last', 'm.zvantsov@gmail.com');
        System.assertEquals('', result);
        Contact con = new Contact();
        con.FirstName = 'First';
        con.LastName = 'Last';
        con.Email = 'm.zvantsov@gmail.com';
        insert con;
        String result2 = newContactController.checkContact('First', 'Last', 'm.zvantsov@gmail.com');
        System.assertNotEquals('', result2);
    }

    @isTest
    public static void createContactTest()
    {
        newContactController.createContact('First', 'Last', 'm.zvantsov@gmail.com', '12345', 'Test');
        Contact con = [SELECT Id FROM CONTACT WHERE Email = 'm.zvantsov@gmail.com'];
        System.assertNotEquals(null, con);
        Case cs = [SELECT Id FROM CASE WHERE ContactId =: con.Id];
        System.assertNotEquals(null, cs);
    }

    @isTest
    public static void createCaseTest()
    {
        Contact con = new Contact();
        con.FirstName = 'First';
        con.LastName = 'Last';
        con.Email = 'm.zvantsov@gmail.com';
        insert con;
        newContactController.createCase('Test', con.Id);
        Case cs = [SELECT Id FROM CASE WHERE ContactId =: con.Id];
        System.assertNotEquals(null, cs);
    }
}
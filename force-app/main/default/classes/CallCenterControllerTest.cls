@isTest
public with sharing class CallCenterControllerTest {
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
    @isTest
    public static void newAccountTest()
    {
        String result = CallCenterController.newAccount('12345', 'Test Name', 'm.zvantsov@gmail.com', True, False);
        System.assertEquals('Business Success', result);
        result = CallCenterController.newAccount('12345', 'Test Name', 'm.zvantsov@gmail.com', False, True);
        System.assertEquals('Person Success', result);
        result = CallCenterController.newAccount('12345', 'Test Name', 'm.zvantsov@gmail.com', False, False);
        System.assertEquals('wrong', result);
    }

    @isTest
    public static void newContactTest()
    {
        String result = CallCenterController.newContact('12345', 'Test Name', 'm.zvantsov@gmail.com', 'Test Department');
        System.assertEquals('Success', result);
    }

    @isTest
    public static void getContTest()
    {
        List<Contact> conlst = CallCenterController.getCont('Test Contact');
        System.assertNotEquals(0, conlst.size());
        conlst = CallCenterController.getCont('');
        System.assertEquals(0, conlst.size());
    }

    @isTest
    public static void getAccsTest()
    {
        List<Account> acclst = CallCenterController.getAccs('Test Account');
        System.assertNotEquals(0, acclst.size());
        acclst = CallCenterController.getAccs('');
        System.assertEquals(0, acclst.size());
    }

    @isTest
    public static void getAccountsByPhoneTest()
    {
        List<Account> acclst = CallCenterController.getAccountsByPhone('12345');
        System.assertNotEquals(0, acclst.size());
        acclst = CallCenterController.getAccountsByPhone('123');
        System.assertEquals(0, acclst.size());
    }

    @isTest
    public static void getContactsByPhoneTest()
    {
        List<Contact> conlst = CallCenterController.getContactsByPhone('12345');
        System.assertNotEquals(0, conlst.size());
        conlst = CallCenterController.getContactsByPhone('123');
        System.assertEquals(0, conlst.size());
    }
}
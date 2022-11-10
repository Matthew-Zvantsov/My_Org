public with sharing class newContactController {
    @AuraEnabled
    public static String checkContact(String newFirst, String newLast, String newEmail)
    {
        List<Contact> conlst = [SELECT Id, FirstName, LastName, Email FROM Contact];
        for(Contact con : conlst)
        {
        if(newFirst == con.FirstName && newLast == con.LastName && newEmail == con.Email)
        {
            System.debug('Find');
            System.debug('con.Id' + con.Id);
            System.debug('con.LastName' + con.LastName);
            return con.Id;
        }
        }
        return '';
    }

    @AuraEnabled
    public static void createContact(String newFirst, String newLast, String newEmail, String newNumb, String newMessage){
        Contact con = new Contact();
        con.FirstName = newFirst;
        con.LastName = newLast;
        con.Email = newEmail;
        con.Phone = newNumb;
        con.Message__c = newMessage;
        System.debug('contact' + con);
        insert con;
        Case cs = new Case();
        cs.ContactId = con.Id;
        cs.Description = con.Message__c;
        insert cs;
    }

    @AuraEnabled
    public static void createCase(String newMessage, String newContactId){
        Case cs = new Case();
        cs.ContactId = newContactId;
        cs.Description = newMessage;
        insert cs;
    }
}
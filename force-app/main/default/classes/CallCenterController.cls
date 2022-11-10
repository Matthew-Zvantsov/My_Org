public without sharing class CallCenterController {

    @AuraEnabled
    public static String newAccount(String newNumb, String newName, String newEmailOrWebsite, Boolean isBusiness, Boolean isPerson)
    {
        String recordTypeId;

        if(isBusiness)
        {
            recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            Account acc = new Account(RecordTypeId = recordTypeId);
            acc.Name = newName;
            acc.Phone = newNumb;
            acc.Website = newEmailOrWebsite;
            acc.Record_Type__c = 'Business';
            insert acc;
            return 'Business Success';
        }
        if(isPerson)
        {
            recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account acc = new Account(RecordTypeId = recordTypeId);
            acc.LastName = newName;
            acc.Phone = newNumb;
            acc.PersonEmail = newEmailOrWebsite;
            acc.Record_Type__c = 'Person';
            insert acc;
            return 'Person Success';
        }
        return 'wrong';
    }

    @AuraEnabled
    public static string newContact(String newNumb, String newName, String newEmail, String newDepartment)
    {
        Contact con = new Contact();
        con.LastName = newName;
        con.Phone = newNumb;
        con.Email = newEmail;
        con.Department = newDepartment;
        insert con;
        return 'Success';
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccs(String accStrName){
        if(accStrName != '')
        {
            String keyNameString = '%' +  accStrName + '%';
            List<Account> acc = [SELECT id, Name, ShippingCountry, Industry, Record_Type__c FROM Account WHERE Name like:keyNameString];
            return acc;
        }
        List<Account> acc = new List<Account>();
        return acc;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getCont(String conStrName){
        if(conStrName != '')
        {
            String keyNameString = '%' +  conStrName + '%';
            List<Contact> con = [SELECT id, Name, Phone, Email, Department FROM Contact WHERE Name like:keyNameString];
            return con;
        }
        List<Contact> con = new List<Contact>();
        return con;
    }

    @AuraEnabled
    public static List<Account> getAccountsByPhone(String phone){
        List<Account> acc = [SELECT id, Name, ShippingCountry, Industry, Record_Type__c FROM Account WHERE Phone =: phone];
        return acc;
    }

    @AuraEnabled
    public static List<Contact> getContactsByPhone(String phone){
        List<Contact> con = [SELECT id, Name, Phone, Email, Department FROM Contact WHERE Phone =: phone];
        return con;
    }
}
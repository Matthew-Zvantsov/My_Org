public with sharing class customersDataController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccs(String accStrName){
            String keyNameString = '%' +  accStrName + '%';
            String stage = '%' + 'Close' + '%';
            List<Account> acc = [SELECT id, Name, Support__c, (SELECT id, Name, Amount, Date__c, StageName, CloseDate FROM Opportunities WHERE StageName like:stage) FROM Account WHERE Support__c like:keyNameString];
            System.debug('acc ' + acc);
            List<Account> result;
            return acc;
    }

    @AuraEnabled(cacheable=true)
    public static Account getSingleAcc(String recordId){
            Account acc = [SELECT id, Name, Support__c, (SELECT id, Name, Amount, Date__c, CloseDate FROM Opportunities) FROM Account WHERE Id =: recordId LIMIT 1];
            System.debug('acc ' + acc);
            return acc;
    }

    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getProducts(String oppId){
            List<OpportunityLineItem> prod = [SELECT Name, Quantity, UnitPrice, TotalPrice  FROM OpportunityLineItem WHERE OpportunityId =: oppId];
            System.debug('prod ' + prod);
            return prod;
    }
}
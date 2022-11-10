trigger paymentTrigger on Payment__c (after insert) 
{
    datetime mydate = datetime.now();
    DateTime myDateTime = DateTime.newInstance(mydate.year(), mydate.month(), mydate.day() + 1, 3, 0, 0);

    System.debug('myDateTime '+myDateTime);

    //List<Payment__c> newPay = [SELECT id, Opportunity__c FROM Payment__c WHERE id IN : Trigger.New];
    List<String> ids = new List<String> ();
    for(Payment__c p : Trigger.New)
    {
        System.debug('p '+p);
        String s = p.Opportunity__c;
        ids.add(s);
    }
    List<Opportunity> allOpp = [SELECT id, Name, Amount, StageName, 
                                (SELECT id, Amount__c FROM Payments__r), 
                                (SELECT Contact.OwnerId FROM OpportunityContactRoles) 
                                FROM Opportunity WHERE id IN : ids];

    System.debug('allOpp'+ allOpp);
    
    List<Opportunity> forUpdate = new List<Opportunity>();
    List<Task> forInsert = new List<Task>();
    for(Opportunity opp : allOpp)
    {
        Decimal sumAmount = 0;
        for(Payment__c p : opp.Payments__r)
        {
            System.debug('p.Amount__c '+p.Amount__c);
            sumAmount += p.Amount__c;
        }

        System.debug('sumAmount '+sumAmount);

        if(opp.Amount > sumAmount && opp.StageName != 'Partially Paid')
        {
            opp.StageName = 'Partially Paid';
            forUpdate.add(opp);
        }
        if(opp.Amount <= sumAmount && sumAmount != 0 && opp.StageName != 'Fully Paid')
        {
            

            opp.StageName = 'Fully Paid';
            forUpdate.add(opp);
            System.debug('forUpdate '+forUpdate);
            Task newTask = new Task();
            newTask.OwnerId = opp.OpportunityContactRoles[0].Contact.OwnerId;
            newTask.Priority = 'Hight';
            newTask.Status = 'Not Started';
            newTask.Subject = 'Delivery of goods';
            newTask.ReminderDateTime = myDateTime;
            newTask.WhatId = opp.id;
            forInsert.add(newTask);
        }
    }

    System.debug('forInsert '+forInsert);
    System.debug('forUpdate '+forUpdate);
    insert forInsert;
    update forUpdate;

}
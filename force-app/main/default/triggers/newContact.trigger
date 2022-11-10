trigger newContact on CONTACT (before insert) 
{    
    /* List<Contact> conlst = [SELECT Id, FirstName, LastName, Email FROM Contact];
    Contact newcon  = Trigger.new[0];
    for(Contact con : conlst)
    {
        if(newcon.FirstName == con.FirstName && newcon.LastName == con.LastName && newcon.Email == con.Email)
        {
            System.debug('Find');
            System.debug('con.Id' + con.Id);
            System.debug('con.LastName' + con.LastName);
            System.debug('newcon.Message__c' + newcon.Message__c);
            Case newcase = [SELECT id, Description FROM Case WHERE ContactId =: con.Id];
            System.debug('newcase ' + newcase);
            newcase.Description = newcon.Message__c;
            try {
                update newcase;
             } catch (DmlException e) {
             System.debug('Wrong');
             }
        }
    } */
}
global class SendBirthdayEmailBatch implements Database.Batchable<sObject>{   
     
    global SendBirthdayEmailBatch(){
    }
     
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = '';
        Date tday = System.today();
        Integer day = tday.day(); 
        Integer month = tday.month(); 
        query = 'SELECT id FROM Contact WHERE CALENDAR_MONTH(Birthdate) =: month and DAY_IN_MONTH(Birthdate) =: day';
        return Database.getQueryLocator(query);
    }
         
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        list<Messaging.SingleEmailMessage> emails = new list<Messaging.SingleEmailMessage>();
        for(Contact c : scope){
            Messaging.SingleEmailMessage email = EmailService.getEmailTemplate(c.Id);
            emails.add(email);
        }
         
        if(!emails.IsEmpty())
            Messaging.sendEmail(emails);
    }
         
    global void finish(Database.BatchableContext BC)
    {
        //System.abortJob(BC.getJobId());
    } 
}
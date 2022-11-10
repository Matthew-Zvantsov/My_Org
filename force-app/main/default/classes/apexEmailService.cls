global class apexEmailService implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(
    Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {


       String invNumber = email.subject;
      
       System.debug('email.subject ' + email.subject);

       Opportunity opp = [SELECT id, StageName, Name FROM Opportunity WHERE Invoice_Number__c =: invNumber LIMIT 1];

       System.debug('opp ' + opp);

       String response = email.plainTextBody.deleteWhitespace();

       Matcher m = Pattern.compile('(?m)^([\\w\\s]*):(.*)$').matcher(response);
       
       List<String> pickListValuesList= new List<String>();
	   Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
	   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       System.debug('ple ' + ple);

       if(opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost')
       {
           if(response == 'Approved')
           {
               System.debug('In approved ' + response);

               for(Integer i = 0; i < ple.size(); i++)
               {
                   String currentple = ple[i].getValue();
                   System.debug('currentple ' + currentple);
                   if(opp.StageName == currentple)
                   {
                       opp.StageName = ple[i+1].getValue();
                       break;
                   }
               }
           }

           else if (response == 'Rejected')
           {
               System.debug('In Rejected ' + response);
               opp.StageName = 'Closed Lost';
           }

           else
           {
              System.debug('In else ' + response);
              opp.StageName = response;
           }
       }
               
       System.debug('opp ' + opp);
       update opp;
      
       Messaging.InboundEmailresult result = new Messaging.InboundEmailResult();
       result.message = 'You have successfully updated this Opportunities stage to ' + opp.StageName;
       return result;
    }
}
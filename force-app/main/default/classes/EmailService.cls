public class EmailService {
    public static Messaging.SingleEmailMessage getEmailTemplate(Id contactId)
    {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Id tempID;
        Try{
            tempID = [select Id from EmailTemplate where developername = 'forBatch'].id;
        }catch(Exception e){
            return null;
        }
        email.setTargetObjectId(contactId);
        email.setTemplateId(tempID);
        return email;                                                        
    }
}
public class PlatformEventCtrl {
     
    public static Database.SaveResult publishEvent(String message, String phone){
        Raw_Phone_Change__e event = new Raw_Phone_Change__e();
        event.message__c = message;
        event.phone__c = phone;
        System.debug('event.message__c  ' + event.message__c);
        
        return EventBus.publish(event);
    }
}
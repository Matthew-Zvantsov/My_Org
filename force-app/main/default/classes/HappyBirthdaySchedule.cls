global class HappyBirthdaySchedule implements System.Schedulable {
    global void execute(SchedulableContext sc) {
         SendBirthdayEmailBatch b = new SendBirthdayEmailBatch();
         Database.executeBatch(b);
    }
 }
public with sharing class HappyBirthdayController 
{
    @AuraEnabled
    public static void ScheduleOrBatch(String classBatchName, String classScheduleName, String CRONstr, Boolean isBatch)
    {
        if(isBatch)
        {           
            Type newBatchType = Type.forName(classBatchName);
            Object instance = newBatchType.newInstance();
            Database.executeBatch((Database.Batchable<sObject>)instance);
        }
        else
        {
            Type newSchedulerType = Type.forName(classScheduleName);
            System.schedule('Happy Birthday', CRONstr, (Schedulable)newSchedulerType.newInstance());
        }
    }
    @AuraEnabled
    public static void deleteJob()
    {
        CronTrigger obj = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id,State FROM CronTrigger where CronJobDetail.Name = 'Happy Birthday'];
        System.abortJob(obj.Id);
    }

    @AuraEnabled(cacheable = true)
    public static String checkJob()
    {
        System.debug('Hello');

        List<CronTrigger> obj = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id,State FROM CronTrigger where CronJobDetail.Name = 'Happy Birthday'];

        System.debug('obj ' + obj);

        if(obj.size() == 0)
        {
            return 'false';
        }
        else
        {
            return 'true';
        }
    }
}
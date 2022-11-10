@isTest
public with sharing class PlatformEventCtrlTest {
    @isTest static void publishEventTest() 
    {
        Test.startTest();
        Database.SaveResult sr = PlatformEventCtrl.publishEvent('message', 'phone');
        Test.stopTest();
        System.assertEquals(true, sr.isSuccess());
    }
}
@RestResource(urlMapping='/apexWebService/Phone/*')
global with sharing class apexWebService {
    public String phone;
    @HttpPost
    global static String catchCall(String phone) 
    {
        RestRequest request = RestContext.request;
        String result = apexWebService.numberAnalyzer(phone);
        PlatformEventCtrl.publishEvent(result, phone);
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/json');
        response.responseBody = Blob.valueOf('{ "Model2ApiService" : "EXECUTED" }');
        response.statusCode = 201;
        return result;
    }   
    public static String numberAnalyzer(String searchNumb){
        List<List<SObject>> searchList = [FIND :searchNumb IN PHONE FIELDS RETURNING Account(Id, Name, Phone, RecordType.Name), 
                                                                                  Contact(Id, Name, Phone)];

        if(searchList[0].size() == 0 && searchList[1].size() == 0)
        {
            return '0';
        }
        else
        {
            if(searchList[0].size() == 0 && searchList[1].size() != 0)
            {
                return 'cont';
            }
            if(searchList[0].size() != 0 && searchList[1].size() == 0)
            {
                return 'acc';
            }
            else
            {
                System.debug('searchList[0].id ' + searchList[0][0].id);
                return '1';
            }
        }
    }
}
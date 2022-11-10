public class OCRController 
{
    public Opportunity Opp {get;set;}
    public ApexPages.StandardController sc;
    public List<OpportunityContactRole> OCRlist2 {get ;set;}
    public OCRController(ApexPages.StandardController controller) 
    {
        this.Opp=(Opportunity)controller.getRecord();
        OCRlist2 = [SELECT OpportunityId, Contact.Name, Contact.Account.Name, Contact.Email, Contact.Phone FROM OpportunityContactRole
                  WHERE OpportunityId = :Opp.id];
    }
}
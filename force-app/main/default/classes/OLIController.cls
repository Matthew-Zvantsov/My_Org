public with sharing class OLIController 
{
public ApexPages.StandardController sc;
public Opportunity Opp {get;set;}
public List<OpportunityLineItem> OLIlist2 {get ;set;}

public OLIController(ApexPages.StandardController controller) 
{ 
this.Opp=(Opportunity)controller.getRecord();
OLIlist2 = [Select Name, Quantity, UnitPrice, TotalPrice, OpportunityId FROM OpportunityLineItem WHERE 
           OpportunityId = :Opp.id];
}
}
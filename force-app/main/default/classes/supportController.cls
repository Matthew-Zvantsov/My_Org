public with sharing class supportController
{
    public Opportunity Opp {get;set;}
    public String invNumber {get;set;}
    public String OwnerId {get;set;}
    public supportController() 
    {
        system.debug('Hello' +  ApexPages.currentPage().getParameters().get('id'));
        this.Opp = [SELECT Id, Invoice_Number__c, OwnerId FROM Opportunity WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
        this.invNumber = Opp.Invoice_Number__c + '.pdf';
        this.OwnerId = Opp.OwnerId;
        system.debug('Opp' + this.Opp);
    }   
    
    public PageReference savePDF() 
    {
      PageReference pdf = Page.Invoice;
      pdf.getParameters().put('id',Opp.id);
            
      List<ContentDocument> cdocs = [SELECT id, Title FROM ContentDocument WHERE Title =: invNumber];
        
      if(cdocs.Size() == 0)
      {      
          ContentVersion cVersion = new ContentVersion();
          cVersion.ContentLocation = 'S'; 
          cVersion.PathOnClient = invNumber;
          cVersion.Origin = 'H';
          cVersion.OwnerId = Opp.OwnerId;
          cVersion.Title = invNumber;
          
          if(!test.isRunningTest()){
          cVersion.VersionData = pdf.getContentAsPDF();
          }else{
          cVersion.VersionData = blob.valueof('TEST');
          }
          
          Insert cVersion;
          
          Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
          ContentDocumentLink cDocLink = new ContentDocumentLink();
          cDocLink.ContentDocumentId = conDocument;
          cDocLink.LinkedEntityId = Opp.id;
          cDocLink.ShareType = 'I';
          cDocLink.Visibility = 'InternalUsers';
          cDocLink.Visibility = 'AllUsers';
          Insert cDocLink;
          
          PageReference p = Page.Invoice;
          p.setRedirect(true);
          return pdf;  
      }
        else
        {
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentDocumentId = cdocs[0].id;
            cVersion.ContentLocation = 'S'; 
            cVersion.PathOnClient = invNumber;
            cVersion.Origin = 'H';
            cVersion.OwnerId = Opp.OwnerId;
            cVersion.Title = invNumber;
            
            if(!test.isRunningTest()){
            cVersion.VersionData = pdf.getContentAsPDF();
            }else{
            cVersion.VersionData = blob.valueof('TEST');
            }
            
            Insert cVersion;
            
            PageReference p = Page.Invoice;
            p.setRedirect(true);
            return pdf;
        }
    } 
}
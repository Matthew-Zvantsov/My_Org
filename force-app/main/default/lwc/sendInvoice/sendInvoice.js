import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import INVOICE_FIELD from '@salesforce/schema/Opportunity.Invoice_Number__c';
import sendEmailToController from '@salesforce/apex/sendInvoiceController.sendEmailToController'
import getTemplateBody from '@salesforce/apex/sendInvoiceController.getTemplateBody'
import getContact from '@salesforce/apex/sendInvoiceController.getContact'
import getRelatedFilesByRecordId  from '@salesforce/apex/sendInvoiceController.getRelatedFilesByRecordId'
import { NavigationMixin } from 'lightning/navigation';

const OPPORTUNITY_FIELDS = [INVOICE_FIELD];

export default class sendInvoice extends NavigationMixin(LightningElement) {
    disabled = false;
    @api recordId;
    @api objectApiName;

    @track body;

    @wire(getRecord, { recordId: '$recordId', fields: OPPORTUNITY_FIELDS })
    opportunity;

    @wire(getTemplateBody)
    template;

    @wire(getContact, { recordId: '$recordId'})
    contact;

    filesList =[];
    @wire(getRelatedFilesByRecordId, {recordId: '$recordId'})
    wiredResult({data, error}){ 
        if(data){ 
            console.log(data)
            this.filesList = Object.keys(data).map(item=>({"label":data[item],
             "value": item,
             "url":`/sfc/servlet.shepherd/document/download/${item}`
            }))
            console.log(this.filesList)
        }
        if(error){ 
            console.log(error)
        }
    }
    previewHandler(event){
        console.log(event.target.dataset.id)
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: event.target.dataset.id
            }
        })
    }

    get invoice() {
        return getFieldValue(this.opportunity.data, INVOICE_FIELD);
    }

    handleCancel(event) {
       this.dispatchEvent(new CloseActionScreenEvent());
    }

   sendEmailAfterEvent()
   {
    const recordInput = {body: this.body, toSend: this.contact.data.Email, subject: this.invoice} 
    sendEmailToController(recordInput)
    .then( () => {
        alert('The letter was sent!');
    }).catch( error => {
        alert('Error');
    })
   }

   handleInputChange(event) 
   {
    this.body = event.detail.value;
   }
}
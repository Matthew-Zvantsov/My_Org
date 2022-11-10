import { LightningElement, api, track, wire } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import newAccount from '@salesforce/apex/CallCenterController.newAccount';
import newContact from '@salesforce/apex/CallCenterController.newContact';
import getAccs from '@salesforce/apex/CallCenterController.getAccs';
import getCont from '@salesforce/apex/CallCenterController.getCont';
import getAccountsByPhone from '@salesforce/apex/CallCenterController.getAccountsByPhone';
import getContactsByPhone from '@salesforce/apex/CallCenterController.getContactsByPhone';
import { NavigationMixin } from 'lightning/navigation';
import header from '@salesforce/label/c.header';
import callerName from '@salesforce/label/c.callerName';
import ACCOUNTS from '@salesforce/label/c.ACCOUNTS';
import CONTACTS from '@salesforce/label/c.CONTACTS';
import NEW_BUSINESS_ACCOUNT from '@salesforce/label/c.NEW_BUSINESS_ACCOUNT';
import NEW_BUSINESS_CONTACT from '@salesforce/label/c.NEW_BUSINESS_CONTACT';
import NEW_PERSON_ACCOUNT from '@salesforce/label/c.NEW_PERSON_ACCOUNT';


const COLUMNS_FOR_ACC = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Country', fieldName: 'ShippingCountry'},
    { label: 'Industry', fieldName: 'Industry'},
    { label: 'Record Type', fieldName: 'Record_Type__c'}
];

const COLUMNS_FOR_CON = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Phone', fieldName: 'Phone'},
    { label: 'Email', fieldName: 'Email'},
    { label: 'Department', fieldName: 'Department'}
]

const DELAY = 100;

export default class CallCenter extends NavigationMixin(LightningElement) {

    label = {
        header,
        callerName,
        ACCOUNTS,
        CONTACTS,
        NEW_BUSINESS_ACCOUNT,
        NEW_BUSINESS_CONTACT,
        NEW_PERSON_ACCOUNT
    };

    columnsForCon=COLUMNS_FOR_CON;
    columnsForAcc=COLUMNS_FOR_ACC;
    @track isModalUnknownOpen = false;
    @track number;
    @track name;
    @api channelName = '/event/Raw_Phone_Change__e';
    @track emailOrWebsite;
    @track createAcc = false;
    @track createContact = false;
    @track person = false
    @track business = false
    @track department
    subscription;
    resp
    contactsByPhone;
    accountsByPhone;
    recordId;
    openListOfRecords = false;
    caseWhenAccAndCont = false;

    connectedCallback() {
        this.handleSubscribe();
    }

    handleSubscribe() {
        const self = this;
        const messageCallback = function (response) {
            var obj = JSON.parse(JSON.stringify(response));
            let objData = obj.data.payload;
            self.resp = objData.message__c;
            self.number = objData.phone__c;
            switch(self.resp)
            {
                case '0':
                    self.isModalUnknownOpen = true;
                    break
                case '1':
                    self.caseWhenAccAndCont = true;
                    self.handleSearchAccounts();
                    self.handleSearchContacts();
                    break
                case 'acc':
                    self.handleSearchAccounts();
                    break
                case 'cont':
                    self.handleSearchContacts();
                    break
            }
        };

        subscribe(self.channelName, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }

    handleSearchAccounts() {
        getAccountsByPhone({ phone: this.number})
            .then((result) => {
                if(result.length > 1)
                {
                    this.openListOfRecords = true;
                    this.accountsByPhone = result;
                }
                else
                    {
                        if(this.caseWhenAccAndCont == true)
                        {
                            this.openListOfRecords = true;
                            this.accountsByPhone = result;
                        }
                        else{
                            this.recordId = result[0].Id;
                            this.navigateToPage();
                        }
                    }
            })
            .catch((error) => {
                this.error = error;
                this.contacts = undefined;
            });
    }

    handleSearchContacts()
    {
        getContactsByPhone({ phone: this.number})
            .then((result) => {
                if(result.length > 1)
                {
                    this.openListOfRecords = true;
                    this.contactsByPhone = result;
                }
                else{
                    if(this.caseWhenAccAndCont == true)
                        {
                            this.openListOfRecords = true;
                            this.contactsByPhone = result;
                        }
                        else{
                            this.recordId = result[0].Id;
                            this.navigateToPage();
                        }
                }
            })
            .catch((error) => {
                this.error = error;
                this.contacts = undefined;
            });
    }

    navigateToPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view'
            }
        });
    }

    handleInputNumber(event)
    {
        this.number = event.detail.value;
    }

    handleInputName(event)
    {
        this.name = event.detail.value;
    }

    handleInputEmailOrWebsite(event)
    {
        this.emailOrWebsite = event.detail.value;
    }

    handleInputDepartment(event)
    {
        this.department = event.detail.value;
    }

    closeModal()
    {
        this.isModalUnknownOpen = false;
        this.openListOfRecords = false;
    }

    closecreateAcc()
    {
        this.createAcc = false;
    }

    newPersonAccount(event)
    { 
        this.isModalUnknownOpen = false;
        this.person = true;
        this.createAcc = true;
    }

    newBusinessAccount(event)
    {
        this.isModalUnknownOpen = false;
        this.business = true;
        this.createAcc = true;
    }

    newContact(event)
    {
        this.isModalUnknownOpen = false;
        this.createContact = true;
        this.person = true;
        this.createAcc = true;
    }

    createContact1(event)
    {
        newContact({ newNumb: this.number, newName: this.name, newEmail: this.newEmailOrWebsite, newDepartment: this.department})
        .then((result) => {

                const evt = new ShowToastEvent({
                    title: 'Account Created',
                    message: result,
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.createAcc = false;
                this.person = false;
                this.business = false;
        })
    }


    createAcc1(event)
    {
        newAccount({ newNumb: this.number, newName: this.name, newEmailOrWebsite: this.emailOrWebsite, isBusiness: this.business, isPerson: this.person})
        .then((result) => {
                const evt = new ShowToastEvent({
                    title: 'Account Created',
                    message: result,
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.createAcc = false;
                this.person = false;
                this.business = false;
        })
    }

    @track searchName = ''
    @track openTables = false;

    searchAccountAction(event){
        this.openTables = true;
        const searchString = event.target.value;
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.searchName = searchString; 
        }, DELAY);
    }


    @track retrieveAccs;

    @wire(getAccs,{accStrName:'$searchName'})
    wiredAccounts({error,data})
    {
        if (data) 
        {
            this.retrieveAccs = data;
        } 
        else 
        {
            if (error) 
            {
                this.error = error;
            }
        } 
        
    }

    @track retrieveCont;

    @wire(getCont,{conStrName:'$searchName'})
    wiredContacts({error,data})
    {
        if (data) 
        {
            this.retrieveCont = data;
        } 
        else 
        {
            if (error) 
            {
                this.error = error;
            }
        } 
        
    }
}
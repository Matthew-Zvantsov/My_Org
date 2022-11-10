import { LightningElement,api,wire,track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getAccs from '@salesforce/apex/customersDataController.getAccs';
import getProducts from '@salesforce/apex/customersDataController.getProducts';
import getSingleAcc from '@salesforce/apex/customersDataController.getSingleAcc';
import { getSObjectValue,refreshApex} from '@salesforce/apex';
import { CloseActionScreenEvent } from 'lightning/actions';
import Name from '@salesforce/schema/Account.Name';

const COLUMNS_FOR_ACC = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Amount', fieldName: 'Amount', type: 'Currency' },
    { label: 'CreatedDate', fieldName: 'Date__c', type: 'date' },
    { label: 'CloseDate', fieldName: 'CloseDate', type: 'date' },
    {
        label: 'View Products',
        type: 'button-icon',
        initialWidth: 75,
        typeAttributes: {
            iconName: 'action:preview',
            title: 'Preview',
            variant: 'border-filled',
            alternativeText: 'View'
        }
    }
];
const COLUMNS_FOR_PRODUCT = [
    {label: 'Product Name', fieldName: 'Name'},
    {label: 'Quantity', fieldName: 'Quantity'},
    {label: 'Unit Price', fieldName: 'UnitPrice'},
    {label: 'Total Price', fieldName: 'TotalPrice'}
];

const DELAY = 100;

export default class customersData extends LightningElement
{

    @api recordId
    columnsForProduct=COLUMNS_FOR_PRODUCT;
    columnsForAcc=COLUMNS_FOR_ACC;
    @track multiple = true;
    @track accountsThisPage ;
    @track accounts=[];
    recordsOnPage = 10;
    @track paginationRange = [];
    @track totalRecords;
    @track accountName;


    @wire(getSingleAcc, { recordId: '$recordId'})
    acc;

@wire(getAccs,{accStrName:'$accountName'})
wiredAccounts({error,data})
    {
        if (data) 
        {
            this.paginationRange = [];
            this.totalRecords=data.length;
            console.log('this.totalRecords ' + this.totalRecords);
            const paginationNumbers = Math.ceil(this.totalRecords / 10);
            console.log('paginationNumbers ' + paginationNumbers);
            
            let i = 0;
            this.accounts = [];
            while ( i < paginationNumbers ) 
            {
                var accsPerPages=[];
                let lim=(i+1)*this.recordsOnPage<this.totalRecords ? this.recordsOnPage : this.totalRecords-i*this.recordsOnPage;
                for(let j=0;j<lim;j++)
                {
                    accsPerPages.push(data[parseInt(i*this.recordsOnPage+j)]);
                }
                console.log('accsPerPages ' + accsPerPages);
                this.accounts.push(accsPerPages);
                this.paginationRange.push(i++);
                console.log('this.accounts.length' + this.accounts.length)
            }
            console.log('this.accounts[0]' + this.accounts[0].Name)
            this.accountsThisPage = this.accounts[0];
        } 
        else 
        {
            if (error) 
            {
                this.error = error;
            }
        } 
        
    }

    handlePaginationClick(event) {
        console.log('event.target.dataset.targetNumber: '+ event.target.dataset.targetNumber);
        this.accountsThisPage=this.accounts[event.target.dataset.targetNumber];
        this.accountsThisPage.forEach(function (item, key) { console.log(key); console.log(item); });
    }

    @track currentOpp;
    @track error;


    handleRowAction(event)
    {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log('row ' + row.Id);
        getProducts({oppId: row.Id})
        .then(result => {
            this.isModalOpen = true;
            this.currentOpp = result;
        })
        .catch(error => {
            this.error = error;
        });
    }

    @track isModalOpen = false;
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }

    accountName = '';

    searchAccountAction(event){
        //this.accountName = event.target.value;
        const searchString = event.target.value;
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.accountName = searchString; 
        }, DELAY);
    }
}
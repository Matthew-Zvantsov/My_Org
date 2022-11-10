import { LightningElement, track} from 'lwc';
import checkContact from '@salesforce/apex/newContactController.checkContact';
import createContact from '@salesforce/apex/newContactController.createContact';
import createCase from '@salesforce/apex/newContactController.createCase';
export default class NewContact extends LightningElement {


    modalText;
    isModalOpen = false;
    @track first;
    @track last;
    @track email;
    @track number;
    @track message;
    conId

    handleInputFirst(event)
    {
        this.first = event.detail.value;
    }

    handleInputLast(event)
    {
        this.last = event.detail.value;
    }

    handleInputEmail(event)
    {
        this.email = event.detail.value;
    }

    handleInputMessage(event)
    {
        this.message = event.detail.value;
    }

    handleInputNumber(event)
    {
        this.number = event.detail.value;
    }


    checkCon(event)
    {
        checkContact({ newNumb: this.number, newFirst: this.first, newLast: this.last, newEmail: this.email, newMessage: this.message})
        .then((result) => {
                if(result != '')
                {
                    this.conId = result;
                    this.createCase();
                }
                else{
                    this.createCon();
                }
        })
    }


    createCon()
    {
        createContact({ newNumb: this.number, newFirst: this.first, newLast: this.last, newEmail: this.email, newMessage: this.message})
        .then((result) => {
                this.modalText = 'Contact was created';
                this.isModalOpen = true;

        })
    }

    closeModal(event)
    {
        this.isModalOpen = false;
    }

    createCase()
    {
        createCase({newMessage: this.message, newContactId: this.conId})
        .then((result) => {
            this.modalText = 'New case was created';
            this.isModalOpen = true;
        })
    }

}
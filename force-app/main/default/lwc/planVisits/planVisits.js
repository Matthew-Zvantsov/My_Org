import { LightningElement, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';

export default class PlanVisits extends NavigationMixin(LightningElement)
{
    @api recordId;
    @api objectApiName;
    @track openModal = true;
    abortModal(event)
    {
        this.openModal = false;
        console.log('Hi')
    }

    closeModal(event)
    {
        this.openModal = false;
        console.log('Hi')
    }

    value = 'inProgress';

    get options() {
        return [
            { label: 'New', value: 'new' },
            { label: 'In Progress', value: 'inProgress' },
            { label: 'Finished', value: 'finished' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }
}
import { LightningElement, track, wire, api} from 'lwc';
import ScheduleOrBatch from '@salesforce/apex/HappyBirthdayController.ScheduleOrBatch';
import deleteJob from '@salesforce/apex/HappyBirthdayController.deleteJob';
import checkJob from '@salesforce/apex/HappyBirthdayController.checkJob';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class HappyBirthday extends LightningElement {
    @api identifierScheduler;
    @api identifierBatch;

    @track CRONstring = '0 0 13 * * ?';
    @track ScheduleBatchLabel;
    @track variant = 'neutral';
    @track disabled;

    @wire(checkJob)
    wiredAccounts({error,data})
    {
        console.log('data ' + data);
        if(data)
        {
            console.log('data ' + data);
            if(data == 'false')
            {
                this.ScheduleBatchLabel = 'Schedule Batch';
                this.variant = 'neutral';
                this.disabled = false;
            }
            else
            {
                this.ScheduleBatchLabel = 'Abort Batch';
                this.variant = 'destructive';
                this.disabled = true;
            }
        }
        else 
        {
            if (error) 
            {
                this.error = error;
            }
        } 
    }

    error;
    currentCRON(event)
    {
        this.CRONstring = event.target.value;
    }

    handleRunOnce()
    {
        ScheduleOrBatch({classBatchName: this.identifierBatch ,classScheduleName: this.identifierScheduler, CRONstr: '', isBatch: true, isRun: false})
        .then(result => {
            const evt = new ShowToastEvent({
                title: 'Running Batch',
                message: 'You have successfully run the batch',
                variant: 'success',
            });
            this.dispatchEvent(evt);
        })
        .catch(error => {
            this.error = error;
        });
    }

    handleSchedule()
    {   if(this.ScheduleBatchLabel == 'Schedule Batch')
        {
        this.disabled = true;
        this.variant = 'destructive';
        this.ScheduleBatchLabel = 'Abort Batch';
        ScheduleOrBatch({classBatchName: this.identifierBatch, classScheduleName: this.identifierScheduler, CRONstr: this.CRONstring, isBatch: false})
        .then(result => {
        })
        .catch(error => {
            this.error = error;
        });
        }

        else
        {
        this.disabled = false;    
        this.ScheduleBatchLabel = 'Schedule Batch';
        this.variant = 'neutral';
        deleteJob()
        .then(result => {
        })
        .catch(error => {
            this.error = error;
        });
        }
    }
}
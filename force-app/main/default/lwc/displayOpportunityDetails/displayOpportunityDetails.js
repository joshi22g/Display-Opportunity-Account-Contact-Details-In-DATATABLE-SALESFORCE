import { LightningElement, track, wire } from 'lwc'; 
import searchOpportunities from '@salesforce/apex/OpportunitySearchController.searchOpportunities'; 
import Opportunity_Search from '@salesforce/label/c.Opportunity_Search';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    { label: 'Opportunity Name', fieldName: 'name',wrapText: true }, 
    { label: 'Opportunity Description', fieldName: 'description',wrapText: true },
    { label: 'Close Date', fieldName: 'closeDate',wrapText: true},
    { label: 'Account Name', fieldName: 'accountName',wrapText: true },
    { label: 'Recent Contact Name', fieldName: 'contactName',wrapText: true }, 
    { label: 'Recent Contact Email', fieldName: 'contact Email',wrapText: true }, 
    { label: 'Recent Contact Number', fieldName: 'contactNumber' ,wrapText: true} 

];

export default class DisplayOpportunityDetails extends LightningElement {

    columns = columns; 
    @track opportunityData;
    @track dataToPass={};
    error;
    searchTerm = ''; 
    labels ={Opportunity_Search};
    badWords=['idiot','stupid'];

    handleSearchvalueChange(event) {
        this.searchTerm = event.target.value; 
        this.searchOpportunities();
    }

    searchOpportunities() {
           let records ={};
           this.error = '';
            
        if (this.searchTerm.length < 3) { 

            records.columns=[];
            records.rowData=[];
            this.dataToPass=records;    
            return;
        }
        if(this.badWords && this.badWords.length>0 )
        {
             this.badWords.forEach(element => {
                if(this.searchTerm.includes(element))
                {
                const event = new ShowToastEvent({
                    title: 'Toast message',
                    message: 'Search on Bad Keywords not allowed !',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
                return;
            }
             });
              
            
        }
        searchOpportunities({ searchKey: this.searchTerm })
            .then(result => {
                this.error = '';
                this.opportunityData=result;
                if(result.length>0)
                {
                records.columns=columns;
                records.rowData=this.opportunityData;
                this.dataToPass=records;      
                }
                else
                {
                    this.error = 'There are no records to display !';
                }          
            })
            .catch(error => {
                this.error = error.message || 'An error occurred while searching opportunities.';
                console.error('error message is '+JSON.stringify(error));
                this.dataToPass={};
                });
       
        
    }
}
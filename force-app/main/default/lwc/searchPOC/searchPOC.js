import { LightningElement, wire } from 'lwc';

import getVFOrigin from '@salesforce/apex/OpportunitySearchBulkController.getVFOrigin';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class SearchPOC extends LightningElement {

    error;
    AccountIds;
   searchKey;
    isLoading = false;
    length;
    displayBanner = false;

    @wire(getVFOrigin)
    vfOrigin;
    countLessthan10=false;

    

    handleSearchChange(event) {
        this.searchKey = event.target.value;
    }


    connectedCallback() {
        window.addEventListener("message", this.handleVFResponse.bind(this));
    }

    handleVFResponse(message) {
        if (message.origin === this.vfOrigin.data) {
            console.log('Came back to lightning');
            let newStr = message.data.replace(/\\/g, '');
           const obj = JSON.parse(newStr);
           this.isLoading=false;
            this.AccountIds=obj.AccIds;
            this.length=obj.length;
            console.log(obj.length);
            if(this.length<10000){
                this.countLessthan10=true
            }
            else{
                this.countLessthan10=false;
            }
           this.displayBanner = true;
            
        }
    }

    handleFiretoVF() {
        this.isLoading=true;
        console.log('came to fire'+this.searchKey);
        this.template.querySelector("iframe").contentWindow.postMessage(this.searchKey, this.vfOrigin.data);
        console.log('came to fire2');
    }
}
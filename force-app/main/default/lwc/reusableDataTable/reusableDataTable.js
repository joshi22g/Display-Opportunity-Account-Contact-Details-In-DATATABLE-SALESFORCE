import {LightningElement,api} from 'lwc';

export default class DatatableWithPagination extends LightningElement {
    
    pageSizeOptions = [5, 10, 25, 50, 75, 100]; 
    records ; 
    columns; 
    totalRecords = 0;
    pageSize; 
    totalPages; 
    pageNumber = 1;     
    recordsToDisplay; 
    @api
    get tableData() {
        return this.results;
    }

    set tableData(value) {
        if(value && value.columns)
        {
            this.columns =value.columns;
        }
        if(value && value.rowData && value.rowData.length >0 )
        {
            this.records = value.rowData;
            this.totalRecords = value.rowData.length;                
            this.pageSize = this.pageSizeOptions[0]; 
            this.paginationHelper();
        }
        else
        {
            this.records = null;
        }
        
        
    }


    get bDisableFirst() {
        return this.pageNumber == 1;
    }

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }


    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }

    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }

    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }

    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }

    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }


    // JS function to handel pagination logic 
    paginationHelper() {
        this.recordsToDisplay = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }

        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.records[i]);
        }
    }
}
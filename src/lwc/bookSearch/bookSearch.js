/**
 * Created by mzulubiev on 22.07.2022.
 */

import {LightningElement, track} from 'lwc';
import getOrderList from '@salesforce/apex/SearchBarLWC.getOrderList';

const cols = [
    {label:'Order Name', fieldName:'Name', sortable: "true"} ,
    {label:'Order Start Date', fieldName:'EffectiveDate', type: "Date", sortable: "true"} ,
    {label:'Order Status', fieldName:'Status', type: "Picklist", sortable: "true"}

]

export default class BookSearch extends LightningElement {

    searchKey;
    @track cols = cols;
    @track orders;
    @track sortBy;
    @track sortDirection;

    //This Function will get the value from Text Input.
    handelSearchKey(event){
        this.searchKey = event.target.value;
    }

    //This function will fetch the Account Name on basis of searchKey
    SearchOrders(){
            //call Apex method.
            getOrderList({searchKey: this.searchKey})
                .then(result => {
                    this.orders = result;
                })
                .catch( error=>{
                    this.orders = null;
                });
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldName, direction) {
        let parseData = JSON.parse(JSON.stringify(this.orders));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldName];
        };
        // checking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.orders = parseData;
    }
}
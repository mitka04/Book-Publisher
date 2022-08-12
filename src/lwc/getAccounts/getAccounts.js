/**
 * Created by mzulubiev on 22.07.2022.
 */

import {LightningElement, track, wire, api} from 'lwc';
import getOrders from '@salesforce/apex/LWCGetOrders.getOrders';

// specifying columns
const columns = [
    {label:'Account Name', fieldName:'Name'} ,
    {type: "button", typeAttributes: {
            label: 'Respond',
            name: 'Respond',
            title: 'Respond',
            value: 'respond',
            iconPosition: 'left'
        }}
];

export default class GetAccounts extends LightningElement {

    // current record id
    @api recordId;
    // columns of datatable
    @track columns = columns;
    // data from apex class
    @track data;

    error;

    // calling apex class, retrieving data and filtering
    @wire(getOrders, {recordId: '$recordId'})
    orders({error, data}) {
        if (data) {
            // parsing JSON data
            let sData = JSON.parse(JSON.stringify(data));
            console.log('sData: ' + JSON.stringify(sData));
            // filtering data and getting AccountName field
            sData = sData.map(row=>{
                return{Name: (row.Account ? row.Account.Name : null)};
            });
            console.log(sData);

            this.data = sData;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }
}
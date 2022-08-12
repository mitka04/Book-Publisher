/**
 * Created by mzulubiev on 23.07.2022.
 */

import {LightningElement, track, wire, api} from 'lwc';
import getAccounts from '@salesforce/apex/DataForMapLWC.getAccounts';

export default class AccountsMap extends LightningElement {

    // current record id
    @api recordId;
    // data from apex class
    @track data;
    // array of mapMarkers
    mapMarkers = [];
    error;

    // load address information
    @wire(getAccounts, {recordId: '$recordId'})
    accounts({error, data}) {
        if (data) {
            data.forEach(accRecord => {
                // iterating over all account records, and storing address information in mapMarkers
                this.mapMarkers = [...this.mapMarkers,
                    {
                        value: accRecord.Id,
                        location: {
                            Street: accRecord.BillingStreet,
                            City: accRecord.BillingCity,
                            Country: accRecord.BillingCountry
                        },
                        title: accRecord.Name,
                        description: accRecord.Description
                    }
                ];
                this.error = undefined;
            })
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }
}
/**
 * Created by mzulubiev on 23.07.2022.
 */

public class DataForMapLWC {

    @AuraEnabled(Cacheable=true)
    public static List<Account> getAccounts(Id recordId){

        // storing unique Accounts id
        Set<Id> accountsId = new Set<Id>();

        // getting OrderItems.Order.AccountId if Order Account record type is "Book Wholesaler"
        for(OrderItem orderItem : [SELECT Order.Account.Id
                                    FROM OrderItem
                                    WHERE Product2Id=:recordId
                                    AND Order.Account.RecordType.Name='Book Wholesaler']){
            accountsId.add(orderItem.Order.Account.Id);
        }

        // getting Accounts with BillingAddress information
        List<Account> accounts = new List<Account>([SELECT Id, Name, BillingCity, BillingStreet, BillingCountry, Description
                                                    FROM Account
                                                    WHERE Id=:accountsId]);

        if (!accounts.isEmpty()) {
            return accounts;
        }else {
            return null;
        }
    }
}
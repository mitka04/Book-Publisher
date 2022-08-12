/**
 * Created by mzulubiev on 22.07.2022.
 */

public class ProductTriggerHandler {

    public static void handleAfterUpdate(Map<Id, Product2> oldProducts, Map<Id, Product2> newProducts){
        List<Product2> product2s = new List<Product2>();

        // checking if release date has been postponed
        for (Id id : oldProducts.keySet()){
            Date oldDate = oldProducts.get(id).Release_Date__c;
            Date newDate = newProducts.get(id).Release_Date__c;

            if (oldDate != newDate && oldDate < newDate) {
                product2s.add(newProducts.get(id));
            }
        }

        if (!product2s.isEmpty()) {
            System.enqueueJob(new CreateCaseQueueJob(product2s));
        }
    }
}
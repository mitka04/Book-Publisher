/**
 * Created by mzulubiev on 22.07.2022.
 */

public with sharing class SearchBarLWC {

    @AuraEnabled(Cacheable=true)
    public static List<Order> getOrderList(String searchKey){
        String searchKeyword = '%' + searchKey + '%';

        // order list to store search result
        List<Order> orderListRecord = new List<Order>();

        // query order records
        for (Order order : [SELECT Id, Name, EffectiveDate, Status
                            FROM Order
                            WHERE Account.Name LIKE :searchKeyword]){
            orderListRecord.add(order);
        }

        if (orderListRecord.size() == 0) {
            throw new AuraHandledException('No Record Found..');
        }

        return orderListRecord;
    }

}
/**
 * Created by mzulubiev on 22.07.2022.
 */

public with sharing class LWCGetOrders {

    @AuraEnabled(Cacheable=true)
    public static List<Order> getOrders(Id recordId){
        // storing unique AccountName with order
        Map<String, Order> ordersWithUniqueAccName = new Map<String, Order>();

        // getting orders with their AccountName if Account record type is "Book Wholesaler"
        for(OrderItem orderItem : [SELECT Order.Account.Name, OrderId
                                    FROM OrderItem
                                    WHERE Product2Id=:recordId
                                    AND Order.Account.RecordType.Name='Book Wholesaler']){
            ordersWithUniqueAccName.put(orderItem.Order.Account.Name, orderItem.Order);
        }

        if (!ordersWithUniqueAccName.isEmpty()) {
            return ordersWithUniqueAccName.values();
        }else {
            return null;
        }
    }
}
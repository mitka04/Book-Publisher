/**
 * Created by mzulubiev on 22.07.2022.
 */

public class CreateCaseQueueJob implements Queueable{
    List<Product2> productList = new List<Product2>();

    // getting productList from handler class
    public CreateCaseQueueJob(List<Product2> productList){
        this.productList.addAll(productList);
    }

    public void execute(QueueableContext param1) {
        // storing unique ids of productList
        Set<Id> ids = new Set<Id>();

        for (Product2 product : productList){
            ids.add(product.Id);
        }

        // list of orderItems with current productId and Order status equals to Pending or Confirmed
        List<OrderItem> orderItems = [SELECT OrderId, Product2Id
                                        FROM OrderItem
                                        WHERE Product2Id=:ids
                                        AND (Order.Status='Pending'
                                        OR Order.Status='Confirmed')];

        List<Case> cases = new List<Case>();

        // create case for all orders that have current productId
        for (Product2 product : productList){
            for (OrderItem orderItem : orderItems) {
                Case createCase = new Case(Type = 'Release delay',
                        Order__c = orderItem.OrderId,
                        Description = product.Name,
                        Status = 'New',
                        Origin = 'Phone');
                cases.add(createCase);
            }
        }

        if (cases.size() > 0) {
            insert cases;
        }
    }
}
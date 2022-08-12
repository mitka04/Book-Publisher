/**
 * Created by mzulubiev on 22.07.2022.
 */

trigger ProductTrigger on Product2 (after update) {

    if (Trigger.isAfter && Trigger.isUpdate) {
        ProductTriggerHandler.handleAfterUpdate(Trigger.oldMap, Trigger.newMap);
    }
}
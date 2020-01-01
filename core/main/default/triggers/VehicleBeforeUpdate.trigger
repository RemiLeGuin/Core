trigger VehicleBeforeUpdate on Vehicle__c (before update) {
    String userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(System.UserInfo.getUserId());
    if (Schema.SObjectType.Vehicle__c.isUpdateable()) {
        Caller.callHandlers('Vehicle__c', 'before', 'update');
    }
    else {
        for (SObject record : Trigger.new) {
            record.addError(Label.Core_NotAllowedToEdit + ' ' + Schema.SObjectType.Vehicle__c.getLabelPlural());
        }
    }
}
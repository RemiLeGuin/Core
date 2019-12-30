trigger VehicleBeforeInsert on Vehicle__c (before insert) {
    String userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(System.UserInfo.getUserId());
    if (Schema.SObjectType.Vehicle__c.isCreateable()) {
        Caller.callHandlers('Vehicle__c', 'before', 'insert');
    }
    else {
        for (SObject record : Trigger.new) {
            record.addError(Label.NotAllowedToCreate + ' ' + Schema.SObjectType.Vehicle__c.getLabelPlural());
        }
    }
}
trigger AccountBeforeInsert on Account (before insert) {
    String userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(System.UserInfo.getUserId());
    if (Schema.SObjectType.Account.isCreateable()
        || (!String.isBlank(userBypassedObjectRestrictions)
            && userBypassedObjectRestrictions.contains('Account (Create)'))) {
        Caller.callHandlers('Account', 'before', 'insert');
    }
    else {
        for (SObject record : Trigger.new) {
            record.addError(Label.NotAllowedToCreate + ' ' + Schema.SObjectType.Account.getLabelPlural());
        }
    }
}
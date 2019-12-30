trigger AccountBeforeUpdate on Account (before update) {
    String userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(System.UserInfo.getUserId());
    if (Schema.SObjectType.Account.isUpdateable()
        || (!String.isBlank(userBypassedObjectRestrictions)
            && userBypassedObjectRestrictions.contains('Account (Edit)'))) {
        Caller.callHandlers('Account', 'before', 'update');
    }
    else {
        for (SObject record : Trigger.new) {
            record.addError(Label.NotAllowedToEdit + ' ' + Schema.SObjectType.Account.getLabelPlural());
        }
    }
}
trigger CaseBeforeUpdate on Case (before update) {
    String userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(System.UserInfo.getUserId());
    if (Schema.SObjectType.Case.isUpdateable()
        || (!String.isBlank(userBypassedObjectRestrictions)
            && userBypassedObjectRestrictions.contains('Case (Edit)'))) {
        Caller.callHandlers('Case', 'before', 'update');
    }
    else {
        for (SObject record : Trigger.new) {
            record.addError(Label.NotAllowedToEdit + ' ' + Schema.SObjectType.Case.getLabelPlural());
        }
    }
}
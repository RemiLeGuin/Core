trigger CaseBeforeUpdate on Case (before update) {
    if (Schema.SObjectType.Case.isUpdateable()
        || Core_UserUtilities.getUserBypassedObjectRestrictionsById(System.UserInfo.getUserId()).contains('Case (Edit)')) {
        Caller.callHandlers('Case', 'before', 'update');
    }
    else {
        for (SObject record : Trigger.new) {
            record.addError(Label.NotAllowedToEdit + ' ' + Schema.SObjectType.Case.getLabelPlural());
        }
    }
}
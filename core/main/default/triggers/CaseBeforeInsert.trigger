trigger CaseBeforeInsert on Case (before insert) {
    if (Schema.SObjectType.Case.isCreateable()
        || Core_UserUtilities.getUserBypassedObjectRestrictionsById(System.UserInfo.getUserId()).contains('Case (Create)')) {
        Caller.callHandlers('Case', 'before', 'insert');
    }
    else {
        for (SObject record : Trigger.new) {
            record.addError(Label.NotAllowedToCreate + ' ' + Schema.SObjectType.Case.getLabelPlural());
        }
    }
}
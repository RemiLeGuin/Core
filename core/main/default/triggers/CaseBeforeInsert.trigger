trigger CaseBeforeInsert on Case (before insert) {
    String userBypassedObjectRestrictions = Core_UserUtilities.getUserBypassedObjectRestrictionsById(System.UserInfo.getUserId());
    if (Schema.SObjectType.Case.isCreateable()
        || (String.isNotBlank(userBypassedObjectRestrictions)
            && userBypassedObjectRestrictions.contains('Case (Create)'))) {
        Caller.callHandlers('Case', 'before', 'insert');
    }
    else {
        for (SObject record : Trigger.new) {
            record.addError(Label.Core_NotAllowedToCreate + ' ' + Schema.SObjectType.Case.getLabelPlural());
        }
    }
}
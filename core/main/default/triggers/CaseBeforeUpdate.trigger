trigger CaseBeforeUpdate on Case (before update) {
    if (Schema.SObjectType.Case.isUpdateable()) {
        Caller.callHandlers('Case', 'before', 'update');
    }
    else {
        for (SObject record : Trigger.new) {
            record.addError(Label.NotAllowedToEdit + ' ' + Schema.SObjectType.Case.getLabelPlural());
        }
    }
}
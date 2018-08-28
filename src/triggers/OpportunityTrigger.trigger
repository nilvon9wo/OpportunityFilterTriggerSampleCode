trigger OpportunityTrigger on Opportunity (before update) {
    (new TRIG_OpportunityTriggerHandler()).invoke();
}
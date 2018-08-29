public class OPP_OpportunityBeforeUpdateHandler implements XAP_TRIG_TriggerEventHandlerIntf {
	OPP_OpportunityOpenNonprofitFilter opportunityOpenNonprofitFilter;
	
	public OPP_OpportunityBeforeUpdateHandler(OPP_OpportunityOpenNonprofitFilter opportunityOpenNonprofitFilter) {
		this.opportunityOpenNonprofitFilter = opportunityOpenNonprofitFilter;
	}
	 
	public OPP_OpportunityBeforeUpdateHandler() {
		this(OPP_OpportunityOpenNonprofitFilter.getInstance());
	} 
	
	private static final Set<SObjectField> FIELD_OF_INTEREST_SET = new Set<SObjectField>{
		Opportunity.Business_Need__c, Opportunity.Product_Date__c 
	}; 
	
	public XAP_TRIG_TriggerEventHandlerIntf handle(XAP_TRIG_TriggerWrapper triggerWrapper) {
		return this.handle(this.opportunityOpenNonprofitFilter.filter(triggerWrapper));
	}
	
	private XAP_TRIG_TriggerEventHandlerIntf handle(Map<Id, Opportunity> filteredOpportunityByIdMap) {
		// TODO: Do something with your filtered values here.
		return this;
	}  
} 
public class OPP_OpportunityOpenNonprofitFilter {
	// Constructor -----------------------------------------------------------------------------------------------   

	private static OPP_OpportunityOpenNonprofitFilter INSTANCE;
	XAP_UTIL_SObjectComparitor sObjectComparitor;

	private OPP_OpportunityOpenNonprofitFilter(XAP_UTIL_SObjectComparitor sObjectComparitor) {
		this.sObjectComparitor = sObjectComparitor;
	}
	
	private OPP_OpportunityOpenNonprofitFilter() {
		this(XAP_UTIL_SObjectComparitor.getInstance());
	}
	
	public static OPP_OpportunityOpenNonprofitFilter getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new OPP_OpportunityOpenNonprofitFilter();
		}
		return INSTANCE;
	}
	
	// Filter logic -----------------------------------------------------------------------------------------------   

	private static final String BUSINESS_TYPE_NON_PROFIT = 'Non Profit';
	private static final String ERROR_NO_SIGNIFICANT_CHANGE = 'Error message goes here.';
	private static final String STAGE_OPEN = 'Open';
	
	private static final Set<SObjectField> FIELD_OF_INTEREST_SET = new Set<SObjectField>{
		Opportunity.Business_Need__c, Opportunity.Product_Date__c 
	}; 
	
	public Map<Id, Opportunity> filter(XAP_TRIG_TriggerWrapper triggerWrapper) {
		Map<Id, Opportunity> filteredOpportunityByIdMap = new Map<Id, Opportunity>();
		for (Opportunity newOpportunity : (List<Opportunity>) triggerWrapper.newSObjectList) {
			if (isOpenNonProfit(newOpportunity)) {
				if (hasSignificantChange(newOpportunity, (Map<Id, Opportunity>) triggerWrapper.oldSObjectByIdMap)) {
 					filteredOpportunityByIdMap.put(newOpportunity.Id, newOpportunity);
				}
				else {
					newOpportunity.addError(ERROR_NO_SIGNIFICANT_CHANGE);
				}
			}
		}
		
		return filteredOpportunityByIdMap;
	}

	private Boolean hasSignificantChange(Opportunity newOpportunity, Map<Id, Opportunity> oldOpportunityByIdMap) {
		Opportunity oldOpportunity = oldOpportunityByIdMap.get(newOpportunity.Id);
		return this.isOpen(oldOpportunity)
			&& this.sObjectComparitor.hasSignificantChange(FIELD_OF_INTEREST_SET, newOpportunity, oldOpportunity);
	}

	private Boolean isOpen(Opportunity opportunity) {
		return STAGE_OPEN.equals(opportunity.StageName);
	}
	
	private Boolean isOpenNonProfit(Opportunity opportunity) {
		return BUSINESS_TYPE_NON_PROFIT.equals(opportunity.Business_Need__c)
			&& this.isOpen(opportunity);
	}	
} 
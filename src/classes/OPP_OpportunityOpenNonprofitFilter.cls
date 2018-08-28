public class OPP_OpportunityOpenNonprofitFilter implements XAP_TRIG_TriggerEventHandlerIntf {
	private static final String BUSINESS_TYPE_NON_PROFIT = 'Non Profit';
	private static final String ERROR_NO_SIGNIFICANT_CHANGE = 'Error message goes here.';
	private static final String STAGE_OPEN = 'Open';
	
	private static final Set<SObjectField> FIELD_OF_INTEREST_SET = new Set<SObjectField>{
		Opportunity.Business_Need__c, Opportunity.Product_Date__c 
	}; 
	
	public XAP_TRIG_TriggerEventHandlerIntf handle(XAP_TRIG_TriggerWrapper triggerWrapper) {
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
		
		return this.handle(filteredOpportunityByIdMap);
	}
	
	private XAP_TRIG_TriggerEventHandlerIntf handle(Map<Id, Opportunity> filteredOpportunityByIdMap) {
		// TODO: Do something with your filtered values here.
		return this;
	}  
	
	private Boolean isOpenNonProfit(Opportunity newOpportunity) {
		return BUSINESS_TYPE_NON_PROFIT.equals(newOpportunity.Business_Need__c)
			&& this.isOpen(newOpportunity);
	}	
	
	
	private Boolean hasSignificantChange(Opportunity newOpportunity, Map<Id, Opportunity> oldOpportunityByIdMap) {
		Opportunity oldOpportunity = oldOpportunityByIdMap.get(newOpportunity.Id);
		return this.isOpen(oldOpportunity)
			&& this.hasSignificantChange(newOpportunity, oldOpportunity);
	}
	
	private Boolean isOpen(Opportunity opportunity) {
		return STAGE_OPEN.equals(opportunity.StageName);
	}
	
	private Boolean hasSignificantChange(Opportunity newOpportunity, Opportunity oldOpportunity) {
		for (SObjectField sObjectField : FIELD_OF_INTEREST_SET) {
			if (!this.isEqual(newOpportunity.get(sObjectField), oldOpportunity.get(sObjectField))) {
				return true;
			}
		}
		return false;
	}
	
	private Boolean isEqual(Object newValue, Object oldValue) {
		return (newValue == null && oldValue == null)
			|| (newValue.equals(oldValue));
	}
} 
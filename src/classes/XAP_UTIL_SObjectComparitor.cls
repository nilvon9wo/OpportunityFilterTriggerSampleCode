public class XAP_UTIL_SObjectComparitor {
	// Constructor -----------------------------------------------------------------------------------------------   

	private static XAP_UTIL_SObjectComparitor INSTANCE;
	
	private XAP_UTIL_SObjectComparitor() {
	}
	
	public static XAP_UTIL_SObjectComparitor getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new XAP_UTIL_SObjectComparitor();
		}
		return INSTANCE;
	}  

	// Comparison Logic -----------------------------------------------------------------------------------------------   
	
	public Boolean hasSignificantChange(Set<SObjectField> fieldOfInterestSet, SObject newValue, SObject oldValue) {
		for (SObjectField sObjectField : fieldOfInterestSet) {
			if (!this.isEqual(newValue.get(sObjectField), oldValue.get(sObjectField))) {
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
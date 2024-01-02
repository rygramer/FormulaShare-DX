List<Donation__c> donations = new List<Donation__c>{new Donation__c(Id = 'a018D000004dDTeQAM'),new Donation__c(Id = 'a018D000004dDTgQAM')};
SObjectType donationSObjectType = Donation__c.SObjectType;

FormulaShareRulesSelector rulesSelector = new FormulaShareInjectionService().getRulesSelector();
List<FormulaShareRule> rules = rulesSelector.getRulesSharingObject(donationSObjectType);

FormulaShareSObjectsRetrievalServiceBase rs = new FormulaShareInjectionService().getSObjectsRetrievalService();
rs.setRequery();
rs.setDetails(donationSObjectType,rules,donations);
List<FormulaShareRetrievedRecordDetails> recordDetails = rs.getDetailsForSharing();

FormulaShareService service = FormulaShareService.construct(donationSObjectType);
service.setSharedRecordDetails(recordDetails);

service.processFormulaShares();

Map<String,FormulaShareService.ShareDetail> insertDetails = service.getInsertDetails();

List<SObject> sharesToInsert = new List<SObject>();
for(FormulaShareService.ShareDetail sd : insertDetails.values()) {
    sharesToInsert.add(sd.shareRecord);
}

FormulaShareSObjectShares fsSharesToInsert = FormulaShareSObjectShares.construct(donationSObjectType);

fsSharesToInsert.insertShares(sharesToInsert);
String insertStatus = 'Success';

FormulaShareProcessEventPublisher publisher = new FormulaShareProcessEventPublisher();
publisher.addInsertEvents(insertDetails, insertStatus, 'insertStatusReason');
publisher.publish();

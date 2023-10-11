/**
 * @description       : Claim_Information__c Selector Implementation
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             :
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 *
 **/

public class Claim_InformationsSelector extends fflib_SObjectSelector
    implements IClaim_InformationsSelector
{

    public Claim_InformationsSelector() {
        super(false, true, true, false);
    }

    public static IClaim_InformationsSelector newInstance() {
        return (IClaim_InformationsSelector) PMd_Application.Selector.newInstance(Claim_Information__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Claim_Information__c.Id,
                Claim_Information__c.Name,
                //Claim_Information__c.Cardholder_s_Name__c,
                Claim_Information__c.Contact_Drug__c,
                Claim_Information__c.CPA_Funds_Paid__c,
                Claim_Information__c.CPA_Indicator__c,
                Claim_Information__c.CreatedById,
                Claim_Information__c.Date_Of_Service_From__c,
                Claim_Information__c.Drug__c,
                Claim_Information__c.Drug_Brand_Name__c,
                Claim_Information__c.Drug_Cost_Paid_by_Primary_Insurance__c,
                Claim_Information__c.Drug_Generic_Name__c,
                Claim_Information__c.Drug_Label_Name__c,
                //Claim_Information__c.NDC__c,
                //Claim_Information__c.GPI_14__c,
                //Claim_Information__c.Insurance_Plan_Name__c,
                Claim_Information__c.Is_there_another_Health_Benefit_Plan__c,
                Claim_Information__c.HCPCS_Code__c,
                Claim_Information__c.LastModifiedById,
                Claim_Information__c.Previous_Segment__c,
                Claim_Information__c.EOP_Date__c,
                Claim_Information__c.Claim_Status__c,
                Claim_Information__c.Claim_Adjustment_Amount__c
                //Claim_Information__c.Total_Drug_Cost__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Claim_Information__c.SObjectType;
    }

    public List<Claim_Information__c> selectById(Set<Id> idSet)
    {
        return (List<Claim_Information__c>) selectSObjectsById(idSet);
    }

    public List<Claim_Information__c> selectByContactId(Set<Id> contactIds) {

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        setCondition('Contact__c IN :contactIds').
                        //setCondition('Patient_First_Name__c IN :firstName').
                        //setCondition('Patient_Last_Name__c IN :lastName').
                        toSOQL()
        );
    }

    public List<Claim_Information__c> selectByPrimary_Claim_Number(Set<String> primary_Claim_NumberSet) {

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Primary_Claim_Number__c).
                        selectField(Claim_Information__c.Claim_Number__c).
                        selectField(Claim_Information__c.Current_Claim_Number__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        setCondition('Primary_Claim_Number__c IN :primary_Claim_NumberSet').
                        //setCondition('Patient_First_Name__c IN :firstName').
                        //setCondition('Patient_Last_Name__c IN :lastName').
                        toSOQL()
        );
    }

    public List<Claim_Information__c> selectOriginalClaimsByPrimaryClaimNumber(Set<String> Primary_Claim_NumberSet) {

        Set<String> claim_SegmentSet = new Set<String>{'00'}; //All Original Claims will have a Claim Segment of 00

        System.debug('selectOriginalClaimsByPrimaryClaimNumber = ' + newQueryFactory().
                selectField(Claim_Information__c.Id).
                selectField(Claim_Information__c.OwnerId).
                selectField(Claim_Information__c.Name).
                //selectField(Claim_Information__c.Cardholder_s_Name__c).
                selectField(Claim_Information__c.Contact__c).
                selectField(Claim_Information__c.Primary_Claim_Number__c).
                selectField(Claim_Information__c.Claim_Number__c).
                selectField(Claim_Information__c.Current_Claim_Number__c).
                selectField(Claim_Information__c.Previous_Segment__c).
                selectField(Claim_Information__c.Date_Of_Service_From__c).
                selectField(Claim_Information__c.EOP_Date__c).
                //selectField(Claim_Information__c.Total_Drug_Cost__c).
                //setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet AND Claim_Segment__c IN :claim_SegmentSet AND Claim_Line__c IN :Claim_LineSet').
                setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet  AND Claim_Segment__c = \'00\'').
                //setCondition('Claim_Segment__c = \'00\'').
                //setCondition('Claim_Line__c IN :Claim_LineSet').
                toSOQL()
        );

        return (List<Claim_Information__c>) Database.query(newQueryFactory().
                selectField(Claim_Information__c.Id).
                selectField(Claim_Information__c.OwnerId).
                selectField(Claim_Information__c.Name).
                //selectField(Claim_Information__c.Cardholder_s_Name__c).
                selectField(Claim_Information__c.Contact__c).
                selectField(Claim_Information__c.Primary_Claim_Number__c).
                selectField(Claim_Information__c.Claim_Number__c).
                selectField(Claim_Information__c.Current_Claim_Number__c).
                selectField(Claim_Information__c.Previous_Segment__c).
                selectField(Claim_Information__c.EOP_Date__c).
                //selectField(Claim_Information__c.Total_Drug_Cost__c).
                //setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet AND Claim_Segment__c IN :claim_SegmentSet AND Claim_Line__c IN :Claim_LineSet').
                setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet  AND Claim_Segment__c = \'00\'').
                //setCondition('Claim_Segment__c = \'00\'').
                //setCondition('Claim_Line__c IN :Claim_LineSet').
                toSOQL()
        );
    }

    public List<Claim_Information__c> selectOriginalClaimsByUniquekey(Set<String> Primary_Claim_NumberSet, Set<String> claim_SegmentSet, Set<String> Claim_LineSet) {

        System.debug('selectOriginalClaimsByUniquekey = ' + newQueryFactory().
                selectField(Claim_Information__c.Id).
                selectField(Claim_Information__c.OwnerId).
                selectField(Claim_Information__c.Name).
                //selectField(Claim_Information__c.Cardholder_s_Name__c).
                selectField(Claim_Information__c.Contact__c).
                selectField(Claim_Information__c.Primary_Claim_Number__c).
                selectField(Claim_Information__c.Claim_Number__c).
                selectField(Claim_Information__c.Current_Claim_Number__c).
                selectField(Claim_Information__c.Previous_Segment__c).
                selectField(Claim_Information__c.Date_Of_Service_From__c).
                selectField(Claim_Information__c.EOP_Date__c).
                //selectField(Claim_Information__c.Total_Drug_Cost__c).
                //setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet AND Claim_Segment__c IN :claim_SegmentSet AND Claim_Line__c IN :Claim_LineSet').
                setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet AND Claim_Segment__c IN :claim_SegmentSet AND Claim_Line__c IN :Claim_LineSet').
                //setCondition('Claim_Segment__c IN :claim_SegmentSet').
                //setCondition('Claim_Line__c IN :Claim_LineSet').
                toSOQL()
        );

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Primary_Claim_Number__c).
                        selectField(Claim_Information__c.Claim_Number__c).
                        selectField(Claim_Information__c.Current_Claim_Number__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        //setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet AND Claim_Segment__c IN :claim_SegmentSet AND Claim_Line__c IN :Claim_LineSet').
                        setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet AND Claim_Segment__c IN :claim_SegmentSet AND Claim_Line__c IN :Claim_LineSet').
                        //setCondition('Claim_Segment__c IN :claim_SegmentSet').
                        //setCondition('Claim_Line__c IN :Claim_LineSet').
                        toSOQL()
        );
    }

    public List<Claim_Information__c> selectOriginalClaimsByUniquekey(Set<String> Primary_Claim_NumberSet, Set<String> Claim_LineSet) {

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Primary_Claim_Number__c).
                        selectField(Claim_Information__c.Claim_Number__c).
                        selectField(Claim_Information__c.Current_Claim_Number__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        //setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet AND Claim_Line__c IN :Claim_LineSet').
                        setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet').
                        //setCondition('Claim_Segment__c IN :claim_SegmentSet').
                        setCondition('Claim_Line__c IN :Claim_LineSet').
                        toSOQL()
        );
    }

    public List<Claim_Information__c> selectExistingClaimsByUniquekey(Set<String> Primary_Claim_NumberSet, Set<String> claim_SegmentSet, Set<String> Claim_LineSet , Set<String>  Previous_SegmentSet) {

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Primary_Claim_Number__c).
                        selectField(Claim_Information__c.Claim_Number__c).
                        selectField(Claim_Information__c.Current_Claim_Number__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        selectField(Claim_Information__c.PA_Approval_Dates__c).
                        selectField(Claim_Information__c.Date_Of_Service_From__c).
                        selectField(Claim_Information__c.Previous_Claim__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet AND Claim_Line__c IN :Claim_LineSet AND Previous_Segment__c IN :Previous_SegmentSet').
                        //setCondition('Claim_Line__c IN :Claim_LineSet').
                        //setCondition('Previous_Segment__c IN :Previous_SegmentSet').
                        addOrdering('Date_Of_Service_From__c', fflib_QueryFactory.SortOrder.DESCENDING).
                        toSOQL()
        );
    }

    //SOQL Order is not working. I believe it is because the records are being updated & inserted in the same transaction.
    //Sort recordy be decending Date_Of_Service_From__c
    public List<Claim_Information__c> selectExistingClaimsByUniquekey(Set<String> Primary_Claim_NumberSet, Set<String> claim_SegmentSet, Set<String> Claim_LineSet) {

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Primary_Claim_Number__c).
                        selectField(Claim_Information__c.Claim_Number__c).
                        selectField(Claim_Information__c.Current_Claim_Number__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        selectField(Claim_Information__c.PA_Approval_Dates__c).
                        selectField(Claim_Information__c.Date_Of_Service_From__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet').
                        setCondition('Claim_Line__c IN :Claim_LineSet').
                        //setCondition('Previous_Segment__c IN :Previous_SegmentSet').
                        addOrdering('Date_Of_Service_From__c', fflib_QueryFactory.SortOrder.DESCENDING).
                        toSOQL()
        );
    }

    //SOQL Order is not working. I believe it is because the records are being updated & inserted in the same transaction.
    //Sort records by descending Date_Of_Service_From__c
    public List<Claim_Information__c> selectExistingClaimsByUniquekey(Set<String> Primary_Claim_NumberSet, Set<String> claim_SegmentSet, Set<String> Claim_LineSet , Set<String>  Previous_SegmentSet, Set<Id> contactIdSet) {

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Primary_Claim_Number__c).
                        selectField(Claim_Information__c.Claim_Number__c).
                        selectField(Claim_Information__c.Current_Claim_Number__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        selectField(Claim_Information__c.PA_Approval_Dates__c).
                        selectField(Claim_Information__c.Date_Of_Service_From__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        setCondition('Primary_Claim_Number__c IN :Primary_Claim_NumberSet').
                        setCondition('Claim_Line__c IN :Claim_LineSet').
                        setCondition('Previous_Segment__c IN :Previous_SegmentSet').
                        setCondition('Contact__c IN :contactIdSet').
                        addOrdering('Date_Of_Service_From__c', fflib_QueryFactory.SortOrder.DESCENDING).
                        toSOQL()
        );
    }

    //Sort records by descending Date_Of_Service_From__c
    public List<Claim_Information__c> selectExistingClaimsByUCKID(Set<String> Previous_ClaimIDSet) {

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Primary_Claim_Number__c).
                        selectField(Claim_Information__c.Claim_Number__c).
                        selectField(Claim_Information__c.Current_Claim_Number__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        selectField(Claim_Information__c.PA_Approval_Dates__c).
                        selectField(Claim_Information__c.Date_Of_Service_From__c).
                        selectField(Claim_Information__c.Previous_Claim__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        setCondition('Primary_Claim_Number__c IN :Previous_ClaimIDSet').
                        addOrdering('Date_Of_Service_From__c', fflib_QueryFactory.SortOrder.DESCENDING).
                        toSOQL()
        );
    }

    //SOQL Order is not working. I believe it is because the records are being updated & inserted in the same transaction.
    //Sort record be descending Date_Of_Service_From__c
    public List<Claim_Information__c> selectExistingClaimsByContactDrugIdSet(Set<Id> contact_DrugIdSet) {

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Primary_Claim_Number__c).
                        selectField(Claim_Information__c.Claim_Number__c).
                        selectField(Claim_Information__c.Current_Claim_Number__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        selectField(Claim_Information__c.PA_Approval_Dates__c).
                        selectField(Claim_Information__c.Date_Of_Service_From__c).
                        selectField(Claim_Information__c.Contact_Drug__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        setCondition('Contact_Drug__c IN :contact_DrugIdSet').
                        addOrdering('Date_Of_Service_From__c', fflib_QueryFactory.SortOrder.DESCENDING).
                        toSOQL()
        );
    }

    //SOQL Order is not working. I believe it is because the records are being updated & inserted in the same transaction.
    //Sort records by decending Date_Of_Service_From__c
    public List<Claim_Information__c> selectExistingClaimsByUniquekey(Set<String> claimNumberSet) {

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Primary_Claim_Number__c).
                        selectField(Claim_Information__c.Claim_Number__c).
                        selectField(Claim_Information__c.Current_Claim_Number__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        selectField(Claim_Information__c.PA_Approval_Dates__c).
                        selectField(Claim_Information__c.Date_Of_Service_From__c).
                        selectField(Claim_Information__c.Previous_Claim__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        setCondition('Claim_Number__c IN :claimNumberSet').
                        addOrdering('Date_Of_Service_From__c', fflib_QueryFactory.SortOrder.DESCENDING).
                        toSOQL()
        );
    }

    //SOQL Order is not working. I believe it is because the records are being updated & inserted in the same transaction.
    //Sort records by decending Date_Of_Service_From__c
    public List<Claim_Information__c> selectExistingClaimsByCurrentClaimNumber(Set<String> currentClaimNumberSet) {

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Primary_Claim_Number__c).
                        selectField(Claim_Information__c.Claim_Number__c).
                        selectField(Claim_Information__c.Current_Claim_Number__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        selectField(Claim_Information__c.PA_Approval_Dates__c).
                        selectField(Claim_Information__c.Date_Of_Service_From__c).
                        selectField(Claim_Information__c.Previous_Claim__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        setCondition('Current_Claim_Number__c IN :currentClaimNumberSet').
                        addOrdering('Date_Of_Service_From__c', fflib_QueryFactory.SortOrder.DESCENDING).
                        toSOQL()
        );
    }

    //SOQL Order is not working. I believe it is because the records are being updated & inserted in the same transaction.
    //Sort recordy be decending Date_Of_Service_From__c
    public List<Claim_Information__c> selectOriginalClaimsByUniquekey(Set<String> claimNumberSet) {

        return (List<Claim_Information__c>) Database.query(
                newQueryFactory().
                        selectField(Claim_Information__c.Id).
                        selectField(Claim_Information__c.OwnerId).
                        selectField(Claim_Information__c.Name).
                        //selectField(Claim_Information__c.Cardholder_s_Name__c).
                        selectField(Claim_Information__c.Contact__c).
                        selectField(Claim_Information__c.Primary_Claim_Number__c).
                        selectField(Claim_Information__c.Claim_Number__c).
                        selectField(Claim_Information__c.Current_Claim_Number__c).
                        selectField(Claim_Information__c.Previous_Segment__c).
                        //selectField(Claim_Information__c.Total_Drug_Cost__c).
                        selectField(Claim_Information__c.PA_Approval_Dates__c).
                        selectField(Claim_Information__c.Date_Of_Service_From__c).
                        selectField(Claim_Information__c.Contact_Drug__c).
                        selectField(Claim_Information__c.EOP_Date__c).
                        setCondition('Claim_Number__c IN :claimNumberSet').
                        addOrdering('Date_Of_Service_From__c', fflib_QueryFactory.SortOrder.DESCENDING).
                        toSOQL()
        );
    }
}
/**
 * @description       :
 * @author            : Garrett.Heathcote@PrudentRx.com
 * @group             :
 * @last modified on  : 05-16-2022
 * @last modified by  : Garrett Heathcote
 * Modifications Log
 * Ver   Date         Author                           Modification
 * 1.0   05-16-2022   Garrett Heathcote                Initial Version
 *
 **/
public with sharing class LetterCreateRequest {
  //  public String description {get;set;} 
    public AddressClass toAddress {get;set;} 
    public String fromAddress {get;set;}  //ID from Company supplied address stored in LOB
    public String file {get;set;}   //HTML or template id
    //public String extra_service {get;set;}  //ENUM: null, certified, registered,  certified_return_receipt
    //public List<String> cards; /// send cards like credit cards?? 
    public String mail_type {get;set;}  //Enum usps_first_class usps_standard 
    public String address_placement {get;set;} //Enum "top_first_page" "insert_blank_page" "bottom_first_page_center" "bottom_first_page"
    public String color {get;set;} 
    public String double_sided {get;set;} 
    
    //public Boolean return_envelope {get;set;} 
    //public Integer perforated_page {get;set;} 
    public Map<String,String> merge_variables {get;set;} 
    //public Object custom_envelope; /// ONly used for custom envelopes

    public class AddressClass {
        //public String id {get;set;}  //1010101010101010
      //  public String description {get;set;}    //1
        public String name {get;set;} 
      //  public String company {get;set;} 
      //  public String phone {get;set;} 
      //  public String email {get;set;} 
        public String address_line1 {get;set;} 
        public String address_line2 {get;set;} 
        public String address_city {get;set;} 
        public String address_state {get;set;} 
        public String address_zip {get;set;} 
       // public String date_created {get;set;} 
       // public String date_modified {get;set;} 
       // public String deleted {get;set;} 
        //public String object;
    }

/*   public static RequestJSON parse(String json){
        return (RequestJSON) System.JSON.deserialize(json, RequestJSON.class);
    }    */
    
}
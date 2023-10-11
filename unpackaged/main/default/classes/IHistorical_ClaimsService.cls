public interface IHistorical_ClaimsService {

    List<Historical_Claim_JSONResponse> doRestAPIPost(Map<String,String> mapAPILog, String JSONString);
}
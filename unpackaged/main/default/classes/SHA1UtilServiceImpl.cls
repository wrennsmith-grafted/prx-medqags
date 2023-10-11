/**
 * @description       : SHA1 Service Implementaion
 * @author            : Ricardy.Banks@PrudentRx.com
 * @group             : 
 * @last modified on  : 08-05-2021
 * @last modified by  : Ricardy Banks
 * Modifications Log 
 * Ver   Date         Author                           Modification
 * 1.0   08-05-2021   Ricardy Banks					   Initial Version
 * 
 **/
public class SHA1UtilServiceImpl
            implements ISHA1UtilService {

        public static String getBase64SHA1Hash(String targetString) {
            /*
            // Convert to BLOB
            Blob targetBlob = Blob.valueOf(targetString);
            // Generate SHA1 digest
            Blob hashSHA1 = Crypto.generateDigest('SHA1', targetBlob);
            // Encode the binary into BASE 64 this will result in 28 chars long string
            String hashBase64SHA1 = EncodingUtil.base64encode (hashSHA1);
    
            return hashBase64SHA1;
            */
            return targetString;
        }
}
@isTest
global class LetterServiceMock implements HttpCalloutMock {
    public String type;

    global LetterServiceMock(final String type){
        this.type = type;
    }
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response.
        // Set response values, and 
        // return response.
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (type == 'testWelcomeLetterSuccess')
        {
            res.setBody('{"id":"ltr_70347496d0c7be52", "expected_delivery_date": "2022-06-02"}');
            res.setStatusCode(200);
        }
        else if(type == 'testFinalNoticeLetterSuccess')
        {
            res.setBody('{"id":"ltr_70347496d0c7be34", "expected_delivery_date": "2022-06-02"}');
            res.setStatusCode(200);
        }
        else if(type == 'testLetterBadAddress')
        {
            res.setBody('{"error":{"message": "The \'to\' address does not meet your minimum deliverability strictness. To change your deliverability strictness, see https://dashboard.lob.com/#/settings/account"}}');
            res.setStatusCode(422);
        }
        else {
            res.setBody('{"error":{"message":"Something is bad"}}');
            res.setStatusCode(500);
        }
        return res;
    }

}
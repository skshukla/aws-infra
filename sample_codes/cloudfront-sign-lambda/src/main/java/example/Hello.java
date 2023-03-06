package example;


import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.sample.work.AuthUtils;
import com.sample.work.CreateCannedPolicyRequest;
import com.sample.work.SigningUtilities;
import software.amazon.awssdk.services.cloudfront.model.CannedSignerRequest;
import software.amazon.awssdk.services.cloudfront.url.SignedUrl;

import java.util.Map;

public class Hello implements RequestHandler<Map<String, Object>, String> {

    public static final String HEADER_ACCESS_TOKEN = "access_token";
    public static final String QUERY_PARAM_KEY_OBJ = "keyObj";

    @Override
    public String handleRequest(Map<String, Object> event, Context context) {
        LambdaLogger logger = context.getLogger();
        String keyObjString = "";
        String tokenString = "";

        for (String key : event.keySet()) {
            if (key.equals("params")) {
                Map<String, Object> paramsMap = (Map<String, Object>) event.get(key);
                for (String paramsInnerKey : paramsMap.keySet()) {
                    logger.log("printing params in details");
                    if (paramsInnerKey.equals("querystring")) {
                        logger.log("" + paramsMap.get(paramsInnerKey));
                        Map<String, Object> queryParamsMap = (Map<String, Object>) paramsMap.get(paramsInnerKey);
                        for (String queryParamKey : queryParamsMap.keySet()) {
                            logger.log("" + queryParamsMap.get(queryParamKey));
                            if (queryParamKey.equals(QUERY_PARAM_KEY_OBJ)) {
                                keyObjString = (String) queryParamsMap.get(queryParamKey);
                                logger.log("keyObj is " + keyObjString);
                            }
                        }
                    }
                    if (paramsInnerKey.equals("header")) {
                        logger.log("headers: " + paramsMap.get(paramsInnerKey));
                        Map<String, Object> headersMap = (Map<String, Object>) paramsMap.get(paramsInnerKey);
                        for (String queryParamKey : headersMap.keySet()) {
                            logger.log("header-key : " + headersMap.get(queryParamKey));
                            if (queryParamKey.equals(HEADER_ACCESS_TOKEN)) {
                                tokenString = (String) headersMap.get(queryParamKey);
                                logger.log("tokenString is " + tokenString);
                            }

                        }
                    }
                }

            }
        }
        if (AuthUtils.isAuthorizedObjectKeyForToken(tokenString, keyObjString)) {

            try {
                CannedSignerRequest cannedRequest = CreateCannedPolicyRequest
                        .createRequestForCannedPolicy(Constants.CF_DISTRIBUTION_DOMAIN_NAME, keyObjString, Constants.PUBLIC_KEY_ID);
                SignedUrl signedUrlWithCannedPolicy = SigningUtilities.signUrlForCannedPolicy(cannedRequest);
                return signedUrlWithCannedPolicy.url();
            } catch (final Exception ex) {
                return String.format("Unauthorized with exception as {%s}", ex.getMessage());
            }
        } else {
            return "Unauthorized " + tokenString + " " + keyObjString;
        }

    }
}

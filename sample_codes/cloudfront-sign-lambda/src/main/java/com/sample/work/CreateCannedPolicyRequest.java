package com.sample.work;

import software.amazon.awssdk.services.cloudfront.model.CannedSignerRequest;

import java.net.URL;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
public class CreateCannedPolicyRequest {

    public static CannedSignerRequest createRequestForCannedPolicy(String distributionDomainName, String fileNameToUpload,
                                                                   String publicKeyId) throws Exception{
        String protocol = "https";
        String resourcePath = "/" + fileNameToUpload;

        String cloudFrontUrl = new URL(protocol, distributionDomainName, resourcePath).toString();
        Instant expirationDate = Instant.now().plus(1, ChronoUnit.DAYS);
        return CannedSignerRequest.builder()
                .resourceUrl(cloudFrontUrl)
                .privateKey(KeyUtils.getPrivateKey())
                .keyPairId(publicKeyId)
                .expirationDate(expirationDate)
                .build();

    }


}

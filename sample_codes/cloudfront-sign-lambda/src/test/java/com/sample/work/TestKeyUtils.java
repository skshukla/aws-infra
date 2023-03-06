package com.sample.work;


import org.junit.Test;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

public class TestKeyUtils {
    @Test
    public void test() throws NoSuchAlgorithmException, InvalidKeySpecException, IOException {
        KeyUtils.getPrivateKey();
    }
}

package com.sample.work;

public class AuthUtils {
    public static final String USER_AUTH_TOKEN = "user123";
    public static final String ADMIN_AUTH_TOKEN = "admin123";

    public static boolean isAuthorizedObjectKeyForToken(final String token , final String keyObj) {

        if (!USER_AUTH_TOKEN.equalsIgnoreCase(token) && !ADMIN_AUTH_TOKEN.equalsIgnoreCase(token)) {
            return false;
        }
        if (USER_AUTH_TOKEN.equalsIgnoreCase(token) && keyObj.toLowerCase().contains("admin") ) {
            return false;
        }
        return true;
    }
}

package com.example.karate;

import com.intuit.karate.junit5.Karate;

class TestRunner {
    @Karate.Test
    Karate testApi() {
        return Karate.run("classpath:UI_feature").tags("@acmebank").relativeTo(getClass());
    }
}

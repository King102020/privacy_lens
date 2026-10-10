package app.privacylens.collectors

import app.privacylens.bridge.TrackerSignatureDto
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class SignatureMatcherTest {
    @Test
    fun matchesJavaPackagePrefixesAsDexDescriptors() {
        val matcher = SignatureMatcher(
            listOf(
                TrackerSignatureDto("ads", listOf("com.ads.sdk")),
                TrackerSignatureDto("crash", listOf("com.crash.lytics")),
            ),
        )
        val found = HashSet<String>()
        matcher.collectMatches(
            listOf(
                "Lcom/ads/sdk/Banner;",
                "Lcom/example/App;",
                "Lcom/crash/lytics/Crash;",
            ),
            found,
        )
        assertEquals(setOf("ads", "crash"), found)
    }

    @Test
    fun doesNotMatchAShorterPackagePrefix() {
        val matcher = SignatureMatcher(
            listOf(TrackerSignatureDto("ads", listOf("com.ads.sdk"))),
        )
        val found = HashSet<String>()
        matcher.collectMatches(listOf("Lcom/ads/Other;"), found)
        assertTrue(found.isEmpty())
    }
}

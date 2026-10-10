package app.privacylens.vpn

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class BlocklistTest {
    @Test
    fun parsesVersionAndMatchesParentDomains() {
        val list = Blocklist.parse(
            sequenceOf(
                "# version: 2026.10.1",
                "# comment",
                "ads.example.com advertising",
                "tracker.io analytics",
            ),
        )
        assertEquals("2026.10.1", list.version)
        assertEquals(2, list.size)
        assertTrue(list.isBlocked("ads.example.com"))
        assertTrue(list.isBlocked("pixel.ads.example.com"))
        assertTrue(list.isBlocked("TRACKER.IO."))
        assertFalse(list.isBlocked("example.com"))
        assertFalse(list.isBlocked("honest.app"))
    }
}

package app.privacylens.vpn

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class BlocklistTest {
    private fun sample(): Blocklist = Blocklist.parse(
        sequenceOf(
            "# version: 2026.10.2",
            "# comment",
            "ads.example.com advertising",
            "tracker.io analytics",
            "attr.example attribution",
        ),
    )

    @Test
    fun parsesVersionAndMatchesParentDomains() {
        val list = sample()
        assertEquals("2026.10.2", list.version)
        assertEquals(3, list.size)
        assertTrue(list.isBlocked("ads.example.com"))
        assertTrue(list.isBlocked("pixel.ads.example.com"))
        assertTrue(list.isBlocked("TRACKER.IO."))
        assertFalse(list.isBlocked("example.com"))
        assertFalse(list.isBlocked("honest.app"))
    }

    @Test
    fun disabledCategoryStopsBlocking() {
        val list = sample()
        list.applyPolicy(
            enabledCategories = listOf("analytics"),
            extraBlocked = emptyList(),
            allowed = emptyList(),
        )
        assertFalse(list.isBlocked("ads.example.com"))
        assertTrue(list.isBlocked("tracker.io"))
    }

    @Test
    fun allowListOverridesCategoryAndExtraBlock() {
        val list = sample()
        list.applyPolicy(
            enabledCategories = listOf("advertising", "analytics"),
            extraBlocked = listOf("honest.app"),
            allowed = listOf("ads.example.com", "honest.app"),
        )
        assertFalse(list.isBlocked("pixel.ads.example.com"))
        assertFalse(list.isBlocked("honest.app"))
        assertTrue(list.isBlocked("tracker.io"))
    }

    @Test
    fun extraBlockMatchesParents() {
        val list = sample()
        list.applyPolicy(
            enabledCategories = emptyList(),
            extraBlocked = listOf("custom.blocked"),
            allowed = emptyList(),
        )
        assertTrue(list.isBlocked("pixel.custom.blocked"))
        assertFalse(list.isBlocked("ads.example.com"))
    }
}

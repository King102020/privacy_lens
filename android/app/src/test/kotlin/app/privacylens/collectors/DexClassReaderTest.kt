package app.privacylens.collectors

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import java.nio.ByteBuffer
import java.nio.ByteOrder

class DexClassReaderTest {
    @Test
    fun rejectsNonDexBytes() {
        assertFalse(DexClassReader.isDex(ByteArray(0x70)))
        assertTrue(DexClassReader.classDescriptors(ByteArray(8)).isEmpty())
    }

    @Test
    fun readsClassDescriptorsAndSkipsPrimitives() {
        val descriptors = DexClassReader.classDescriptors(
            dexWith(
                "Lcom/ads/Tracker;",
                "I",
                "[Ljava/lang/String;",
                "Lcom/example/App;",
            ),
        )
        assertEquals(
            listOf("Lcom/ads/Tracker;", "Lcom/example/App;"),
            descriptors,
        )
    }

    @Test
    fun returnsEmptyWhenHeaderOffsetsDoNotFit() {
        val bytes = ByteArray(0x70)
        bytes[0] = 'd'.code.toByte()
        bytes[1] = 'e'.code.toByte()
        bytes[2] = 'x'.code.toByte()
        bytes[3] = '\n'.code.toByte()
        val buffer = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)
        buffer.putInt(0x38, 99)
        buffer.putInt(0x3C, 0x70)
        assertTrue(DexClassReader.classDescriptors(bytes).isEmpty())
    }
}

/** Minimal DEX that only fills the header fields DexClassReader reads. */
fun dexWith(vararg strings: String): ByteArray {
    val stringData = ArrayList<Byte>()
    val stringOffsets = IntArray(strings.size)
    for ((index, value) in strings.withIndex()) {
        stringOffsets[index] = stringData.size
        val utf8 = value.toByteArray(Charsets.UTF_8)
        stringData += utf8.size.toByte()
        stringData += utf8.toList()
        stringData += 0.toByte()
    }

    val headerSize = 0x70
    val stringIdsOff = headerSize
    val typeIdsOff = stringIdsOff + strings.size * 4
    val dataOff = typeIdsOff + strings.size * 4
    val bytes = ByteArray(dataOff + stringData.size)
    bytes[0] = 'd'.code.toByte()
    bytes[1] = 'e'.code.toByte()
    bytes[2] = 'x'.code.toByte()
    bytes[3] = '\n'.code.toByte()

    val buffer = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)
    buffer.putInt(0x38, strings.size)
    buffer.putInt(0x3C, stringIdsOff)
    buffer.putInt(0x40, strings.size)
    buffer.putInt(0x44, typeIdsOff)
    for (index in strings.indices) {
        buffer.putInt(stringIdsOff + index * 4, dataOff + stringOffsets[index])
        buffer.putInt(typeIdsOff + index * 4, index)
    }
    for (index in stringData.indices) {
        bytes[dataOff + index] = stringData[index]
    }
    return bytes
}

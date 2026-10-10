package app.privacylens.collectors

import java.nio.ByteBuffer
import java.nio.ByteOrder

/**
 * Reads class type descriptors (for example `Lcom/example/Foo;`) from a DEX
 * file using only the header, string ids, and type ids sections.
 * Format: https://source.android.com/docs/core/runtime/dex-format
 */
object DexClassReader {
    private const val HEADER_SIZE = 0x70
    private const val STRING_IDS_SIZE_OFFSET = 0x38
    private const val STRING_IDS_OFF_OFFSET = 0x3C
    private const val TYPE_IDS_SIZE_OFFSET = 0x40
    private const val TYPE_IDS_OFF_OFFSET = 0x44

    fun isDex(bytes: ByteArray): Boolean =
        bytes.size >= HEADER_SIZE &&
            bytes[0] == 'd'.code.toByte() &&
            bytes[1] == 'e'.code.toByte() &&
            bytes[2] == 'x'.code.toByte() &&
            bytes[3] == '\n'.code.toByte()

    /** Returns class descriptors, skipping primitive and array types. */
    fun classDescriptors(bytes: ByteArray): List<String> {
        if (!isDex(bytes)) return emptyList()
        val buffer = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)
        val stringIdsSize = buffer.getInt(STRING_IDS_SIZE_OFFSET)
        val stringIdsOff = buffer.getInt(STRING_IDS_OFF_OFFSET)
        val typeIdsSize = buffer.getInt(TYPE_IDS_SIZE_OFFSET)
        val typeIdsOff = buffer.getInt(TYPE_IDS_OFF_OFFSET)
        if (!fits(bytes, stringIdsOff, stringIdsSize) || !fits(bytes, typeIdsOff, typeIdsSize)) {
            return emptyList()
        }

        val descriptors = ArrayList<String>(typeIdsSize)
        for (index in 0 until typeIdsSize) {
            val descriptorIndex = buffer.getInt(typeIdsOff + index * Int.SIZE_BYTES)
            if (descriptorIndex < 0 || descriptorIndex >= stringIdsSize) continue
            val dataOffset = buffer.getInt(stringIdsOff + descriptorIndex * Int.SIZE_BYTES)
            val descriptor = readStringData(bytes, dataOffset) ?: continue
            if (descriptor.startsWith('L')) descriptors += descriptor
        }
        return descriptors
    }

    private fun fits(bytes: ByteArray, offset: Int, count: Int): Boolean =
        offset >= 0 && count >= 0 && offset.toLong() + count.toLong() * Int.SIZE_BYTES <= bytes.size

    /** string_data_item: a ULEB128 UTF-16 length, then MUTF-8 bytes ending in 0. */
    private fun readStringData(bytes: ByteArray, offset: Int): String? {
        if (offset < 0 || offset >= bytes.size) return null
        var position = offset
        while (position < bytes.size && bytes[position].toInt() and 0x80 != 0) position++
        position++
        val start = position
        while (position < bytes.size && bytes[position] != 0.toByte()) position++
        if (position >= bytes.size) return null
        return String(bytes, start, position - start, Charsets.UTF_8)
    }
}

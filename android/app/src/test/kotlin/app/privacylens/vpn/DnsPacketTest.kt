package app.privacylens.vpn

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class DnsPacketTest {
    @Test
    fun parseReadsDomainAndNxDomainKeepsTheQuestion() {
        val packet = dnsQueryPacket("ads.example.com")
        val query = DnsPacket.parse(packet, packet.size)
        assertNotNull(query)
        assertEquals("ads.example.com", query!!.domain)

        val reply = DnsPacket.nxDomain(query)
        assertTrue(reply[2].toInt() and 0x80 != 0)
        assertEquals(3, reply[3].toInt() and 0x0F)

        val wrapped = DnsPacket.wrapReply(query, reply)
        assertEquals(0x45, wrapped[0].toInt() and 0xFF)
        assertEquals(17, wrapped[9].toInt() and 0xFF)
        assertEquals(query.sourcePort, u16(wrapped, 22))
    }

    @Test
    fun parseRejectsResponsesAndNonDnsPorts() {
        val response = dnsQueryPacket("ads.example.com")
        response[30] = (response[30].toInt() or 0x80).toByte()
        assertNull(DnsPacket.parse(response, response.size))

        val otherPort = dnsQueryPacket("ads.example.com", destPort = 5353)
        assertNull(DnsPacket.parse(otherPort, otherPort.size))
    }

    private fun dnsQueryPacket(domain: String, destPort: Int = 53): ByteArray {
        val labels = domain.split('.')
        val question = ArrayList<Byte>()
        for (label in labels) {
            question += label.length.toByte()
            question += label.toByteArray(Charsets.US_ASCII).toList()
        }
        question += 0.toByte()
        question += 0.toByte()
        question += 1.toByte()
        question += 0.toByte()
        question += 1.toByte()

        val message = ByteArray(12 + question.size)
        message[4] = 0
        message[5] = 1
        for (index in question.indices) message[12 + index] = question[index]

        val udpLength = 8 + message.size
        val packet = ByteArray(20 + udpLength)
        packet[0] = 0x45.toByte()
        setU16(packet, 2, packet.size)
        packet[9] = 17
        packet[12] = 10
        packet[13] = 1
        packet[14] = 2
        packet[15] = 3
        packet[16] = 10
        packet[17] = 111
        packet[18] = 222.toByte()
        packet[19] = 2
        setU16(packet, 20, 12345)
        setU16(packet, 22, destPort)
        setU16(packet, 24, udpLength)
        System.arraycopy(message, 0, packet, 28, message.size)
        return packet
    }

    private fun u16(bytes: ByteArray, offset: Int): Int =
        ((bytes[offset].toInt() and 0xFF) shl 8) or (bytes[offset + 1].toInt() and 0xFF)

    private fun setU16(bytes: ByteArray, offset: Int, value: Int) {
        bytes[offset] = (value shr 8).toByte()
        bytes[offset + 1] = value.toByte()
    }
}

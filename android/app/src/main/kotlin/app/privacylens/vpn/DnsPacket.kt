package app.privacylens.vpn

/** A DNS query carried in an IPv4/UDP packet read from the tunnel. */
class DnsQuery(
    val sourceAddress: ByteArray,
    val destinationAddress: ByteArray,
    val sourcePort: Int,
    val destinationPort: Int,
    /** The DNS message (UDP payload). */
    val message: ByteArray,
    val domain: String,
    /** Offset in [message] just past the first question. */
    val questionEnd: Int,
)

/**
 * Minimal IPv4/UDP/DNS handling for a DNS-only tunnel: parse queries, build an
 * NXDOMAIN reply, and wrap replies back into IPv4/UDP packets.
 */
object DnsPacket {
    private const val IPV4_VERSION = 4
    private const val PROTOCOL_UDP = 17
    private const val DNS_PORT = 53
    private const val UDP_HEADER_SIZE = 8
    private const val DNS_HEADER_SIZE = 12
    private const val IPV4_HEADER_SIZE = 20
    private const val DEFAULT_TTL = 64
    private const val MAX_LABEL_LENGTH = 63
    private const val RCODE_NAME_ERROR = 3

    fun parse(packet: ByteArray, length: Int): DnsQuery? {
        if (length < IPV4_HEADER_SIZE + UDP_HEADER_SIZE + DNS_HEADER_SIZE) return null
        val version = (packet[0].toInt() shr 4) and 0x0F
        if (version != IPV4_VERSION) return null
        val ipHeaderLength = (packet[0].toInt() and 0x0F) * 4
        if (packet[9].toInt() and 0xFF != PROTOCOL_UDP) return null
        val totalLength = u16(packet, 2).coerceAtMost(length)
        val udpStart = ipHeaderLength
        if (totalLength < udpStart + UDP_HEADER_SIZE + DNS_HEADER_SIZE) return null

        val destinationPort = u16(packet, udpStart + 2)
        if (destinationPort != DNS_PORT) return null
        val sourcePort = u16(packet, udpStart)
        val payloadStart = udpStart + UDP_HEADER_SIZE
        val message = packet.copyOfRange(payloadStart, totalLength)

        val isResponse = message[2].toInt() and 0x80 != 0
        val questionCount = u16(message, 4)
        if (isResponse || questionCount < 1) return null
        val (domain, questionEnd) = readQuestion(message) ?: return null

        return DnsQuery(
            sourceAddress = packet.copyOfRange(12, 16),
            destinationAddress = packet.copyOfRange(16, 20),
            sourcePort = sourcePort,
            destinationPort = destinationPort,
            message = message,
            domain = domain,
            questionEnd = questionEnd,
        )
    }

    /** A reply with the query's header and first question, answering NXDOMAIN. */
    fun nxDomain(query: DnsQuery): ByteArray {
        val reply = query.message.copyOfRange(0, query.questionEnd)
        // QR=1 (response), keep opcode and RD, set RA=1 and RCODE=NXDOMAIN.
        reply[2] = (0x80 or (query.message[2].toInt() and 0x79)).toByte()
        reply[3] = (0x80 or RCODE_NAME_ERROR).toByte()
        setU16(reply, 4, 1)
        setU16(reply, 6, 0)
        setU16(reply, 8, 0)
        setU16(reply, 10, 0)
        return reply
    }

    /** Wraps a DNS reply into an IPv4/UDP packet addressed back to the querier. */
    fun wrapReply(query: DnsQuery, reply: ByteArray, replyLength: Int = reply.size): ByteArray {
        val udpLength = UDP_HEADER_SIZE + replyLength
        val totalLength = IPV4_HEADER_SIZE + udpLength
        val packet = ByteArray(totalLength)
        packet[0] = 0x45
        setU16(packet, 2, totalLength)
        packet[6] = 0x40 // Don't fragment.
        packet[8] = DEFAULT_TTL.toByte()
        packet[9] = PROTOCOL_UDP.toByte()
        System.arraycopy(query.destinationAddress, 0, packet, 12, 4)
        System.arraycopy(query.sourceAddress, 0, packet, 16, 4)
        setU16(packet, 10, ipv4Checksum(packet))

        setU16(packet, IPV4_HEADER_SIZE, query.destinationPort)
        setU16(packet, IPV4_HEADER_SIZE + 2, query.sourcePort)
        setU16(packet, IPV4_HEADER_SIZE + 4, udpLength)
        // UDP checksum 0 means "not computed", which IPv4 allows.
        System.arraycopy(reply, 0, packet, IPV4_HEADER_SIZE + UDP_HEADER_SIZE, replyLength)
        return packet
    }

    private fun readQuestion(message: ByteArray): Pair<String, Int>? {
        var position = DNS_HEADER_SIZE
        val labels = ArrayList<String>()
        while (true) {
            if (position >= message.size) return null
            val length = message[position].toInt() and 0xFF
            position++
            if (length == 0) break
            if (length > MAX_LABEL_LENGTH || position + length > message.size) return null
            labels += String(message, position, length, Charsets.US_ASCII)
            position += length
        }
        val questionEnd = position + 4 // QTYPE and QCLASS.
        if (labels.isEmpty() || questionEnd > message.size) return null
        return labels.joinToString(".").lowercase() to questionEnd
    }

    private fun ipv4Checksum(packet: ByteArray): Int {
        var sum = 0
        for (offset in 0 until IPV4_HEADER_SIZE step 2) {
            if (offset == 10) continue
            sum += u16(packet, offset)
        }
        while (sum shr 16 != 0) sum = (sum and 0xFFFF) + (sum shr 16)
        return sum.inv() and 0xFFFF
    }

    private fun u16(bytes: ByteArray, offset: Int): Int =
        ((bytes[offset].toInt() and 0xFF) shl 8) or (bytes[offset + 1].toInt() and 0xFF)

    private fun setU16(bytes: ByteArray, offset: Int, value: Int) {
        bytes[offset] = (value shr 8).toByte()
        bytes[offset + 1] = value.toByte()
    }
}

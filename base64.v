fn encode(input_string string) string {
    input_bytes := input_string.bytes()

    if input_bytes.len == 0 {
        return ""
    }

    input_length := input_bytes.len
    full_block_count := input_length / 3
    remaining_bytes := input_length % 3
    output_length := full_block_count * 4 + if remaining_bytes == 0 { 0 } else { 4 }
    mut output_chars := []rune{len: output_length}

    for i := 0; i < full_block_count; i++ {
        byte_index := i * 3
        first_byte := input_bytes[byte_index]
        second_byte := input_bytes[byte_index + 1]
        third_byte := input_bytes[byte_index + 2]

        output_chars[i * 4] = six_bit_to_char((first_byte >> 2) & 0x3F)
        output_chars[i * 4 + 1] = six_bit_to_char(((first_byte & 0x03) << 4) | ((second_byte >> 4) & 0x0F))
        output_chars[i * 4 + 2] = six_bit_to_char(((second_byte & 0x0F) << 2) | ((third_byte >> 6) & 0x03))
        output_chars[i * 4 + 3] = six_bit_to_char(third_byte & 0x3F)
    }

    if remaining_bytes > 0 {
        byte_index := full_block_count * 3
        first_byte := input_bytes[byte_index]
        second_byte := if remaining_bytes > 1 { input_bytes[byte_index + 1] } else { 0 }

        output_chars[full_block_count * 4] = six_bit_to_char((first_byte >> 2) & 0x3F)
        output_chars[full_block_count * 4 + 1] = six_bit_to_char(((first_byte & 0x03) << 4) | ((second_byte >> 4) & 0x0F))
        output_chars[full_block_count * 4 + 2] = if remaining_bytes == 1 { `=` } else { six_bit_to_char(((second_byte & 0x0F) << 2)) }
        output_chars[full_block_count * 4 + 3] = `=`
    }

    return output_chars.string()
}

fn six_bit_to_char(b u8) rune {
    if b < 26 {
        return rune(`A` + b)
    }
    if b < 52 {
        return rune(`a` + (b - 26))
    }
    if b < 62 {
        return rune(`0` + (b - 52))
    }
    if b == 62 {
        return `+`
    } else {
        return `/`
    }
}

fn decode(encoded_string string) []u8 {
    if encoded_string.len == 0 {
        return []u8{}
    }

    padding_count := if encoded_string.ends_with('==') { 2 } else if encoded_string.ends_with('=') { 1 } else { 0 }
    block_count := encoded_string.len / 4
    mut bytes := []u8{len: block_count * 3 - padding_count}

    for i := 0; i < block_count; i++ {
        char_index := i * 4
        temp1 := char_to_six_bit(encoded_string[char_index])
        temp2 := char_to_six_bit(encoded_string[char_index + 1])
        temp3 := char_to_six_bit(encoded_string[char_index + 2])
        temp4 := char_to_six_bit(encoded_string[char_index + 3])

        first_byte := (temp1 << 2) | (temp2 >> 4)
        second_byte := ((temp2 & 0x0F) << 4) | (temp3 >> 2)
        third_byte := ((temp3 & 0x03) << 6) | temp4

        byte_index := i * 3
        bytes[byte_index] = first_byte
        if padding_count < 2 || i < block_count - 1 {
            bytes[byte_index + 1] = second_byte
        }
        if padding_count < 1 || i < block_count - 1 {
            bytes[byte_index + 2] = third_byte
        }
    }

    return bytes
}

fn char_to_six_bit(c u8) u8 {
    if c >= `A` && c <= `Z` {
        return c - `A`
    }
    if c >= `a` && c <= `z` {
        return 26 + (c - `a`)
    }
    if c >= `0` && c <= `9` {
        return 52 + (c - `0`)
    }
    if c == `+` {
        return 62
    }
    return 63
}

fn main() {
    println('Encoded String: ${encode('Le lait tombe : adieu veau, vache, cochon, couvée.')}')
    println('Decoded Bytes: ${decode('TGUgbGFpdCB0b21iZSA6IGFkaWV1IHZlYXUsIHZhY2hlLCBjb2Nob24sIGNvdXbDqWUu').bytestr()}')
}
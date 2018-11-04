# File format for STAR001.VOC included on the Star Control 3 disc
#   Size: 276,078,592 bytes
#   Date: ‎August ‎15, ‎1996, ‏‎2:35:38 PM
#   SHA1: 31d06d53fc9129114aa06e645889e9660e2095e0
#
# Header:
#   2 byte, little-endian: count of following indices
#   4 byte, little-endian: absolute position from start of file for first chunk
#   ... repeat above as needed
# Chunks:
#   2 byte, little-endian: unknown. only values are 0x2000 and 0x0000
#   4 byte, little-endian: length of data
#   following bytes are data (WAV, starting with the "RIFF" header)
#
begin
    file = File.open("STAR001.VOC", "rb")
    index = {}
    chunk = file.read(2)
    count_objects = chunk.unpack("S<").first
    
    0.upto(count_objects) do |i|
        chunk = file.read(4)
        index[i] = chunk.unpack("L<").first
    end
    
    index.each do |idx, file_pos|
        if file_pos != 0
            file.seek(file_pos, IO::SEEK_SET )
            chunk = file.read(2)# + "\0\0"
            unknown = chunk.unpack("S<").first
            chunk = file.read(4)
            data_length = chunk.unpack("L<").first
            output_filename = "STAR001_#{idx.to_s.rjust(4,'0')}_#{unknown.to_s(16).rjust(2,'0')}.wav"
            output = File.new(output_filename, "wb+")
            output.write(file.read(data_length))
        end
    end
end
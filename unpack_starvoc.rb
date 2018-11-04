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
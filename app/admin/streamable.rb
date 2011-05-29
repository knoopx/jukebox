module Streamable
  def stream_file(file_path)
    length = File.size(file_path)
    status_code = 200
    range_start = 0
    range_end = length - 1

    headers.update(
        'Content-Type' => "application/octet-stream",
        'Content-Transfer-Encoding' => 'binary'
    )

    if request.env['HTTP_RANGE'] =~ /bytes=(\d+)-(\d*)/ then
      status_code = 206
      range_start, range_end = $1, $2

      if range_start.empty? and range_end.empty?
        headers["Content-Length"] = "0"
        return render(:status => 416, :nothing => true)
      end

      if range_end.empty?
        range_end = length - 1
      else
        range_end = range_end.to_i
      end

      if range_start.empty?
        range_start = length - range_end
        range_end = length - 1
      else
        range_start = range_start.to_i
      end

      headers['Accept-Ranges'] = 'bytes'
      headers['Content-Range'] = "bytes #{range_start}-#{range_end}/#{length}"
    end

    range_length = range_end.to_i - range_start.to_i + 1
    headers['Content-Length'] = range_length.to_s
    headers['Cache-Control'] = 'private' if headers['Cache-Control'] == 'no-cache'

    File.open(file_path, 'rb') do |file|
      file.seek(range_start, IO::SEEK_SET)
      render :status => status_code, :text => file.read(range_length)
    end
  end
end

ActiveAdmin::ResourceController.send(:include, Streamable)
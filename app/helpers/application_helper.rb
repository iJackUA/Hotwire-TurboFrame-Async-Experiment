module ApplicationHelper
  def turbo_frame_tag_async(dom_id, *data, loading: "Loading...", &)
    async_tag_id = "async_tag_" + SecureRandom.hex(5)

    Concurrent::Promises.zip(*data).then do |*values|
      html_block = capture(*values, &)
      Turbo::StreamsChannel.broadcast_replace_to(async_tag_id, target: dom_id, html: html_block)
    end

    output = turbo_stream_from async_tag_id
    frame = turbo_frame_tag dom_id do
      loading
    end
    output << frame
    output.html_safe
  end
end

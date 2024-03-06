class OpenAi
  require 'ruby/openai'
  require 'base64'

  def self.generate_title(body, post_image)
    client = OpenAI::Client.new

    prompt = "次の画像と文章をもとに、ユニークなタイトルをつけてください。
              ただし、出力に「タイトル」を含めないでください。
              文章：#{body}、
              No repeat, no remarks, only results, in Japanese:"

    # バイナリ形式で画像ファイルを読み込み、Base64エンコード
    encoded_image = Base64.encode64(post_image.read)

    # multiple images is also possible, add to this list
    messages = [
      { type: "text", text: prompt },
      { type: "image_url",
        image_url: {
          url: "data:image/jpeg;base64, #{encoded_image}",
          detail: "low"
        }
      }
    ]

    response = client.chat(
      parameters: {
        model: "gpt-4-vision-preview",
        messages: [ { role: "user", content: messages } ],
        temperature: 0.7,
      }
    )

    # Extracting the response text from the first choice
    # Adjust this if the structure is different
    response.dig("choices", 0, "message", "content")
  end
end

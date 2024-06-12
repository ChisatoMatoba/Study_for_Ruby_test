module MarkdownHelper
  # RedcarpetとRedcarpet::Render::Stripを読み込む
  require 'redcarpet'
  require 'redcarpet/render_strip'

  # マークダウン形式のテキストをHTMLに変換するメソッド
  def markdown(text)
    # レンダリングのオプションを設定する
    render_options = {
      filter_html: true, # HTMLタグのフィルタリングを有効にする
      hard_wrap: true, # ハードラップを有効にする
      link_attributes: { rel: 'nofollow', target: '_blank' }, # リンクの属性を設定する
      space_after_headers: true, # ヘッダー後のスペースを有効にする
      fenced_code_blocks: true # フェンス付きコードブロックを有効にする
    }

    # マークダウンの拡張機能を設定する
    extensions = {
      autolink: true, # 自動リンクを有効にする
      no_intra_emphasis: true, # 単語内の強調を無効にする
      fenced_code_blocks: true, # フェンス付きコードブロックを有効にする
      lax_spacing: true, # 緩いスペーシングを有効にする
      strikethrough: true # 取り消し線を有効にする
    }

    # HTMLレンダラーを作成する
    renderer = CustomRender.new(render_options)
    # マークダウンをHTMLに変換し、結果をhtml_safeにする
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe # rubocop:disable all
  end

  class CustomRender < Redcarpet::Render::HTML
    def block_code(code, _language)
      "<pre class='code-block'><code>#{ERB::Util.html_escape(code)}</code></pre>"
    end

    def codespan(code)
      "<code class='inline-code'>#{ERB::Util.html_escape(code)}</code>"
    end
  end
end

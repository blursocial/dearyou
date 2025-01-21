module ApplicationHelper

  def show_svg(path, options = {})
  file_path = Rails.root.join("app", "assets", "images", path)
  if File.exist?(file_path)
    svg = File.read(file_path)
    if options[:class]
      doc = Nokogiri::HTML::DocumentFragment.parse(svg)
      svg_tag = doc.at_css("svg")
      svg_tag["class"] = options[:class]
      doc.to_html.html_safe
    else
      raw svg
    end
  else
    "(SVG not found)"
  end
end

end

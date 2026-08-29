require "nokogiri"

# Order-insensitive XML comparison: attributes are sorted by name and sibling
# elements by their own canonical form, then both documents are compared as
# strings.
module XmlAssertions
  def self.canonicalize(xml, indent = 0)
    node = xml.is_a?(String) ? Nokogiri::XML.parse(xml).root : xml
    return "(unparsable xml)\n#{xml}" if node.nil?

    pad      = "  " * indent
    attrs    = node.attribute_nodes.map { |a| " #{a.name}=#{a.value.inspect}" }.sort.join
    children = node.elements

    if children.empty?
      "#{pad}<#{node.name}#{attrs}>#{node.text.strip}</#{node.name}>\n"
    else
      body = children.map { |child| canonicalize(child, indent + 1) }.sort.join
      "#{pad}<#{node.name}#{attrs}>\n#{body}#{pad}</#{node.name}>\n"
    end
  end

  # Arguments read (asserted, expected), the assertion order used throughout this suite.
  def assert_xml_equal(actual, expected, msg = nil)
    assert_equal XmlAssertions.canonicalize(expected),
                 XmlAssertions.canonicalize(actual),
                 msg
  end
end

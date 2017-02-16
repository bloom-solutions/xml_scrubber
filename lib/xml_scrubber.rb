require "nokogiri"
require "xml_scrubber/version"

module XMLScrubber

  DEFAULT_REPLACEMENT = "[filtered]"

  def self.call(xml, *directives)
    tree = Nokogiri.XML(xml)
    tree.traverse do |node|
      Array(directives).flatten.each do |directive|
        node.content = DEFAULT_REPLACEMENT if applies_to_node?(directive, node)
      end
    end
    tree.to_s
  end

  private

  def self.applies_to_node?(directive, node)
    directive_name, directive_opts = directive.to_a.flatten
    if directive_name == :name
      namespace_name = node.respond_to?(:namespace) ?
        node.namespace&.prefix : nil
      node_name = [namespace_name, node.name].compact.join(":")
      if node_name.match(directive_opts[:matches])
        node.content = DEFAULT_REPLACEMENT
      end
    else
      fail ArgumentError, "unknown directive `#{directive_name}`"
    end
    node_name.match(directive_opts[:matches])
  end

end

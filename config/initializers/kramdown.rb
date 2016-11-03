module Kramdown
  module Converter
    class GovauHtml < Html

      # Wrap any table in the content-table class
      def convert_table(el, indent)
        attr = el.attr.dup
        attr['class'] = 'content-table'
        format_as_indented_block_html(el.type, attr, inner(el, indent), indent)
      end


      # The generated TOC does not need the index-links class, as
      # the nav that wraps it uses this class to inform the TOC style.
      # Method overriden from https://github.com/gettalong/kramdown/blob/REL_1_11_1/lib/kramdown/converter/html.rb#L375
      def generate_toc_tree(toc, type, attr)
        # Don't use the default ul styling
        sections = Element.new(type, nil, {})
        sections.attr['id'] ||= 'markdown-toc'
        stack = []
        toc.each do |level, id, children|
          li = Element.new(:li, nil, nil, {:level => level})
          li.children << Element.new(:p, nil, nil, {:transparent => true})
          a = Element.new(:a, nil)
          a.attr['href'] = "##{id}"
          a.attr['id'] = "#{sections.attr['id']}-#{id}"
          a.children.concat(remove_footnotes(Marshal.load(Marshal.dump(children))))
          li.children.last.children << a
          li.children << Element.new(type)

          success = false
          while !success
            if stack.empty?
              sections.children << li
              stack << li
              success = true
            elsif stack.last.options[:level] < li.options[:level]
              stack.last.children.last.children << li
              stack << li
              success = true
            else
              item = stack.pop
              item.children.pop unless item.children.last.children.size > 0
            end
          end
        end
        while !stack.empty?
          item = stack.pop
          item.children.pop unless item.children.last.children.size > 0
        end
        # Wrap the TOC ul in a nav
        nav_wrapped(sections)
      end


      # Define the conversion method for :nav
      def convert_nav(el, indent)
        format_as_indented_block_html(el.type, el.attr, inner(el, indent), indent)
      end


      private
      # The TOC ul should be wrapped with markup here, as it cannot be
      # specified as part of the markdown due to the way that the TOC
      # is expanded by kramdown.
      #
      # <nav>
      #   <h2>On this page</h2>
      #   <TOC>
      # </nav>
      def nav_wrapped(sections)
        if sections.children.empty?
          sections
        else
          nav = Element.new(:nav, nil, {class: 'index-links'})
          header = Element.new(:header, nil, {'class' => 'no_toc'}, {
              level: 2,
              raw_text: 'On this page'
          })

          header.children << Element.new(:text, 'On this page')
          nav.children << header
          nav.children << sections
          nav
        end
      end
    end
  end
end
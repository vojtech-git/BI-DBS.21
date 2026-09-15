from lxml import etree

# Load the XML and XSL files
xml_content = etree.parse('main.xml')
xsl_content = etree.parse('sproject_html.xsl')

# Transform XML using XSL
transform = etree.XSLT(xsl_content)
result = transform(xml_content)

# Save the output to index.html
with open('index.html', 'wb') as f:
    f.write(etree.tostring(result, pretty_print=True, encoding='utf-8'))

print("Conversion complete! 'index.html' generated.")
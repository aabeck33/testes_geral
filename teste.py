from xml.sax.saxutils import escape

text = escape('(!) isso é < & > um teste')

print(text)
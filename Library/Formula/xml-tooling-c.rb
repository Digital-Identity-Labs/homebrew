require 'formula'

class XmlToolingC < Formula
  url 'http://www.shibboleth.net/downloads/c++-opensaml/2.4.3/xmltooling-1.4.2.tar.gz'
  homepage 'https://wiki.shibboleth.net/confluence/display/OpenSAML/Home'
  md5 '98ed7fb45c63cd6d03446f8c47dc645b'

  depends_on 'pkg-config' => :build
  depends_on 'log4shib'
  depends_on 'xerces-c'
  depends_on 'xml-security-c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

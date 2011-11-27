require 'formula'

class Opensaml < Formula
  url 'http://www.shibboleth.net/downloads/c++-opensaml/2.4.3/opensaml-2.4.3.tar.gz'
  homepage 'https://wiki.shibboleth.net/confluence/display/OpenSAML/Home'
  md5 '368361d56992afafbc6f8190a77ffd53'

  depends_on 'pkg-config' => :build
  depends_on 'log4shib'
  depends_on 'xerces-c'
  depends_on 'xml-security-c'
  depends_on 'xml-tooling-c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

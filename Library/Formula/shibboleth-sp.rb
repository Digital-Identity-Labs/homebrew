require 'formula'

class ShibbolethSp <Formula
  url 'http://www.shibboleth.net/downloads/service-provider/2.4.3/shibboleth-sp-2.4.3.tar.gz'
  homepage 'http://shibboleth.internet2.edu/'
  md5 '4152eeb80d878ff33f6015e3bcf19db1'

  depends_on 'opensaml'

  def options
     [
       ['--odbc',      "Compile support for ODBC sessions (experimental)"],
       ['--memcached', "Compile support for Memcached sessions (experimental)"]
     ]
  end

  depends_on 'unixodbc'  if ARGV.include? '--odbc'
  depends_on 'memcached' if ARGV.include? '--with-memcached'
  
  def install
    
    ENV['NOKEYGEN'] = "1"
    
    args  = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--with-xmltooling=#{HOMEBREW_PREFIX}"
    ]
    
    args << "--enable-odbc"    if ARGV.include?('--odbc')
    args << "--with-memcached" if ARGV.include?('--memcached')
    
    system "./configure", *args

    (var+"run/shibboleth").mkpath
    (var+"lib/shibboleth").mkpath
    
    
    system "cd configs && ./keygen.sh -b"
    
    inreplace "configs/shibd-osx.plist.in", '@-PREFIX-@/sbin', "#{HOMEBREW_PREFIX}/sbin"
    inreplace "configs/shibd-osx.plist.in", '@-PKGRUNDIR-@',  "#{var}/run/shibboleth"
    
    system "make install"
    
    puts "Blah"
    puts etc
    
    (etc+"shibboleth").install Dir["#{prefix}/etc/shibboleth/*"]
    
  end
  
  def caveats; <<-EOS.undent
    
    Your Shibboleth SP configuration files have been installed into:
      #{etc}/shibboleth

    A basic Apache config file is supplied in #{etc}/shibboleth. You can install
    it with:
    
      sudo cp #{etc}/shibboleth/apache22.config /etc/apache2/other/shibboleth.conf
      sudo apachectl restart
    
    The Shibd daemon should be running before Apache is restarted.
    
    If this is your first install, automatically load the shibd daemon on login with:
    
      mkdir -p ~/Library/LaunchAgents
      cp #{etc}/shibboleth/shibd-osx.plist ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/shibd-osx.plist

    If this is an upgrade and you already have the shibd-osx.plist loaded:
    
      launchctl unload -w ~/Library/LaunchAgents/shibd-osx.plist
      cp #{etc}/shibboleth/shibd-osx.plist ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/shibd-osx.plist

    Or start the daemon manually:
    
      #{HOMEBREW_PREFIX}/sbin/shibd -F -f -p #{var}/run/shibboleth/shibd.pid    
    
    EOS
  end

    
end

module ApplicationHelper    

  def facebook_logo
       image_tag("facebook_logo.png", :alt => "Facebook login", :class => "logo", :width => 17, :height => 17)
  end

  def base64_url_decode(str)
       str += '=' * (4 - str.length.modulo(4))
       Base64.decode64(str.tr('-_','+/'))
     end


    def encrypt(unencrypted, key)
        c = OpenSSL::Cipher.new("aes-128-cbc")
        c.encrypt
        c.key = key
        e = c.update(unencrypted)
        e << c.final
        return e
    end

    def decrypt2(encrypted_attr, key)
        c = OpenSSL::Cipher::Cipher.new("aes-128-cbc")
        c.decrypt
        c.key = key
        d = c.update(encrypted_attr)
        d << c.final
        return d
    end
  
  
end

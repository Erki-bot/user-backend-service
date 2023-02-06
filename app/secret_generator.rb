def secretGenerator(length)
  chars = ("a".."z").to_a.concat(("A".."Z").to_a)
  (1..length).map { chars[rand(chars.length - 1)] }.join
end

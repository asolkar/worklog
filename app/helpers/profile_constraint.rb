class ProfileConstraint
  def self.matches?(request)
    reserved_words = ['login', 'signup', 'logout', 'help', 'about', 'search']
    !reserved_words.include?(request.path_parameters[:username])
  end
end

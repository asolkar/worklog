class ProfileConstraint
  def self.matches?(request)
    reserved_words = ['login', 'signup', 'logout', 'help', 'about', 'search', 'profile',
                      'google_plus_sign_in', 'gplussignin']
    !reserved_words.include?(request.path_parameters[:username])
  end
end

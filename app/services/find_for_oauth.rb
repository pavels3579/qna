module Services
  class FindForOauth
    attr_reader :auth

    def initialize(auth)
      @auth = auth
    end

    def call
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      email = auth.info[:email] || "tempusermail#{rand(1000..9999)}@tempusermail.com"
      user = User.where(email: email).first
      unless user
        password = Devise.friendly_token[0, 20]
        user = User.new(email: email, password: password, password_confirmation: password)
        user.skip_confirmation!
        user.save!
      end
      user.create_authorization(auth)
      user
    end
  end
end

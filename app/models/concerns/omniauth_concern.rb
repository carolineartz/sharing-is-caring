module OmniauthConcern
  extend ActiveSupport::Concern

  def update_from_omniauth(oauth)
    data, attrs = self.class.normalize_oauth(oauth)
    self.oauth_data = data
    update_attributes(attrs)
  end

  module ClassMethods
    def build_from_omniauth(oauth)
      data, attrs = normalize_oauth(oauth)
      auth = Authentication.new(attrs)
      auth.oauth_data = data
      auth
    end

    def normalize_oauth(oauth)
      data = {
        provider:             oauth.provider.downcase,
        uid:                  oauth.uid,
        username:             oauth.extra.try(:[], 'raw_info').try(:[], 'username').presence ||
                              oauth.extra.try(:[], 'raw_info').try(:[], 'screen_name'),
        nickname:             oauth.info.try(:[], 'nickname'),
        email:                oauth.info.try(:[], 'email').presence ||
                              oauth.extra.try(:[], 'raw_info').try(:[], 'email'),
        name:                 oauth.info.try(:[], 'name'),
        first_name:           oauth.info.try(:[], 'first_name'),
        last_name:            oauth.info.try(:[], 'last_name'),
        image_url:            oauth.info.try(:[], 'image'),
        location:             oauth.info.try(:[], 'location').presence ||
                              oauth.extra.try(:[], 'raw_info').try(:[], 'location').try(:[], 'name'),
        token:                oauth.credentials.token,
        refresh_token:        oauth.credentials.try(:[], 'refresh_token') || nil,
        secret:               oauth.credentials.try(:[], 'secret') || nil,
        expires:              oauth.credentials.try(:[], 'expires').presence || nil,
        expires_at:           oauth.credentials.try(:[], 'expires_at').presence || nil,
        verified:             oauth.extra.try(:[], 'raw_info').try(:[], 'verified'),
        bio:                  oauth.info.try(:[], 'description').presence ||
                              oauth.extra.try(:[], 'raw_info').try(:[], 'bio').presence ||
                              oauth.info.try(:[], 'headline')
      }
      data[:urls] = Array(oauth.info.try(:[], 'urls')).select do |name,url|
        data[:profile_url] = url if name.downcase == oauth.provider.downcase || name == 'public_profile'
        name.underscore != oauth.provider && name.downcase != oauth.provider
      end
      [data, normalized_oauth_to_attributes(data)]
    end

    def normalized_oauth_to_attributes(data)
      @@attribute_symbols ||= self.attribute_names.map{|a| a.to_sym}.freeze
      data[:proid] = data[:uid]
      data[:expires_at] = Time.at(data[:expires_at]) if data[:expires_at].present?
      data.select{|k, v| @@attribute_symbols.include?(k)}
    end
  end
end
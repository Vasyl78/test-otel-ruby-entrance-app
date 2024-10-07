# frozen_string_literal: true

module Routes
  # Routes::Application
  class Application < ::Roda
    opts[:root] = ENV.fetch('APP_ROOT', nil)
    plugin :all_verbs
    plugin :symbol_status
    plugin :json, content_type: 'application/vnd.api+json'
    plugin :json_parser
    plugin :slash_path_empty
    plugin :hash_routes
    plugin :request_headers

    route(&:hash_routes)

    hash_branch 'entrance-application' do |req|
      req.is('validate-user-license', String, method: :post) do |uuid|
        user_data = Utils::JsonRequest.call(
          url: format(Constants::USERS_FIND_BY_UID_URL, { uuid: uuid }),
          payload: {},
          http_method: :get
        )
        Utils::RedisStorage.set(uuid, user_data)
        req_params = { uuid: user_data[:uuid], passport_no: user_data[:passport_no] }
        valid_license = Utils::JsonRequest.call(
          url: Constants::LICENSES_VERIFY_URL,
          payload: req_params,
          http_method: :post
        )

        response.status = 200
        user_data[:license] = valid_license
        user_data
      end

      req.is('user', String, method: :get) do |uuid|
        user_data = Utils::RedisStorage.get(uuid)

        unless user_data.is_a?(Hash)
          user_data = Utils::JsonRequest.call(
            url: format(Constants::USERS_FIND_BY_UID_URL, { uuid: uuid }),
            payload: {},
            http_method: :get
          )

          Utils::RedisStorage.set(uuid, user_data)
        end

        response.status = 200
        user_data
      end
    end
  end
end

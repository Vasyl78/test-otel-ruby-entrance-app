# frozen_string_literal: true

module Constants
  # Common
  APP_ROOT              = ENV.fetch('APP_ROOT')
  # OpenTelemetry
  APPLICATION_NAME      = ENV.fetch('APPLICATION_NAME')
  APPLICATION_VERSION   = ENV.fetch('APPLICATION_VERSION')
  # Redis
  REDIS_URL             = ENV.fetch('REDIS_URL')
  # External Services
  USERS_FIND_BY_UID_URL = ENV.fetch('USERS_FIND_BY_UID_URL')
  LICENSES_VERIFY_URL   = ENV.fetch('LICENSES_VERIFY_URL')
end

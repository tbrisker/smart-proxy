require 'test_helper'
require 'json'
require 'root/root_v2_api'
require 'logs/logs'

class LogsApiFeaturesTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Proxy::PluginInitializer.new(Proxy::Plugins.instance).initialize_plugins
    Proxy::RootV2Api.new
  end

  def test_features
    # not sure why, but this module loads without loading the config file
    # Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('logs.yml').returns(enabled: true')

    get '/features'

    response = JSON.parse(last_response.body)

    mod = response['logs']
    refute_nil(mod)
    assert_equal([], mod['capabilities'])

    assert_equal({}, mod['settings'])
  end
end

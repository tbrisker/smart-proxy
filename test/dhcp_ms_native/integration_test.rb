require 'test_helper'
require 'json'
require 'root/root_v2_api'
require 'dhcp/dhcp'
require 'dhcp_native_ms/dhcp_native_ms'

class DhcpNativeMsApiFeaturesTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Proxy::PluginInitializer.new(Proxy::Plugins.instance).initialize_plugins
    Proxy::RootV2Api.new
  end

  def test_features
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('dhcp.yml').returns(enabled: true, use_provider: 'dhcp_native_ms')
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('dhcp_native_ms.yml').returns({})

    get '/features'

    response = JSON.parse(last_response.body)

    mod = response['dhcp']
    refute_nil(mod)
    assert_equal([], mod['capabilities'])

    expected_settings = {'use_provider' => 'dhcp_native_ms'}
    assert_equal(expected_settings, mod['settings'])
  end
end

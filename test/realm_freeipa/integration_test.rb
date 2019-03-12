require 'test_helper'
require 'json'
require 'root/root_v2_api'
# require 'realm_freeipa/configuration_loader'
require 'realm_freeipa/realm_freeipa'

class RealmFreeipaApiFeaturesTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Proxy::PluginInitializer.new(Proxy::Plugins.instance).initialize_plugins
    Proxy::RootV2Api.new
  end

  def test_features
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('realm.yml').returns(enabled: true, use_provider: 'realm_freeipa')
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('realm_freeipa.yml').returns({keytab_path: '/etc/foreman-proxy/freeipa.keytab', principal: 'realm-proxy@EXAMPLE.COM', ipa_config: '/etc/ipa/default.conf'})

    get '/features'

    response = JSON.parse(last_response.body)

    mod = response['realm']
    refute_nil(mod)
    assert_equal([], mod['capabilities'])

    expected_settings = {'use_provider' => 'realm_freeipa'}
    assert_equal(expected_settings, mod['settings'])
  end
end

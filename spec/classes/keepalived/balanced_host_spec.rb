# frozen_string_literal: true

require 'spec_helper'

describe 'psick_profile::keepalived::balanced_host' do
  on_supported_os.each do |os, os_facts|
    skip "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do {
        'vip': '1.1.1.1',
        'ports': [ '80', '8080' ],
      } end
      let(:pre_condition) { 'include psick ; include psick_profile::keepalived' }

      it { is_expected.to compile.with_all_deps }
    end
  end
end

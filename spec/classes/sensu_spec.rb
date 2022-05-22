# frozen_string_literal: true

require 'spec_helper'

describe 'psick_profile::sensu' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:pre_condition) { 'include psick' }
      let(:facts) { os_facts }
      let(:params) do {
        'rabbitmq_password': 'aa',
        'api_password': '808080',
      } end
      it { is_expected.to compile.with_all_deps }
    end
  end
end

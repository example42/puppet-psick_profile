# frozen_string_literal: true

require 'spec_helper'

describe 'psick_profile::openvpn::connection' do
  let(:title) { 'namevar' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    skip "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
    end
  end
end

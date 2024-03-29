# frozen_string_literal: true

require 'spec_helper'

describe 'psick_profile::gitlab::user' do
  let(:title) { 'namevar' }
  let(:params) do
    {}
  end
  let(:pre_condition) { 'include psick; include psick_profile::gitlab::cli' }

  on_supported_os.each do |os, os_facts|
    skip "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
    end
  end
end

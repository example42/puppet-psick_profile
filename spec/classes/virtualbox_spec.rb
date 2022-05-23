# frozen_string_literal: true

require 'spec_helper'

describe 'psick_profile::virtualbox' do
  on_supported_os.each do |os, os_facts|
    skip "on #{os}" do
      let(:pre_condition) { 'include psick' }
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
    end
  end
end

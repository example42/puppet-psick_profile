# frozen_string_literal: true

require 'spec_helper'

describe 'psick_profile::gitlab' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:pre_condition) { 'include psick' }
      let(:facts) { os_facts }

      if os.include?('windows')
        it { is_expected.to compile.and_raise_error(/.*/) }
      else
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end

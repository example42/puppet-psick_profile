# frozen_string_literal: true

require 'spec_helper'

describe 'psick_profile::openswan::connection' do
  let(:title) { 'namevar' }
  let(:params) do {
    'options': {'fsd': 'ff'},
  } end
  let(:pre_condition) { 'include psick; include psick_profile::openswan' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      if os.include?('windows')
        it { is_expected.to compile.and_raise_error(/.*/) }
      else
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end

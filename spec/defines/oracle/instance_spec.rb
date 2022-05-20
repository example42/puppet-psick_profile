# frozen_string_literal: true

require 'spec_helper'

describe 'psick_profile::oracle::instance' do
  let(:title) { 'namevar' }
  let(:pre_condition) { include 'psick_profile::oracle' }
  let(:params) do
    {}
  end
  let(:pre_condition) { 'include psick; include psick_profile::oracle' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
    end
  end
end

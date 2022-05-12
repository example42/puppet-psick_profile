# frozen_string_literal: true

require 'spec_helper'

describe 'psick_profile::openswan::connection' do
  let(:title) { 'namevar' }
  let(:params) do
    {}
  end
  let(:pre_condition) { 'include psick; include psick_profile::openswan' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end

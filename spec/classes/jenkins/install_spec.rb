# frozen_string_literal: true

require 'spec_helper'

describe 'psick_profile::jenkins::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include psick; include psick_profile::jenkins' }

      it { is_expected.to compile.with_all_deps }
    end
  end
end

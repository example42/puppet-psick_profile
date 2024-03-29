# frozen_string_literal: true

require 'spec_helper'

describe 'psick_profile::mongo::command' do
  let(:title) { 'namevar' }
  let(:params) do {
    'path': '/tmp/me.txt',
    'template': 'psick_profile/mongo/add_member.js.erb',
  } end
  let(:pre_condition) { 'include psick; include psick_profile::mongo' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
    end
  end
end

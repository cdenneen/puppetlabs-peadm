require 'spec_helper'

describe 'peadm::convert' do
  # Include the BoltSpec library functions
  include BoltSpec::Plans

  let(:trustedjson) do
    JSON.parse File.read(File.expand_path(File.join(fixtures, 'plans', 'trusted_facts.json')))
  end

  let(:params) do
    { 'primary_host' => 'primary' }
  end

  it 'single primary no dr valid' do
    allow_out_message
    allow_any_command
    allow_any_task
    allow_apply

    expect_task('peadm::cert_data').return_for_targets('primary' => trustedjson)
    expect_task('peadm::read_file').always_return({ 'content' => '2021.7.3' })

    # For some reason, expect_plan() was not working??
    allow_plan('peadm::modify_certificate').always_return({})

    expect(run_plan('peadm::convert', params)).to be_ok
  end
end

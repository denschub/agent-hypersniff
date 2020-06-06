# frozen_string_literal: true

require "json"
require "yaml"

require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require_relative "./lib/comparator"
require_relative "./lib/counter"
require_relative "./lib/data_loader"
require_relative "./lib/helpers"

sniffers = DataLoader.sniffers
user_agents = DataLoader.user_agents

puts "Available tests:"
puts "  Noses: #{Counter.noses(sniffers)}"
puts "  Sniffers: #{Counter.sniffers(sniffers)}"
puts "  User Agents: #{Counter.user_agents(user_agents)}"

puts
puts "Starting tests!"
puts

test_results = Hash.tree
test_errors = []
field_result_counters = { pass: 0, fail: 0, "n/a": 0 }

user_agents.each do |test_ua|
  test_ua_name, test_ua_data = test_ua

  sniffers.each do |test_nose, sniffers|
    sniffers.each do |test_sniffer|
      sniffer_name, sniffer_data = test_sniffer

      begin
        response = Faraday.get(
          "http://nose-#{test_nose}:8000/#{sniffer_name}",
          {},
          {
            "Accept": "application/json",
            "User-Agent": test_ua_data[:userAgent]
          }
        )

        unless response.success?
          test_errors.push("Request was unsuccessful! (nose: #{test_nose}, sniffer: #{sniffer_name}, ua: #{test_ua_name}")
          print_char("F")
          next
        end

        test_result = {};
        response_payload = JSON.parse(response.body).symbolize_keys
        response_payload.keys.each do |test_field|
          comp_result = Comparator.compare(
            test_field,
            test_ua_data[:expect][test_field].to_s,
            response_payload[test_field].to_s
          )

          field_result_counters[comp_result[:result]] += 1
          test_result[test_field] = comp_result
        end
        test_results[test_ua_name]["#{test_nose}/#{sniffer_name}"] = test_result
        print_char(".")
      end
    rescue
      test_errors.push("Test threw exception! (nose: #{test_nose}, sniffer: #{sniffer_name}, ua: #{test_ua_name} - #{$!}")
      print_char("F")
    end
  end
end

puts
puts

if test_errors.length > 0
  puts "Errors occured during testing:"
  test_errors.each do |err|
    puts "  * #{err}"
  end
end

puts "Tests done!"
puts
puts "Total fields tested: #{field_result_counters[:pass] + field_result_counters[:fail] + field_result_counters[:"n/a"]}"
puts "  Passed: #{field_result_counters[:pass]}"
puts "  Failed: #{field_result_counters[:fail]}"
puts "  N/A: #{field_result_counters[:"n/a"]}"

target_filename = "#{Time.now.utc.strftime("%Y-%m-%d_%H%M%S")}.json"
File.open("output/#{target_filename}", "w") do |file|
  file.write(JSON.pretty_generate(test_results))
end

puts
puts "Results stored as #{target_filename}."

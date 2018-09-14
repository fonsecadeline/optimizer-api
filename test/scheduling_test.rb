# Copyright © Mapotempo, 2018
#
# This file is part of Mapotempo.
#
# Mapotempo is free software. You can redistribute it and/or
# modify since you respect the terms of the GNU Affero General
# Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Mapotempo is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the Licenses for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Mapotempo. If not, see:
# <http://www.gnu.org/licenses/agpl.html>
#
require './test/test_helper'

class HeuristicTest < Minitest::Test

  # Long tests
  def test_data_retrieved_with_baleares2
    vrp = Models::Vrp.create(Hashie.symbolize_keys(JSON.parse(File.open('test/fixtures/instance_baleares2.json').to_a.join)['vrp']))
    result = OptimizerWrapper.wrapper_vrp('ortools', {services: {vrp: [:ortools]}}, vrp, nil)
    assert result
    assert_equal 3, result[:unassigned].size
    assert_equal vrp[:services].size, result[:routes].collect{ |route| route[:activities].select{ |stop| stop[:service_id] }.size }.sum + result[:unassigned].size
    assert_equal result[:routes].collect{ |route| route[:activities].select{ |activity| activity[:service_id] }.collect{ |activity| activity[:detail][:quantities][0][:value] }.sum }.sum  + result[:unassigned].collect{ |unassigned| unassigned[:detail][:quantities][0][:value] }.sum, vrp.services.collect{ |service| service[:quantities][0][:value] }.sum, vrp.services.collect{ |service| service[:quantities][0][:value] }.sum
    assert !result[:routes].any?{ |route| route[:activities].select{ |stop| !stop[:detail][:quantities].empty? }.collect{ |stop| stop[:detail][:quantities][0][:value] }.sum > vrp.vehicles.find{ |vehicle| vehicle[:id] == route[:vehicle_id] }[:capacities][0][:limit] }
    assert_equal result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } }.flatten.compact.size, result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } }.flatten.compact.uniq.size
  end

  def test_data_retrieved_with_andalucia2
    vrp = Models::Vrp.create(Hashie.symbolize_keys(JSON.parse(File.open('test/fixtures/instance_andalucia2.json').to_a.join)['vrp']))
    result = OptimizerWrapper.wrapper_vrp('ortools', {services: {vrp: [:ortools]}}, vrp, nil)
    assert result
    assert_equal 22, result[:unassigned].size
    assert_equal vrp[:services].size, result[:routes].collect{ |route| route[:activities].select{ |stop| stop[:service_id] }.size }.sum + result[:unassigned].size
    assert_equal result[:routes].collect{ |route| route[:activities].select{ |activity| activity[:service_id] }.collect{ |activity| activity[:detail][:quantities][0][:value] }.sum }.sum + result[:unassigned].collect{ |unassigned| unassigned[:detail][:quantities][0][:value] }.sum, vrp.services.collect{ |service| service[:quantities][0][:value] }.sum
    assert !result[:routes].any?{ |route| route[:activities].select{ |stop| !stop[:detail][:quantities].empty? }.collect{ |stop| stop[:detail][:quantities][0][:value] }.sum > vrp.vehicles.find{ |vehicle| vehicle[:id] == route[:vehicle_id] }[:capacities][0][:limit] }
    assert_equal (result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } } + result[:unassigned].collect{ |unassigned| unassigned[:service_id] }).flatten.compact.size, (result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } } + result[:unassigned].collect{ |unassigned| unassigned[:service_id] }).flatten.compact.uniq.size
  end

  def test_data_retrieved_with_andalucia1_two_vehicles
    vrp = Models::Vrp.create(Hashie.symbolize_keys(JSON.parse(File.open('test/fixtures/instance_andalucia1_two_vehicles.json').to_a.join)['vrp']))
    result = OptimizerWrapper.wrapper_vrp('ortools', {services: {vrp: [:ortools]}}, vrp, nil)
    assert result
    assert_equal 0, result[:unassigned].size
    assert_equal vrp[:services].size, result[:routes].collect{ |route| route[:activities].select{ |stop| stop[:service_id] }.size }.sum
    assert_equal result[:routes].collect{ |route| route[:activities].select{ |activity| activity[:service_id] }.collect{ |activity| activity[:detail][:quantities][0] ? activity[:detail][:quantities][0][:value] : 0 }.sum }.sum + result[:unassigned].collect{ |unassigned| unassigned[:detail][:quantities][0] ? unassigned[:detail][:quantities][0][:value] : 0 }.sum, vrp.services.collect{ |service| service[:quantities][0] ? service[:quantities][0][:value] : 0 }.sum
    assert !result[:routes].any?{ |route| route[:activities].select{ |stop| !stop[:detail][:quantities].empty? }.collect{ |stop| stop[:detail][:quantities][0][:value] }.sum > vrp.vehicles.find{ |vehicle| vehicle[:id] == route[:vehicle_id] }[:capacities][0][:limit] }
    assert_equal result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } }.flatten.compact.size, result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } }.flatten.compact.uniq.size
  end

  def test_data_retrieved_with_andalucia1_two_vehicles
    vrp = Models::Vrp.create(Hashie.symbolize_keys(JSON.parse(File.open('test/fixtures/instance_andalucia1_two_vehicles.json').to_a.join)['vrp']))
    result = OptimizerWrapper.wrapper_vrp('ortools', {services: {vrp: [:ortools]}}, vrp, nil)
    assert result
    assert_equal 0, result[:unassigned].size
    assert_equal vrp[:services].size, result[:routes].collect{ |route| route[:activities].select{ |stop| stop[:service_id] }.size }.sum
    assert_equal result[:routes].collect{ |route| route[:activities].select{ |activity| activity[:service_id] }.collect{ |activity| activity[:detail][:quantities][0] ? activity[:detail][:quantities][0][:value] : 0 }.sum }.sum + result[:unassigned].collect{ |unassigned| unassigned[:detail][:quantities][0] ? unassigned[:detail][:quantities][0][:value] : 0 }.sum, vrp.services.collect{ |service| service[:quantities][0] ? service[:quantities][0][:value] : 0 }.sum
    assert !result[:routes].any?{ |route| route[:activities].select{ |stop| !stop[:detail][:quantities].empty? }.collect{ |stop| stop[:detail][:quantities][0][:value] }.sum > vrp.vehicles.find{ |vehicle| vehicle[:id] == route[:vehicle_id] }[:capacities][0][:limit] }
    assert_equal result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } }.flatten.compact.size, result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } }.flatten.compact.uniq.size
  end

  def test_data_retrieved_with_800_clustered
    vrp = Models::Vrp.create(Hashie.symbolize_keys(JSON.parse(File.open('test/fixtures/instance_800unaffected_clustered.json').to_a.join)['vrp']))
    result = OptimizerWrapper.wrapper_vrp('ortools', {services: {vrp: [:ortools]}}, vrp, nil)
    assert result
    assert_equal vrp[:services].collect{ |service| service[:visits_number] }.sum.round(4), result[:routes].collect{ |route| route[:activities].select{ |stop| stop[:service_id] }.size }.sum + result[:unassigned].size
    assert_equal vrp.services.collect{ |service| service[:quantities].find{ |qte| qte[:unit][:id] == 'kg' }[:value]*service[:visits_number] }.sum.round(4), (result[:routes].collect{ |route| route[:activities].collect{ |stop| stop[:service_id] && stop[:detail][:quantities].size > 0 && stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'kg' }[:value] }}.flatten.compact.sum.round(4) + result[:unassigned].collect{ |service| service[:detail][:quantities].size > 0 && service[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'kg' }[:value] }.flatten.compact.sum).round(4)
    assert_equal vrp.services.collect{ |service| service[:quantities].find{ |qte| qte[:unit][:id] == 'qte' }[:value]*service[:visits_number] }.sum.round(4), (result[:routes].collect{ |route| route[:activities].collect{ |stop| stop[:service_id] && stop[:detail][:quantities].size > 0 && stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'qte' }[:value] }}.flatten.compact.sum.round(4) + result[:unassigned].collect{ |service| service[:detail][:quantities].size > 0 && service[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'qte' }[:value] }.flatten.compact.sum).round(4)
    assert_equal vrp.services.collect{ |service| service[:quantities].find{ |qte| qte[:unit][:id] == 'l' }[:value]*service[:visits_number] }.sum.round(4), (result[:routes].collect{ |route| route[:activities].collect{ |stop| stop[:service_id] && stop[:detail][:quantities].size > 0 && stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'l' }[:value] }}.flatten.compact.sum.round(4) + result[:unassigned].collect{ |service| service[:detail][:quantities].size > 0 && service[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'l' }[:value] }.flatten.compact.sum).round(4)
    assert !result[:routes].any?{ |route| route[:activities].select{ |stop| !stop[:detail][:quantities].empty? }.collect{ |stop| stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'kg' }[:value] }.sum > vrp[:vehicles].find{ |vehicle| vehicle[:id] == route[:vehicle_id].split('_')[0] }[:capacities].find{ |cap| cap[:unit_id] == 'kg' }[:limit]}
    assert !result[:routes].any?{ |route| route[:activities].select{ |stop| !stop[:detail][:quantities].empty? }.collect{ |stop| stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'qte' }[:value] }.sum > vrp[:vehicles].find{ |vehicle| vehicle[:id] == route[:vehicle_id].split('_')[0] }[:capacities].find{ |cap| cap[:unit_id] == 'qte' }[:limit]}
    assert !result[:routes].any?{ |route| route[:activities].select{ |stop| !stop[:detail][:quantities].empty? }.collect{ |stop| stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'l' }[:value] }.sum > vrp[:vehicles].find{ |vehicle| vehicle[:id] == route[:vehicle_id].split('_')[0] }[:capacities].find{ |cap| cap[:unit_id] == 'l' }[:limit]}
    assert_equal result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } }.flatten.compact.size, result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } }.flatten.compact.uniq.size
  end

  def test_data_retrieved_with_800_clustered_and_same_point_day
    vrp = Models::Vrp.create(Hashie.symbolize_keys(JSON.parse(File.open('test/fixtures/instance_800unaffected_clustered_same_point.json').to_a.join)['vrp']))
    result = OptimizerWrapper.wrapper_vrp('ortools', {services: {vrp: [:ortools]}}, vrp, nil)
    assert result
        assert_equal vrp[:services].collect{ |service| service[:visits_number] }.sum.round(4), result[:routes].collect{ |route| route[:activities].select{ |stop| stop[:service_id] }.size }.sum + result[:unassigned].size
    assert_equal vrp.services.collect{ |service| service[:quantities].find{ |qte| qte[:unit][:id] == 'kg' }[:value]*service[:visits_number] }.sum.round(4), (result[:routes].collect{ |route| route[:activities].collect{ |stop| stop[:service_id] && stop[:detail][:quantities].size > 0 && stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'kg' }[:value] }}.flatten.compact.sum.round(4) + result[:unassigned].collect{ |service| service[:detail][:quantities].size > 0 && service[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'kg' }[:value] }.flatten.compact.sum).round(4)
    assert_equal vrp.services.collect{ |service| service[:quantities].find{ |qte| qte[:unit][:id] == 'qte' }[:value]*service[:visits_number] }.sum.round(4), (result[:routes].collect{ |route| route[:activities].collect{ |stop| stop[:service_id] && stop[:detail][:quantities].size > 0 && stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'qte' }[:value] }}.flatten.compact.sum.round(4) + result[:unassigned].collect{ |service| service[:detail][:quantities].size > 0 && service[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'qte' }[:value] }.flatten.compact.sum).round(4)
    assert_equal vrp.services.collect{ |service| service[:quantities].find{ |qte| qte[:unit][:id] == 'l' }[:value]*service[:visits_number] }.sum.round(4), (result[:routes].collect{ |route| route[:activities].collect{ |stop| stop[:service_id] && stop[:detail][:quantities].size > 0 && stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'l' }[:value] }}.flatten.compact.sum.round(4) + result[:unassigned].collect{ |service| service[:detail][:quantities].size > 0 && service[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'l' }[:value] }.flatten.compact.sum).round(4)
    assert !result[:routes].any?{ |route| route[:activities].select{ |stop| !stop[:detail][:quantities].empty? }.collect{ |stop| stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'kg' }[:value] }.sum > vrp[:vehicles].find{ |vehicle| vehicle[:id] == route[:vehicle_id].split('_')[0] }[:capacities].find{ |cap| cap[:unit_id] == 'kg' }[:limit]}
    assert !result[:routes].any?{ |route| route[:activities].select{ |stop| !stop[:detail][:quantities].empty? }.collect{ |stop| stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'qte' }[:value] }.sum > vrp[:vehicles].find{ |vehicle| vehicle[:id] == route[:vehicle_id].split('_')[0] }[:capacities].find{ |cap| cap[:unit_id] == 'qte' }[:limit]}
    assert !result[:routes].any?{ |route| route[:activities].select{ |stop| !stop[:detail][:quantities].empty? }.collect{ |stop| stop[:detail][:quantities].find{ |qte| qte[:unit][:id] == 'l' }[:value] }.sum > vrp[:vehicles].find{ |vehicle| vehicle[:id] == route[:vehicle_id].split('_')[0] }[:capacities].find{ |cap| cap[:unit_id] == 'l' }[:limit]}
    assert_equal result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } }.flatten.compact.size, result[:routes].collect{ |route| route[:activities].collect{ |activity| activity[:service_id] } }.flatten.compact.uniq.size
  end

  def test_reject_if_no_vehicle_tw_but_heuristic
    ortools = OptimizerWrapper::ORTOOLS
    problem = {
      points: [{
        id: 'point_0',
        location: {
          lat: 48.8418,
          lon: 2.5435
        }
      }, {
        id: 'point_1',
        location: {
          lat: 48.8218,
          lon: 2.5435
        }
      }, {
        id: 'point_2',
        location: {
          lat: 48.8318,
          lon: 2.5435
        }
      }],
      vehicles: [{
        id: 'vehicle_0',
        start_point_id: 'point_0',
      }],
      services: [{
        id: 'service_1',
        activity: {
          point_id: 'point_1'
        }
      }, {
        id: 'service_2',
        activity: {
          point_id: 'point_2'
        }
      }],
      configuration: {
        preprocessing:{
          use_periodic_heuristic: true
        },
        resolution: {
          duration: 10,
          solver_parameter: -1
        },
        schedule: {
          range_indices:{
            start: 0,
            end: 3
          }
        }
      }
    }
    vrp = Models::Vrp.create(problem)
    assert ortools.inapplicable_solve?(vrp).include? :assert_vehicle_tw_if_schedule
  end

  def test_reject_if_no_heuristic_neither_first_sol_strategy
    ortools = OptimizerWrapper::ORTOOLS
    problem = {
      points: [{
        id: 'point_0',
        location: {
          lat: 48.8418,
          lon: 2.5435
        }
      }, {
        id: 'point_1',
        location: {
          lat: 48.8218,
          lon: 2.5435
        }
      }, {
        id: 'point_2',
        location: {
          lat: 48.8318,
          lon: 2.5435
        }
      }],
      vehicles: [{
        id: 'vehicle_0',
        start_point_id: 'point_0',
        timewindow: {
          start: 0,
          end: 10
        }
      }],
      services: [{
        id: 'service_1',
        activity: {
          point_id: 'point_1'
        }
      }, {
        id: 'service_2',
        activity: {
          point_id: 'point_2'
        }
      }],
      configuration: {
        resolution: {
          duration: 10,
          solver_parameter: -1
        },
        schedule: {
          range_indices:{
            start: 0,
            end: 3
          }
        }
      }
    }
    vrp = Models::Vrp.create(problem)
    assert ortools.inapplicable_solve?(vrp).include? :assert_solver_parameter_is_valid
  end

  def test_reject_if_periodic_heuristic_without_schedule
    ortools = OptimizerWrapper::ORTOOLS
    problem = {
      points: [{
        id: 'point_0',
        location: {
          lat: 48.8418,
          lon: 2.5435
        }
      }, {
        id: 'point_1',
        location: {
          lat: 48.8218,
          lon: 2.5435
        }
      }, {
        id: 'point_2',
        location: {
          lat: 48.8318,
          lon: 2.5435
        }
      }],
      vehicles: [{
        id: 'vehicle_0',
        start_point_id: 'point_0',
        timewindow: {
          start: 0,
          end: 10
        }
      }],
      services: [{
        id: 'service_1',
        activity: {
          point_id: 'point_1'
        }
      }, {
        id: 'service_2',
        activity: {
          point_id: 'point_2'
        }
      }],
      configuration: {
        preprocessing:{
          use_periodic_heuristic: true
        },
        resolution: {
          duration: 10,
          solver_parameter: -1
        }
      }
    }
    vrp = Models::Vrp.create(problem)
    assert ortools.inapplicable_solve?(vrp).include? :assert_if_periodic_heuristic_then_schedule
  end

  def test_compute_best_common_tw_when_empty_tw
    problem = {
      points: [{
        id: 'point_0',
        location: {
          lat: 48.8418,
          lon: 2.5435
        }
      },{
        id: 'point_1',
        location: {
          lat: 48.8418,
          lon: 2.5335
        }
      }],
      vehicles: [{
        id: 'vehicle_0',
        start_point_id: 'point_0',
        timewindow: {
          start: 0,
          end: 1000
        }
      }],
      services: [{
        id: 'service_1',
        activity: {
          point_id: 'point_0'
        }
      }, {
        id: 'service_2',
        activity: {
          point_id: 'point_0'
        }
      }, {
        id: 'service_3',
        activity: {
          point_id: 'point_1'
        }
      }],
      configuration: {
        preprocessing:{
          use_periodic_heuristic: true
        },
        resolution: {
          duration: 10,
          same_point_day: true,
          solver_parameter: -1
        },
        schedule: {
          range_indices:{
            start: 0,
            end: 3
          }
        }
      }
    }
    vrp = Models::Vrp.create(problem)
    result = OptimizerWrapper.wrapper_vrp('demo', {services: {vrp: [:ortools] }}, Models::Vrp.create(problem), nil)
    assert result
    assert result[:unassigned].empty?
  end

  def test_compute_best_common_tw_uncompatible
    problem = {
      points: [{
        id: 'point_0',
        location: {
          lat: 48.8418,
          lon: 2.5435
        }
      },{
        id: 'point_1',
        location: {
          lat: 48.8318,
          lon: 2.5435
        }
      }],
      vehicles: [{
        id: 'vehicle_0',
        start_point_id: 'point_0',
        timewindow: {
          start: 0,
          end: 1000
        }
      }],
      services: [{
        id: 'service_1',
        activity: {
          point_id: 'point_0',
          timewindows:[{
            start: 11,
            end: 12
          }]
        }
      }, {
        id: 'service_2',
        activity: {
          point_id: 'point_0',
          timewindows:[{
            start: 10,
            end: 11
          }]
        }
      }, {
        id: 'service_3',
        activity: {
          point_id: 'point_1'
        }
      }],
      configuration: {
        preprocessing:{
          use_periodic_heuristic: true
        },
        resolution: {
          duration: 10,
          same_point_day: true,
          solver_parameter: -1
        },
        schedule: {
          range_indices:{
            start: 0,
            end: 3
          }
        }
      }
    }
    vrp = Models::Vrp.create(problem)
    result = OptimizerWrapper.wrapper_vrp('demo', {services: {vrp: [:ortools] }}, Models::Vrp.create(problem), nil)
    assert result
    assert_equal 2, result[:unassigned].size
  end

  def test_compute_best_common_tw_compatible
    problem = {
      points: [{
        id: 'point_0',
        location: {
          lat: 48.8418,
          lon: 2.5435
        }
      },{
        id: 'point_1',
        location: {
          lat: 48.8318,
          lon: 2.5435
        }
      }],
      vehicles: [{
        id: 'vehicle_0',
        start_point_id: 'point_0',
        timewindow: {
          start: 0,
          end: 1000
        }
      }],
      services: [{
        id: 'service_1',
        activity: {
          point_id: 'point_0',
          timewindows:[{
            start: 9,
            end: 15
          }]
        }
      }, {
        id: 'service_2',
        activity: {
          point_id: 'point_0',
          timewindows:[{
            start: 10,
            end: 11
          }]
        }
      }, {
        id: 'service_3',
        activity: {
          point_id: 'point_1'
        }
      }],
      configuration: {
        preprocessing:{
          use_periodic_heuristic: true
        },
        resolution: {
          duration: 10,
          same_point_day: true,
          solver_parameter: -1
        },
        schedule: {
          range_indices:{
            start: 0,
            end: 3
          }
        }
      }
    }
    vrp = Models::Vrp.create(problem)
    result = OptimizerWrapper.wrapper_vrp('demo', {services: {vrp: [:ortools] }}, Models::Vrp.create(problem), nil)
    assert result
    assert result[:unassigned].empty?
  end

  def test_solve_tsp_with_one_point
    problem = {
      points: [{
        id: 'point_0',
        location: {
          lat: 48.8418,
          lon: 2.5435
        }
      }],
      vehicles: [{
        id: 'vehicle_0',
        start_point_id: 'point_0',
        timewindow: {
          start: 0,
          end: 10
        }
      }],
      services: [{
        id: 'service_1',
        activity: {
          point_id: 'point_0',
          timewindow:{
            start: 11,
            end: 12
          }
        }
      }, {
        id: 'service_2',
        activity: {
          point_id: 'point_0'
        }
      }, {
        id: 'service_3',
        activity: {
          point_id: 'point_0'
        }
      }],
      configuration: {
        preprocessing:{
          use_periodic_heuristic: true
        },
        resolution: {
          duration: 10,
          solver_parameter: -1
        },
        schedule: {
          range_indices:{
            start: 0,
            end: 3
          }
        }
      }
    }
    vrp = Models::Vrp.create(problem)
    periodic = Interpreters::PeriodicVisits.new(vrp)
    order = periodic.send(:solve_tsp, vrp)
    assert_equal 1, order.size
  end

end
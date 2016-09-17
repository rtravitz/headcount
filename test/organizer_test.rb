require "./test/test_helper"
require "./lib/organizer"

class OrganizerTest < Minitest::Test
  include Organizer

  def test_organize_enrollment_data
    expected = {:kindergarten=> {2007=>0.395, 2006=>0.337, 2005=>0.278},
                :name=>"COLORADO"}

    assert_equal expected, Organizer.organize_enrollment_data(enrollment_data)
  end

  def test_check_kindergarten
    kindergarten_data = {:name=>"ACADEMY 20",
      :kindergarten_participation=>{2010=>0.3915, 2011=>0.35356, 2012=>0.2677}}

    expected = {:kindergarten=>{2010=>0.3915, 2011=>0.35356, 2012=>0.2677}}

    assert_equal expected, Organizer.check_kindergarten(kindergarten_data)
  end

  def test_organize_statewide_testing_data
    expected = {:third_grade=>[{:location=>"Colorado", :score=>"Math", :source=>:third_grade}],
                :writing=>[{:location=>"Colorado", :race_ethnicity=>"Native American", :source=>:writing}],
                :reading=>[{:location=>"Colorado", :race_ethnicity=>"Hawaiian/Pacific Islander", :source=>:reading}],
                :math=>[{:location=>"Colorado", :race_ethnicity=>"White", :source=>:math}],
                :eighth_grade=>[{:location=>"Colorado", :score=>"Reading", :source=>:eighth_grade}], :name=>"COLORADO"}

    action = Organizer.organize_statewide_testing_data(statewide_test_data)

    assert_equal expected, action
  end

  def enrollment_data
    [{ :location=>"Colorado", :timeframe=>"2007", :dataformat=>"Percent",
       :data=>"0.39465", :source=>:kindergarten},
     { :location=>"Colorado", :timeframe=>"2006", :dataformat=>"Percent",
       :data=>"0.33677", :source=>:kindergarten},
     { :location=>"Colorado", :timeframe=>"2005", :dataformat=>"Percent",
       :data=>"0.27807", :source=>:kindergarten}]
  end

  def statewide_test_data
    [
      {:location=>"Colorado", :score=>"Math", :source=>:third_grade},
      {:location=>"Colorado", :race_ethnicity=>"Native American", :source=>:writing},
      {:location=>"Colorado", :race_ethnicity=>"Hawaiian/Pacific Islander", :source=>:reading},
      {:location=>"Colorado", :race_ethnicity=>"White", :source=>:math},
      {:location=>"Colorado", :score=>"Reading", :source=>:eighth_grade}
    ]
  end

end

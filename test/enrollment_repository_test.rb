require './test/test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_enrollment_repository_exists
    er = EnrollmentRepository.new

    assert_instance_of EnrollmentRepository, er
  end

  def test_load_data_creates_hash_of_enrollments
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    er.repository.each do |name, enrollment|
      assert_instance_of Enrollment, enrollment
    end
  end

  def test_find_by_name_returns_correct_enrollment
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", enrollment.name
  end
end

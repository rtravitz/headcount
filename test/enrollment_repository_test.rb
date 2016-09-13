require './test/test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_enrollment_repository_exists
    er = EnrollmentRepository.new

    assert_instance_of EnrollmentRepository, er
  end
end

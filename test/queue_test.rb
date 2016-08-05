require "./lib/queue"
require "./test/test_helper"

class TestQueue < Minitest::Test
  def test_queue_exists
    queue = ParaMorse::Queue.new

    assert_instance_of Queue, queue
  end

end

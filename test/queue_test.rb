require "./lib/queue"
require "./test/test_helper"

class TestQueue < Minitest::Test
  def test_queue_exists
    queue = ParaMorse::Queue.new

    assert_instance_of ParaMorse::Queue, queue
  end

  def test_queue_can_have_items_pushed_to_it
    queue = ParaMorse::Queue.new
    queue.push("1")

    assert_equal 1, queue.count
  end

  def test_queue_can_have_more_than_one_item_pushed_into_it
    queue = ParaMorse::Queue.new
    queue.push("1")
    queue.push("0")

    assert_equal 2, queue.count
  end

  def test_queue_can_show_its_contents_when_peek_is_called
    queue = ParaMorse::Queue.new
    queue.push("1")
    queue.push("0")

    assert_equal "1", queue.peek
  end

  def test_peek_can_show_more_than_element_in_queue
    queue = ParaMorse::Queue.new
    queue.push("1")
    queue.push("0")
    queue.push("0")
    queue.push("0")
    queue.push("1")

    assert_equal ["1", "0", "0"], queue.peek(3)
    assert_equal ["1", "0", "0", "0", "1"], queue.peek(5)
  end

  def test_queue_shows_the_last_element_in_the_queue
    queue = ParaMorse::Queue.new
    queue.push("1")
    queue.push("0")
    queue.push("5")

    assert_equal "1", queue.peek
    assert_equal "5", queue.tail
  end

  def test_queue_shows_more_items_from_the_end_if_argument_is_passed_in
    queue = ParaMorse::Queue.new
    queue.push("1")
    queue.push("0")
    queue.push("5")

    assert_equal ["5", "0"], queue.tail(2)
    assert_equal ["5", "0", "1"], queue.tail(3)
  end

  def test_elements_can_be_popped_from_the_queue_fifo_style
    queue = ParaMorse::Queue.new
    queue.push("1")
    queue.push("0")
    queue.push("5")

    assert_equal 3, queue.count
    assert_equal "1", queue.pop
    assert_equal 2, queue.count
    assert_equal "0", queue.pop
    assert_equal 1, queue.count
    assert_equal "5", queue.peek
  end

  def test_more_than_one_element_can_be_popped_from_the_queue
    queue = ParaMorse::Queue.new
    queue.push("1")
    queue.push("0")
    queue.push("5")

    assert_equal "01", queue.pop(2)
    queue.push("1")
    queue.push("0")
    queue.push("0")
    queue.push("0")
    queue.push("1")
    assert_equal "015", queue.pop(3)
    assert_equal 3, queue.count
  end

  def test_queue_can_be_cleared
    queue = ParaMorse::Queue.new
    queue.push("1")
    queue.push("0")
    queue.push("5")

    assert_equal 3, queue.count
    queue.clear
    assert_equal 0, queue.count
  end

  def test_queue_can_pop_all_to_a_string
    queue = ParaMorse::Queue.new
    queue.push("1")
    queue.push("0")
    queue.push("5")

    assert_equal "105", queue.pop_all
  end
end

require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestDirtyHashy < MiniTest::Unit::TestCase

    describe DirtyHashy do
      it "should behave as expected" do
        hashy = DirtyHashy.new

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal({}, hashy.changes)

        hashy["name"] = "Paul"

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal true, hashy.changed?("name")
        assert_equal [nil, "Paul"], hashy.change(:name)
        assert_equal [nil, "Paul"], hashy.change("name")
        assert_equal({"name" => [nil, "Paul"]}, hashy.changes)

        hashy[:name] = nil

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal false, hashy.changed?(:name)
        assert_equal false, hashy.changed?("name")
        assert_equal nil, hashy.change(:name)
        assert_equal nil, hashy.change("name")
        assert_equal({}, hashy.changes)

        hashy["name"] = "Stephan"

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal true, hashy.changed?("name")
        assert_equal [nil, "Stephan"], hashy.change(:name)
        assert_equal [nil, "Stephan"], hashy.change("name")
        assert_equal({"name" => [nil, "Stephan"]}, hashy.changes)

        hashy.clean_up!

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal false, hashy.changed?(:name)
        assert_equal false, hashy.changed?("name")
        assert_equal nil, hashy.change(:name)
        assert_equal nil, hashy.change("name")
        assert_equal({}, hashy.changes)

        hashy["name"] = "Chris"

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal true, hashy.changed?("name")
        assert_equal ["Stephan", "Chris"], hashy.change(:name)
        assert_equal ["Stephan", "Chris"], hashy.change("name")
        assert_equal({"name" => ["Stephan", "Chris"]}, hashy.changes)

        hashy["name"] = "Stephan"

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal false, hashy.changed?(:name)
        assert_equal false, hashy.changed?("name")
        assert_equal nil, hashy.change(:name)
        assert_equal nil, hashy.change("name")
        assert_equal({}, hashy.changes)

        hashy["name"] = "Paul"

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal true, hashy.changed?("name")
        assert_equal ["Stephan", "Paul"], hashy.change(:name)
        assert_equal ["Stephan", "Paul"], hashy.change("name")
        assert_equal({"name" => ["Stephan", "Paul"]}, hashy.changes)

        hashy["name"] = "Tim"

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal true, hashy.changed?("name")
        assert_equal ["Stephan", "Tim"], hashy.change(:name)
        assert_equal ["Stephan", "Tim"], hashy.change("name")
        assert_equal({"name" => ["Stephan", "Tim"]}, hashy.changes)

        hashy["company"] = "Holder"

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal true, hashy.changed?("name")
        assert_equal true, hashy.changed?(:company)
        assert_equal true, hashy.changed?("company")
        assert_equal ["Stephan", "Tim"], hashy.change(:name)
        assert_equal ["Stephan", "Tim"], hashy.change("name")
        assert_equal [nil, "Holder"], hashy.change(:company)
        assert_equal [nil, "Holder"], hashy.change("company")
        assert_equal({"name" => ["Stephan", "Tim"], "company" => [nil, "Holder"]}, hashy.changes)

        hashy["city"] = "Amsterdam"
        assert_equal({"name" => ["Stephan", "Tim"], "company" => [nil, "Holder"], "city" => [nil, "Amsterdam"]}, hashy.changes)

        hashy.delete :city
        assert_equal({"name" => ["Stephan", "Tim"], "company" => [nil, "Holder"]}, hashy.changes)

        hashy.clean_up!

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal false, hashy.changed?(:name)
        assert_equal false, hashy.changed?("name")
        assert_equal false, hashy.changed?(:name)
        assert_equal false, hashy.changed?("name")
        assert_equal nil, hashy.change(:company)
        assert_equal nil, hashy.change("company")
        assert_equal({}, hashy.changes)

        hashy.delete :company

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.changed?(:company)
        assert_equal true, hashy.changed?("company")
        assert_equal "Holder", hashy.was(:company)
        assert_equal "Holder", hashy.was("company")
        assert_equal ["Holder", nil], hashy.change(:company)
        assert_equal ["Holder", nil], hashy.change("company")
      end
    end

  end
end
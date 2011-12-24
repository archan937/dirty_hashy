require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestDirtyAttributes < MiniTest::Unit::TestCase

    describe DirtyAttributes do
      it "should behave as expected without key restriction" do
        class Person
          include DirtyAttributes
        end

        person = Person.new

        assert_equal({}, person.attributes)
        assert_equal false, person.dirty?
        assert_equal false, person.changed?
        assert_equal({}, person.changes)

        assert_raises(NoMethodError) do
          person.name
        end

        person.name = "Paul"

        assert_equal "Paul", person.name
        assert_equal true, person.dirty?
        assert_equal true, person.changed?
        assert_equal true, person.name_changed?
        assert_equal [nil, "Paul"], person.name_change
        assert_equal({"name" => [nil, "Paul"]}, person.changes)

        person.name = nil

        assert_equal false, person.dirty?
        assert_equal false, person.changed?
        assert_equal false, person.name_changed?
        assert_equal nil, person.name_change
        assert_equal({}, person.changes)

        person.name = "Stephan"

        assert_equal true, person.dirty?
        assert_equal true, person.changed?
        assert_equal true, person.name_changed?
        assert_equal [nil, "Stephan"], person.name_change
        assert_equal({"name" => [nil, "Stephan"]}, person.changes)

        person.clean_up!

        assert_equal false, person.dirty?
        assert_equal false, person.changed?
        assert_equal false, person.name_changed?
        assert_equal nil, person.name_change
        assert_equal({}, person.changes)

        person.foo = "Bar"

        assert_equal "Bar", person.foo
        assert_equal true, person.dirty?
        assert_equal true, person.changed?
        assert_equal false, person.name_changed?
        assert_equal true, person.foo_changed?
        assert_equal nil, person.name_change
        assert_equal [nil, "Bar"], person.foo_change
        assert_equal({"foo" => [nil, "Bar"]}, person.changes)
      end

      it "should behave as expected with key restriction" do
        class User
          include DirtyAttributes
          attrs :name
        end

        user = User.new

        assert_equal({"name" => nil}, user.attributes)
        assert_equal nil, user.name
        assert_equal false, user.dirty?
        assert_equal false, user.changed?
        assert_equal({}, user.changes)

        assert_raises(NoMethodError) do
          user.foo
        end

        assert_raises(NoMethodError) do
          user.foo = "Bar"
        end

        user.name = "Paul"

        assert_equal "Paul", user.name
        assert_equal true, user.dirty?
        assert_equal true, user.changed?
        assert_equal true, user.name_changed?
        assert_equal [nil, "Paul"], user.name_change
        assert_equal({"name" => [nil, "Paul"]}, user.changes)

        user.name = nil

        assert_equal false, user.dirty?
        assert_equal false, user.changed?
        assert_equal false, user.name_changed?
        assert_equal nil, user.name_change
        assert_equal({}, user.changes)

        user.name = "Stephan"

        assert_equal true, user.dirty?
        assert_equal true, user.changed?
        assert_equal true, user.name_changed?
        assert_equal [nil, "Stephan"], user.name_change
        assert_equal({"name" => [nil, "Stephan"]}, user.changes)

        user.clean_up!

        assert_equal false, user.dirty?
        assert_equal false, user.changed?
        assert_equal false, user.name_changed?
        assert_equal nil, user.name_change
        assert_equal({}, user.changes)
      end
    end

  end
end
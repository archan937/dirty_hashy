require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestDirtyHashy < MiniTest::Unit::TestCase

    describe DirtyHashy do
      it "should behave as expected without method mapping and without restricted keys" do
        hashy = DirtyHashy.new

        assert_equal({}, hashy)
        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal({}, hashy.changes)

        assert_raises(NoMethodError) do
          hashy.name = "Paul"
        end

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

        hashy.merge! :name => "Paul", :company => "Internetbureau Holder B.V."

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal true, hashy.changed?("name")
        assert_equal true, hashy.changed?(:company)
        assert_equal true, hashy.changed?("company")
        assert_equal ["Tim", "Paul"], hashy.change(:name)
        assert_equal ["Tim", "Paul"], hashy.change("name")
        assert_equal ["Holder", "Internetbureau Holder B.V."], hashy.change(:company)
        assert_equal ["Holder", "Internetbureau Holder B.V."], hashy.change("company")
        assert_equal({"name" => ["Tim", "Paul"], "company" => ["Holder", "Internetbureau Holder B.V."]}, hashy.changes)
      end

      it "should behave as expected without method mapping, but with restricted keys" do
        hashy = DirtyHashy.new({}, false, [:name])

        assert_equal({"name" => nil}, hashy)
        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal({}, hashy.changes)

        assert_raises(NoMethodError) do
          hashy.name = "Paul"
        end

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

        hashy[:name] = "Stephan"

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
        assert_equal "Stephan", hashy.was("name")
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

        hashy.clean_up!
        hashy.merge! :name => "Paul"

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal true, hashy.changed?("name")
        assert_equal ["Tim", "Paul"], hashy.change(:name)
        assert_equal ["Tim", "Paul"], hashy.change("name")
        assert_equal({"name" => ["Tim", "Paul"]}, hashy.changes)

        assert_raises(IndexError) do
          hashy[:company]
        end

        assert_raises(IndexError) do
          hashy["company"] = "Holder"
        end

        assert_raises(IndexError) do
          hashy.delete :company
        end

        assert_raises(IndexError) do
          hashy.changed? :company
        end

        assert_raises(IndexError) do
          hashy.change :company
        end

        assert_raises(IndexError) do
          hashy.was :company
        end

        assert_raises(IndexError) do
          hashy.merge! :name => "Paul", :company => "Internetbureau Holder B.V."
        end
      end

      it "should behave as expected with method mapping and without restricted keys" do
        hashy = DirtyHashy.new({}, true)

        assert_equal({}, hashy)
        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal({}, hashy.changes)

        assert_raises(NoMethodError) do
          hashy.name
        end

        hashy.name = "Paul"

        assert_equal "Paul", hashy.name
        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.name_changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal [nil, "Paul"], hashy.name_change
        assert_equal [nil, "Paul"], hashy.change(:name)
        assert_equal({"name" => [nil, "Paul"]}, hashy.changes)

        hashy.name = nil

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal false, hashy.name_changed?
        assert_equal false, hashy.changed?(:name)
        assert_equal nil, hashy.name_change
        assert_equal nil, hashy.change(:name)
        assert_equal({}, hashy.changes)

        hashy.name = "Stephan"

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.name_changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal [nil, "Stephan"], hashy.name_change
        assert_equal [nil, "Stephan"], hashy.change(:name)
        assert_equal({"name" => [nil, "Stephan"]}, hashy.changes)

        hashy.clean_up!

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal false, hashy.name_changed?
        assert_equal false, hashy.changed?(:name)
        assert_equal nil, hashy.name_change
        assert_equal nil, hashy.change(:name)
        assert_equal({}, hashy.changes)

        hashy.name = "Chris"

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.name_changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal "Stephan", hashy.name_was
        assert_equal "Stephan", hashy.was(:name)
        assert_equal ["Stephan", "Chris"], hashy.name_change
        assert_equal ["Stephan", "Chris"], hashy.change(:name)
        assert_equal({"name" => ["Stephan", "Chris"]}, hashy.changes)

        hashy.name = "Stephan"

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal false, hashy.name_changed?
        assert_equal false, hashy.changed?(:name)
        assert_equal nil, hashy.name_change
        assert_equal nil, hashy.change(:name)
        assert_equal({}, hashy.changes)

        hashy.name = "Tim"
        hashy.city = "Amsterdam"

        assert_equal true, hashy.city_changed?
        assert_equal true, hashy.changed?(:city)
        assert_equal nil, hashy.city_was
        assert_equal [nil, "Amsterdam"], hashy.city_change
        assert_equal({"name" => ["Stephan", "Tim"], "city" => [nil, "Amsterdam"]}, hashy.changes)

        hashy.delete :city
        assert_equal({"name" => ["Stephan", "Tim"]}, hashy.changes)

        hashy.merge! :company => "Internetbureau Holder B.V."

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal true, hashy.changed?("name")
        assert_equal true, hashy.changed?(:company)
        assert_equal true, hashy.changed?("company")
        assert_equal ["Stephan", "Tim"], hashy.change(:name)
        assert_equal ["Stephan", "Tim"], hashy.change("name")
        assert_equal [nil, "Internetbureau Holder B.V."], hashy.change(:company)
        assert_equal [nil, "Internetbureau Holder B.V."], hashy.change("company")
        assert_equal({"name" => ["Stephan", "Tim"], "company" => [nil, "Internetbureau Holder B.V."]}, hashy.changes)

        hashy.clean_up!

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
      end

      it "should behave as expected with method mapping and with restricted keys" do
        hashy = DirtyHashy.new({}, true, [:name])

        assert_equal({"name" => nil}, hashy)
        assert_equal nil, hashy.name
        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal({}, hashy.changes)

        hashy.name = "Paul"

        assert_equal "Paul", hashy.name
        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.name_changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal [nil, "Paul"], hashy.name_change
        assert_equal [nil, "Paul"], hashy.change(:name)
        assert_equal({"name" => [nil, "Paul"]}, hashy.changes)

        hashy.name = nil

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal false, hashy.name_changed?
        assert_equal false, hashy.changed?(:name)
        assert_equal nil, hashy.name_change
        assert_equal nil, hashy.change(:name)
        assert_equal({}, hashy.changes)

        hashy.name = "Stephan"

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.name_changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal [nil, "Stephan"], hashy.name_change
        assert_equal [nil, "Stephan"], hashy.change(:name)
        assert_equal({"name" => [nil, "Stephan"]}, hashy.changes)

        hashy.clean_up!

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal false, hashy.name_changed?
        assert_equal false, hashy.changed?(:name)
        assert_equal nil, hashy.name_change
        assert_equal nil, hashy.change(:name)
        assert_equal({}, hashy.changes)

        hashy.name = "Chris"

        assert_equal true, hashy.dirty?
        assert_equal true, hashy.changed?
        assert_equal true, hashy.name_changed?
        assert_equal true, hashy.changed?(:name)
        assert_equal "Stephan", hashy.name_was
        assert_equal "Stephan", hashy.was(:name)
        assert_equal ["Stephan", "Chris"], hashy.name_change
        assert_equal ["Stephan", "Chris"], hashy.change(:name)
        assert_equal({"name" => ["Stephan", "Chris"]}, hashy.changes)

        hashy.name = "Stephan"

        assert_equal false, hashy.dirty?
        assert_equal false, hashy.changed?
        assert_equal false, hashy.name_changed?
        assert_equal false, hashy.changed?(:name)
        assert_equal nil, hashy.name_change
        assert_equal nil, hashy.change(:name)
        assert_equal({}, hashy.changes)

        assert_raises(NoMethodError) do
          hashy.company
        end

        assert_raises(NoMethodError) do
          hashy.company = "Holder"
        end

        assert_raises(IndexError) do
          hashy.delete :company
        end

        assert_raises(NoMethodError) do
          hashy.company_changed?
        end

        assert_raises(NoMethodError) do
          hashy.company_change
        end

        assert_raises(NoMethodError) do
          hashy.company_was
        end

        assert_raises(IndexError) do
          hashy.merge! :name => "Paul", :company => "Internetbureau Holder B.V."
        end
      end
    end

  end
end
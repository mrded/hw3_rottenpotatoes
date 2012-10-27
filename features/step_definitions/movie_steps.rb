# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(", ").each do |rating|
    if uncheck
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  end
end

When /^I press (.*)$/ do |pressed|
  click_button(pressed)
end

When /^I follow (.*)$/ do |pressed|
  click_link(pressed)
end

Then /I should see all the movies/ do
  assert all("table#movies tbody tr").count == 10
end

Then /I shouldn't see any movies/ do
  assert all("table#movies tbody tr").count == 0
end

Then /I should(n't)? see: (.*)/ do |not_present, title_list|
  title_list.split(", ").each do |title|
    if not_present
      assert !page.has_content?(title)
    else
      assert page.has_content?(title)
    end
  end
end

module Enumerable
  def sorted?
    each_cons(2).all? { |a, b| (a <=> b) <= 0 }
  end
end

Then /^the movies should be sorted by (.+)$/ do |sort_field|
  col_index = case sort_field
    when "title"
      0
    when "release_date"
      2
    else
      raise ArgumentError
  end

  values = all("table#movies tbody tr").collect do |row| 
    row.all("td")[col_index].text 
  end

  assert values.sorted?
end
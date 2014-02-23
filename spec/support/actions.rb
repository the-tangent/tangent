module Actions
  def create_category(category)
    visit "/editor"
    
    click_on "Categories"
    click_on "New Category"

    fill_in "Name", :with => category
    click_on "Save"
  end
end
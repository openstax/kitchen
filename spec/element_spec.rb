require 'spec_helper'

RSpec.describe Kitchen::Element do

  let(:element_1) do
    new_element(
      <<~HTML
        <div id="divId" class="class1 class2" data-type="a-div">
          <p id="pId">Hi there</p>
        </div>
      HTML
    )
  end

  it "can get the name" do
    expect(element_1.name).to eq "div"
  end

  it "can set the name" do
    element_1.name = "h2"
    expect(element_1.to_s).to start_with("<h2")
  end

  it "can get an arbitrary attribute" do
    expect(element_1["data-type"]).to eq "a-div"
  end

  it "can set an arbitrary attribute" do
    element_1["some_attr"] = "hi"
    expect(element_1.to_s).to match(/div.*some_attr="hi"/)
  end

  it "can remove an arbitrary attribute" do
    element_1.remove_attribute("data-type")
    expect(element_1.to_s).not_to match(/some_attr/)
  end

  it "can add a class" do
    element_1.add_class("new_class")
    expect(element_1.to_s).to match(/class="class1 class2 new_class"/)
  end

  it "can remove a class" do
    element_1.remove_class("class1")
    expect(element_1.to_s).to match(/class="class2"/)
  end

  it "can say if has a class" do
    expect(element_1.has_class?("class2")).to eq true
  end

  it "can return an array of classes" do
    expect(element_1.classes).to contain_exactly("class1", "class2")
  end

  it "can get the ID" do
    expect(element_1.id).to eq "divId"
  end

  it "can set the ID" do
    element_1.id = "blah"
    expect(element_1.to_s).to match(/<div id="blah"/)
  end

  it "can get the text contents" do
    expect(element_1.text).to match /\n.*Hi there\n/
  end

  it "can wrap itself" do
    element_1.wrap("<div id='outer'>")
    expect(element_1.raw.parent[:id]).to eq "outer"
  end

  xit "can return its children" do

  end

  it "can be converted to an HTML string" do
    expect(element_1.to_html + "\n").to eq(
      <<~HTML
        <div id="divId" class="class1 class2" data-type="a-div">
          <p id="pId">Hi there</p>
        </div>
      HTML
    )
  end

  context "#cut and #paste" do
    before { @parent = element_1.parent }

    context "using clipboards" do
      it "can cut to a named clipboard" do
        element_1.cut(to: :something)
        expect(@parent.to_s).not_to match(/divId/)
        expect(element_1.document.clipboard(name: :something).first.id).to eq "divId"
      end

      it "can cut to an existing clipboard" do
        clipboard = Kitchen::Clipboard.new
        element_1.cut(to: clipboard)
        expect(@parent.to_s).not_to match(/divId/)
        expect(clipboard.first.id).to eq "divId"
      end

      it "uses same ID on first paste and unique IDs on second and third paste" do
        clipboard = Kitchen::Clipboard.new
        element_1.cut(to: clipboard)
        expect(clipboard.paste).to match(/divId"/)
        expect(clipboard.paste).to match(/divId_copy_1"/)
        expect(clipboard.paste).to match(/divId_copy_2"/)
      end
    end

    context "without clipboards" do
      it "can cut avoiding clipboards" do
        the_cut_element = element_1.cut
        expect(@parent.to_s).not_to match(/divId/)
        expect(the_cut_element.id).to eq "divId"
      end

      it "uses same ID on first paste and unique IDs on second and third paste" do
        the_cut_element = element_1.cut
        expect(the_cut_element.paste).to match(/divId"/)
        expect(the_cut_element.paste).to match(/divId_copy_1"/)
        expect(the_cut_element.paste).to match(/divId_copy_2"/)
      end
    end
  end

  context "#copy and #paste" do
    before { @parent = element_1.parent }

    context "using clipboards" do
      it "can copy to a named clipboard" do
        element_1.copy(to: :something)
        expect(@parent.to_s).to match(/divId/)
        expect(element_1.document.clipboard(name: :something).first.id).to eq "divId"
      end

      it "can copy to an existing clipboard" do
        clipboard = Kitchen::Clipboard.new
        element_1.copy(to: clipboard)
        expect(@parent.to_s).to match(/divId/)
        expect(clipboard.first.id).to eq "divId"
      end

      it "uses unique IDs all pastes" do
        clipboard = Kitchen::Clipboard.new
        element_1.copy(to: clipboard)
        expect(clipboard.paste).to match(/divId_copy_1"/)
        expect(clipboard.paste).to match(/divId_copy_2"/)
      end
    end

    context "without clipboards" do
      it "can copy" do
        the_copied_element = element_1.copy
        expect(@parent.to_s).to match(/divId/)
        expect(the_copied_element.id).to eq "divId"
      end

      it "uses unique IDs all pastes" do
        the_copied_element = element_1.copy
        expect(the_copied_element.paste).to match(/divId_copy_1"/)
        expect(the_copied_element.paste).to match(/divId_copy_2"/)
      end

      it "keeps using unique IDs even if copied multiple times" do
        the_copied_element = element_1.copy
        expect(the_copied_element.paste).to match(/divId_copy_1"/)
        the_copied_element = element_1.copy
        expect(the_copied_element.paste).to match(/divId_copy_2"/)
      end
    end
  end

end